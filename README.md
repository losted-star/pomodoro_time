# Pomodoro Timer

A visually polished desktop Pomodoro timer built with Tauri v2 and vanilla web technologies.

## Features

- **Three timer modes** — Focus (25 min), Short Break (5 min), Long Break (15 min)
- **SVG circular progress ring** — Animated countdown with smooth dash offset transitions
- **Dark glass-morphism UI** — Neon glow effects, color themes per mode (red/green/purple)
- **System tray integration** — Minimizes to tray, right-click menu (Show / Quit), dynamic tooltip showing remaining time
- **Native notifications** — Fires on timer completion via Windows notification system
- **Auto-switch** — Work → Break → Work cycling; every 4th work session triggers a long break
- **Pomodoro counter** — Visual dot indicators (0–8) tracking completed sessions
- **Keyboard shortcuts** — `Space` to start/pause, `R` to reset
- **Lightweight** — ~5 MB binary, no heavy framework dependencies

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Desktop framework | Tauri v2 (Rust) |
| Frontend | Vanilla HTML / CSS / JavaScript |
| Build tool | Vite v8 |
| Notifications | tauri-plugin-notification |
| Rust toolchain | stable-x86_64-pc-windows-msvc |

## Project Structure

```
pomodoro_time/
├── index.html              # Frontend (HTML/CSS/JS, single-file)
├── vite.config.js          # Vite dev server config
├── dev.bat                 # One-click launcher (sets MSVC env)
├── package.json            # Node.js dependencies
│
└── src-tauri/
    ├── Cargo.toml          # Rust crate config
    ├── tauri.conf.json     # Tauri app config (window, CSP, bundle)
    ├── build.rs            # Tauri build script
    ├── capabilities/
    │   └── default.json    # API permissions (window, tray, notification)
    ├── src/
    │   ├── main.rs         # Entry point
    │   └── lib.rs          # Core: tray, notifications, IPC commands
    └── icons/              # App icons (32x32, 128x128, ICO)
```

## Prerequisites

- [Rust](https://rustup.rs/) (stable MSVC toolchain on Windows)
- [Node.js](https://nodejs.org/) v18+
- Visual Studio Build Tools (for MSVC linker) or MinGW-w64 (for GNU)

## Quick Start

### 1. Clone the repo

```bash
git clone git@github.com:losted-star/pomodoro_time.git
cd pomodoro_time
```

### 2. Install dependencies

```bash
npm install
```

### 3. Run in dev mode

**Windows** — double-click `dev.bat`, or run:

```bash
npx tauri dev
```

**macOS / Linux:**

```bash
npx tauri dev
```

The app window will open at 420 × 560 pixels.

### 4. Build for distribution

```bash
npx tauri build
```

The installer / executable will be in `src-tauri/target/release/bundle/`.

## IPC Commands

The frontend calls these Rust commands via `invoke()`:

| Command | Parameters | Description |
|---------|-----------|-------------|
| `send_notification` | `title`, `body` | Shows a native OS notification |
| `set_always_on_top` | `on_top: bool` | Toggles window always-on-top |
| `update_tray_tooltip` | `text` | Updates system tray tooltip text |

## Architecture

```
index.html (JS)
    │
    │  import { invoke } from '@tauri-apps/api/core'
    ▼
Tauri IPC Bridge
    │
    ▼
lib.rs (Rust)
    ├── send_notification()   →  Windows notification
    ├── set_always_on_top()   →  Window Z-order control
    └── update_tray_tooltip() →  Tray tooltip text
```

## License

MIT
