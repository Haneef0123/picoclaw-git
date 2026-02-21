#!/bin/bash
# Deploy script for picoclaw-git
# Usage: ./deploy.sh [production]

set -e

PROJECT_ROOT="/home/ubuntu/.openclaw/workspace/picoclaw-git"
CREDENTIALS_FILE="/home/ubuntu/.openclaw/credentials/deployment.env"

# Load tokens from secure credentials
if [ -f "$CREDENTIALS_FILE" ]; then
    export $(grep -v '^#' "$CREDENTIALS_FILE" | xargs)
fi

cd "$PROJECT_ROOT"

echo "🔨 Building project..."

# Check if Next.js project exists
if [ -f "package.json" ]; then
    npm install
    npm run build
fi

echo "🚀 Deploying to Vercel..."

if [ "$1" == "production" ]; then
    vercel --token="$VERCEL_TOKEN" --prod
    echo "✅ Deployed to production!"
else
    vercel --token="$VERCEL_TOKEN"
    echo "✅ Preview deployed!"
fi
