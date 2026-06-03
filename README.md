# pre-PP — 路演 PPT 迭代助手

> Pre Pitch Practice — 在正式 PP 评估之前，帮助创始人从零到一制作/迭代路演 deck

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/MiraclePlus/pre-pp)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 功能概览

- 🎯 **三种工作模式**：制作、审阅、规划
- 📊 **多格式输出**：飞书 Slides（默认）/ HTML / PDF / PPTX
- ✨ **智能内容优化**：基于 2025S 奇绩创坛 57 个项目的最佳实践
- 🔍 **6维诊断框架**：结构、密度、逻辑、数据、表达、视觉
- 🎨 **视觉合规检查**：路演日强制要求自动验证

## 新增功能 🆕

**讲稿内容迭代规则**（v1.0.0）

基于 2025S 奇绩创坛 57 个项目路演讲稿的真实数据分析，自动优化：

- **第一页黄金规则**：用类比法让投资人一眼看懂（"XX行业的Cursor"）
- **前三页30秒记忆测试**：产品定位 → 痛点场景 → 核心能力
- **吸睛度检查**：6种钩子类型防止台下玩手机
- **虚实结合叙事**：前6页讲实在的，后3-4页讲升华的

详见：[`references/pitch-content-rules.md`](./references/pitch-content-rules.md)

## 快速开始

### 安装

```bash
# 1. 克隆到 Claude Code skills 目录
cd ~/.claude/skills/  # 或项目的 .claude/skills/
git clone https://github.com/MiraclePlus/pre-pp.git

# 2. 安装依赖（一键安装）
cd pre-pp
bash setup.sh

# 3. 验证环境
bash verify.sh
```

### 使用示例

```bash
# 制作模式（默认输出飞书 Slides）
/pre-PP Meridian 帮我从零做一个5分钟路演deck

# 审阅模式（提供已有 PDF/PPT）
/pre-PP 慧化科技 帮我看看这个deck哪里需要改 [附件: deck.pdf]

# 规划模式（提供 Markdown 分页稿）
/pre-PP Meridian 基于下面的分页规划帮我做deck：
## Slide 1: 封面 ...
## Slide 2: 痛点 ...

# 内容优化（新功能）
/pre-PP VoiceCursor 优化讲稿内容，让它更吸引投资人

# 转换已有 HTML deck 到飞书 Slides
/pre-PP StudySpace 把 PP评估/decks/StudySpace-deck-v2.html 转成飞书slides
```

## 三种工作模式

| 模式 | 触发条件 | 输出 |
|------|---------|------|
| **制作模式** | 用户说"做/写/生成 deck" | 从零生成飞书 Slides（默认）/ HTML / PPTX |
| **审阅模式** | 用户提供 PDF/PPT/截图 + "帮我看看/改改/优化" | 逐页修改建议 + 重写方案 |
| **规划模式** | 用户提供 Markdown 分页文档 | 结构评审 + 内容补全 + 生成 deck |

## 输出格式对比

| 格式 | 优点 | 适用场景 |
|------|------|---------|
| **飞书 Slides** | 云端渲染、字体一致、在线协作、一键分享 | 默认推荐（无字体风险） |
| **HTML Deck** | 高视觉品质、自带动效、快速预览 | 快速迭代、在线演示 |
| **PDF + PPTX** | 离线可用、打印分发 | 路演日提交（有字体风险） |

## 技术栈

- **PptxGenJS** — 程序化生成 .pptx
- **Sharp** — 图片处理、渐变预渲染
- **Playwright + Chromium** — HTML → 截图
- **python-pptx** — PPTX 读写解析
- **markitdown** — PPT/PDF 文本提取
- **lark-cli** — 飞书 Slides API

## 项目结构

```
pre-pp/
├── SKILL.md                    # Skill 定义（主文件）
├── README.md                   # 本文档
├── setup.sh                    # 一键安装脚本
├── verify.sh                   # 环境验证脚本
├── version-check.sh            # 版本检查脚本
├── log-entry.sh                # 迭代日志工具
├── requirements.txt            # Python 依赖
├── ppt-tools/                  # Node 工具链
│   ├── package.json
│   └── node_modules/
└── references/                 # 参考文档
    ├── pp-diagnostic-handbook.md      # PP 诊断手册
    ├── pitch-content-rules.md         # 讲稿内容迭代规则（新增）
    └── lark-slides/                   # 飞书 Slides 技术文档
```

## 讲稿内容优化规则

基于 2025S 奇绩创坛 57 个项目的真实路演数据分析提取：

### 1. 第一页黄金规则

