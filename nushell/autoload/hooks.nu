# Let nushell send ansi escape sequence (CSI) '0 q' to the terminal everytime, to reset the cursor-shape
# to user-default
# see: https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences#cursor-shape
#
# Note that in https://invisible-island.net/xterm/ctlseqs/ctlseqs.html, CSI '0 q' is setting the cursor to
# blinking block, so the actual behaviour is relied on the terminal implementation
#
# Both neovim and windows terminal developers have made effort to solve this problem, but it turns out
# that we have to handle this cursor issue by ourself (see https://github.com/neovim/neovim/issues/36863),
# I'd say it is kind of annoying to be confused by the cursor-shape everytime.

$env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt | append { print -n (ansi -e '0 q') }
