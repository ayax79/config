# External completer example
let carapace_completer = {|spans| 
     carapace $spans.0 nushell $spans | from json
}


def get_directive_name [
  directive: int
] {
  if $directive == 1 {
    'ShellComp$directiveError'
  } else if $directive == 2 {
    'ShellComp$directiveNoSpace '
  } else if $directive == 4 {
    'ShellComp$directiveNoFileComp'
  } else if $directive == 8 {
    'ShellComp$directiveFilterFileExt'
  } else if $directive == 16 {
    'ShellComp$directiveFilterDirs'
  } else if $directive == 0 {
    'ShellCompDirectiveDefault '
  } else {
      'Unknown'
  } 

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
let cobra_apps = ["minikube", "helm", "kubectl"]

# An external completer that works with any cobra based
# command line application (e.g. kubectl, minikube)
let cobra_completer = {|spans| 
  $"spans: ($spans)\n" | save --append "/tmp/completions.txt"
  let cmd = $spans.0

  if not ($cobra_apps | where $cmd =~ $it | is-empty) {
    let ShellCompDirectiveError = 1
    let ShellCompDirectiveNoSpace = 2
    let ShellCompDirectiveNoFileComp = 4
    let ShellCompDirectiveFilterFileExt = 8
    let ShellCompDirectiveFilterDirs = 16
   
    let last_span = ($spans | last | str trim)

    def exec_complete [
      --fuzzy,
      spans: list
    ] {
      let params = {
        last_span: ($spans | last | str trim),
        spans: $spans
      }
      
      # If there is an equals in the last span
      # parse the span into two
      let params = if $last_span =~ '=' {
        let split = ($last_span | split row '=')
        if ($split | length) > 1 {
          {
            last_span: ($split | last),
            spans: ($spans | drop | append ($split | first) | append ($split | last))
          }
        } else {
          {
            last_span: '',
            spans: ($spans | drop | append ($split | first) | append '')
          }
        } 
      } else {
        $params
      }

      let last_span = $params.last_span
      let spans = $params.spans

      # Drop the last param so we can fuzzy search on it
      let spans = if $fuzzy {
        $spans | drop
      } else {
        $spans
      }

      # skip the first entry in the span (the command) and join the rest of the span to create __complete args
      let cmd_args = ($spans | skip 1 | str join ' ') 

      # If the last span entry was empty add "" to the end of the command args
      let cmd_args = if ($last_span | is-empty) or $fuzzy {
        $'($cmd_args) ""'
      } else {
        $cmd_args
      }

      # The full command to be executed with active help disable (Nushell does not support active help)
      let full_cmd = $'COBRA_ACTIVE_HELP=0 ($cmd) __complete ($cmd_args)'

      # Since nushell doesn't have anything like eval, execute in a subshell
      let result = (do -i { nu -c $"'($full_cmd)'" } | complete)

      # Create a record with all completion related info. 
      # directive and directive_str are for posterity
      let stdout_lines = ($result.stdout | lines)
      let directive = ($stdout_lines | last | str trim | str replace ":" "" | into int)
      let completions = ($stdout_lines | drop | parse -r '([\w\-\.:\+\=\/]*)\t?(.*)' | rename value description)
      let completions = if $fuzzy {
        $completions | where $it.value =~ $last_span

      } else {
        ($completions | where {|it| $it.value | str starts-with $last_span })
      }

      {
        directive: $directive,    
        completions: $completions
      }
    }

    let result = (exec_complete $spans)
    let result = if (not ($last_span | is-empty)) and ($result.completions | is-empty) {
      exec_complete --fuzzy $spans
    } else {
      $result
    }

    let directive = $result.directive
    let completions = $result.completions

    # Add space at the end of each completion
    let completions = if $directive != $ShellCompDirectiveNoSpace {
      $completions | each {|it| {value: $"($it.value) ", description: $it.description}}
    } else {
      $completions
    }

    # Cobra returns a list of completions that are supported with this directive
    # There is no way to currently support this in a nushell external completer
    let completions = if $directive == $ShellCompDirectiveFilterFileExt {
      []
    } else {
      $completions
    }

    let return_val = if $last_span =~ '=' {
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

    $return_val
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
    # do $carapace_completer $spans
    null
  }
}


