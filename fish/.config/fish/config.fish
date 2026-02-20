# Prioritize Linuxbrew Python 3.13
fish_add_path -p /home/linuxbrew/.linuxbrew/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

# Set up fzf key bindings
fzf --fish | source

# AWS completer
complete --command aws --no-files --arguments "(aws_completer)"

# others
zoxide init fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /var/home/mathetes/.lmstudio/bin
# End of LM Studio CLI section


# SSM tunnel to staging internal API with transparent DNS routing
function ssm-stg-api
    echo "Setting up nftables redirect (80 → 8080)..."
    sudo nft add table ip nat 2>/dev/null
    sudo nft add chain ip nat output '{ type nat hook output priority -100 ; }' 2>/dev/null
    sudo nft add rule ip nat output tcp dport 80 ip daddr 127.0.0.1 redirect to :8080 2>/dev/null

    echo "Starting SSM tunnel on port 8080..."
    echo "Press Ctrl+C to stop and cleanup"

    # Run SSM session (blocks until Ctrl+C)
    AWS_PROFILE=stg-admin aws ssm start-session \
        --target i-0d1380a870cb3cd43 \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters '{"host":["internal-stg-int-srv-gral-1963655361.us-west-2.elb.amazonaws.com"],"portNumber":["80"],"localPortNumber":["8080"]}' \
        --region us-west-2

    # Cleanup on exit
    echo "Cleaning up nftables rules..."
    sudo nft delete table ip nat 2>/dev/null
    echo "Done."
end

function ssm-stg-api-stop
    echo "Cleaning up nftables rules..."
    sudo nft delete table ip nat 2>/dev/null
    echo "Done."
end

# Claude Code aliases
alias cc='claude --dangerously-skip-permissions'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/var/home/mathetes/google-cloud-sdk/path.fish.inc' ]; . '/var/home/mathetes/google-cloud-sdk/path.fish.inc'; end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
