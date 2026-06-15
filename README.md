# 🌸 Lily — Telegram AI Chatbot

A Gen-Z Hinglish AI chatbot for Telegram powered by **Nvidia NIM** (free LLMs).  
She replies with stickers, understands images/video stickers via vision AI, and works in both private chats and group chats.

---

## 📁 Project Structure

```
lily-bot/
├── bot.py               ← Main bot (full features: vision, video stickers)
├── sticker_packs.json   ← Auto-updated list of sticker packs
├── requirements.txt     ← Python dependencies
├── .env.example         ← API key template
├── .env                 ← Your actual keys (DO NOT commit this!)
├── lily-bot.service     ← systemd service for VPS
├── setup.sh             ← One-click VPS setup script
└── README.md            ← This file
```

---

## 🚀 Deploy on VPS (Ubuntu/Debian)

### Step 1 — Upload files to your VPS

```bash
# On your local machine, upload the folder:
scp -r lily-bot/ user@your-vps-ip:~/lily-bot
```

Or clone/copy manually via your VPS panel.

### Step 2 — SSH into your VPS

```bash
ssh user@your-vps-ip
cd ~/lily-bot
```

### Step 3 — Run the setup script

```bash
chmod +x setup.sh
bash setup.sh
```

This will:
- Install system dependencies (`libgl1` for OpenCV, etc.)
- Create a Python virtual environment
- Install all Python packages
- Prompt you to fill in `.env`
- Register and start `lily-bot` as a **systemd service** (auto-starts on reboot)

---

## ⚙️ Manual Setup (if you prefer)

```bash
# Install system deps
sudo apt-get update && sudo apt-get install -y python3 python3-venv libgl1

# Create venv & install packages
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Set up your env file
cp .env.example .env
nano .env   # ← fill in your keys

# Run the bot
python bot.py
```

---

## 🔑 Environment Variables (`.env`)

| Variable | Required | Description |
|---|---|---|
| `TELEGRAM_BOT_TOKEN` | ✅ | From [@BotFather](https://t.me/BotFather) |
| `LLM_API_KEY` | ✅ | From [Nvidia NIM](https://integrate.api.nvidia.com) (free tier available) |
| `HF_TOKEN` | ❌ | Hugging Face token (optional, not used currently) |
| `ALLOWED_USER_ID` | ❌ | Lock bot to one user ID (get it from [@userinfobot](https://t.me/userinfobot)) |
| `BASE_URL` | ❌ | Default: `https://integrate.api.nvidia.com/v1` |

---

## 🛠 Managing the Bot Service

```bash
sudo systemctl status lily-bot      # Is it running?
sudo systemctl restart lily-bot     # Restart after code changes
sudo systemctl stop lily-bot        # Stop the bot
sudo systemctl start lily-bot       # Start it again
sudo journalctl -u lily-bot -f      # Live logs (Ctrl+C to exit)
```

---

## 🤖 Features

- 💬 **Conversational memory** — remembers last 40 messages per user
- 🗣️ **Hinglish / multilingual** — replies in the same language as the user
- 🎭 **Sticker reactions** — sends contextual stickers back
- 👁️ **Vision AI** — understands static, animated, and video stickers
- 📚 **Auto-learns sticker packs** — silently adds new packs from group chats
- 🔄 **LLM fallback chain** — tries 7 models in order if one is rate-limited
- 🔒 **Private mode** — optionally lock to a single user ID

---

## 🔁 Updating the Bot

```bash
# Stop the service
sudo systemctl stop lily-bot

# Upload your new bot.py
scp bot.py user@your-vps-ip:~/lily-bot/bot.py

# Restart
sudo systemctl start lily-bot
sudo journalctl -u lily-bot -f   # Watch logs
```
