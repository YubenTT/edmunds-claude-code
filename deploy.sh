#!/bin/bash
# AI CLI Orchestrator V2 - Automated Deployment Script
# This script automates the deployment process for production or local testing

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}===================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main deployment function
main() {
    print_header "AI CLI Orchestrator V2 - Automated Deployment"

    # Step 1: Check prerequisites
    print_header "Step 1/8: Checking Prerequisites"

    # Check Docker
    if ! command_exists docker; then
        print_error "Docker is not installed"
        print_info "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        print_success "Docker installed"
        print_warning "Please log out and log back in for Docker permissions to take effect"
        print_warning "Then run this script again"
        exit 0
    fi
    print_success "Docker found: $(docker --version)"

    # Check Docker Compose
    if ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose is not installed"
        exit 1
    fi
    print_success "Docker Compose found: $(docker compose version)"

    # Check if .env exists
    if [ ! -f .env ]; then
        print_warning ".env file not found"
        print_info "Creating .env from template..."

        if [ -f .env.v2.example ]; then
            cp .env.v2.example .env
            print_success ".env created from template"
            print_warning "Please edit .env file and add your Supabase credentials:"
            print_info "  - SUPABASE_URL"
            print_info "  - SUPABASE_ANON_KEY"
            print_info "  - SUPABASE_SERVICE_KEY"
            print_info ""
            print_info "After editing, run this script again"

            # Open editor if available
            if command_exists nano; then
                read -p "Open .env in nano now? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    nano .env
                fi
            fi
            exit 0
        else
            print_error ".env.v2.example not found"
            exit 1
        fi
    fi

    # Verify required env vars
    source .env
    if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ] || [ -z "$SUPABASE_SERVICE_KEY" ]; then
        print_error "Missing required Supabase environment variables in .env"
        print_info "Please set: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY"
        exit 1
    fi
    print_success "Environment configuration verified"

    # Step 2: Generate secrets if missing
    print_header "Step 2/8: Generating Security Secrets"

    SECRETS_UPDATED=false

    if [ -z "$JWT_SECRET" ]; then
        JWT_SECRET=$(openssl rand -hex 32)
        echo "JWT_SECRET=$JWT_SECRET" >> .env
        SECRETS_UPDATED=true
        print_success "Generated JWT_SECRET"
    fi

    if [ -z "$API_KEY_SALT" ]; then
        API_KEY_SALT=$(openssl rand -hex 32)
        echo "API_KEY_SALT=$API_KEY_SALT" >> .env
        SECRETS_UPDATED=true
        print_success "Generated API_KEY_SALT"
    fi

    if [ -z "$SESSION_ENCRYPTION_KEY" ]; then
        SESSION_ENCRYPTION_KEY=$(openssl rand -hex 32)
        echo "SESSION_ENCRYPTION_KEY=$SESSION_ENCRYPTION_KEY" >> .env
        SECRETS_UPDATED=true
        print_success "Generated SESSION_ENCRYPTION_KEY"
    fi

    if [ "$SECRETS_UPDATED" = true ]; then
        print_success "Security secrets generated and saved to .env"
    else
        print_success "Security secrets already configured"
    fi

    # Step 3: Check Supabase schema
    print_header "Step 3/8: Verifying Supabase Database"

    print_info "Please ensure you have deployed the database schema:"
    print_info "  1. Go to https://app.supabase.com/project/_/sql"
    print_info "  2. Run the SQL in supabase/schema.sql"
    print_info "  3. Enable Realtime for: accounts, quotas, requests, alerts"
    read -p "Have you completed the database setup? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Please complete database setup first"
        print_info "See QUICKSTART_V2.md Step 2 for detailed instructions"
        exit 0
    fi
    print_success "Database setup confirmed"

    # Step 4: Clean up old containers
    print_header "Step 4/8: Cleaning Up Old Containers"

    if docker compose -f docker-compose.v2.yml ps -q 2>/dev/null | grep -q .; then
        print_info "Stopping existing containers..."
        docker compose -f docker-compose.v2.yml down
        print_success "Old containers stopped"
    else
        print_success "No existing containers found"
    fi

    # Step 5: Build images
    print_header "Step 5/8: Building Docker Images"

    print_info "This may take 5-10 minutes on first run..."
    if docker compose -f docker-compose.v2.yml build; then
        print_success "Docker images built successfully"
    else
        print_error "Failed to build Docker images"
        exit 1
    fi

    # Step 6: Start services
    print_header "Step 6/8: Starting Services"

    if docker compose -f docker-compose.v2.yml up -d; then
        print_success "All services started"
    else
        print_error "Failed to start services"
        exit 1
    fi

    # Wait for services to be ready
    print_info "Waiting for services to initialize..."
    sleep 10

    # Step 7: Verify deployment
    print_header "Step 7/8: Verifying Deployment"

    # Check container status
    CONTAINERS=$(docker compose -f docker-compose.v2.yml ps --format json 2>/dev/null | jq -r '.Name' 2>/dev/null)

    if [ -z "$CONTAINERS" ]; then
        # Fallback for older docker-compose versions
        CONTAINERS=$(docker compose -f docker-compose.v2.yml ps --services)
    fi

    ALL_RUNNING=true
    while IFS= read -r container; do
        if docker compose -f docker-compose.v2.yml ps "$container" | grep -q "Up"; then
            print_success "$container is running"
        else
            print_error "$container is not running"
            ALL_RUNNING=false
        fi
    done <<< "$CONTAINERS"

    if [ "$ALL_RUNNING" = false ]; then
        print_error "Some containers failed to start"
        print_info "Check logs with: docker compose -f docker-compose.v2.yml logs"
        exit 1
    fi

    # Test webapp
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
        print_success "Webapp is accessible at http://localhost:3000"
    else
        print_warning "Webapp may not be ready yet (this is normal, try in a few seconds)"
    fi

    # Test Redis
    if docker compose -f docker-compose.v2.yml exec -T redis redis-cli ping | grep -q "PONG"; then
        print_success "Redis is responding"
    else
        print_warning "Redis may not be ready yet"
    fi

    # Step 8: Display next steps
    print_header "Step 8/8: Deployment Complete!"

    print_success "AI CLI Orchestrator V2 is now running!"
    echo ""
    print_info "Access the webapp:"
    echo "  → http://localhost:3000"
    echo ""
    print_info "Next steps:"
    echo "  1. Sign up at http://localhost:3000"
    echo "  2. Add your first AI provider account"
    echo "  3. Generate an API key (see QUICKSTART_V2.md Step 7)"
    echo "  4. Test the API (see QUICKSTART_V2.md Step 8)"
    echo ""
    print_info "Useful commands:"
    echo "  • View logs:    docker compose -f docker-compose.v2.yml logs -f"
    echo "  • Stop:         docker compose -f docker-compose.v2.yml down"
    echo "  • Restart:      docker compose -f docker-compose.v2.yml restart"
    echo "  • Status:       docker compose -f docker-compose.v2.yml ps"
    echo ""
    print_info "Documentation:"
    echo "  • Quick Start:  QUICKSTART_V2.md"
    echo "  • Full Guide:   DEPLOYMENT_GUIDE.md"
    echo "  • Architecture: SYSTEM_ARCHITECTURE_V2_OAUTH.md"
    echo ""

    # Ask if user wants to view logs
    read -p "Would you like to view the logs now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker compose -f docker-compose.v2.yml logs -f
    fi
}

# Run main function
main "$@"
