#!/bin/bash

# Test Neon PostgreSQL connection for MCP
set -e

echo "🌟 Testing Neon PostgreSQL connection..."

# Connection details
NEON_HOST="ep-green-math-a79uozqe-pooler.ap-southeast-2.aws.neon.tech"
NEON_PORT="5432"
NEON_DB="test-rag"
NEON_USER="neondb_owner"
NEON_PASSWORD="npg_ZkSF23Myzbds"

echo "📋 Connection details:"
echo "   Host: $NEON_HOST"
echo "   Database: $NEON_DB"
echo "   User: $NEON_USER"

# Test basic connection
echo "🔍 Testing basic connection..."
PGPASSWORD="$NEON_PASSWORD" psql -h "$NEON_HOST" -p "$NEON_PORT" -U "$NEON_USER" -d "$NEON_DB" -c "SELECT version();" || {
    echo "❌ Failed to connect to Neon PostgreSQL"
    echo "Please check your connection string and network connectivity"
    exit 1
}

echo "✅ Basic connection successful!"

# Check for pgvector extension
echo "🧩 Checking pgvector extension..."
PGPASSWORD="$NEON_PASSWORD" psql -h "$NEON_HOST" -p "$NEON_PORT" -U "$NEON_USER" -d "$NEON_DB" -c "CREATE EXTENSION IF NOT EXISTS vector;" || {
    echo "⚠️  Could not create pgvector extension"
    echo "Neon might not have pgvector enabled by default"
    echo "You may need to enable it in your Neon console or use a different approach"
}

# Test vector functionality if available
echo "🔍 Testing vector functionality..."
if PGPASSWORD="$NEON_PASSWORD" psql -h "$NEON_HOST" -p "$NEON_PORT" -U "$NEON_USER" -d "$NEON_DB" -c "SELECT '[1,2,3]'::vector(3) AS test_vector;" &>/dev/null; then
    echo "✅ pgvector is working!"
else
    echo "⚠️  pgvector not available - MCP will use fallback embedding storage"
fi

echo ""
echo "🎯 Neon PostgreSQL is configured and ready!"
echo "Your MCP should now be able to connect to Neon."