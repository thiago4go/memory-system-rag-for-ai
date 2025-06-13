#!/bin/bash

# Test RAG Memory MCP with PostgreSQL
set -e

echo "🧪 Testing RAG Memory MCP with PostgreSQL..."

# Check if MCP is built
if [ ! -f "/home/thiago/rag/dist/index.js" ]; then
    echo "🔧 Building MCP first..."
    cd /home/thiago/rag
    npm run build
    cd - > /dev/null
fi

# Export environment variables for Neon PostgreSQL
export DB_TYPE=postgresql
export PG_HOST=ep-green-math-a79uozqe-pooler.ap-southeast-2.aws.neon.tech
export PG_PORT=5432
export PG_DATABASE=test-rag
export PG_USERNAME=neondb_owner
export PG_PASSWORD=npg_ZkSF23Myzbds
export PG_SSL=true
export VECTOR_DIMENSIONS=384
export ENABLE_DB_LOGGING=true
export QUERY_TIMEOUT=30000

echo "📋 Testing with configuration:"
echo "   Database Type: $DB_TYPE"
echo "   Host: $PG_HOST:$PG_PORT"
echo "   Database: $PG_DATABASE"
echo "   User: $PG_USERNAME"

# Test MCP server startup
echo "🚀 Starting MCP server test..."

# Create a simple test to check if MCP starts and connects
echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}' | timeout 10s node /home/thiago/rag/dist/index.js || {
    echo "❌ MCP startup failed"
    echo "Make sure PostgreSQL is running and accessible with the configured credentials"
    exit 1
}

echo "✅ MCP server started successfully with PostgreSQL!"
echo ""
echo "🎯 Your MCP is ready to use. You can now:"
echo "1. Use it in Claude Desktop by adding the mcp-config.json configuration"
echo "2. Test individual tools using the MCP protocol"
echo "3. Start building your knowledge graph!"