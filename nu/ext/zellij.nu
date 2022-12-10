export extern zellij [
    --config(-c): string,     # Change where zellij looks for the configuration file [env: ZELLIJ_CONFIG_FILE=]
    --config-dir: string,     # Change where zellij looks for the configuration directory [env: ZELLIJ_CONFIG_DIR=]
    --debug(-d): string,      # Specify emitting additional debug information
    --data-dir                # Change where zellij looks for plugins
    --help(-h)                # Print help information
    --layout(-l)              # Name of a predefined layout inside the layout directory or the path to a layout file
    --max-panes               # Maximum panes on screen, caution: opening more panes will close old ones
    --session(-s)             # Specify name of a new session
    --version(-V)             # Print version information
]

export def "nu-complete zellij-sessions" [] {
  zellij list-sessions | lines | where not $it =~ current
}


# Send actions to a specific session [aliases: ac]
export extern "zellij action" [
    --help(-h)                # Print help information
]

export alias "zellij ac" = zellij action

# Attach to a session [alijases: a]
export extern "zellij attach" [
    session?:string@"nu-complete zellij-sessions",
    --help(-h)                # Print help information
]             

export alias "zellij a" = zellij attach

export extern "zellij convert-config" [
    old_config_file:glob,
    --help(-h)                # Print help information
]

export extern "zellij convert-layout" [
    old_layout_file:glob,
    --help(-h)                # Print help information

]

export extern "zellij convert-theme" [
    old_theme_file: glob,
    --help(-h)                # Print help information
]

# Edit file with default $EDITOR / $VISUAL [aliases: e]
export extern "zellij edit" [
    file:glob,
    --help(-h)                # Print help information

]

# Print this message or the help of the given subcommand(s)
export extern "zellij help" [
    --help(-h)                # Print help information
]
 
# Kill all sessions [aliases: ka]
export extern "zellij kill-all-sessions" [
    --help(-h)                # Print help information
    --yes(-y)                 # Automatic yes to prompts
]

# Kill the specific session [aliases: k]
export extern "zellij kill-session" [
    session?:string@"nu-complete zellij-sessions"
    --help(-h)                # Print help information
]

# List active sessions [aliases: ls]
export extern "zellij list-sessions" [
    --help(-h)                # Print help information
]

export alias "zellij ls" = zellij list-sessions

# Change the behaviour of zellij
export extern "zellij options" [
    --help(-h)                # Print help information

]

# Run a command in a new pane [aliases: r]
export extern "zellij run" [
    --help(-h)                # Print help information

]

# Setup zellij and check its configuration
export extern "zellij setup" [
    --help(-h)                # Print help information

]


# Return the current session
export def "zellij current" [] {
  zellij ls | lines | where $it =~ current | first | split row " " | first
}
