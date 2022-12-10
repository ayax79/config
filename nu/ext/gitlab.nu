# The gitlab base path, checks GITLAB_HOST then GL_HOST
def gitlab_url [] {
  let host = ($env | get -i GITLAB_HOST)
  if ($host | is-empty) {
    $env | get -i GL_HOST
  } else {
    $host
  }
}


def clone_page [
  end_cursor: string   # page to pull 
] {
  let query = $"query { projects \(first: 100, after: \"($end_cursor)\") { nodes { fullPath, sshUrlToRepo},  pageInfo {endCursor, hasNextPage} }}"
  $"query: ($query)\n"


  let api_path = $"(gitlab_url)/api/graphql"
  let repos = (glab api $api_path -f $"query=($query)" | from json)
  $"($repos)\n"

  $repos.data.projects.nodes | par-each { |it|
    let full_path = ($it.fullPath)
    let dirs = ($full_path| path split)
    let parents = ($dirs | path join)
    $"Creating parent directories: ($parents)\n"
    mkdir $parents
    let repo = ($it.sshUrlToRepo)
    $"Cloning ($repo) to ($full_path)\n"
    git clone $repo $full_path
  }

  let pageInfo = ($repos.data.projects.pageInfo)

  if $pageInfo.hasNextPage {
    clone_page $pageInfo.endCursor
  }

}


# Clone all repositories that you have access to
export def "glab clone-all" [] {
  clone_page ""
}

# Updates each repo under the parent path
export def "glab pull-all" [] {
  let dirs = (ls -a **/.git | get name | str replace ".git" "")
  $dirs | par-each { |it|
    $"Updating ($it)\n"
    git -C $it pull --rebase --autostash
  }
}

