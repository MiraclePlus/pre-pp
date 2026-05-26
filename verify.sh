#!/bin/bash
# pre-pp verify.sh — 安装后环境自检
# 用法: bash verify.sh [--fix]
# 加 --fix 自动尝试修复失败项

set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/ppt-tools"
FIX_MODE="${1:-}"
PASS=0; FAIL=0; WARN=0

check() {
  local label="$1" cmd="$2" fix_cmd="$3"
  if eval "$cmd" &>/dev/null; then
    echo "  ✅ $label"
    ((PASS++))
  else
    echo "  ❌ $label"
    ((FAIL++))
    if [[ "$FIX_MODE" == "--fix" && -n "$fix_cmd" ]]; then
      echo "     → 尝试修复: $fix_cmd"
      eval "$fix_cmd" 2>&1 | sed 's/^/     /'
    else
      [[ -n "$fix_cmd" ]] && echo "     修复: $fix_cmd"
    fi
  fi
}

warn() {
  local label="$1" cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  ✅ $label"
    ((PASS++))
  else
    echo "  ⚠️  $label (可选，飞书 Slides 模式不需要)"
    ((WARN++))
  fi
}

echo "=== pre-PP 环境自检 ==="
echo ""

# 必须项
echo "【必须】"
check "Node.js ≥ 18" \
  "node --version | grep -qE 'v(1[89]|[2-9][0-9])'" \
  "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && sudo apt install -y nodejs"

check "Python ≥ 3.9" \
  "python3 --version | grep -qE '3\.(9|1[0-9]|[2-9][0-9])'" \
  ""

check "python-pptx" \
  "python3 -c 'import pptx'" \
  "pip3 install --break-system-packages python-pptx"

check "markitdown" \
  "python3 -c 'import markitdown'" \
  "pip3 install --break-system-packages markitdown"

check "pptxgenjs" \
  "node -e \"require('$TOOLS_DIR/node_modules/pptxgenjs')\"" \
  "cd $TOOLS_DIR && npm install --production"

check "log-entry.sh 可执行" \
  "test -x $SCRIPT_DIR/log-entry.sh" \
  "chmod +x $SCRIPT_DIR/log-entry.sh"

echo ""

# 本地渲染项（飞书 Slides 模式可跳过）
echo "【本地渲染】（仅 --format pptx/html/pdf 需要）"
warn "中文字体" \
  "fc-list :lang=zh 2>/dev/null | grep -q ."

warn "sharp (图片处理)" \
  "node -e \"require('$TOOLS_DIR/node_modules/sharp')\""

warn "Chromium (Playwright)" \
  "ls $HOME/.cache/ms-playwright/chromium-* &>/dev/null || ls /usr/bin/chromium-browser &>/dev/null"

echo ""

# 输出目录
echo "【输出】"
OUTPUT_BASE="$(dirname "$SCRIPT_DIR")/../../PP评估/decks"
check "输出目录存在" \
  "test -d '$OUTPUT_BASE'" \
  "mkdir -p '$OUTPUT_BASE'"

check "迭代日志文件" \
  "test -f '$OUTPUT_BASE/pre-pp-log.md'" \
  "bash $SCRIPT_DIR/setup.sh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  结果: ✅ $PASS 通过  ❌ $FAIL 失败  ⚠️  $WARN 可选未装"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ $FAIL -gt 0 ]]; then
  echo ""
  echo "提示: 运行 'bash verify.sh --fix' 自动修复失败项"
  exit 1
fi
