#!/usr/bin/env bash
# pre-pp version-check.sh — 每次 skill 运行时检查远程版本
#
# Output (one line, or nothing):
#   UPGRADE_AVAILABLE <local> <remote>  — 远程版本更新
#   UP_TO_DATE <version>                — 已是最新
#   (nothing)                           — 检查跳过（网络超时/被 snooze）
#
# 借鉴 gstack 的设计：缓存机制 + snooze + 超时保护
set -euo pipefail

SKILL_DIR="${PRE_PP_DIR:-$(cd "$(dirname "$0")" && pwd)}"
STATE_DIR="${PRE_PP_STATE_DIR:-$HOME/.pre-pp}"
CACHE_FILE="$STATE_DIR/last-update-check"
SNOOZE_FILE="$STATE_DIR/update-snoozed"
LOCAL_VERSION_FILE="$SKILL_DIR/SKILL.md"
REMOTE_URL="${PRE_PP_REMOTE_URL:-https://raw.githubusercontent.com/MiraclePlus/pre-pp/main/SKILL.md}"

# 缓存有效期：6 小时（避免每次运行都请求网络）
CACHE_TTL=21600

mkdir -p "$STATE_DIR"

# ─── 提取本地版本 ──────────────────────────────────────────
get_local_version() {
  grep -m1 '^version:' "$LOCAL_VERSION_FILE" 2>/dev/null | sed 's/version:[[:space:]]*//'
}

# ─── 检查缓存是否有效 ─────────────────────────────────────
cache_valid() {
  [ -f "$CACHE_FILE" ] || return 1
  local now cached_at
  now=$(date +%s)
  cached_at=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)
  [ $((now - cached_at)) -lt $CACHE_TTL ]
}

# ─── 检查 snooze ──────────────────────────────────────────
is_snoozed() {
  [ -f "$SNOOZE_FILE" ] || return 1
  local now snoozed_until
  now=$(date +%s)
  snoozed_until=$(cat "$SNOOZE_FILE" 2>/dev/null || echo 0)
  [ "$now" -lt "$snoozed_until" ]
}

# ─── Force 模式（跳过缓存和 snooze）─────────────────────
if [ "${1:-}" = "--force" ]; then
  rm -f "$CACHE_FILE" "$SNOOZE_FILE"
fi

# ─── Snooze 检查 ──────────────────────────────────────────
if is_snoozed; then
  exit 0
fi

# ─── 缓存检查 ─────────────────────────────────────────────
LOCAL_VER=$(get_local_version)
if [ -z "$LOCAL_VER" ]; then
  exit 0
fi

if cache_valid; then
  CACHED_REMOTE=$(cat "$CACHE_FILE" 2>/dev/null || true)
  if [ -n "$CACHED_REMOTE" ] && [ "$CACHED_REMOTE" != "$LOCAL_VER" ]; then
    echo "UPGRADE_AVAILABLE $LOCAL_VER $CACHED_REMOTE"
  fi
  exit 0
fi

# ─── 网络请求（2秒超时，不阻塞 skill 启动）─────────────
REMOTE_CONTENT=$(curl -sL --connect-timeout 2 --max-time 5 "$REMOTE_URL" 2>/dev/null || true)
if [ -z "$REMOTE_CONTENT" ]; then
  exit 0
fi

REMOTE_VER=$(echo "$REMOTE_CONTENT" | grep -m1 '^version:' | sed 's/version:[[:space:]]*//')
if [ -z "$REMOTE_VER" ]; then
  exit 0
fi

# 写入缓存
echo "$REMOTE_VER" > "$CACHE_FILE"

# ─── 比较版本 ─────────────────────────────────────────────
if [ "$REMOTE_VER" != "$LOCAL_VER" ]; then
  echo "UPGRADE_AVAILABLE $LOCAL_VER $REMOTE_VER"
else
  echo "UP_TO_DATE $LOCAL_VER"
fi
