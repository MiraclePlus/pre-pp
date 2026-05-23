# pre-pp 技术架构文档

## 1. 定位与原理

pre-pp 是一个 **Claude Code Skill**——即一段结构化的 prompt + 工具链配置，当用户在 Claude Code 中触发 `/pre-pp` 时自动加载执行。

它不是一个独立的应用程序，而是 Claude Code 的"技能包"：告诉 Claude 在收到路演 deck 相关请求时，应该如何思考、检索什么数据、调用哪些工具、输出什么格式。

### 核心公式

```
用户输入 + 项目上下文 + 方法论框架 + 工具链 → PDF/PPTX deck
```

### 与传统 PPT 工具的区别

| 维度 | 传统工具（Canva/PPT模板） | pre-pp |
|------|------------------------|--------|
| 内容来源 | 用户手写 | AI 从项目资料自动提取 |
| 结构设计 | 用户自行安排 | 基于 PP 方法论自动规划 |
| 诊断能力 | 无 | 6维度自动诊断 |
| 迭代方式 | 手动修改 | 自然语言指令修改 |
| 输出格式 | 单一 | PDF + PPTX + HTML |

## 2. 工作流（Workflow）

```
┌─────────────────────────────────────────────────────────────────┐
│                        用户触发 /pre-pp                          │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 0: 上下文加载                                             │
│  ┌──────────────┐  ┌──────────────────┐  ┌───────────────────┐ │
│  │ 识别项目名称  │  │ 加载 OH 录音记录  │  │ 加载方法论框架     │ │
│  └──────────────┘  └──────────────────┘  └───────────────────┘ │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 若有已有deck: markitdown 提取结构                         │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────┬───────────────────────────────────────────┘
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
    ┌──────────┐ ┌──────────┐ ┌──────────┐
    │ 制作模式  │ │ 审阅模式  │ │ 规划模式  │
    │(从零生成) │ │(诊断改进) │ │(MD→deck) │
    └────┬─────┘ └────┬─────┘ └────┬─────┘
         │            │            │
         ▼            ▼            ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 1: 大纲对齐                                               │
│  - 标准 10-14 页结构（封面/痛点/方案/市场/团队/Traction/融资）    │
│  - 每页 ≤ 1 个核心信息                                           │
│  - 用户确认后继续                                                 │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 2: 内容填充                                               │
│  - 标题 ≤ 8字 / 核心信息 ≤ 30字 / 支撑数据 / 视觉指引           │
│  - 写作标准：数据>形容词, 断言>论证, 单页≤80字                    │
│  - 鼓励真实产品照片 + 团队照片                                    │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 3: 制作输出                                               │
│  ┌─────────────────────────────────────┐                        │
│  │ 模式A（默认）: PptxGenJS → .pptx    │                        │
│  │                Playwright → .pdf    │                        │
│  └─────────────────────────────────────┘                        │
│  ┌─────────────────────────────────────┐                        │
│  │ 模式B（--format html）: 单HTML文件   │                        │
│  └─────────────────────────────────────┘                        │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 4: 迭代打磨（循环）                                       │
│  用户反馈 → 逐页修改 → mini-check → 用户再反馈 → ...            │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│  Phase 5: 路演日合规检查（Pre-flight）                            │
│  16:9 / 无动画 / 字号≥24pt / 底部安全区 / 二维码 / 真实照片      │
└─────────────────────────────────────────────────────────────────┘
```

## 3. 依赖清单

### 3.1 Python 依赖

| 包 | 版本 | 用途 | 调用时机 |
|----|------|------|---------|
| `python-pptx` | ≥1.0.0 | PPTX 文件读写、解析已有 PPT 结构 | 审阅模式读取用户上传的 .pptx |
| `markitdown` | ≥0.1.0 | 将 PPT/PDF 转为 Markdown 文本 | Phase 0 提取已有 deck 内容 |

安装：`pip3 install -r requirements.txt`

