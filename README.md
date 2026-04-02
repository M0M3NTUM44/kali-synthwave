# 🎧 Kali Synthwave Terminal Setup

> *"If The Rule You Followed Brought You To This... Of What Use Was The Rule?..."*

A one-shot script to transform any fresh Kali Linux into a **synthwave-themed**, fully equipped hacker terminal.

![Synthwave](https://img.shields.io/badge/theme-synthwave-BD93F9?style=for-the-badge&logo=gnome-terminal&logoColor=white)
![Kali](https://img.shields.io/badge/Kali-Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white)
![Zsh](https://img.shields.io/badge/Shell-Zsh-00FFFF?style=for-the-badge&logo=gnu-bash&logoColor=white)

---

## 🖥️ What You Get

| Feature | Details |
|---|---|
| **Shell** | Zsh + Oh-My-Zsh |
| **Theme** | Powerlevel10k (pre-configured, no wizard) |
| **Font** | MesloLGS Nerd Font (icons + glyphs) |
| **Colors** | Synthwave Dark — deep purple bg, neon cyan + magenta |
| **Syntax highlighting** | Commands glow cyan ✓ or red ✗ before you hit enter |
| **Autosuggestions** | Ghost text from history (→ to accept) |
| **Startup banner** | Fastfetch system info with HACK ASCII logo |
| **Quote** | The rule quote on every terminal open |
| **Hacker aliases** | nmap, gobuster, ffuf, burp, msf, serve + more |

---

## ⚡ Quick Install

```bash
git clone https://github.com/M0M3NTUM44/kali-synthwave.git
cd kali-synthwave
bash setup.sh
```

Then restart your terminal.

---

## 🎨 After Install

### For QTerminal (Kali Default)
1. Dropdown Menu / File → **Preferences**
2. **Appearance** tab:
   - **Color Scheme**: Select `Synthwave Dark`
   - **Font**: Set to `MesloLGS NF`
3. Restart terminal

### For XFCE4 Terminal
1. **Edit** → **Preferences**
2. **Appearance** tab → Font → set to `MesloLGS NF 12`
3. **Colors** tab → Presets → select `Synthwave Dark`
4. Restart terminal

---

## 🛠️ Aliases Included

### Recon
```bash
nmapq       # nmap -sV -sC (quick)
nmapfull    # nmap -p- full port scan
nmapudp     # UDP top 200 ports
nmapvuln    # vuln scripts
nmappng     # ping sweep
```

### Web
```bash
ffd         # ffuf with common wordlist
gobust      # gobuster dir scan
ferox       # feroxbuster
```

### Network
```bash
myip        # external IP
localip     # local interfaces
ports       # all listening ports
sniff       # tcpdump capture
serve       # python3 http server
```

### Tools
```bash
msf         # msfconsole quiet
burp        # launch Burp Suite
py          # python3
revshell    # quick pty spawn
```

---

## 🎨 Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#0D0D1E` | Deep space purple |
| Foreground | `#E0D0FF` | Soft lavender |
| Cyan | `#00FFFF` | Commands, cursor |
| Magenta | `#FF79C6` | Pink neon accents |
| Purple | `#BD93F9` | Directories |
| Green | `#50FA7B` | Success / clean git |
| Red | `#FF5555` | Errors |
| Yellow | `#F1FA8C` | Warnings / timing |

---

## 📦 Stack

- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [MesloLGS Nerd Font](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)

---

*Built for offensive security professionals who take their terminal seriously.*
