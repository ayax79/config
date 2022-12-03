let-env CARGO_HOME = $'($env.HOME)/.cargo'
let-env LOCAL_HOME = $'($env.HOME)/.local'
let-env HOMEBREW_HOME = '/opt/homebrew'

let-env PATH = ($env.PATH | prepend $'($env.CARGO_HOME)/bin')
let-env PATH = ($env.PATH | prepend $'($env.LOCAL_HOME)/bin')
let-env PATH = ($env.PATH | prepend $'($env.HOMEBREW_HOME)/bin')
