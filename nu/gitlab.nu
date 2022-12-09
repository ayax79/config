# The gitlab base path, checks GITLAB_HOST then GL_HOST
def gitlab_url [] {
  let host = ($env | get -i GITLAB_HOST)
  if ($host | is-empty) {
    $env | get -i GL_HOST
  } else {
    $host
  }
}



# Clone all repositories that you have access to
export def "glab clone-all" [] {

  let api_path = $"(gitlab_url)/api/v4/projects"
  let repos = (glab api $api_path | from json)

  $repos | par-each { |it|
    let full_path = ($it.path_with_namespace)
    let dirs = ($full_path| path split)
    let parents = ($dirs | path join)
    $"Creating parent directories: ($parents)\n"
    mkdir $parents
    let repo = ($it.ssh_url_to_repo)
    $"Cloning ($repo) to ($full_path)\n"
    git clone $repo $full_path
  }

}

# Updates each repo under the parent path
export def "glab pull-all" [] {
  let dirs = (ls -a **/.git | get name | str replace ".git" "")
  $dirs | par-each { |it|
    $"Updating ($it)\n"
    git -C $it pull --rebase --autostash
  }
}

