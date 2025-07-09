#!/bin/bash
# init.sh - n8n Services Initialization Script

set -e

echo "==================================="
echo "n8n Services Setup"
echo "==================================="

# Start services
echo "Starting services..."
sudo docker compose up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Check service health
echo "Checking service status..."
sudo docker compose ps

echo ""
echo "==================================="
echo "Setup complete!"
echo "==================================="
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
echo ""