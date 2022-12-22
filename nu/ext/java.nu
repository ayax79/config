# List java virtual machines. Requires the plist plugin
export def "java_home list" [] {
  /usr/libexec/java_home -X | from plist | select JVMName JVMHomePath | each {|it| {name: ($it.JVMName | str replace -a ' ' '_'), home: $it.JVMHomePath}}
}

def "nu_complete java_home_names" [] {
  java_home list | get name
}


export def "java_home get" [
  name: string@"nu_complete java_home_names"  # Name of the java home
] {
  java_home list | where $it.name == $name | get home | first
}

# Sets the java home
export def-env "java_home set" [
  name: string@"nu_complete java_home_names"  # Name of the java home
] {

  let path = ($env.PATH | where $it != ($env | get -i JAVA_HOME))
  let-env JAVA_HOME = (java_home get $name)
  let-env PATH = ($path | prepend $env.JAVA_HOME)
}