### 3.2 Node.js 依赖

| 包 | 版本 | 用途 | 调用时机 |
|----|------|------|---------|
| `pptxgenjs` | ^4.0.1 | 程序化生成 .pptx 幻灯片 | Phase 3 模式A：生成 PPTX |
| `sharp` | ^0.34.5 | 图片裁剪、格式转换、渐变预渲染 | 处理产品图片/团队照片嵌入 |
| `playwright` | ^1.60.0 | 无头浏览器，HTML→截图/PDF | Phase 3：HTML渲染为PDF |
| `lucide-static` | ^1.16.0 | 开源图标 SVG 库 | 幻灯片中嵌入图标元素 |
| `chromium`（via playwright） | 自动安装 | Playwright 浏览器引擎 | HTML→PDF 渲染 |

安装：`cd ppt-tools && npm install`（postinstall 自动装 chromium）

### 3.3 系统依赖

| 依赖 | 最低版本 | 用途 |
|------|---------|------|
| Node.js | 18+ | 运行 PptxGenJS/Sharp/Playwright |
| Python | 3.9+ | 运行 python-pptx/markitdown |
| Chromium 系统库 | — | Playwright 需要的 so 文件 |

### 3.4 数据依赖（内置）

| 文件 | 用途 |
|------|------|
| `references/pp-diagnostic-handbook.md` | PP 诊断手册（6维度 32+ 问题类型），审阅模式的评估标准 |

## 4. 目录结构

```
pre-pp/
├── SKILL.md                  # 主 Skill 定义（Claude Code 读取此文件）
├── ARCHITECTURE.md           # 本文档
├── README.md                 # GitHub 展示
├── setup.sh                  # 一键安装（pip + npm + playwright）
├── requirements.txt          # Python 依赖声明
├── ppt-tools/
│   └── package.json          # Node 依赖声明
└── references/
    └── pp-diagnostic-handbook.md  # PP 诊断手册（来源：飞书 wiki）
```

## 5. 执行原理详解

### 5.1 Claude Code Skill 机制

Claude Code 的 Skill 系统工作原理：

1. **注册**：`SKILL.md` 放在 `.claude/skills/` 目录下，Claude Code 启动时扫描并注册
2. **触发**：用户输入匹配 `trigger` 中的关键词时，SKILL.md 的内容被注入为 system prompt
3. **执行**：Claude 按 SKILL.md 中定义的流程，调用 Bash/Read/Write/Edit 等工具完成任务
4. **输出**：生成的文件保存到指定目录

```
用户: "/pre-pp 潇湘智控 帮我做deck"
         │
         ▼
Claude Code 识别触发词 "pre-pp"
         │
         ▼
加载 SKILL.md 为上下文指令
         │
         ▼
Claude 按流程执行：
  1. 读取项目 OH 资料（Read 工具）
  2. 规划大纲（输出文本）
  3. 填充内容（输出文本）
  4. 调用工具生成文件：
     - node -e "const pptx = require('pptxgenjs'); ..." → .pptx
     - playwright 渲染 → .pdf
  5. 输出到 PP评估/decks/
```

### 5.2 PPTX 生成流程

```javascript
// PptxGenJS 程序化生成（Claude 在 Bash 中执行）
const PptxGenJS = require('pptxgenjs');
const pptx = new PptxGenJS();

// 设置 16:9
pptx.defineLayout({ name: 'CUSTOM', width: 10, height: 5.625 });

// 逐页生成
const slide = pptx.addSlide();
slide.addText('标题', { x: 0.8, y: 0.5, fontSize: 36, bold: true });
slide.addText('正文内容', { x: 0.8, y: 1.5, fontSize: 24 });
slide.addImage({ path: 'product-photo.png', x: 5, y: 1, w: 4, h: 3 });

// 输出
await pptx.writeFile('output.pptx');
```

### 5.3 PDF 生成流程

```javascript
// Playwright 将 HTML 渲染为 PDF
const { chromium } = require('playwright');
const browser = await chromium.launch();
const page = await browser.newPage();

// 方式1：从 HTML deck 转 PDF
await page.goto(`file://${htmlPath}`);
await page.pdf({ path: 'output.pdf', format: 'A4', landscape: true });

// 方式2：从 PPTX 截图组装（备选）
// 每页截图 → sharp 组装
```

### 5.4 审阅模式流程

```
用户上传 deck.pdf 或 deck.pptx
         │
         ▼
markitdown 提取文本结构
  $ python3 -m markitdown deck.pptx
  → Markdown 格式的逐页内容
         │
         ▼
Claude 对照 pp-diagnostic-handbook.md 的 6 维度逐页诊断
         │
         ▼
输出：评级 + 逐页诊断表 + 结构建议 + 重写示例
```

## 6. 方法论来源

### PP 诊断手册（6 维度）

来源：[MPR | 校友PP参考手册(F25)](https://miracleplus.feishu.cn/wiki/IQLuwdguhisFCukAAXCcq31SnDP)

| 维度 | 检查重点 | 典型问题 |
|------|---------|---------|
| **What**（做什么） | 30秒内能否说清产品 | 一句话定位缺失、产品定义模糊 |
| **Why Now**（痛点） | 场景化、新信息量 | 背景铺垫过长、缺乏量化数据 |
| **How**（方案） | 产品可视化、技术翻译 | 功能罗列、无 demo 截图 |
| **Why**（市场） | TAM/SAM/SOM | 市场数据缺失、商业模式不清 |
| **Why Us**（团队） | 经验匹配度 | 照片缺失、分工不明 |
| **Traction**（进展） | 量化指标 | 无数据、无时间线 |

### 路演日视觉规范

| 规则 | 值 | 原因 |
|------|---|------|
| 比例 | 16:9 | 大屏标准 |
| 最小字号 | ≥ 24pt | 后排可读 |
| 字号差 | ≤ 30pt | 视觉层次不过度跳跃 |
| 底部安全区 | 25% | 防桌面/人头遮挡 |
| 动画/视频 | 禁止 | 现场播放不稳定 |
| 真实照片 | 必须 | 增强可信度、避免纯文本堆砌 |

## 7. 环境变量

```bash
# 必须设置（setup.sh 自动处理）
export NODE_PATH=<skill_dir>/ppt-tools/node_modules

# 可选（项目上下文相关）
export LARK_APP_ID=cli_a93d24bb57fe5bd4        # 飞书 MetaBot
export LARK_APP_SECRET=...                      # 飞书密钥
```

## 8. 部署检查清单

```bash
# 验证 Python 依赖
python3 -c "import pptx; print(pptx.__version__)"
python3 -c "import markitdown; print('ok')"

# 验证 Node 依赖
node -e "require('pptxgenjs'); console.log('pptxgenjs ok')"
node -e "require('sharp'); console.log('sharp ok')"
node -e "require('playwright'); console.log('playwright ok')"

# 验证 Chromium
npx playwright install --dry-run chromium

# 验证输出目录
ls -la <project_root>/PP评估/decks/
```

## 9. 常见问题

### Q: 为什么默认 PDF+PPTX 而不是 HTML？
A: 路演日提交要求 .pptx 文件；PDF 方便打印和分享；HTML 仅作快速预览用。

### Q: Playwright chromium 安装失败怎么办？
A: 执行 `npx playwright install-deps chromium` 安装系统依赖（需要 sudo）。

### Q: 能否不装 Node 只用 Python？
A: 不行。python-pptx 只能做基础文本 PPT，PptxGenJS 支持更丰富的图表/渐变/排版。

### Q: 审阅模式必须有诊断手册吗？
A: 是的，`references/pp-diagnostic-handbook.md` 是审阅模式的评分标准。缺失时 Claude 会退化为通用建议。
