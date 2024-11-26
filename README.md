# Dotfiles

## Introduction

Welcome to my dotfiles repository! This project is designed to manage and share configuration files across multiple devices and operating systems, including Linux, macOS, and Windows/WSL. The repository leverages GNU stow to simplify the process of linking configuration files to their appropriate system directories, ensuring a consistent and portable environment across machines.

Dotfiles are essential for developers and power users, as they store personalized configurations for various tools and programs. By centralizing these configurations, you can quickly set up a new environment or restore your settings after a system change.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your system:

1. Install **GNU Stow**: via your system's package manager:
    - Linux: `sudo apt install stow` (Debian/Ubuntu) ro `sudo pacman -S stow` (Arch).
    - macOS: `brew install stow`.
    - Windows/WSL: Use package manager like `choco` or `scoop` (`scoop install stow`)
2. Clone this **Git** repository:
    - You should be in your `$HOME` directory
        ```bash
        git clone https://github.com/TingeyTime/dotfiles.git
        cd dotfiles
        ```

### Installation and Setup

#### Linux/macOS

1. Clone the repository to your home directory or another preferred location.
1. Navigate to the repository folder.
1. Use GNU stow to link configurations:
    ```bash
    stow nvim
    stow tmux
    stow git
    ```
    This will create symbolic links for the specified configuration files in your home directory.

#### Windows/WSL

1. Clone the repository into your WSL or home directory.
1. Use GNU stow as you would on Linux/macOS to link configurations.
1. For PowerShell configurations, ensure you have administrative privileges when necessary.