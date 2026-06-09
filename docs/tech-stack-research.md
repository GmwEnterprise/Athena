# Tauri 2.0 桌面智能体技术栈调研

## 1. 核心架构

| 层级 | 技术选型 | 说明 |
|------|----------|------|
| **后端** | Rust | Tauri 核心，处理系统级操作、IPC 命令、业务逻辑 |
| **前端** | React 19 + TypeScript | Webview 渲染 UI，社区最成熟的搭配方案 |
| **通信** | Tauri IPC (`invoke` / `events`) | 前后端通过消息传递通信，安全且高效 |
| **Webview** | WebView2 (Windows) | Win10/11 内置，无需额外打包浏览器引擎 |

## 2. 关键 Tauri 2.0 插件（智能体必备）

| 插件 | 用途 |
|------|------|
| **shell** | 执行系统命令、Sidecar 进程（如运行本地 Python/Node 脚本） |
| **fs** | 文件系统读写，管理配置、日志、知识库 |
| **dialog** | 原生文件选择/保存对话框 |
| **clipboard** | 剪贴板读写 |
| **http** | HTTP 客户端，调用 LLM API（OpenAI / Claude / 本地 Ollama） |
| **notification** | 系统通知推送 |
| **global-shortcut** | 全局快捷键唤醒智能体 |
| **process** | 进程管理 |
| **updater** | 应用自动更新 |
| **autostart** | 开机自启 |
| **deep-link** | URL Scheme 深度链接 |
| **tray-icon** | 系统托盘，最小化到托盘常驻 |

## 3. 智能体核心能力实现路径

| 能力 | 实现方式 |
|------|----------|
| **LLM 对话** | `http` 插件调用远程 API，或 `shell` sidecar 运行 Ollama 本地推理 |
| **工具调用 (Function Calling)** | Rust 后端实现 Tool 执行器，通过 IPC 暴露给前端 |
| **系统操作** | Rust 层直接调用 Windows API / PowerShell 命令 |
| **文件管理** | `fs` 插件 + Rust 后端 |
| **屏幕感知** | Rust 调用截图 API，图片传给多模态 LLM |
| **后台常驻** | `tray-icon` + `autostart` + `global-shortcut` |
| **流式输出** | Tauri Events（Rust → 前端实时推送 SSE 数据） |

## 4. 推荐技术栈组合

```
前端:  React 19 + TypeScript + Vite + TailwindCSS + shadcn/ui
后端:  Rust + Tauri 2.0 SDK
AI:   HTTP 调用 OpenAI / Claude API 或 Sidecar 运行 Ollama
构建:  pnpm + cargo
UI库:  shadcn/ui 或 Radix UI（Win11 风格定制）
状态:  Zustand 或 Jotai
```

## 5. 项目创建命令

```powershell
# Windows PowerShell
irm https://create.tauri.app/ps | iex
# 或
pnpm create tauri-app
```

## 6. Tauri 2.0 相比 1.x 的核心改进

- **模块化插件系统**：API 全部插件化，按需引入，减小包体积
- **权限模型**：细粒度的安全权限控制（capabilities + permissions）
- **多窗口管理**：完善的 Window / Webview API，支持多窗口 + 透明窗口
- **系统托盘**：原生支持，菜单 + 事件回调
- **Sidecar**：可随应用分发外部二进制文件（如 Python 运行时、Ollama 等）
- **自动更新**：内置 updater 插件

## 7. 开发环境要求（Windows 11）

- **Rust** (`rustup`)
- **Node.js** ≥ 18
- **WebView2** (Win11 内置)
- **Visual Studio Build Tools** (C++ 工具链)
- **pnpm** (推荐包管理器)

## 8. 参考资料

- [Tauri 2.0 官方文档](https://v2.tauri.app/)
- [Tauri 2.0 Stable Release Blog](https://v2.tauri.app/blog/tauri-20/)
- [Tauri GitHub](https://github.com/tauri-apps/tauri)
- [Tauri 插件列表](https://v2.tauri.app/plugin/)
