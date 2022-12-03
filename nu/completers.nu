# External completer example
let carapace_completer = {|spans| 
     carapace $spans.0 nushell $spans | from json
}


# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A list of cobra apps that completion will be attempted for.
# Add new apps to this list to enable completion for them.
let cobra_apps = ["minikube", "kubectl", "helm"]

# An external completer that works with any cobra based
# command line application (e.g. kubectl, minikube)
let cobra_completer = {|spans| 
  let cmd = $spans.0

  if not ($cobra_apps | where $cmd =~ $it | is-empty) {
    let ShellCompDirectiveError = 1
    let ShellCompDirectiveNoSpace = 2
    let ShellCompDirectiveNoFileComp = 4
    let ShellCompDirectiveFilterFileExt = 8
    let ShellCompDirectiveFilterDirs = 16
   
    let last_span = ($spans | last | str trim)

    # skip the first entry in the span (the command) and join the rest of the span to create __complete args
    let cmd_args = ($spans | skip 1 | str join ' ') 

    # If the last span entry was empty add "" to the end of the command args
    let cmd_args = if ($last_span | is-empty) {
      $'($cmd_args) ""'
    } else {
      $cmd_args
    }

    # The full command to be executed with active help disable (Nushell does not support active help)
    let full_cmd = $'MINIKUBE_ACTIVE_HELP=0 ($cmd) __complete ($cmd_args)'

    # Since nushell doesn't have anything like eval, execute in a subshell
    let result = (do -i { nu -c $"'($full_cmd)'" } | complete)

    # Create a record with all completion related info. 
    # directive and directive_str are for posterity
    let stdout_lines = ($result.stdout | lines)
    let directive = ($stdout_lines | last | str trim | str replace ":" "" | into int)
    let completions = ($stdout_lines | drop | parse -r '([\w\-\.:\+\=]*)\t?(.*)' | rename value description)

    # filter completions that don't contain the last span, for fuzzy searches
    let filtered = ($completions | where $it.value =~ $last_span) 
    let completions = if not ($filtered | is-empty) {
      $filtered
    } else {
      $completions
    }

    # Add space at the end of each completion
    let completions = if $directive != $ShellCompDirectiveNoSpace {
      ($completions | each {|it| {value: $"($it.value) ", description: $it.description}})
    } else {
      $completions
    }

    if $last_span =~ '=' {
      # if the completion is of the form -n= return flag as part of the completion so that it doesn't get replaced
      $completions | each {|it| $"($last_span | split row '=' | first)=($it.value)" }
    } else if $directive == $ShellCompDirectiveNoFileComp {
      # Allow empty results as this will stop file completion
      $completions
    } else if ($completions | is-empty)  or  $directive == $ShellCompDirectiveError {
      # Not returning null causes file completions to break
      # Return null if there are no completions or ShellCompDirectiveError 
      null
    } else {
      $completions
    }
  } else {
    null
  }
}


# Use my own completer first, then use carapace
let chaining_completer = {|spans| 
  let cmd = $spans.0
  if not ($cobra_apps | where $cmd =~ $it | is-empty) {
    do $cobra_completer $spans
  } else {
    do $carapace_completer $spans
  }
}


