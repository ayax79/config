# Display the names of all Lambda functions in the current environment
export def "aws lambda log names" [] {
    aws logs describe-log-groups --query logGroups[*].logGroupName | from json
}


# Display all the log locations for a specified lambda function
export def "aws lambda log ls" [
    # The name of the lambda function to get logs for for
    function_name: string@"aws lambda log names"
] {
    aws logs describe-log-streams --log-group-name $function_name --query logStreams[*].logStreamName | from json
}

export def "aws lambda log last" [
    # The name of the lambda function to get logs for for
    function_name: string@"aws lambda log names"
] {
    aws lambda log ls $function_name | last
}

export def "aws lambda log open" [
    # The name of the lambda function to get logs for for
    function_name: string@"aws lambda log names"
    # The name of the log to use, it will default to latest
    log_name: string
]  {

    let log = if ($log_name == null) {
        last_log_name $function_name
    } else {
        $log_name
    }

    aws logs get-log-events --log-group-name $function_name --log-stream-name $log | from json
}

export def "aws lambda log open-last" [
    # The name of the lambda function to get logs for for
    function_name: string@"aws lambda log names"
] {
    let log_name = (aws lambda log last $function_name)
    aws lambda log open $function_name $log_name
}


