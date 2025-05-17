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
    docker-compose up
}

# Function to build specific services
build_services() {
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

    print_message "Building specified services..."
    for service in "$@"
    do
        print_message "Building $service..."
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
    print_message "Showing logs for all services..."
    docker-compose logs -f
}

# Function to show logs for a specific service
show_service_logs() {
    if [ -z "$1" ]; then
        print_error "Please specify a service name"
        echo "Available services:"
        echo "- postgres"
        echo "- keycloak"
        echo "- service-registry"
        echo "- api-gateway"
        echo "- identity-service"
        echo "- product-service"
        exit 1
    fi
    print_message "Showing logs for $1..."
    docker-compose logs -f $1
}

# Function to restart a specific service
restart_service() {
    if [ -z "$1" ]; then
        print_error "Please specify a service name"
        echo "Available services:"
        echo "- postgres"
        echo "- keycloak"
        echo "- service-registry"
        echo "- api-gateway"
        echo "- identity-service"
        echo "- product-service"
        exit 1
    fi
    print_message "Restarting $1..."
    docker-compose restart $1
}

# Function to show help
show_help() {
    echo "Usage: ./run.sh [command] [service1] [service2] ..."
    echo ""
    echo "Commands:"
    echo "  start       Build and start all services"
    echo "  up          Start all services without rebuilding"
    echo "  build       Build specific services"
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
    "build")
        shift  # Remove the first argument (build)
        build_services "$@"
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
        if [ -z "$2" ]; then
            show_logs
        else
            show_service_logs $2
        fi
        ;;
    "restart")
        if [ -z "$2" ]; then
            print_error "Please specify a service name"
            exit 1
        else
            restart_service $2
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