#!/bin/bash
# BMad Workflow Automation Script
# Handles: git commit → push → deploy
# Usage: ./bmad-deploy.sh "commit message" [production]

set -e

PROJECT_ROOT="/home/ubuntu/.openclaw/workspace/picoclaw-git"
CREDENTIALS_FILE="/home/ubuntu/.openclaw/credentials/deployment.env"

# Load tokens from secure credentials
if [ -f "$CREDENTIALS_FILE" ]; then
    export $(grep -v '^#' "$CREDENTIALS_FILE" | xargs)
fi

cd "$PROJECT_ROOT"

MESSAGE="${1:-"BMad workflow update"}"
DEPLOY_TARGET="${2:-preview}"

echo "═══════════════════════════════════════"
echo "  BMad Deployment Pipeline"
echo "═══════════════════════════════════════"
echo ""

# Step 1: Git status check
echo "📊 Git Status:"
git status --short

# Step 2: Add and commit
echo ""
echo "📦 Committing changes..."
git add -A
git commit -m "$MESSAGE" || echo "⚠️  Nothing to commit"

# Step 3: Push to GitHub
echo ""
echo "🚀 Pushing to GitHub..."
git push origin main
echo "✅ GitHub: https://github.com/Haneef0123/picoclaw-git"

# Step 4: Deploy to Vercel (if Next.js project exists)
if [ -f "package.json" ]; then
    echo ""
    echo "🚀 Deploying to Vercel..."
    if [ "$DEPLOY_TARGET" == "production" ]; then
        vercel --token="$VERCEL_TOKEN" --prod
    else
        vercel --token="$VERCEL_TOKEN"
    fi
    echo "✅ Deployment complete!"
else
    echo ""
    echo "ℹ️  No package.json found - skipping Vercel deployment"
    echo "   (This is expected during planning phase)"
fi

echo ""
echo "═══════════════════════════════════════"
echo "  Pipeline Complete!"
echo "═══════════════════════════════════════"
