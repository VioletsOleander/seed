$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
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

const third_party = ($nu.default-config-dir | path join "third_party")
const git_completions_path = ($third_party | path join "nu_scripts/custom-completions/git/git-completions.nu")
source $git_completions_path

alias la = ls -a
alias ll = ls -l
alias g = git
alias lg = lazygit
