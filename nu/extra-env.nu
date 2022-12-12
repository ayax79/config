let-env CARGO_HOME = $'($env.HOME)/.cargo'
let-env LOCAL_HOME = $'($env.HOME)/.local'
let-env HOMEBREW_HOME = '/opt/homebrew'
let-env NEOVIM_HOME = $'($env.LOCAL_HOME)/share/neovim'

let-env PATH = ($env.PATH | prepend $'($env.HOMEBREW_HOME)/bin')
let-env PATH = ($env.PATH | prepend $'($env.CARGO_HOME)/bin')
let-env PATH = ($env.PATH | prepend $'($env.LOCAL_HOME)/bin')
let-env PATH = ($env.PATH | prepend $'($env.NEOVIM_HOME)/bin')

let-env EDITOR = 'lvim'
let-env THEME = 'nord'

let-env LS_COLORS = (vivid generate $env.THEME)
