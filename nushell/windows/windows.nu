# Tool
$env.YAZI_FILE_ONE = [$env.HOMEDRIVE $env.HOMEPATH 'scoop\apps\git\current\usr\bin\file.exe'] | path join
$env.DELTA_PAGER = $'less --lesskey-src="([$env.HOMEDRIVE $env.HOMEPATH "_lesskey"] | path join)"'
$env.BAT_CONFIG_DIR = [$env.APPDATA 'bat'] | path join

# Completion
use completions/git.nu *
use completions/cargo.nu *
use completions/rustup.nu *
use completions/uv.nu *
use completions/rg.nu *
use completions/eza.nu *
use completions/vivid.nu *
use completions/dprint.nu *
use completions/gh.nu *
use completions/curl.nu *
use completions/fd.nu *
use completions/git-cliff.nu *
use completions/scoop.nu *
use completions/wsl.nu *
