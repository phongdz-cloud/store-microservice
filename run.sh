#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Function to stop and remove all containers and volumes
cleanup() {
    print_message "Cleaning up Docker environment..."
    docker-compose down -v
    docker system prune -f
    print_message "Cleanup completed."
}

# Function to build and start all services
start_services() {
    print_message "Building and starting all services..."
    docker-compose up --build
}

# Function to start services without rebuilding
start_services_no_build() {
    print_message "Starting services without rebuilding..."
    docker-compose up -d
}

# Function to start services in background mode
start_services_background() {
    print_message "Starting services in background mode..."
    docker-compose up -d --build
    print_message "Services are running in background. Use './run.sh logs' to view logs."
}

# Function to build specific services
build_services() {
    if [ $# -eq 0 ]; then
        print_error "Please specify at least one service to build"
        exit 1
    fi

    for service in "$@"; do
        print_message "Building $service..."
        # Build Maven project first
        cd $service
        ./mvnw clean package -DskipTests
        cd ..
        # Then build Docker image
        docker-compose build $service
    done
    print_message "Build completed."
}

# Function to stop all services
stop_services() {
    print_message "Stopping all services..."
    docker-compose down
}

# Function to show logs
show_logs() {
    if [ -z "$1" ]; then
        print_message "Showing logs for all services..."
        docker-compose logs -f
    else
        print_message "Showing logs for $1..."
        docker-compose logs -f $1
    fi
}

# Function to show status of all services
show_services_status() {
    print_message "Showing status of all services..."
    docker-compose ps
}

# Function to rebuild specific services
rebuild_services() {
    if [ -z "$1" ]; then
        print_error "Please specify at least one service name"
        echo "Available services:"
        echo "- postgres"
        echo "- keycloak"
        echo "- service-registry"
        echo "- api-gateway"
        echo "- identity-service"
        echo "- product-service"
        exit 1
    fi

    print_message "Rebuilding specified services..."
    for service in "$@"
    do
        print_message "Rebuilding $service..."
        docker-compose up -d --build --no-deps $service
    done
    print_message "Rebuild completed."
}

# Function to show help
show_help() {
    echo "Usage: ./run.sh [command] [service1] [service2] ..."
    echo ""
    echo "Commands:"
    echo "  start       Build and start all services"
    echo "  up          Start all services without rebuilding"
    echo "  start-bg    Start all services in background mode"
    echo "  build       Build specific services"
    echo "  rebuild     Rebuild and restart specific services"
    echo "  ps          Show status of all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  clean       Stop and remove all containers and volumes"
    echo "  logs        Show logs for all services"
    echo "  logs [service] Show logs for a specific service"
    echo "  restart [service] Restart a specific service"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./run.sh build identity-service product-service"
    echo "  ./run.sh rebuild api-gateway"
    echo "  ./run.sh logs keycloak"
    echo "  ./run.sh restart api-gateway"
}

# Main script
check_docker

case "$1" in
    "start")
        start_services
        ;;
    "up")
        start_services_no_build
        ;;
    "start-bg")
        start_services_background
        ;;
    "build")
        shift  # Remove the first argument (build)
        build_services "$@"
        ;;
    "rebuild")
        shift  # Remove the first argument (rebuild)
        rebuild_services "$@"
        ;;
    "ps")
        show_services_status
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        stop_services
        start_services
        ;;
    "clean")
        cleanup
        ;;
    "logs")
        show_logs $2
        ;;
    "restart")
        if [ -z "$2" ]; then
            print_error "Please specify a service name"
            exit 1
        else
            docker-compose restart $2
        fi
        ;;
    "help"|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac 