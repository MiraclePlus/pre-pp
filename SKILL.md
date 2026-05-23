---
name: pre-pp
version: 1.0.0
author: MiraclePlus CC Team
description: >-
  Pre Pitch Practice — 路演PPT迭代助手

  在正式 PP 评估之前，帮助创始人从零到一制作/迭代路演 deck。
  支持：大纲生成、PPT 制作（PDF/PPTX/HTML）、逐页打磨、视觉优化。
  当用户提到"做PPT"、"改PPT"、"迭代deck"、"准备路演材料"、"pre PP"时触发。
trigger:
  - pre-pp, pre PP, pre-PP, 做PPT, 改PPT, 迭代deck, 准备路演, 制作deck, PPT迭代, 路演材料制作
tags:
  - pitch
  - ppt
  - deck
  - creation
  - iteration
  - miracleplus
---

# pre-PP — 路演PPT迭代助手

## 概述

帮助 S26 创始人在正式 Pitch Practice 之前迭代路演 deck。从大纲到成品，支持多轮打磨。
与 PP skill 的关系：PP 是**评估**已有材料，pre-PP 是**制作/迭代**材料。

**核心定位**：路演材料的"编辑器"+"顾问"。既能制作，也能诊断改进。

## 三种工作模式

| 模式 | 触发条件 | 输出 |
|------|---------|------|
| **制作模式** | 用户说"做/写/生成 deck" | 从零生成 PDF + PPTX |
| **审阅模式** | 用户提供 PDF/PPT/截图 + "帮我看看/改改/优化" | 逐页修改建议 + 重写方案 |
| **规划模式** | 用户提供 Markdown 分页文档 | 结构评审 + 内容补全 + 生成 deck |

## 适用场景

- 创始人还没有 deck，需要从项目资料生成大纲和初稿
- 创始人有初版 deck，需要结构调整或内容重写
- 创始人想针对某几页进行定向打磨
- 路演日前最后冲刺，需要快速出稿
- **创始人写了 Markdown 分页规划稿，需要评审和制作**
- **创始人有现成 PDF/PPT，需要具体的修改建议**

## 技术栈

已安装在 `/home/ubuntu/AI_First/ppt-tools/`：
- **PptxGenJS** — 程序化生成 .pptx
- **Sharp** — 图片处理、渐变预渲染
- **Playwright + Chromium** — HTML → 截图（用于 HTML deck 转 PPTX）
- **python-pptx** — Python 端 PPTX 读写
- **markitdown** — PPTX 文本提取分析

输出格式选择：
| 格式 | 命令 | 适用场景 |
|------|------|---------|
| PDF + PPTX | 默认 | 路演日提交、多人协作、打印分发 |
| 网页 HTML deck | `--format html` | 快速预览、高视觉品质、自带动效 |

## 执行流程

### Phase 0: 上下文加载

1. 识别项目名称（从用户输入或对话上下文）
2. 加载项目 OH 资料（同 PP skill 的 Stage 3 路A）
3. 加载 Pitch Practice 方法论：`/home/ubuntu/AI_First/信息层级 (Information Hierarchy)/顶层结构/Pitch Practice/`
4. 若用户提供了现有 deck（PDF/PPT），用 markitdown 提取结构

### Phase 0A: Markdown 分页规划解析（规划模式）

当创始人提供 Markdown 格式的 PPT 分页规划时：

**识别格式**（自动检测）：
```markdown
# Slide 1: 封面
- 标题：xxx
- 副标题：xxx

# Slide 2: 痛点
- 核心数据：xxx
- 场景描述：xxx
```

或任何类似的分页结构（`## 第1页`、`### Page 1`、`---` 分隔符等）。

**解析流程**：
1. 自动识别分页标记（标题级别/分隔符/编号）
2. 提取每页：标题、要点、数据、视觉指引
3. 映射到标准结构（封面/痛点/方案/市场/团队/Traction/融资/尾页）
4. 生成结构评审报告：
   - 缺失模块（如缺 Why Now、缺 Traction）
   - 顺序问题（如团队放太前、融资放中间）
   - 内容密度（每页字数是否超标）
   - 逻辑断裂（页间衔接是否自然）

