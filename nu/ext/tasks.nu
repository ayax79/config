export def "from task" [] {
    let ids_raw = ($in | awk '{print $1}' | lines --skip-empty)
    let ids = ($ids_raw | skip 2 | drop 1)
    task $ids export | from json
}
