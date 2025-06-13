#!/bin/bash

# Check PostgreSQL Docker setup for MCP
echo "🐳 Checking PostgreSQL Docker setup..."

# Check if PostgreSQL is accessible
if ! pg_isready -h localhost -p 5432 &>/dev/null; then
    echo "❌ PostgreSQL is not accessible on localhost:5432"
    echo "Please ensure your PostgreSQL Docker container is running and accessible"
    exit 1
fi

echo "✅ PostgreSQL is accessible"

# Try to connect and check for database/user
echo "🔍 Checking database and user setup..."

# You'll need to update these credentials to match your Docker setup
PGPASSWORD="your_postgres_password" psql -h localhost -p 5432 -U postgres -c "\l" &>/dev/null || {
    echo "❌ Cannot connect to PostgreSQL"
    echo "Please update the credentials in mcp-config.json to match your Docker setup"
    echo ""
    echo "Common Docker PostgreSQL setups:"
    echo "- Default postgres user with password 'password'"
    echo "- Custom database and user you created"
    echo ""
    echo "Check your Docker setup with:"
    echo "  docker ps | grep postgres"
    echo "  docker logs <postgres_container_name>"
    exit 1
}

echo "✅ PostgreSQL connection successful"
echo ""
echo "🔧 Next steps:"
echo "1. Update mcp-config.json with your actual PostgreSQL credentials"
echo "2. Make sure the database 'rag_memory' exists (or update the database name)"
echo "3. Ensure pgvector extension is available"
echo "4. Run ./test-mcp.sh to test the MCP"