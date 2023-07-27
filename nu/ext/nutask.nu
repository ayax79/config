def base_filters [] {
    ["rc.verbose:nothing"]
}

def exec_task [
    --filters: list,
] {
    let combined_filters = (base_filters | append $filters)
    let raw = (task $combined_filters nu)
    let exported = ($raw | lines | task export $in)
    let converted = ($exported | from json)

    $converted | par-each { |it| 
        $it
    }
}

# Setup the report that will be used by nushell
export def init [] {
    task config "report.nu.columns" "uuid"
    task config "report.nu.description" "report used by nushell"
}

# Show completed tasks
export def completed [
    --filters: list,  # Additional filters to provide to taskwarrior
] {
    exec_task --filters ($filters | append status:completed)
}

# Show completed today
export def completed-today [
    --filters: list,  # Additional filters to provide to taskwarrior
] {
    
    completed --filters ($filters | append end.after:yesterday)
}

export def list [
    --filters: list, # Additional filters to provide to taskwar
] {
    exec_task --filters ($filters | append "status:pending -WAITING")
}

# start-,due+,project+,urgency-
