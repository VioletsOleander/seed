# Tips: Do not add `--help` flag, since it will let nushell take over the help display

# A problem is that non-defined extern will use the completer of `git` for completion

const diffstate_descriptions = {
    'A': 'Added'
    'C': 'Copied'
    'M': 'Modified'
    'D': 'Deleted'
    'R': 'Renamed'
}

const filestate_descriptions = {
    'H': 'Tracked file that is not either unmerged or skip-worktree'
    'S': 'Tracked file that is skip-worktree'
    'M': 'Tracked file that is unmerged'
    'R': 'Tracked file with unstaged removal/deletion'
    'C': 'Modified but not staged' # 'Tracked file with unstaged modification/change'
    'K': 'Untracked paths which are part of file/directory conflicts which prevent checking out tracked files'
    '?': 'Untracked file'
    'U': 'File with resolve-undo information'
}

# Subcommands for git
def commands [] {
    ^git help --all
    | lines
    | where {|line| 
        let trimmed = $line | str trim 
        $trimmed != '' and ($line | str starts-with ' ')
    }
    | parse --regex '\s+(?<value>\S+)\s+(?<description>.+)'
}

# Files changed or untracked
def add-files [] {
    # TODO: Progressive disclosure for directory, by reading context and using git -C
    ^git ls-files -t --modified --others --exclude-standard
    | lines
    | parse --regex '(?<state>[HSMRCK?U]) (?<value>.+)'
    | update 'value' {|row| $'`($row.value)`' }
    | insert 'description' {|row| $filestate_descriptions | get $row.state}
}

# Files changed
def diff-files [context: string] {
    let segments = $context | split row ' '
    let entries = if ('--cached' in $segments) or ('--staged' in $segments) {
        ^git diff --cached --name-status
    } else {
        ^git diff --name-status
    }

    $entries
    | lines
    | parse --regex '(?<state>[ACDMRTUXB])\s+(?<value>.+)'
    | update 'value' {|row| $'`($row.value)`' }
    | insert 'description' {|row| $diffstate_descriptions | get $row.state}
}

# Files changed
def restore-files [place: record] {
    let entries = if ('--staged' in $place.command) or ('-S' in $place.command) {
        # The R100 entires is hard to parse, so turn off rename detection
        ^git diff --cached --name-status --no-renames
    } else {
        ^git diff --name-status --no-renames
    }

    $entries
    | lines
    | parse --regex '(?<state>[ACDMRTUXB])\s+(?<value>.+)'
    | update 'value' {|row| $'`($row.value)`' }
    | insert 'description' {|row| $diffstate_descriptions | get $row.state}
}

# Branches in current repository
def branches [place: record] {
    let branches = if ('-r' in $place.command) or ('--remotes' in $place.command) {
        ^git branch --list --remotes --format='%(refname:lstrip=2)'
    } else {
        ^git branch --list --format='%(refname:lstrip=2)'
    }

    $branches
    | lines
}

# Remotes in current repository
def remotes [] {
    ^git remote
    | lines
}

# Remote branches in current repository
def remote-branches [] {
    ^git branch --remotes
    | lines
    | where {|line| '->' not-in $line}
    | each {|line| $'remotes/($line | str trim)'}
}

# Refspecs in current repository
def refspecs [] {
    let tags = ^git for-each-ref --format='%(refname:strip=2) Tag' refs/tags
    | lines
    | parse --regex '(?<value>\S+)\s+(?<description>.+)'

    let local_branches = ^git for-each-ref --format='%(refname:strip=2) Local Branch' refs/heads
    | lines
    | parse --regex '(?<value>\S+)\s+(?<description>.+)'

    $local_branches
    | append $tags
}

# Commit objects in current repository
def commit-objects [] {
    ^git rev-list --all --oneline
    | lines
    | parse --regex '(?<value>\S+)\s+(?<description>.+)'
}

# Subcommands for git config
def config-commands [] {
    [
        {value: 'list', description: 'List all variables set in config file, along with their values.'}
        {value: 'get', description: 'Emits the value of the specified key.'}
        {value: 'set', description: 'Set value for one or more config options.'}
        {value: 'unset', description: 'Unset value for one or more config options.'}
    ]
}

# Subcommands for git worktree
def worktree-commands [] {
    [
        {value: 'add', description: 'Create a worktree at <path> and checkout <commit-ish> into it.'}
        {value: 'list', description: 'List details of each worktree.'}
        {value: 'remove', description: 'Remove a worktree. Only clean worktrees (no untracked files and no modification in tracked files) can be removed.'}
    ]
}

export extern main [
    --version (-v)
    command?: string@commands 
]

export extern 'git add' [
    --all (-A) # Add changes from all tracked and untracked files.
    --dry-run (-n) 
    --verbose (-v)
    ...pathspec: path@add-files 
]

