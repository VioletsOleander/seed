### Environment

## Editor
$env.config.buffer_editor = 'nvim'

## Edit
$env.config.edit_mode = 'vi'
$env.config.keybindings ++= [
    # Vim mode
    {
        name: 'ctrl-[ escape'
        modifier: Control
        keycode: Char_u00005b
        mode: [Vi_Insert]
        event: {send: ViChangeMode, mode: normal}
    }
    {
        name: 'ctrl-l escape'
        modifier: Control
        keycode: Char_l
        mode: [Vi_Insert]
        event: {send: ViChangeMode, mode: normal}
    }
    {
        name: 'ctrl-l no-op'
        modifier: Control
        keycode: Char_l
        mode: [Vi_Normal]
        event: {send: None}
    }
    {
        name: 'H goto line start'
        modifier: Shift
        keycode: Char_h
        mode: [Vi_Normal]
        event: {edit: MoveToLineStart, select: false}
    }
    {
        name: 'L goto line end'
        modifier: Shift
        keycode: Char_l
        mode: [Vi_Normal]
        event: {edit: MoveToLineEnd, select: false}
    }
    {
        name: 'ctrl-m enter'
        modifier: Control
        keycode: Char_m
        mode: [Vi_Insert]
        event: {send: Enter}
    }
    {
        name: 'ctrl-f word completion'
        modifier: Control
        keycode: Char_f
        mode: [Vi_Insert]
        event: {
            until: [
                {send: HistoryHintWordComplete}
                {edit: MoveWordRight, select: false}
            ]
        }
    }
    {
        name: 'ctrl-u cut line'
        modifier: Control
        keycode: Char_u
        mode: [Vi_Insert]
        event: {edit: CutFromStart}
    }
    {
        name: 'ctrl-j menu down'
        modifier: Control
        keycode: Char_j
        mode: [Vi_Insert]
        event: {
            until: [
                {send: MenuDown}
                {send: Down}
            ]
        }
    }
    {
        name: 'ctrl-k menu up'
        modifier: Control
        keycode: Char_k
        mode: [Vi_Insert]
        event: {
            until: [
                {send: MenuUp}
                {send: Up}
            ]
        }
    }
]

$env.config.cursor_shape.vi_insert = 'line'
$env.config.cursor_shape.vi_normal = 'block'

## Display
$env.config.color_config.bool = 'cyan'
$env.config.color_config.shape_bool = 'cyan'
$env.config.color_config.shape_external_resolved = 'yellow_bold'
$env.config.color_config.shape_nothing = 'cyan'
$env.config.color_config.shape_raw_string = 'purple'
$env.LS_COLORS = (vivid generate onelight-refined)

## Misc
$env.config.completions.algorithm = "fuzzy"
$env.config.rm.always_trash = true
$env.config.show_banner = false
$env.LANG = 'C.UTF-8' # Disable localization
$env.PROMPT_COMMAND_RIGHT = {||
    let time = date now | format date '%m/%d/%Y %a %I:%M:%S %p'
    $'(ansi purple)($time)(ansi reset)'
}

### Source
## OS specific 
const windows = if $nu.os-info.name == 'windows' {
    $nu.default-config-dir | path join 'windows/windows.nu'
} else { null }

const linux = if $nu.os-info.name == 'linux' {
    $nu.default-config-dir | path join 'linux/linux.nu'
} else { null }

source $windows
source $linux

### Alias

## Built-in
alias la = ls -a
alias ll = ls -l
alias cls = clear

## Tool
alias lg = lazygit
alias re = recnys
alias vn = vanillian
alias nv = nvim
alias np = npm
alias co = cargo
alias ez = eza --long --all
alias cat = bat
alias tec = tectonic

alias g = git
alias ga = git add
alias gc = git commit
alias gs = git status
alias gd = git diff
alias gl = git log
alias gf = git fetch
alias gp = git push
alias gb = git branch
alias gsw = git switch
alias gbd = git branch -D
alias gbdr = git branch -D --remotes

# Only used in vault-vanilla
alias gcd = git cd
alias gcn = git cn
