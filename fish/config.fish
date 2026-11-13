# Vars.

set --export EDITOR nvim
set --export LANG C.UTF-8
fish_add_path --path ~/.cargo/bin ~/.local/bin
fish_add_path --path /home/linuxbrew/.linuxbrew/bin/

if status is-interactive
    # Abbrs.

    abbr --add g git

    abbr --add ba bat
    abbr --add co cargo
    abbr --add nv nvim
    abbr --add zs z seed

    abbr --add ga git add
    abbr --add gb git branch
    abbr --add gc git commit
    abbr --add gd git diff
    abbr --add gf git fetch
    abbr --add gi git
    abbr --add gl git log
    abbr --add gp git push
    abbr --add gs git status
    abbr --add gw git switch
    abbr --add gr git restore

    abbr --add gll git log --all --oneline --graph -20
    abbr --add gbd git branch -D
    abbr --add cls clear

    abbr --add conf $EDITOR ~/.config/fish/config.fish

    # Keybinds.

    fish_hybrid_key_bindings
    bind --user -M insert ctrl-n down-or-search
    bind --user -M insert ctrl-j down-or-search
    bind --user -M insert ctrl-k up-or-search
    bind --user L end-of-line
    bind --user H beginning-of-line

    # Zoxide

    zoxide init fish | source
end