✅ **优秀案例**：
- "科技写作的Cursor"（三鲤理工套件）
- "AI时代的企业黑客"（AI黑客）
- "Agent的Upwork"（Bonjour）

❌ **避免错误**：
- "人类动作智能系统"（太抽象）
- "基于深度学习的XXX平台"（技术堆砌）

### 2. 吸睛度检查（6种钩子）

每页必须有至少1个钩子：

| 钩子类型 | 示例 |
|---------|------|
| 震撼数据 | "164亿美金"、"覆盖率提升3倍" |
| 对比反差 | "他们7000万18个月 vs 我们3000美金1周" |
| 视觉冲击 | 产品demo、数据曲线 |
| 具体场景 | "GitHub因为MCP漏洞泄漏代码" |
| 反常识洞察 | "60%的提示词其实并非必要" |
| 未来愿景 | "十年之后会比Salesforce做得更大" |

### 3. 虚实结合叙事

- **前6页讲实在的**：产品定义、具体痛点、核心能力、数据验证
- **后3-4页讲升华的**：团队愿景、市场想象空间、使命宣言

完整规则详见：[`references/pitch-content-rules.md`](./references/pitch-content-rules.md)

## 数据来源

本 Skill 的讲稿内容迭代规则基于以下数据源：

### 2025S 奇绩创坛路演讲稿

- **数据集**：[2025春季创业营57个项目2分钟路演视频 Whisper 转录文本](https://github.com/qbu11/2025s-miracleplus-pitch-transcripts)
- **分析样本**：13 个代表性项目（涵盖 AI、硬件、SaaS、消费、生物医药等多个领域）
- **提取规则**：第一页定位、前三页记忆测试、吸睛度钩子、虚实叙事节奏

### 奇绩 Pitch Practice 方法论

- [校友PP参考手册 (F25)](https://miracleplus.feishu.cn/wiki/N1IawWlaeiF1h5kWNQgc0lpbn2f)
- [路演日Pitch反馈汇总 (S25/F25)](https://miracleplus.feishu.cn/file/boxcnMotmaGURmoDUbLJ13hlYvg)
- [路演日展台样本图 & Deck Examples](https://miracleplus.feishu.cn/docx/IkxsdezMvo1lQrxsMxmczhdknFb)

### 合伙人观点

- **陆奇**：认知负荷、一次一个核心信息、叙事连贯性
- **Max**：产品定义优先、实物照片必须、技术翻译
- **Peter**：证据驱动、数据质量、避免空洞描述
- **Xuwen**：结构效率、表达简洁、避免啰嗦

## 与 PP Skill 的关系

| Skill | 定位 | 使用时机 |
|-------|------|---------|
| **pre-PP** | 制作/迭代工具 | 从零做 deck、改进现有 deck |
| **PP** | 评估工具 | 正式评估、路演日前最终检查 |

**推荐流程**：pre-PP 制作完成 → `/PP` 正式评估 → 根据评估结果用 pre-PP 迭代

## 环境要求

- **Node.js** ≥ 18
- **Python** ≥ 3.9
- **lark-cli** ≥ 1.0.0（飞书 Slides 模式需要）
- **字体**（仅 PPTX 模式）：Microsoft YaHei / Arial

## 输出目录

所有输出统一保存到：`/home/ubuntu/AI_First/PP评估/decks/`

- PPTX: `{项目名}-deck-v{n}.pptx`
- PDF: `{项目名}-deck-v{n}.pdf`
- HTML: `{项目名}-deck-v{n}.html`
- 迭代记录: `~/.pre-pp/logs/{项目名}.md`

## 更新日志

### v1.0.0 (2025-06-03)

- ✨ **新增**：讲稿内容迭代规则（基于 2025S 57个项目）
  - 第一页黄金规则：简单类比法
  - 前三页30秒记忆测试
  - 吸睛度检查（6种钩子）
  - 虚实结合叙事
- 📚 新增参考文档：`references/pitch-content-rules.md`
- 🔧 优化审阅模式：自动应用内容优化规则
- 📝 完善 README 和使用示例

### v0.9.0 (2025-05-28)

- 🚀 初始版本
- 支持飞书 Slides / HTML / PPTX 三种输出格式
- 实现制作、审阅、规划三种工作模式
- 集成 PP 诊断手册（6维框架）

## License

MIT © MiraclePlus CC Team

## 相关链接

- [奇绩创坛官网](https://www.miracleplus.com/)
- [lark-cli 文档](https://github.com/larksuite/cli)
- [Claude Code 文档](https://claude.ai/code)

---

**Built with ❤️ by MiraclePlus CC Team**
