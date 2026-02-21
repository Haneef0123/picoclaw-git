#!/bin/bash
# Git push script with automatic commit message
# Usage: ./git-push.sh "commit message"

set -e

PROJECT_ROOT="/home/ubuntu/.openclaw/workspace/picoclaw-git"
cd "$PROJECT_ROOT"

MESSAGE="${1:-"Update from BMad workflow"}"

echo "📦 Adding changes..."
git add -A

echo "📝 Committing: $MESSAGE"
git commit -m "$MESSAGE"

echo "🚀 Pushing to GitHub..."
git push origin main

echo "✅ Pushed successfully!"
echo "🔗 https://github.com/Haneef0123/picoclaw-git"
