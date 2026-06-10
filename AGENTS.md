# Athena - Project Rules

## Core Goal

基于 Tauri 2.0 构建运行在 Windows 11 上的桌面通用智能体应用。前端使用 React + TypeScript，后端使用 Rust，通过 Tauri IPC 通信，集成 LLM 实现对话、工具调用、系统操作等智能体能力。

## Development Environment

- 开发环境运行在 **Windows 11 原生**，Shell 为 **PowerShell 7 (pwsh)**，系统默认编码为 **UTF-8**
- 文件路径统一使用 Windows 格式（`C:\...`），支持正斜杠（`C:/...`）

## Code Style (Mandatory)

- **TypeScript**: 严格模式 (`"strict": true`)，禁止 `any`，所有函数和接口必须有类型注解
- **Rust**: 遵循 `cargo clippy` 零警告标准，使用 `rustfmt` 默认格式化
- **命名约定**:
  - TypeScript: `camelCase` 变量/函数，`PascalCase` 组件/类型/接口，`kebab-case` 文件名
  - Rust: `snake_case` 函数/变量/模块，`PascalCase` 类型/Trait/Enum 变体
- **禁止** 在代码中添加多余注释，除非逻辑复杂到必须解释
- **禁止** 提交 `console.log`、`println!` 等调试语句
- 组件文件不超过 300 行，超过时必须拆分

## Architecture (Mandatory)

- **前后端严格分离**: 前端只负责 UI 渲染和用户交互，所有系统操作、文件 IO、网络请求必须经过 Tauri IPC 由 Rust 后端执行
- **目录结构**（前端）:
  ```
  src/
  ├── components/     # UI 组件，按功能分子目录
  ├── hooks/          # 自定义 React hooks
  ├── services/       # 封装 Tauri invoke 调用的服务层
  ├── stores/         # 状态管理
  ├── types/          # TypeScript 类型定义
  └── utils/          # 纯工具函数
  ```
- **目录结构**（后端）:
  ```
  src-tauri/src/
  ├── commands/       # IPC command handlers，每个文件对应一类功能
  ├── services/       # 业务逻辑层
  ├── models/         # 数据模型
  ├── utils/          # 工具函数
  └── lib.rs          # 模块注册入口
  ```
- **插件按需引入**: 只在 `Cargo.toml` 和 `tauri.conf.json` 中声明实际使用的 Tauri 插件
- **新增 IPC 命令**: 必须在 `commands/` 下创建对应模块，在 `lib.rs` 中注册到 `generate_handler!`
- **状态管理**: 前端使用 Zustand，Store 按功能域拆分，禁止单个巨型 Store

## Quick Verification Commands

```bash
# 前端类型检查
npx tsc --noEmit

# 前端代码检查
npx eslint .

# 前端格式化检查
npx prettier --check .

# Rust 代码检查
cargo clippy --manifest-path src-tauri/Cargo.toml -- -D warnings

# Rust 格式化检查
cargo fmt --manifest-path src-tauri/Cargo.toml -- --check

# 编译检查
pnpm tauri build --debug

# 运行开发模式
pnpm tauri dev
```
