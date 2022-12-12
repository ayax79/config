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



# Close the focused pane                                                                                                                                                                                                                                                                                                       
export extern "zellij action close-pane" [
    --help(-h)
]

# Close the current tab
export extern "zellij action close-tab" [
    --help(-h)
]


# Dump the focused pane to a file
export extern "zellij action dump-screen" [
    --help(-h)
]

#Open the specified file in a new zellij pane with your default EDITOR
export extern "zellij action edit" [
    --help(-h)
]

# Open the pane scrollback in your default editor
export extern "zellij action edit-scrollback" [
    --help(-h)
]

# Change focus to the next pane
export extern "zellij action focus-next-pane" [
    --help(-h)
]

# Change focus to the previous pane
export extern "zellij action focus-previous-pane" [
    --help(-h)
]

# Go to the next tab
export extern "zellij action go-to-next-tab" [
    --help(-h)
]

# Go to the previous tab
export extern "zellij action go-to-previous-tab" [
    --help(-h)
]


# Go to tab with index [index]
export extern "zellij action go-to-tab" [
    --help(-h)
]

# Scroll down half page in focus pane
export extern "zellij action half-page-scroll-down" [
    --help(-h)
]

# Scroll up half page in focus pane
export extern "zellij action half-page-scroll-up" [
    --help(-h)
]

# Print this message or the help of the given subcommand(s)
export extern "zellij action help" [
    --help(-h)
]

# Move the focused pane in the specified direction. [right|left|up|down]
export extern "zellij action move-focus" [
    --help(-h)
]

# Move focus to the pane or tab (if on screen edge) in the specified direction  
# [right|left|up|down]                                                         
export extern "zellij action move-focus-or-tab" [
    --help(-h)
]


# Change the location of the focused pane in the specified direction [right|left|up|down]       
export extern "zellij action move-pane" [
    --help(-h)
]                                                                                      


# Open a new pane in the specified direction [right|down] If no direction is specified,   
# will try to use the biggest available space                                             
export extern "zellij action new-pane" [
    --help(-h)
]                                                                                       


# Create a new tab, optionally with a specified tab layout and name                       
export extern "zellij action new-tab" [
    --help(-h)
]                                                                                        

# Scroll down one page in focus pane                                                      
export extern "zellij action page-scroll-down" [
    --help(-h)
]                                                                               


# Scroll up one page in focus pane                                                        
export extern "zellij action page-scroll-up" [
    --help(-h)
]                                                                                 


# Renames the focused pane                                                                
export extern "zellij action rename-pane" [
    --help(-h)
]                                                                                    

# Renames the focused pane                                                                
export extern "zellij action rename-tab" [
    --help(-h)
]                                                                                    

# [increase|decrease] the focused panes area at the [left|down|up|right] border           
export extern "zellij action resize" [
    --help(-h)
]                                                                                         


# Scroll down in focus pane                                                               
export extern "zellij action scroll-down" [
    --help(-h)
]                                                                                    


# Scroll down to bottom in focus pane                                                     
export extern "zellij action scroll-to-bottom" [
    --help(-h)
]                                                                               

# Scroll up in the focused pane                                                           
export extern "zellij action scroll-up" [
    --help(-h)
]                                                                                      

# Switch input mode of all connected clients [locked|pane|tab|resize|move|search|session] 
export extern "zellij action switch-mode" [
    --help(-h)
]                                                                                    


# Toggle between sending text commands to all panes on the current tab and normal mode    
export extern "zellij action toggle-active-sync-tab" [
    --help(-h)
]                                                                         


# Toggle the visibility of all fdirectionloating panes in the current Tab, open one if none exist                                                                              
export extern "zellij action toggle-floating-panes" [
    --help(-h)
]                                                                          


# Toggle between fullscreen focus pane and normal layout                                  
export extern "zellij action toggle-fullscreen" [
    --help(-h)
]                                                                              

# Embed focused pane if floating or float focused pane if embedded                        
export extern "zellij action toggle-pane-embed-or-floating" [
    --help(-h)
]                                                                  

# Toggle frames around panes in the UI                                                    
export extern "zellij action toggle-pane-frames" [
    --help(-h)
]                                                                             

# Remove a previously set pane name                                                       
export extern "zellij action undo-rename-pane" [
    --help(-h)
]                                                                               

# Remove a previously set tab name                                                        
export extern "zellij action undo-rename-tab" [
    --help(-h)
]                                                                                

# Write bytes to the terminal
export extern "zellij action write" [
    --help(-h)
]                                                                                          

# Write characters to the terminl
export extern "zellij action write-chars" [
    --help(-h)
]                                                                                    