**输出**：修订版大纲 + 改进建议 → 用户确认后进入 Phase 3 制作

### Phase 0B: 已有 PDF/PPT 审阅（审阅模式）

当创始人提供已有的 PDF 或 PPT 文件时：

**提取流程**：
1. PDF → 用 `Read` 工具直接读取（支持图片识别）
2. PPT/PPTX → `python3 -m markitdown {file}` 提取文本结构
3. 对每页提取：标题、正文、数据点、图表描述

**诊断维度**（6+4 检查）：

| 维度 | 检查内容 | 输出 |
|------|---------|------|
| **结构完整性** | PP手册6模块是否齐全 | 缺失/多余页标注 |
| **信息密度** | 每页字数、要点数 | 过载页/空白页标记 |
| **逻辑连贯** | 页间承接关系 | 断裂点 + 修复建议 |
| **数据支撑** | 关键论点有无数据佐证 | 需补充数据的位置 |
| **表达效率** | 是否啰嗦/是否断言式 | 精简重写方案 |
| **视觉合规** | 路演日强制要求 | 违规项 + 修复方法 |

**合伙人视角快评**（简化版，每人1句）：
- 陆奇：叙事/认知负荷
- Max：产品定义清晰度
- Peter：证据/数据质量
- Xuwen：结构/表达效率

**输出格式**：
```markdown
# {项目名} Deck 审阅报告

## 整体评级：⭐⭐⭐☆☆（3/5）

## 逐页诊断
| 页 | 当前内容摘要 | 问题 | 修改建议 |
|---|------------|------|---------|
| 1 | 封面：xxx | Logo过大，缺一句话定位 | 添加"一句话"，Logo缩小50% |
| 2 | 背景铺垫 | 浪费时间论证市场存在 | 删除，直接用断言开场 |
| 3 | ... | ... | ... |

## 结构建议
- 建议删除第X页（原因）
- 建议在第Y页后插入（内容）
- 建议调整顺序：A→B→C 改为 B→A→C（原因）

## 内容重写示例
### 第X页（重写前 vs 重写后）
**Before**: "我们发现在XXX领域存在着巨大的市场机会..."
**After**: "中国XXX市场年规模800亿，但80%仍在用Excel管理。"

## 合伙人快评
- 🧠 陆奇：{一句话}
- 💼 Max：{一句话}
- 📊 Peter：{一句话}
- ⚡ Xuwen：{一句话}

## 下一步
1. {最高优先级修改}
2. {次优先级修改}
3. 修改完成后建议运行 `/PP` 做正式评估
```

### Phase 1: 大纲对齐（Outline）

基于奇绩 PP 标准，生成/调整 deck 大纲：

**标准结构（可调）**：
```
1. 封面 — 项目名 + 一句话定位 + Logo
2. 问题/痛点 — 具体场景 + 量化数据
3. 解决方案 — 产品是什么 + 核心功能
4. 产品演示 — Demo截图/流程图
5. Why Now — 时机/技术变革
6. 市场 — TAM/SAM/SOM + 竞争格局
7. 商业模式 — 如何收费 + 单位经济
8. Traction — 关键指标 + 增长曲线
9. 团队 — 核心成员 + 相关经验
10. 融资 — 金额 + 资金用途 + 里程碑
11. 尾页 — 二维码 + 联系方式 + 展位号
```

**对齐要求**：
- 每页核心信息 ≤ 1 个（陆奇：一次传递一个核心信息）
- 页间逻辑衔接（上一页的结论引出下一页的问题）
- 总页数 10-14 页（2分钟pitch = 骨架，5分钟pitch = 完整叙事）
- 必须有用户确认后才进入制作阶段

### Phase 2: 内容填充（Content）

逐页填写：
- **标题**：≤ 8 字，动词或名词开头
- **核心信息**：≤ 30 字，这页想让投资人记住什么
- **支撑数据**：具体数字、案例、截图描述
- **视觉指引**：图/表/截图/对比图/流程图

