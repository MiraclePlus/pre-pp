#!/bin/bash
# pre-PP skill setup — 一键安装所有依赖
# 用法: cd <skill目录> && bash setup.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/ppt-tools"

echo "=== pre-PP Skill Setup ==="

# 1. Python 依赖
echo "[1/4] Installing Python dependencies..."
pip3 install --break-system-packages -q python-pptx markitdown 2>/dev/null || \
pip3 install python-pptx markitdown

# 2. Node 依赖
echo "[2/4] Installing Node dependencies..."
if [ ! -d "$TOOLS_DIR/node_modules" ]; then
  cd "$TOOLS_DIR"
  npm install --production
  cd "$SCRIPT_DIR"
else
  echo "  node_modules already exists, skipping"
fi

# 3. Playwright browsers (仅 chromium)
echo "[3/4] Installing Playwright Chromium..."
cd "$TOOLS_DIR"
npx playwright install chromium 2>/dev/null || echo "  Chromium already installed or install skipped"
cd "$SCRIPT_DIR"

# 4. 创建输出目录
echo "[4/4] Creating output directories..."
OUTPUT_BASE="$(dirname "$SCRIPT_DIR")/../../PP评估/decks"
mkdir -p "$OUTPUT_BASE" 2>/dev/null || true

echo ""
echo "=== Setup Complete ==="
echo "Python: python-pptx $(pip3 show python-pptx 2>/dev/null | grep Version | cut -d' ' -f2), markitdown $(pip3 show markitdown 2>/dev/null | grep Version | cut -d' ' -f2)"
echo "Node tools: $TOOLS_DIR"
echo "Output dir: $OUTPUT_BASE"
