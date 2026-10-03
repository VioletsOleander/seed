# Tool
$env.YAZI_FILE_ONE = [$env.HOMEDRIVE $env.HOMEPATH 'scoop\apps\git\current\usr\bin\file.exe'] | path join
$env.DELTA_PAGER = $'less --lesskey-src="([$env.HOMEDRIVE $env.HOMEPATH "_lesskey"] | path join)"'
$env.BAT_CONFIG_DIR = [$env.APPDATA 'bat'] | path join

# Completion
source 'completions.nu'

let carapace_completer = {|place|
    carapace $place.command.0 nushell ...$place.command
    | from json
}
$env.config.completions.external = {enable: true, completer: $carapace_completer}