export extern 'git branch' [
    --delete (-d) # Delete a branch.
    -D # Shortcut for --delete --force.
    --copy (-c) # Copy a branch, together with its config and reflog.
    -C # Shortcut for --copy --force
    --force (-f) # Reset <branch-name> to <start-point>, even if <branch-name> exists already.  In combination with -d (or --delete), allow deleting the branch irrespective of its merged status.
    --list (-l) # List branches.
    --remotes (-r) # List or delete (if used with -d) the remote-tracking branches.
    --all (-a) # List both remote-tracking branches and local branches.
    --set-upstream-to (-u): string@remote-branches # Set up <branch-name>'s tracking information so <upstream> is considered <branch-name>'s upstream branch. If no <branch-name> is specified, then it defaults to the current branch.
    --verbose (-v) # When in list mode, show sha1 and commit subject line for each head, along with relationship to upstream branch (if any). If given twice, print the path of the linked worktree (if any) and the name of the upstream branch, as well.
    ...branch: string@branches
]

export extern 'git switch' [
    --create (-c): string # Create a new branch named <new-branch> starting at current branch.
    --force (-f) # An alias for --discard-changes
    --discard-changes # Proceed even if the index or the working tree differs from HEAD.
    branch?: string@branches 
]

export extern 'git diff' [
    --name-only # Show only the name of each changed file in the post-image tree.
    --name-status # Show only the name(s) and status of each changed file. 
    --cached # Compare index to HEAD.
    --staged # Synonym of --cached.
    --word-diff # Change diff granularity from line to word. By default, words are delimited by whitespace.
    --word-diff-regex: string # Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word. Also implies --word-diff unless it was already enabled. For example, --word-diff-regex=. will treat each character as a word and, correspondingly, show differences character by character.
    --no-renames # Turn off rename detection, even when the configuration file gives the default to do so.
    ...pathspec: path@diff-files
]

export extern 'git restore' [
    --staged (-S) # Specify the restore location to index to only restore the index. 
    --worktree (-W) # Specify the restore location to worktree to only restore the worktree. If --staged, --worktree both not given, worktree is restored by default.
    ...pathspec: path@restore-files
]

export extern 'git commit' [
    --message (-m): string # Use <msg> as the commit message. If multiple -m options are given, their values are concatenated as separate paragraphs.
    --amend # Replace the tip of the current branch by creating a new commit. 
    --edit (-e) # Let the user further edit the message taken from <file> with -F <file>, command line with -m <message>, and from <commit> with -C <commit>.
    --no-edit # Use the selected commit message without launching an editor.
    --no-verify (-n) # Bypass the pre-commit and commit-msg hooks.
    --allow-empty
]

export extern 'git push' [
    --prune # Remove remote branches that don’t have a local counterpart. 
    --delete (-d) # All listed refs are deleted from the remote repository.
    --force (-f) 
    --set-upstream (-u) # For every branch that is up to date or successfully pushed, add upstream (tracking) reference, used by argument-less git-pull[1] and other commands. 
    repository?: string@remotes
    ...refspec: string@refspecs
]

export extern 'git pull' [
    --prune (-p) # Before fetching, remove any remote-tracking references that no longer exist on the remote. 
    --depth: int # Limit fetching to the specified number of commits from the tip of each remote branch history.
    --dry-run
    repository?: string@remotes
]

export extern 'git config' [
    --local # Write to or read from local .git/config file. This is the default behaviour.
    --global # Write to or read from global ~/.gitconfig file.
    command?: string@config-commands
]

export extern 'git status' [
    --untracked-files (-u) # Show untracked files and individual files in untracked directories.
    --short (-s) # Give the output in the short-format.
    --verbose (-v) # In addition to the names of files that have been changed, also show the textual changes that are staged to be committed.
]

export extern 'git clone' [
    --depth: number # Create a shallow clone with a history truncated to the specified number of commits.  
]

export extern 'git ls-files' [
    --modified (-m) # Show files with an unstaged modification (note that an unstaged deletion also counts as an unstaged modification).
    --others (-o) # Show other (i.e. untracked) files in the output.
    -t # Show status tags together with filenames. 
    --exclude-standard # Add the standard Git exclusions: .git/info/exclude, .gitignore in each directory, and the user’s global exclusion file.
]

export extern 'git remote' [
    --verbose (-v) # Be a little more verbose and show remote url after name.
    command?: string@['add', 'rename', 'remove']
]

export extern 'git log' [
    --oneline # This is a shorthand for --pretty=oneline --abbrev-commit used together.
    --all # Pretend as if all the refs in refs/, along with HEAD, are listed on the command line as <commit>.
    --graph # Draw a text-based graphical representation of the commit history on the left hand side of the output.
    --max-count (-n): number # Limit the output to the first <number> commits that would be shown.
]

export extern 'git fetch' [
    --prune # Before fetching, remove any remote-tracking references that no longer exist on the remote.
]

export extern 'git rebase' [
    --interactive (-i) # Make a list of the commits which are about to be rebased. Let the user edit that list before rebasing.
]

export extern 'git worktree' [
    command?: string@worktree-commands
]

export extern 'git show' [
    object?: string@commit-objects
]
