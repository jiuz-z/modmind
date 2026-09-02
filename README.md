# ModMind - 自定义 AI API 版

> 基于 [ModMind](https://github.com/waterpail114514/modmind) 1.4.4 的二次开发版本，新增自定义 AI API 配置功能，支持接入任意 OpenAI 兼容的大模型服务。

ModMind 是一个基于 Electron 的 AI 辅助 Minecraft Mod 开发工作台，集成了项目创建、代码编辑、构建测试、Blockbench 建模、发布等完整工作流。

## 本分支新增功能

### 自定义 AI API 配置

在设置 → AI 与 Agent → AI 提供商中，可选择：

- **ModMind Cloud**（原官方云端服务，保留全部功能）
- **自定义 OpenAI 兼容 API**（接入任意第三方大模型服务）

自定义 API 支持配置：

| 配置项 | 说明 |
|--------|------|
| Base URL | API 服务地址，通常以 `/v1` 结尾（输入时会自动提示） |
| API Key | 服务密钥，经系统 safeStorage 加密存储，不写入源码/日志/配置文件 |
| Model | 模型 ID，支持自动扫描或手动填写 |
| Reasoning Effort | 思考强度：low / medium / high / xhigh / max / ultra，默认 high |

### 内置 12 个常用 API 供应商预设

一键选择自动填充 Base URL 和默认模型：

OpenAI GPT、DeepSeek、Kimi（月之暗面）、智谱 AI、MiniMax、通义千问、豆包、硅基流动、Groq、OpenRouter、Ollama、LM Studio

### 测试连接功能

点击"测试连接"自动检测：

- 连接成功
- API Key 无效（401/403）
- 模型不存在（404）
- Base URL 错误
- Responses API 不支持
- Chat Completions 不支持
- 余额不足（402，琥珀色提示）
- 网络错误 / 其他 HTTP 错误

### ChatCompletionsAdapter 流式支持

- 上游走 `/chat/completions` 时支持增量流式转发，文字逐字输出
- 3 秒心跳保活，避免慢模型连接中断
- 自动兼容 `/responses` 和 `/chat/completions` 两种协议
- 支持 tool_calls / function calling / usage 统计

### 其他改进

- Base URL 输入框增加 `/v1` 结尾检测提示
- 一键启动脚本 `启动开发模式.bat`（双击即可启动开发模式）
- API 凭证全程加密，不暴露在 UI 日志或控制台

## 系统要求

- Windows 10/11（主开发平台）
- Node.js 18+
- npm

## 快速开始

```powershell
npm install
npm run dev
```

或直接双击项目根目录下的 `启动开发模式.bat`。

## 项目结构

```
modmind/
├── src/
│   ├── main/          # Electron 主进程（Adapter、IPC、服务管理）
│   ├── preload/       # 预加载脚本（渲染端 API 桥接）
│   ├── renderer/      # React 渲染端（UI）
│   └── shared/        # 共享类型定义
├── resources/         # 静态资源、技能、工具链
├── out/               # 构建输出（开发模式）
└── release/           # 打包产物
```

## 自定义 API 数据流

```
用户 UI
  ↓
本地设置（settings.json + safeStorage 加密凭证）
  ↓
CodexServerConfig { apiKey, baseUrl, model, reasoningEffort }
  ↓
prepareCodex() → 写入 config.toml
  ↓
Codex CLI（本地 Agent Runtime）
  ↓
ChatCompletionsAdapter（本地 127.0.0.1 随机端口）
  ↓
用户自定义 API（OpenAI 兼容）
  ↓
LLM
  ↓
Codex Agent → MCP → Minecraft 工具链
```

## Git 工作流（本分支）

本仓库已配置双远程：

- `upstream` → 官方原项目 `https://github.com/waterpail114514/modmind.git`
- `origin` → 本仓库 `https://github.com/jiuz-z/modmind.git`

### 同步上游更新

```powershell
git pull upstream main
# 如有冲突，手动解决后 commit
git push origin master:main
```

### 版本备份

每次确认版本可用后，打 Tag 永久备份：

```powershell
git tag stable-1.4.4-custom-v1
git push origin stable-1.4.4-custom-v1
```

已备份版本：`stable-1.4.4-custom-v1`

## 上游原版功能

ModMind 原版提供：

- Fabric / Quilt / Forge / NeoForge 项目创建与迁移
- Monaco 代码编辑器 + VS Code Java 语言服务
- 本地与远程 Git 工作流
- 项目快照与恢复
- Modrinth / Maven 依赖管理
- 嵌入式 Blockbench 建模
- 隔离的客户端/服务端/GameTest 验证
- CI 生成、发布前检查、Modrinth/CurseForge/GitHub Releases 发布
- mappings.dev 映射查询与本地缓存
- 13 个内置开发技能（Mod 开发、迁移、测试、发布、内容创作、Blockbench 建模、图片素材、插件开发等）

## 许可证

自 1.4.4 版本起，ModMind 原始源码采用 GNU Affero 通用公共许可证 v3.0（`AGPL-3.0-only`）。1.4.3 及更早版本仍按原 MIT 许可证发布。详见 [LICENSE](LICENSE) 和 [CONTRIBUTING.md](CONTRIBUTING.md)。

第三方组件和捆绑工具按其各自许可证发布，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。ModMind 名称和标志为商标，不随软件许可证授权，详见 [TRADEMARKS.md](TRADEMARKS.md)。

## 致谢

- 原项目：[waterpail114514/modmind](https://github.com/waterpail114514/modmind)
- MCP 服务：[ModMind-MCP](https://github.com/waterpail114514/ModMind-MCP)
- DeepSeek 兼容性修复贡献：[@ZHANGNIUBI1](https://github.com/ZHANGNIUBI1)
