if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

# Set up fzf key bindings
fzf --fish | source