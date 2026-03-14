# Dotfiles

## Introduction

Welcome to my dotfiles repository! This project manages configuration files across multiple devices and operating systems (Linux, macOS, Windows/WSL). It uses GNU Stow to symlink config files to their appropriate system directories.

## Quick Start

```bash
# Run the interactive stow manager
./stow_configs.sh
```

## Prerequisites

1. **GNU Stow** - via your system's package manager:
   - Linux: `sudo apt install stow` (Debian/Ubuntu) or `sudo pacman -S stow` (Arch)
   - macOS: `brew install stow`
   - Windows/WSL: `scoop install stow`
2. **Git** - for version control

## Usage

### Interactive Mode (Recommended)

Run the interactive stow manager:
```bash
./stow_configs.sh
```

This will:
1. Detect which tools are installed on your system
2. Show available packages with their status
3. Allow you to select/deselect tools to stow
4. Install or uninstall selected tools

### Manual Stow

You can also stow individual packages manually:
```bash
stow nvim
stow tmux
stow git
```