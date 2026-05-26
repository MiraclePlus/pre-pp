#!/bin/bash
# pre-PP skill setup — 一键安装所有依赖
# 用法: cd <skill目录> && bash setup.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/ppt-tools"

echo "=== pre-PP Skill Setup ==="

# 1. 中文字体（PDF 渲染必须）
echo "[1/6] Installing Chinese fonts..."
if ! fc-list :lang=zh 2>/dev/null | grep -q .; then
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y fonts-noto-cjk fonts-noto-cjk-extra 2>/dev/null || \
    sudo apt-get install -y fonts-wqy-zenhei 2>/dev/null || \
    echo "  WARN: Could not install system fonts, trying user-level install..."
  fi
  # Fallback: 用户级字体目录
  if ! fc-list :lang=zh 2>/dev/null | grep -q .; then
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    if [ ! -f "$FONT_DIR/NotoSansSC-Regular.ttf" ]; then
      echo "  Downloading Noto Sans SC..."
      curl -sL "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansSC-Regular.otf" \
        -o "$FONT_DIR/NotoSansSC-Regular.otf" 2>/dev/null || true
      curl -sL "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansSC-Bold.otf" \
        -o "$FONT_DIR/NotoSansSC-Bold.otf" 2>/dev/null || true
      fc-cache -f "$FONT_DIR" 2>/dev/null || true
    fi
  fi
  fc-list :lang=zh 2>/dev/null | head -2 && echo "  Chinese fonts installed" || echo "  WARN: No Chinese fonts available, PDF may show garbled text"
else
  echo "  Chinese fonts already installed"
fi

# 2. Python 依赖
echo "[2/6] Installing Python dependencies..."
pip3 install --break-system-packages -q python-pptx markitdown 2>/dev/null || \
pip3 install python-pptx markitdown

# 3. Node 依赖
echo "[3/6] Installing Node dependencies..."
if [ ! -d "$TOOLS_DIR/node_modules" ]; then
  cd "$TOOLS_DIR"
  npm install --production
  cd "$SCRIPT_DIR"
else
  echo "  node_modules already exists, skipping"
fi

# 4. Playwright browsers (仅 chromium)
echo "[4/6] Installing Playwright Chromium..."
cd "$TOOLS_DIR"
npx playwright install chromium 2>/dev/null || echo "  Chromium already installed or install skipped"
cd "$SCRIPT_DIR"

# 5. 创建输出目录
echo "[5/6] Creating output directories..."
OUTPUT_BASE="$(dirname "$SCRIPT_DIR")/../../PP评估/decks"
mkdir -p "$OUTPUT_BASE" 2>/dev/null || true

# 6. 初始化迭代日志
echo "[6/6] Initializing iteration log..."
LOG_FILE="$OUTPUT_BASE/pre-pp-log.md"
if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" << 'LOGHEADER'
# Pre-PP 迭代日志

> 自动记录每次 deck 迭代的输入输出，便于回顾完整历程。

LOGHEADER
  echo "  Created: $LOG_FILE"
else
  echo "  Log file already exists: $LOG_FILE"
fi
chmod +x "$SCRIPT_DIR/log-entry.sh"

echo ""
echo "=== Setup Complete ==="
echo "Fonts: $(fc-list :lang=zh 2>/dev/null | wc -l) Chinese font(s)"
echo "Python: python-pptx $(pip3 show python-pptx 2>/dev/null | grep Version | cut -d' ' -f2), markitdown $(pip3 show markitdown 2>/dev/null | grep Version | cut -d' ' -f2)"
echo "Node tools: $TOOLS_DIR"
echo "Output dir: $OUTPUT_BASE"
echo "Log file: $LOG_FILE"
