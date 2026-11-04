set --local commands "branch pr commit"

complete --command devios --no-files

complete --command devios --condition "not __fish_seen_subcommand_from $commands" --arguments branch --description "Manipulate branches"
complete --command devios --condition "not __fish_seen_subcommand_from $commands" --arguments pr --description "Manipulate pull requests"
complete --command devios --condition "not __fish_seen_subcommand_from $commands" --arguments commmit --description "Manipulate commmits"

set --local branch_commands create
set --local pr_commands "create merge"
set --local commit_commands create

complete --command devios --condition "__fish_seen_subcommand_from branch and not __fish_seen_subcommand_from $branch_commands" --arguments create --description "Create a new branch with a timestamp"
complete --command devios --condition "__fish_seen_subcommand_from pr and not __fish_seen_subcommand_from $pr_commands" --arguments create --description "Create a new pull request on HEAD"
complete --command devios --condition "__fish_seen_subcommand_from pr and not __fish_seen_subcommand_from $pr_commands" --arguments merge --description "Sqush merge the pull request on current branch"
complete --command devios --condition "__fish_seen_subcommand_from commit and not __fish_seen_subcommand_from $commit_commands" --arguments create --description "Create a new commit on the main branch via a pr based process"