**写作标准**（详见 `references/pp-diagnostic-handbook.md`）：
- 单页文字 ≤ 80 字，正文字号不能太小
- 一页一重点，信息点 ≤ 5 个
- 数据 > 形容词，断言 > 论证
- 先结论后解释（金字塔原则）
- 用大白话，避免术语堆砌
- 产品先行（Max：先讲清产品是什么）
- **必须使用真实素材**：产品实拍照片、团队真人照片、客户现场图，禁止纯文本/占位符堆砌
- **大屏幕可读性**：所有文字必须确保后排观众清晰可见，字号不能太小、颜色不能太淡

### Phase 3: 制作输出（Build）

#### 模式 A：PDF + PPTX（默认）

流程：PptxGenJS 程序化生成 .pptx → Playwright 渲染为 PDF
- 每页 720pt x 405pt（16:9）
- 深色/浅色交替节奏
- 图片作为情绪载体
- 字号 ≥ 24pt，标题 36-48pt，正文 24-32pt

输出：
- PPTX: `/home/ubuntu/AI_First/PP评估/decks/{项目名}-deck.pptx`
- PDF: `/home/ubuntu/AI_First/PP评估/decks/{项目名}-deck.pdf`

#### 模式 B：网页 HTML Deck（`--format html`）

参考风格（非强制，按项目调整）：
- 字体：Inter + Noto Sans SC
- 深色底 + 高对比强调色（金/蓝/绿）
- clamp() 响应式字号，标题 2-3.5rem，正文 0.9-1.1rem
- 底部留 25% 安全区，内容区最大宽度 1000px
- 参考范例：`/home/ubuntu/AI_First/PP评估/decks/潇湘智控-路演日Deck-v1.html`

输出：单 HTML 文件 → `/home/ubuntu/AI_First/PP评估/decks/{项目名}-deck.html`

### Phase 4: 迭代打磨（Iterate）

用户反馈后逐页修改：
- "第3页太多字" → 精简到 ≤ 50 字
- "缺少竞争对比" → 插入竞争矩阵页
- "开场不够有力" → 用"断言+数据"替代背景铺垫
- "顺序不对" → 调整页面顺序

每轮迭代后自动执行 PP 标准 mini-check：
- 30秒规则：前3页能否说清产品？
- 逻辑衔接：页间是否断裂？
- 记忆点：有没有投资人能转述的金句？

### Phase 5: 路演日合规检查（Pre-flight）

最终输出前执行路演日强制要求检查：
- [ ] 16:9 比例
- [ ] 无动画无视频
- [ ] 底部留 1/4-1/5 空间
- [ ] 字号 ≥ 24pt
- [ ] 最大与最小字号之差 ≤ 30pt
- [ ] 最后一页：有实质内容 + 展位号（≥ 36pt）+ 二维码放上方角落
- [ ] 二维码位置：页面上方角落（不占主体空间）
- [ ] 图片 ≥ 300dpi
- [ ] 使用免费字体
- [ ] 包含真实产品照片（实物/截图/demo），不能只有文本和图标
- [ ] 包含团队真人照片，不能用占位符或姓氏首字母代替
- [ ] 大屏幕测试：正文在 3 米外清晰可读（字号、对比度、颜色均需达标）

## 输出格式

```markdown
# {项目名称} Deck 迭代 v{版本号}

## 大纲确认
| # | 页面 | 核心信息 | 视觉形式 |
|---|------|---------|----------|
| 1 | 封面 | 一句话定位 | Logo + 标题 |
| 2 | 痛点 | 量化问题 | 数据图表 |
| ... | ... | ... | ... |

## 当前状态
- 版本：v{n}
- 变更：{本轮改了什么}
- 待确认：{需要用户决策的点}

## Mini-Check
| 检查项 | 状态 | 备注 |
|--------|------|------|
| 30秒清晰度 | Pass/Fail | ... |
| 页间逻辑 | Pass/Fail | ... |
| 记忆点 | Pass/Fail | ... |

## 文件输出
- PPTX: `/home/ubuntu/AI_First/PP评估/decks/xxx-deck.pptx`
- PDF: `/home/ubuntu/AI_First/PP评估/decks/xxx-deck.pdf`
- HTML: `/home/ubuntu/AI_First/PP评估/decks/xxx-deck.html`（仅 --format html 时）
```

