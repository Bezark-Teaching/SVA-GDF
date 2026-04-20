# GDGS Mac Rendering Fix Review Note

更新时间：2026-03-18 20:43:38 CST

状态：已写入仓库，待 review，暂未决定是否合并

## 背景

当前插件在 Windows 下可以正常渲染，但在 Mac 下会静默黑屏，不报错也不崩溃。  
本插件源自 2Retr0 的 `GodotGaussianSplatting`，而上游在同类 Mac 环境下可以正常渲染，因此问题更可能来自本插件后续分叉改动，而不是 Godot 4.4 或 Mac 对 Gaussian Splatting 的通用限制。

前期诊断结论分成两部分：

- 显示链路层面：
  已补充 `display_mode = Compositor | Direct Texture`，用于区分“rasterizer 黑”还是“compositor 黑”。
- 真正根因层面：
  在 Mac/Metal 上，projection compute pass 中有两个点会导致整条 GS 链路静默归零：
  - 使用 `splat_buffer.length()` 作为 shader 侧长度判断
  - 使用 GPU 端 `atomicMax` 动态更新 `grid_dimensions`

## 这次主要改动

### 1. 保留诊断路径，方便继续定位

已保留前面做的诊断补丁：

- `runtime/compositor/gaussian_compositor_effect.gd`
  新增 `display_mode = Compositor | Direct Texture`
- `runtime/debug/shaders/direct_texture_overlay.gdshader`
  新增原始 GS 纹理直显 shader
- `runtime/compositor/shaders/gaussian_composite.glsl`
  支持在不依赖 scene depth 的情况下查看 `GS Alpha / GS Color / GS Depth`
- `plugin.gd`
  补充 direct texture overlay 的清理

这些改动的目的，是让后续 review 和复现时可以快速判断问题落在 compositor 还是 rasterizer。

### 2. 修复 projection pass 在 Mac/Metal 上的静默失败

#### `runtime/render/gaussian_render_manager.gd`

- 将 `grid_dimensions` 的 indirect dispatch 尺寸改为 CPU 侧预填最大安全值
- 将 `_point_count` 显式写入 uniforms，供 projection shader 使用

#### `runtime/render/shaders/compute/gsplat_projection.glsl`

- 用 CPU 传入的 `point_count` 替代 `splat_buffer.length()`
- 删除 projection pass 中对 `grid_dims[0]` 和 `grid_dims[3]` 的 `atomicMax(...)`

## 改动原因

在本地 Mac 真机验证中，已经确认：

- 不是资源导入问题
- 不是 `CompositorEffect` 本身导致
- 不是 `Texture2DRD` 直显层导致
- 不是点云本身不在视野里

真正异常的是 projection pass 本身：

- 只要 shader 中保留 `splat_buffer.length()`，projection 输出就可能整段为 0
- 只要 projection pass 在 GPU 上 `atomicMax(grid_dimensions)`，后续排序/边界链路也可能全空

这两个点都会在 Mac/Metal 上表现为“无报错黑屏”。

## 当前验证结果

本地验证环境：

- Godot `4.4.1.stable`
- Backend `Metal 3.2`
- Device `Apple M4`

验证结果：

- `Direct Texture` 模式下最终帧已恢复为非黑
- 默认 `Compositor` 模式下最终帧也已恢复为非黑
- `git diff --check` 已通过

说明这次修复已经不只是诊断补丁，而是实际让 Mac 渲染重新产出了可见结果。

## 可能影响

### 功能正确性

按当前代码逻辑判断，这次改动不应破坏 Windows 的功能正确性：

- `point_count` 只是把 shader 侧长度来源改成 CPU 显式传入，语义等价
- 排序和边界阶段都会按真实 `element_count / sort_buffer_size` 做 early return

### 性能风险

这次最需要 review 的点是性能，而不是正确性：

- 以前 `grid_dimensions` 会根据真实 `sort_buffer_size` 动态缩小
- 现在是预填最大 dispatch 上界
- 所以在“实际可见 splat 很少”的场景里，Windows 侧理论上可能会多跑一些空 workgroup

也就是说：

- Mac 稳定性更高
- Windows 结果大概率不变
- 但 Windows 性能可能存在轻微回退，需要实机回归

## 建议 review 重点

- 是否接受“统一走保守 dispatch”这笔性能换稳定性的取舍
- 是否要进一步做成“仅 Mac/Metal 走保守路径，其他后端保留原动态路径”
- 是否要继续把 projection 数学进一步向上游靠拢，减少平台差异

## 这次涉及的主要文件

- `addons/gdgs/runtime/compositor/gaussian_compositor_effect.gd`
- `addons/gdgs/runtime/compositor/shaders/gaussian_composite.glsl`
- `addons/gdgs/runtime/debug/shaders/direct_texture_overlay.gdshader`
- `addons/gdgs/plugin.gd`
- `addons/gdgs/runtime/render/gaussian_render_manager.gd`
- `addons/gdgs/runtime/render/shaders/compute/gsplat_projection.glsl`
