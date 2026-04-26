# Config Editor
$env.config.buffer_editor = "nvim"

# Edit
$env.config.edit_mode = "vi"
$env.config.keybindings ++= [ {
    name: "ctrl-[ escape"
    modifier: Control 
    keycode: Char_u00005b
    mode: [Vi_Insert]
    event: {
        send: ViChangeMode
        mode: normal # This is case senstive, see https://github.com/nushell/reedline/pull/932
    }
} ]
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

# Color
$env.config.color_config.bool = "cyan"
$env.config.color_config.shape_bool = "cyan"
$env.config.color_config.shape_external_resolved = "yellow_bold"
$env.config.color_config.shape_nothing = "cyan"
$env.config.color_config.shape_raw_string = "purple"

$env.LS_COLORS = (vivid generate one-light-refined)

# Misc
$env.config.rm.always_trash = true
$env.config.show_banner = false

# Nu scripts
const third_party = ($nu.default-config-dir | path join "third_party")
const nu_scripts = ($third_party | path join "nu_scripts")

# completion
const custom_completions = ($nu_scripts | path join "custom-completions")
source ($custom_completions | path join "git/git-completions.nu")
source ($custom_completions | path join "scoop/scoop-completions.nu")
source ($custom_completions | path join "uv/uv-completions.nu")
source ($custom_completions | path join "pytest/pytest-completions.nu")
source ($custom_completions | path join "cargo/cargo-completions.nu")
source ($custom_completions | path join "rustup/rustup-completions.nu")

# color theme
const nu_themes = ($nu_scripts | path join "themes/nu-themes")

# Alias
alias la = ls -a
alias ll = ls -l
alias g = git
alias lg = lazygit
alias re = recnys
alias vn = vanillian
alias nv = nvim
# the completion command will shadow the original command
# for consulting help message, the original command should be preferred
# while ^ is hard to type, so use , to replace it.
alias ,git = ^git
alias ,scoope = ^scoope
alias ,uv = ^uv
alias ,pytest = ^pytest
alias ,cargo = ^cargo

# Plugin
# const NU_PLUGIN_DIRS = [
#   ($nu.current-exe | path dirname)
#   ...$NU_PLUGIN_DIRS
# ]
#
# if ($nu.os-info.name == "windows") {
#   plugin add ($NU_PLUGIN_DIRS | path join "nu_plugin_gstat.exe")
# } else {
#   plugin add ($NU_PLUGIN_DIRS | path join "nu_plugin_gstat")
# }
