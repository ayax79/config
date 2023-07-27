$env.CARGO_HOME = $'($env.HOME)/.cargo'
$env.LOCAL_HOME = $'($env.HOME)/.local'
$env.HOMEBREW_HOME = '/opt/homebrew'
$env.NEOVIM_HOME = $'($env.LOCAL_HOME)/share/neovim'

$env.PATH = ($env.PATH | prepend $'($env.HOMEBREW_HOME)/bin')
$env.PATH = ($env.PATH | prepend $'($env.CARGO_HOME)/bin')
$env.PATH = ($env.PATH | prepend $'($env.LOCAL_HOME)/bin')
$env.PATH = ($env.PATH | prepend $'($env.NEOVIM_HOME)/bin')

$env.EDITOR = 'nvim'
$env.THEME = 'nord'

$env.LS_COLORS = (vivid generate $env.THEME)
$env.BAT_THEME = 'Nord'
