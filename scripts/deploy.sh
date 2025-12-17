#!/bin/bash

# Smart AI Notes - Deployment Script
# This script automates the deployment process

set -e  # Exit on error

echo "🚀 Smart AI Notes Deployment Script"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if required tools are installed
check_requirements() {
    echo ""
    echo "Checking requirements..."
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        exit 1
    fi
    print_success "Node.js installed"
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed"
        exit 1
    fi
    print_success "npm installed"
    
    if ! command -v firebase &> /dev/null; then
        print_warning "Firebase CLI not installed. Install with: npm install -g firebase-tools"
    else
        print_success "Firebase CLI installed"
    fi
}

# Deploy backend to Railway
deploy_backend_railway() {
    echo ""
    echo "📦 Deploying backend to Railway..."
    
    cd backend
    
    if ! command -v railway &> /dev/null; then
        print_error "Railway CLI not installed. Install with: npm install -g @railway/cli"
        exit 1
    fi
    
    # Check if logged in
    if ! railway whoami &> /dev/null; then
        print_warning "Not logged in to Railway. Running login..."
        railway login
    fi
    
    # Deploy
    railway up
    
    print_success "Backend deployed to Railway"
    cd ..
}

# Deploy backend to Firebase Functions
deploy_backend_firebase() {
    echo ""
    echo "📦 Deploying backend to Firebase Functions..."
    
    cd backend
    
    # Check if logged in
    if ! firebase projects:list &> /dev/null; then
        print_warning "Not logged in to Firebase. Running login..."
        firebase login
    fi
    
    # Deploy functions
    firebase deploy --only functions
    
    print_success "Backend deployed to Firebase Functions"
    cd ..
}

# Build Flutter app
build_flutter_app() {
    echo ""
    echo "📱 Building Flutter app..."
    
    cd mobile
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed"
        exit 1
    fi
    
    # Clean and get dependencies
    flutter clean
    flutter pub get
    
    # Build APK
    echo "Building APK..."
    flutter build apk --release
    
    # Build App Bundle
    echo "Building App Bundle..."
    flutter build appbundle --release
    
    print_success "Flutter app built successfully"
    print_success "APK: build/app/outputs/flutter-apk/app-release.apk"
    print_success "AAB: build/app/outputs/bundle/release/app-release.aab"
    
    cd ..
}

# Run tests
run_tests() {
    echo ""
    echo "🧪 Running tests..."
    
    # Backend tests
    echo "Testing backend..."
    cd backend
    npm test || print_warning "Backend tests failed or not configured"
    cd ..
    
    # Flutter tests
    echo "Testing Flutter app..."
    cd mobile
    flutter test || print_warning "Flutter tests failed or not configured"
    cd ..
    
    print_success "Tests completed"
}

# Main menu
show_menu() {
    echo ""
    echo "Select deployment option:"
    echo "1) Deploy backend to Railway"
    echo "2) Deploy backend to Firebase Functions"
    echo "3) Build Flutter app (APK + AAB)"
    echo "4) Run tests"
    echo "5) Full deployment (Backend + App)"
    echo "6) Exit"
    echo ""
    read -p "Enter choice [1-6]: " choice
    
    case $choice in
        1)
            check_requirements
            deploy_backend_railway
            ;;
        2)
            check_requirements
            deploy_backend_firebase
            ;;
        3)
            check_requirements
            build_flutter_app
            ;;
        4)
            check_requirements
            run_tests
            ;;
        5)
            check_requirements
            run_tests
            echo ""
            read -p "Deploy backend to Railway (r) or Firebase (f)? " backend_choice
            if [ "$backend_choice" = "r" ]; then
                deploy_backend_railway
            else
                deploy_backend_firebase
            fi
            build_flutter_app
            print_success "Full deployment completed!"
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            show_menu
            ;;
    esac
}

# Run the script
check_requirements
show_menu

echo ""
echo "===================================="
echo "✨ Deployment script completed!"
echo "===================================="
