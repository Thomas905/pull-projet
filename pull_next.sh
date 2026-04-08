#!/bin/bash

echo "📥 Pull du projet..."
git pull || { echo "❌ Git pull failed"; exit 1; }

echo "📦 Install..."
pnpm install || exit 1

echo "🏗️ Build..."
pnpm build || exit 1

sleep 2

echo ""
echo "🎯 Sélectionne le process PM2 à restart (flèches + entrée) :"

pm2_target=$(pm2 jlist | jq -r '.[].name' | fzf --height=10 --border --prompt="PM2 > ")

if [ -z "$pm2_target" ]; then
  echo "❌ Aucun choix"
  exit 1
fi

echo "🔄 Restart de $pm2_target..."
pm2 restart "$pm2_target"

echo "✅ Done"