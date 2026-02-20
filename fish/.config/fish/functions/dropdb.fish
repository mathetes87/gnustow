function dropdb --description "Run dropdb through distrobox container"
    set -l container_name "postgres-tools"

    if not distrobox list | grep -q "$container_name"
        echo "Container 'postgres-tools' not found. Run 'psql' first to create it."
        return 1
    end

    distrobox enter "$container_name" -- dropdb $argv
end
