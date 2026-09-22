# Create a new pull request with HEAD.
#
# The pull request title will be the the commit message title of HEAD, and description will be the commit message body
# of HEAD.
export def new-pull-request [] {
    ^gh pr new --title (^git log -1 --format=%s) --body (^git log -1 --format=%b)
}

# Create a new branch on HEAD.
#
# The branch name will be <name> appended with unique timestamp.
export def new-branch [name: string] {
    let timestamp = date now | format date "%Y%m%d-%H%M%S"
    let branch = $name + "/" + $timestamp

    ^git switch --create $branch
}

# Push main branch to GitHub and/or Codeberg.
export def update-remotes [] {
    let remotes = (^git remote)

    if ($remotes | str contains 'gh') {
        print 'Pushing to GitHub'
        ^git push gh main
    }

    if ($remotes | str contains 'cb') {
        print 'Pushing to Codeberg'
        ^git push cb main
    }
}

# Squash merge pull request on current branch.
export def merge-pull-request [--message-style(-s): string@[platform-independent github-specific]] {
    if $message_style not-in ['platform-independent', 'github-specific'] {
        error make 'Error: unrecognized message style'
    }

    print 'Checking CI status'

    let checks_result = (^gh pr checks --json 'bucket' | from json)
    if 'fail' in $checks_result.bucket {
        print 'Failed to merge pull request: there exits failed CI'
        return
    }

    print 'Composing pull request message'

    let view_result = (^gh pr view --json 'title,body,url' | from json)
    let title = $view_result.title
    let body = $view_result.body
    let url = $view_result.url

    let message_body = match $message_style {
        'github-specific' => body
        'platform-independent' => {
            let trimmed_body = $body | str trim --right
            $"($trimmed_body)\n\nPR: ($url)"
        }
    }

    print $'Merging pull request ($url)'

    ^gh pr merge --squash --subject $title --body $message_body
}

export alias new-pr = new-pull-request
export alias new-b = new-branch
export alias up-r = update-remotes
export alias mr-pr = merge-pull-request
