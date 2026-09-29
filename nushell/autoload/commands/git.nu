# Create a new branch on HEAD.
#
# The branch name will be <name> appended with unique timestamp.
# The branch name will be the return value of this command.
export def create-branch [name: string] {
    let timestamp = date now | format date "%Y%m%d-%H%M%S"
    let branch = $name + "/" + $timestamp

    ^git switch --create $branch

    $branch
}

# Create a new pull request with HEAD.
#
# The pull request title will be the the commit message title of HEAD, and description will be the
# commit message body of HEAD.
export def create-pull-request [] {
    let subject = ^git log -1 --format=%s
    let body = ^git log -1 --format=%b

    ^gh pr new --title $subject --body $body
}

# Squash merge the pull request on current branch.
#
# The commit message will has a footnote indicating the pull request URL.
export def merge-pull-request [] {
    let info = (^gh pr view --json 'title,body,url,statusCheckRollup' | from json)

    # If has CI, do CI checks.
    if not ($info.statusCheckRollup | is-empty) {
        print 'Checking CI status'
        ^gh pr checks --watch --fail-fast
    }

    print 'Composing pull request message'

    let subject = $info.title
    let body = $"($info.body | str trim --right)\n\nPR: ($info.url)"

    print $'Merging pull request ($info.url)'
    print $"The commit message is\n: ($subject)($body)"

    ^gh pr merge --squash --subject $subject --body $body
}

# Create a commit on the main branch throught a pull request based process.
#
# This command will:
#
# 1. Create a new branch whose name is prefixed with <branch_name> and postfixed with a unique timestamp.
# 2. Switch to that branch and initiate git commit to commit the staged area.
# 3. After commit, create a new pull request with that commit.
# 4. Check pull request CI status and squash that pull request if CI is ok.
# 5. Switch to the main branch, pull the newly merged commit.
# 6. Delete the previouly created branch.
export def create-commit [
    --branch-name(-n): string # Base name of the temporary branch to create
] {
    if ($branch_name | is-empty) {
        error make '--branch-name is required'
    }

    let branch_name = create-branch $branch_name

    ^git commit
    ^git push

    create-pull-request
    merge-pull-request

    ^git switch main
    ^git pull --prune
    ^git branch -D $branch_name
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

export alias cr-pr = create-pull-request
export alias cr-br = create-branch
export alias mr-pr = merge-pull-request
export alias cr-cm = create-commit
