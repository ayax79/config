export def "from task" [] {
    let ids = ($in | lines --skip-empty | skip 2 | drop 1 | split column ' ' | get column2 | where (not ($it |is-empty)))
    task $ids export | from json
}
