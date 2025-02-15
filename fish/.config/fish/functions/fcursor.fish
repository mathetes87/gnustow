function fcursor --wraps='set files $(fzf -m --preview="bat --color=always {}"); and cursor $files' --description 'alias fcursor=set files $(fzf -m --preview="bat --color=always {}"); and cursor $files'
  set files $(fzf -m --preview="bat --color=always {}"); and cursor $files $argv
        
end
