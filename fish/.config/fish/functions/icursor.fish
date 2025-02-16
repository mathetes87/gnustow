function icursor
    set -l mode "dirs"  # Default mode is directories
    set -l search_path "."  # Default search path is the current directory

    # Parse arguments
    set -l args $argv
    set -l flags  # Will hold flags
    set -l non_flags  # Will hold non-flag arguments (like path)

    for arg in $args
        if echo $arg | string match -r "^-"  # Check if it's a flag
            set flags $flags $arg
        else
            set non_flags $non_flags $arg
        end
    end

    # Check for the flag indicating "files"
    if echo $flags | grep -q -e "--file" -e "-f"
        set mode "files"
    end

    # If there's a path, use it; otherwise, use the default "."
    if test (count $non_flags) -gt 0
        set search_path $non_flags[1]
    end

    # Run the appropriate fzf command
    if test "$mode" = "files"
        set selection (find $search_path -type f -readable -print 2>/dev/null | fzf -m --preview="bat --color=always {} 2>/dev/null || echo 'Unable to preview file'")
    else
        set selection (find $search_path -type d -readable -print 2>/dev/null | fzf)
    end

    # Check if selection is empty (Ctrl+C or no selection)
    if test -n "$selection"
        echo "cursor $selection"
        cursor $selection
    end
end
