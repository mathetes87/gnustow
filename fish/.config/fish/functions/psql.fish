function psql --description "Run psql through distrobox container"
    # Container name for PostgreSQL tools
    set -l container_name "postgres-tools"

    # Check if container exists
    if not distrobox list | grep -q "$container_name"
        echo "Creating distrobox container '$container_name' with PostgreSQL tools..."
        distrobox create --name "$container_name" \
            --image docker.io/library/postgres:16-alpine \
            --additional-flags "--userns=keep-id" \
            --yes

        if test $status -ne 0
            echo "Failed to create container. Aborting."
            return 1
        end
    end

    # Run psql in the container with all arguments passed through
    # distrobox enter handles starting the container automatically
    distrobox enter --name "$container_name" -- psql $argv
end
