# Tool
$env.BAT_CONFIG_DIR = [$env.HOME ".config/bat"] | path join
$env.RUST_BACKTRACE = 0

# Path
let local_bin = [$env.HOME ".local/bin"] | path join
let cargo_bin = [$env.HOME ".cargo/bin"] | path join

if $local_bin not-in $env.PATH {
    $env.PATH = $env.PATH | prepend $local_bin
}
if $cargo_bin not-in $env.PATH {
    $env.PATH = $env.PATH | prepend $cargo_bin
}

# Completion
let fish_completer = {|place|
    fish --no-config --private --command $"complete '--do-complete=($place.command | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

$env.config.completions.external = {enable: true, completer: $fish_completer}
