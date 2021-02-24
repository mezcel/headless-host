## launch vim in powershell 
## gvim version v81

Set-Alias vim 'C:\Program Files (x86)\Vim\vim81\vim.exe'
Set-Alias vi 'C:\Program Files (x86)\Vim\vim81\vim.exe'
Set-Alias gvim 'C:\Program Files (x86)\Vim\vim81\gvim.exe'

## Append the vimrc

Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set number"
Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set tabstop=4 shiftwidth=4"
Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set expandtab smarttab"
Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set expandtab smarttab"

## No backup dot files

Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set nobackup"
Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set noswapfile"
Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set noundofile"

foldsGeneralPurpose

write-host "
Done.

Press any key to continue..."
[void][System.Console]::ReadKey($true)

# Folds Feature (not implemented)
function foldsGeneralPurpose {
    ## General purpose folding

    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set foldmethod=indent"
    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set foldnestmax=10"
    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set nofoldenable"
    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set foldlevel=2"
}

function foldsForProgramming {
    ## folds for programming syntax
    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set foldmethod=syntax"
}

function foldsForWriting {
    ## fold at indents for normal text files
    Add-Content 'C:\Program Files (x86)\Vim\_vimrc' "set foldmethod=indent"
}
