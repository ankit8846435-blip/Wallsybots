#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  Lily Bot — VPS Setup Script
#  Run once on your VPS: bash setup.sh
# ─────────────────────────────────────────────────────────────

set -e  # Exit immediately on error

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🌸 Lily Bot — VPS Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. System packages
echo ""
echo "📦 Installing system dependencies..."
sudo apt-get update -qq
sudo apt-get install -y python3 python3-pip python3-venv libgl1 libglib2.0-0

# 2. Virtual environment
echo ""
echo "🐍 Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# 3. Python packages
echo ""
echo "📥 Installing Python packages..."
pip install --upgrade pip -q
pip install -r requirements.txt -q

# 4. .env file
if [ ! -f ".env" ]; then
    echo ""
    echo "⚙️  Creating .env from template..."
    cp .env.example .env
    echo ""
    echo "⚠️  Please fill in your API keys now:"
    echo "    nano .env"
    echo ""
    read -p "Press ENTER after editing .env to continue setup..."
fi

# 5. Install systemd service
echo ""
echo "🔧 Installing systemd service..."

# Replace 'ubuntu' with the current user in the service file
CURRENT_USER=$(whoami)
CURRENT_DIR=$(pwd)

sed "s|/home/ubuntu/lily-bot|$CURRENT_DIR|g; s|User=ubuntu|User=$CURRENT_USER|g" \
    lily-bot.service > /tmp/lily-bot.service

sudo cp /tmp/lily-bot.service /etc/systemd/system/lily-bot.service
sudo systemctl daemon-reload
sudo systemctl enable lily-bot
sudo systemctl start lily-bot

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Setup complete!"
echo ""
echo "  Useful commands:"
echo "    sudo systemctl status lily-bot   → Check if running"
echo "    sudo systemctl restart lily-bot  → Restart the bot"
echo "    sudo systemctl stop lily-bot     → Stop the bot"
echo "    sudo journalctl -u lily-bot -f   → View live logs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