## 审阅诊断依据

审阅模式（Phase 0B）使用 **PP诊断手册** 作为核心评估标准：

参考文档：`references/pp-diagnostic-handbook.md`
来源：[MPR | 校友PP参考手册(F25)](https://miracleplus.feishu.cn/wiki/IQLuwdguhisFCukAAXCcq31SnDP)

### 6维诊断框架

| 维度 | 核心检查项 | 常见问题数 |
|------|-----------|-----------|
| 1. What（做什么） | 30秒清晰度、一句话定位、视觉一致性 | 3类 |
| 2. Why Now（痛点） | 场景化、新信息量、信服力、时间分配 | 7类 |
| 3. How（产品方案） | 可视化、一致性、技术翻译、聚焦度 | 9类 |
| 4. Why/市场 | TAM-SAM-SOM、入口客户、商业模式 | 4类 |
| 5. Why Us（团队） | 匹配度、记忆标签、分工、互补性 | 5类 |
| 6. Traction（进展） | 量化、时间线、增长曲线、视觉突出 | 4类 |

### 审阅输出格式



示例：


## 与 PP Skill 的协作

- pre-PP 制作完成后，建议用户运行 `/PP` 做正式评估
- pre-PP 的 mini-check 是 PP 完整评估的子集（快速检查）
- PP 的评估结果可直接作为 pre-PP 下一轮迭代的输入

## 设计规范速查

### 配色方案（推荐）
| 方案 | 背景 | 主色 | 强调色 | 适用 |
|------|------|------|--------|------|
| 深蓝科技 | #0A1628 | #FFFFFF | #3B82F6 | AI/SaaS/数据 |
| 暖白商务 | #FAFAFA | #1A1A1A | #FF6B35 | 消费/服务/平台 |
| 深绿生物 | #0D1F22 | #E8F5E9 | #4CAF50 | 生物/医疗/环保 |
| 纯黑硬件 | #000000 | #FFFFFF | #FFD700 | 硬件/机器人/工业 |

### 字体配对
| 标题 | 正文 | 风格 |
|------|------|------|
| Inter Bold | Inter Regular / Noto Sans SC | 科技/现代 |
| Georgia Bold | Calibri | 商务/稳重 |
| Arial Black | Arial | 简洁/通用 |

### 版式规则
- 标题区：顶部 15%
- 内容区：中部 60%
- 安全区：底部 25%（防遮挡）
- 左右边距：≥ 8%
- 单页元素：≤ 5 个

## 使用示例

```
# 制作模式
/pre-PP Meridian 帮我从零做一个5分钟路演deck
/pre-PP VoiceCursor 基于最新OH内容更新deck
/pre-PP 潇湘智控 --format html 生成HTML预览版

# 审阅模式（提供已有 PDF/PPT）
/pre-PP 慧化科技 帮我看看这个deck哪里需要改 [附件: deck.pdf]
/pre-PP 深智构DeepGigoAI /tmp/deepgigo-pitch.pptx 给修改建议

# 规划模式（提供 Markdown 分页稿）
/pre-PP Meridian 基于下面的分页规划帮我做deck：
## Slide 1: 封面 ...
## Slide 2: 痛点 ...

# 定向打磨
/pre-PP 慧化科技 我现在的deck第3-5页太啰嗦，帮我精简
/pre-PP 深智构DeepGigoAI 帮我重写开场，要更有冲击力
```

## 补充说明

- 所有输出文件保存到 `/home/ubuntu/AI_First/PP评估/decks/{项目名}-deck-v{n}.[pptx|pdf|html]`
- 迭代记录保存到 `/home/ubuntu/AI_First/PP评估/{项目名}-deck-v{n}.md`
- S26 项目自动加载最新 OH 上下文
- 首次制作会执行需求澄清（风格/受众/时长/素材）
- 输出的 HTML deck（--format html）可直接在浏览器全屏演示
- NODE_PATH 设置：`export NODE_PATH=/home/ubuntu/AI_First/ppt-tools/node_modules`


## Skill 路由调度（自动选择下游 Skill）

pre-PP 根据任务类型自动调用最合适的已安装 Skill，无需用户手动指定。

### 路由表

| 任务类型 | 首选 Skill | 备选 Skill | 触发条件 |
|---------|-----------|-----------|---------|
| **PPTX 生成**（程序化） | ppt-workflow | pptx-generator | --format pptx；用户要求"PPT文件" |
| **HTML → PPTX 转换** | html-to-pptx | — | 已有 HTML deck，需转为 .pptx 提交 |
| **学术/科研演示** | scientific-slides | pptx-from-layouts | 项目属 biotech/AI4S/学术方向 |
| **咨询级商务 Deck** | presentation-consulting | ppt-workflow | 用户要求"专业/商务/投行风格" |
| **模板化 PPTX**（已有模板） | pptx-from-layouts | pptx-generator | 用户提供 .pptx 模板文件 |
| **PDF 读取/解析** | pdf | — | 输入为 PDF 文件（审阅模式） |
| **幻灯片结构设计** | slides | pptx-generator | 纯结构/大纲阶段，快速原型 |

### 调度逻辑



### 组合调用场景

| 场景 | 调用链 |
|------|--------|
| 从零做路演 deck（HTML） | pre-PP Phase 0-2 → guizang-ppt-skill（渲染） |
| 从零做路演 deck（PPTX） | pre-PP Phase 0-2 → ppt-workflow（生成 .pptx） |
| HTML deck 转交付文件 | guizang-ppt-skill（生成 HTML）→ html-to-pptx（转 .pptx） |
| 审阅已有 PDF | pdf（提取内容）→ pre-PP Phase 0B（诊断） |
| 审阅已有 PPTX | pptx（解析结构）→ pre-PP Phase 0B（诊断） |
| 基于模板重做 | pptx-from-layouts（套用模板）→ pre-PP Phase 4（迭代） |
| 学术项目路演 | pre-PP Phase 0-2 → scientific-slides（学术排版） |
| 商务融资 deck | pre-PP Phase 0-2 → presentation-consulting（咨询风格） |

### Skill 路径速查



### 自动路由示例




## Skill 路由调度（自动选择下游 Skill）

pre-PP 根据任务类型自动调用最合适的已安装 Skill，无需用户手动指定。

### 路由表

| 任务类型 | 首选 Skill | 备选 Skill | 触发条件 |
|---------|-----------|-----------|---------|
| **PPTX 生成**（程序化） | ppt-workflow | pptx-generator | `--format pptx`；用户要求"PPT文件" |
| **HTML → PPTX 转换** | html-to-pptx | — | 已有 HTML deck，需转为 .pptx 提交 |
| **学术/科研演示** | scientific-slides | pptx-from-layouts | 项目属 biotech/AI4S/学术方向 |
| **咨询级商务 Deck** | presentation-consulting | ppt-workflow | 用户要求"专业/商务/投行风格" |
| **模板化 PPTX**（已有模板） | pptx-from-layouts | pptx-generator | 用户提供 .pptx 模板文件 |
| **PDF 读取/解析** | pdf | — | 输入为 PDF 文件（审阅模式） |
| **幻灯片结构设计** | slides | pptx-generator | 纯结构/大纲阶段，快速原型 |

### 调度逻辑

```
1. 解析用户意图 -> 确定任务类型（制作/审阅/转换/解析）
2. 检查输入格式（Markdown / PDF / PPTX / 无文件）
3. 检查输出格式要求（HTML / PPTX / 两者都要）
4. 检查项目领域标签（科技/消费/生物/硬件/学术）
5. 匹配路由表 -> 调用对应 Skill 的方法论和模板
```

### 组合调用场景

| 场景 | 调用链 |
|------|--------|
| 从零做路演 deck（PPTX） | pre-PP Phase 0-2 -> ppt-workflow（生成 .pptx） |
| 审阅已有 PDF | pdf（提取内容） -> pre-PP Phase 0B（诊断） |
| 审阅已有 PPTX | pptx-generator（解析结构） -> pre-PP Phase 0B（诊断） |
| 基于模板重做 | pptx-from-layouts（套用模板） -> pre-PP Phase 4（迭代） |
| 学术项目路演 | pre-PP Phase 0-2 -> scientific-slides（学术排版） |
| 商务融资 deck | pre-PP Phase 0-2 -> presentation-consulting（咨询风格） |

### Skill 路径速查

```
/home/ubuntu/AI_First/.claude/skills/
  ppt-workflow/              # 端到端流水线，26风格，18图表类型
  html-to-pptx/             # HTML -> 原生PPTX形状转换
  scientific-slides/         # 学术PPTX，437 stars
  pptx-from-layouts/         # Markdown -> 模板PPTX映射
  presentation-consulting/   # 咨询级商务deck
  pdf/                       # PDF生成与解析
  pptx-generator/            # 程序化PPTX生成
  slides/                    # 幻灯片结构设计
```

### 自动路由示例

```
用户: "/pre-PP Meridian 帮我从零做一个5分钟路演deck"
  路由: ppt-workflow（默认 PDF+PPTX 输出）
  调用链: Phase 0 -> 1 -> 2 -> 3A (ppt-workflow渲染)

用户: "/pre-PP VoiceCursor --format html"
  路由: HTML deck 渲染
  调用链: Phase 0 -> 1 -> 2 -> 3B (HTML输出)

用户: "/pre-PP 慧化科技 帮我看看 deck.pdf"
  路由: pdf（解析） -> pre-PP Phase 0B（诊断）
  输出: 审阅报告 + 修改建议

用户: "/pre-PP 从分子设计到科学创新 做个学术风格的deck"
  路由: scientific-slides（学术排版）
  调用链: Phase 0 -> 1 -> 2 -> 3 (scientific-slides渲染)

用户: "把刚才的HTML deck转成pptx文件"
  路由: html-to-pptx
  输入: 已生成的HTML -> 输出: .pptx
```


## 部署与依赖安装

本 skill 自包含所有依赖声明，copy 到生产环境后执行 setup 即可。

### 目录结构

```
pre-PP/
  SKILL.md              # 主 skill 定义
  setup.sh              # 一键安装脚本
  requirements.txt      # Python 依赖声明
  ppt-tools/
    package.json        # Node 依赖声明（含 postinstall 自动装 chromium）
  references/
    pp-diagnostic-handbook.md  # PP诊断手册（6维度40+问题类型）
```

### 部署步骤

```bash
# 1. Copy skill 到生产目录
cp -r /path/to/pre-PP /efs/vibe_oh_agent/.claude/skills/pre-PP

# 2. 一键安装所有依赖
cd /efs/vibe_oh_agent/.claude/skills/pre-PP
bash setup.sh
```

### 依赖清单

| 类型 | 包 | 用途 |
|------|------|------|
| Python | python-pptx | PPTX 读写解析 |
| Python | markitdown | PPT/PDF 文本提取 |
| Node | pptxgenjs | 程序化生成 PPTX |
| Node | sharp | 图片处理/渐变预渲染 |
| Node | playwright + chromium | HTML 截图转 PPTX |
| Node | lucide-static | 图标素材 |

### 环境变量

```bash
export NODE_PATH=<skill_dir>/ppt-tools/node_modules
```

### 输出目录

生产环境输出到：`<项目根>/PP评估/decks/`
- PPTX: `{项目名}-deck-v{n}.pptx`（默认）
- PDF: `{项目名}-deck-v{n}.pdf`（默认）
- HTML: `{项目名}-deck-v{n}.html`（--format html）
- 迭代记录: `{项目名}-deck-v{n}.md`
