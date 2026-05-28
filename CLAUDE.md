# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run in dev mode (requires MSVC environment on Windows)
npx tauri dev

# On Windows, use the launcher which sets MSVC PATH/LIB/INCLUDE
dev.bat

# Build production release
npx tauri build

# Rust check only (no JS)
cargo check -p pomodoro-timer

# Run Vite frontend alone (no Tauri window)
npx vite --port 1420
```

## Architecture

This is a Tauri v2 desktop app. There are three key files that define the entire application:

- **`index.html`** — The whole frontend: DOM structure (lines 253-313), all CSS in `<style>` (lines 7-251), and all JS logic as an ES module in `<script type="module">` (lines 315-491). No framework. State is held in a single `state` object (mode, remaining, total, running, completed, intervalId). Timer tick updates the SVG ring via `setProgress()`, which sets `stroke-dashoffset` on a circle with circumference `2 * PI * 130` (≈ 816.814). The frontend calls Rust via `import { invoke } from '@tauri-apps/api/core'`.

- **`src-tauri/src/lib.rs`** — Three `#[tauri::command]` functions exposed over IPC: `send_notification`, `set_always_on_top`, `update_tray_tooltip`. The `run()` function wires the tray icon (left-click shows window, right-click menu with Show/Quit), intercepts `CloseRequested` to hide-to-tray instead of quitting, and registers the command handler.

- **`src-tauri/tauri.conf.json`** — Window config (420x560, non-resizable, centered), dev server URL (`http://localhost:1420`), CSP, bundle icons.

Data flow: `index.html` JS -> `invoke('command', {args})` -> Tauri IPC bridge -> Rust function in `lib.rs` -> OS APIs (notifications, window management, tray).

`src-tauri/src/main.rs` is a one-liner: calls `pomodoro_timer::run()`.

## Crate naming

Cargo crate name is `pomodoro-timer` (hyphenated). The Rust module path is `pomodoro_timer` (underscored). In `Cargo.toml` the `[package] name` is `pomodoro-timer`.

## Tauri v2 capability system

`src-tauri/capabilities/default.json` declares which APIs the webview can access. Permissions are explicit: window operations, tray, and notifications each need their own entries. If a new `invoke()` call fails with "not allowed", a permission is missing here.

## Port 1420 and Vite lifecycle

In dev mode, `npx tauri dev` runs `beforeDevCommand` (`npx vite`) to start the Vite dev server on port 1420, then runs `cargo run` which opens a native window connecting to `http://localhost:1420`. If the Vite process from a previous run is still alive (e.g., after killing `npx tauri dev` with Ctrl+C), the next run fails — `beforeDevCommand` can't start because port 1420 is occupied. Kill the stale Vite with `npx kill-port 1420` before retrying.

`vite.config.js` ignores `**/src-tauri/**` and `**/target/**` in its file watcher to prevent EBUSY errors from Cargo build artifacts.

## MSVC environment (Windows)

This project uses the `stable-x86_64-pc-windows-msvc` Rust toolchain. Cargo needs the MSVC linker and Windows SDK libraries on PATH, LIB, and INCLUDE. `dev.bat` sets these before running `npx tauri dev`. The current paths:

- MSVC: `C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.51.36231`
- SDK: `C:\Program Files (x86)\Windows Kits\10`
- SDK version: `10.0.26100.0`
