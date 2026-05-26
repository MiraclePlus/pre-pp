# pre-pp — 路演PPT迭代助手

> Claude Code Skill for iterating pitch decks before formal Pitch Practice.

帮助创始人在正式 PP 评估之前，从零到一制作、审阅、迭代路演 deck。支持飞书 Slides / PPTX / HTML 多格式输出。

---

## Quick Start

```bash
# 1. Clone to your Claude Code skills directory
git clone https://github.com/MiraclePlus/pre-pp.git .claude/skills/pre-pp

# 2. Install dependencies (fonts, Python, Node, Chromium)
cd .claude/skills/pre-pp && bash setup.sh
```

Done. The skill auto-triggers when you mention "做PPT"、"改deck"、"路演材料" etc.

## Usage

```
帮我从零做一个5分钟路演deck
帮我看看这个deck哪里需要改 [attach: deck.pdf]
基于这个 markdown 大纲生成 slides [attach: outline.md]
```

### Three Modes

| Mode | Trigger | Output |
|------|---------|--------|
| **Build** | "做/写/生成 deck" | Feishu Slides (default) / PPTX / HTML |
| **Review** | Provide PDF/PPT + "帮我看看" | Diagnosis report + rewrite suggestions |
| **Plan** | Provide Markdown outline | Structure review → generate deck |

### Format Options

```
--format feishu   # 飞书 Slides（默认，云端渲染，字体无忧）
--format pptx     # PowerPoint + PDF
--format html     # 网页 HTML Deck
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                        SKILL.md                              │
│         (Brain — all logic, prompts, constraints)            │
└────────────┬──────────────────┬──────────────────┬──────────┘
             │                  │                  │
     ┌───────▼──────┐  ┌───────▼──────┐  ┌───────▼──────┐
     │   Node.js    │  │    Python    │  │    Shell     │
     │  ppt-tools/  │  │              │  │              │
     └───────┬──────┘  └───────┬──────┘  └───────┬──────┘
             │                  │                  │
  generate-deck.js      python-pptx         log-entry.sh
  layouts.js            markitdown          setup.sh
  Sharp (images)
  Playwright+Chromium
```

### Phase Pipeline

```
Input → Phase 0 (Mode Detection)
      → Phase 1 (Outline Alignment)
      → Phase 2 (Content Fill)
      → Phase 3 (Build Output)
      → Phase 4 (Iterate & Polish)
      → Phase 5 (Pre-flight Check)
      → Phase 6 (Iteration Log)
```

## Iteration Logging

Every deck output is automatically logged to `pre-pp-log.md` (same directory as output files).

**Log entry format:**
```markdown
---

## ProjectName - v2 | 2026-05-26 14:30

- **Query**: 把第3页的数据图表换成用户增长曲线
- **Mode**: 制作
- **Output**:
  - `ProjectName-deck-v2.html`
  - 飞书 Slides: https://xxx.feishu.cn/slides/xxx
- **Changes**: 替换第3页图表，增加用户增长数据可视化
```

You can also use the helper script directly:
```bash
bash log-entry.sh ./pre-pp-log.md "ProjectName" "v2" "制作" "把第3页改成增长曲线" \
  --output ProjectName-deck-v2.html --slides-url "https://..."
```

## Compatibility

This skill works with **any agent** that can read a SKILL.md file:

| Platform | Status | Notes |
|----------|--------|-------|
| Claude Code | ✅ Native | Auto-triggers via `trigger` field |
| claudeskills.io | ✅ | Standard frontmatter format |
| Codex (OpenAI) | ✅ | Reads SKILL.md as system prompt |
| Hermes | ✅ | Reads SKILL.md as instructions |

No platform-specific hooks or APIs required. The SKILL.md text instructions are the single source of truth.

## Tech Stack

| Layer | Package | Purpose |
|-------|---------|---------|
| Node | PptxGenJS | Programmatic .pptx generation |
| Node | Sharp | Image compression & gradient rendering |
| Node | Playwright + Chromium | HTML → screenshot/PDF |
| Python | python-pptx | PPTX read/write |
| Python | markitdown | Extract text from PPT/PDF for analysis |
| Shell | log-entry.sh | Structured iteration logging |

## File Structure

```
pre-pp/
├── SKILL.md              # Core skill (all logic lives here)
├── setup.sh              # One-command install
├── log-entry.sh          # Iteration log helper
├── requirements.txt      # Python deps
├── ppt-tools/            # Node.js tooling
│   ├── generate-deck.js  # HTML deck generator
│   ├── layouts.js        # Layout templates & color schemes
│   └── package.json
└── references/           # Reference docs
    ├── pp-diagnostic-handbook.md
    └── lark-slides/      # Feishu Slides API reference
```

## Requirements

- Node.js ≥ 18
- Python ≥ 3.9
- `setup.sh` handles everything else (fonts, npm, pip, Chromium)

## License

MIT
