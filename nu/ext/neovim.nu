def remote_path [
  prefix: string,
  index: int,
] {
  $"/tmp/nvim-($prefix)-($index)"
}


def build_remote_file [
  prefix: string,
  index: int,
] {
  let p = (remote_path $prefix $index)
  if ($p | path exists) {
    build_remote_file $prefix ($index + 1)
  } else {
    $p
  }
}

export def build_remote_location [
  index: int
] {
  let zellij_session = (zellij current)
  if ($zellij_session | is-empty) {
    let prefix = (random chars)
    build_remote_file $prefix $index
  } else {
    build_remote_file $zellij_session $index
  }
}

#export alias lvim = lvim --listen (build_listen_location)

# Run lunar vim while controlling which neovim server by zellij session
export def vir [
  --listen(-l),                       # Port to listen on for initial session
  --index(-i): int = 0,               # The version per zellij session
  --remote(-r): string,               # The remote string.. optional instead of --index
  --previous-pane(-p)                 # Return to the previous pane in zellij (probably the editor pane)
  ...rest: string,                    # The rest of the command args
] {
  
  if $listen {
    let location = (build_remote_location $index)
    $"Listening on ($location)\n"
    lvim --listen $location $rest
  } else {

    if not ($remote | is-empty) {
      $"Attempting to connect to ($remote)\n"
      nvr --servername $remote $rest
    } else {
      let current_session = (zellij current)
      let path = (remote_path $current_session $index)
      $"Attempting to connect to ($path)\n"
      nvr --servername $path $rest
    }

    if $previous_pane {
      zellij action focus-previous-pane
    }
  }

}


