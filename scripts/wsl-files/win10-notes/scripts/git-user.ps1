## setup git user info

function setup_git {

    $githubusername = Read-Host -Prompt 'Input your github.com  name: '
    $githubuseremail = Read-Host -Prompt 'Input your github.com  email: '

    git config --global user.name $githubusername
    git config --global user.email $githubuseremail
    git config --global  core.editor "nano"
}

setup_git

write-host "
The following was set:

    git config --global user.name $githubusername
    git config --global user.email $githubuseremail
    git config --global  core.editor "nano"

Press any key to continue..."
[void][System.Console]::ReadKey($true)