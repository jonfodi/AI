#!/bin/bash
set -e # Stop the script if any command fails

# Color variables
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m' # No Color

# Function to find an available port
find_available_port() {
    local port
    local retry_count=0
    local max_retries=10
    while [ $retry_count -lt $max_retries ]; do
        port=$(comm -23 <(seq 8000 9000) <(netstat -tuln | awk '{print $4}' | awk -F':' '{print $NF}' | sort -n | uniq) | head -n 1)
        if [ -z "$port" ]; then
            echo -e "${RED}No available ports found.${NC}"
            exit 1
        fi
        if ! netstat -tuln | grep -q ":$port\b"; then
            echo $port
            return
        fi
        retry_count=$((retry_count + 1))
    done
    echo -e "${RED}Failed to find an available port after $max_retries attempts.${NC}"
    exit 1
}

# Tag the image with a version and build date for better traceability
IMAGE_TAG="simple_jupyter:$(date +%Y%m%d%H%M)"

# Check the argument
if [ "$1" == "1" ]; then
    echo -e "${GREEN}Building Docker image...${NC}"
    docker build -t $IMAGE_TAG -f deploy/docker/Dockerfile .
    echo -e "${GREEN}Docker image built successfully: $IMAGE_TAG${NC}"

    PORT=$(find_available_port)
    echo -e "${GREEN}Using port $PORT${NC}"
    
    # Attempt to spin up the Jupyter server on the available port
    if ! docker run -it -p $PORT:8888 $IMAGE_TAG /home/jovyan/start-up.sh; then
        echo -e "${RED}Failed to bind to port $PORT. It may already be in use.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Jupyter server is available at http://localhost:$PORT${NC}"
    
elif [ "$1" == "2" ]; then
    # Open the container's shell
    docker run -it $IMAGE_TAG /bin/bash
    echo -e "${GREEN}Opened the container's shell.${NC}"
else
    echo -e "${RED}Invalid argument. Use 1 to build and spin up the Jupyter server or 2 to open the container's shell.${NC}"
    exit 1
fi

