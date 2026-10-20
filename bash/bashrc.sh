# Sourced from ~/.bashrc (install.sh adds the line).

. "$(dirname "${BASH_SOURCE[0]}")/aliases.sh"

if command -v starship >/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    eval "$(starship init bash)"
fi
