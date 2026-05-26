#!/bin/bash
# pre-pp log-entry.sh — 追加一条迭代日志到 pre-pp-log.md
# 用法: bash log-entry.sh <log_file> <project> <version> <mode> <query> [--output file1 file2 ...] [--slides-url URL]
#
# 示例:
#   bash log-entry.sh ./pre-pp-log.md "Meridian" "v1" "制作" "帮我做一个5分钟路演deck" \
#     --output Meridian-deck-v1.html --slides-url "https://xxx.feishu.cn/slides/xxx"
set -e

LOG_FILE="${1:?用法: log-entry.sh <log_file> <project> <version> <mode> <query> [--output ...] [--slides-url URL]}"
PROJECT="${2:?缺少 project 参数}"
VERSION="${3:?缺少 version 参数}"
MODE="${4:?缺少 mode 参数}"
QUERY="${5:?缺少 query 参数}"
shift 5

# 解析可选参数
OUTPUTS=()
SLIDES_URL=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        OUTPUTS+=("$1")
        shift
      done
      ;;
    --slides-url)
      SLIDES_URL="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# 首次写入时添加文件头
if [ ! -f "$LOG_FILE" ]; then
  cat > "$LOG_FILE" << 'HEADER'
# Pre-PP 迭代日志

> 自动记录每次 deck 迭代的输入输出，便于回顾完整历程。

HEADER
fi

# 截取 query 前 200 字符
QUERY_TRUNCATED="${QUERY:0:200}"

# 追加日志条目
{
  echo "---"
  echo ""
  echo "## ${PROJECT} - ${VERSION} | $(date '+%Y-%m-%d %H:%M')"
  echo ""
  echo "- **Query**: ${QUERY_TRUNCATED}"
  echo "- **Mode**: ${MODE}"
  echo "- **Output**:"
  if [ ${#OUTPUTS[@]} -gt 0 ]; then
    for f in "${OUTPUTS[@]}"; do
      echo "  - \`${f}\`"
    done
  fi
  if [ -n "$SLIDES_URL" ]; then
    echo "  - 飞书 Slides: ${SLIDES_URL}"
  fi
  echo ""
} >> "$LOG_FILE"

echo "✓ 日志已追加到 $LOG_FILE"
