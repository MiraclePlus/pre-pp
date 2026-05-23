# pre-pp — 路演PPT迭代助手

Claude Code Skill：帮助创始人在正式 Pitch Practice 之前迭代路演 deck。

## 功能

- **制作模式**：从零生成 PDF + PPTX
- **审阅模式**：逐页诊断 + 修改建议（6维度框架）
- **规划模式**：Markdown 分页规划 → 结构评审 → 生成 deck

## 安装

```bash
# 1. Clone 到 .claude/skills/ 目录
git clone https://github.com/qbu11/pre-pp.git .claude/skills/pre-pp

# 2. 安装依赖
cd .claude/skills/pre-pp
bash setup.sh
```

## 使用

```
/pre-pp {项目名} 帮我从零做一个5分钟路演deck
/pre-pp {项目名} 帮我看看这个deck哪里需要改 [附件: deck.pdf]
/pre-pp {项目名} --format html 生成HTML预览版
```

## 技术栈

| 类型 | 包 | 用途 |
|------|------|------|
| Python | python-pptx | PPTX 读写 |
| Python | markitdown | PPT/PDF 文本提取 |
| Node | pptxgenjs | 程序化生成 PPTX |
| Node | sharp | 图片处理 |
| Node | playwright + chromium | HTML → PDF/截图 |

## 默认输出

- `.pptx` — 路演日提交
- `.pdf` — 打印分发
- `.html`（可选，`--format html`）— 浏览器预览

## License

MIT
