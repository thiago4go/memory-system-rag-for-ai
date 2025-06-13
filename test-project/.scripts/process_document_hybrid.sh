#!/bin/bash

# process_document_hybrid.sh - Execute size-aware processing using Hybrid Strategy 2+3
# Routes documents to appropriate processing based on proven size thresholds

if [ -z "$1" ]; then
    echo "❌ Error: Document file path is required"
    echo "Usage: make process-doc file=\"path/to/document.md\""
    exit 1
fi

FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")

if [ ! -f "$FILE_PATH" ]; then
    echo "❌ Error: File '$FILE_PATH' not found"
    exit 1
fi

FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
FILE_SIZE_KB=$((FILE_SIZE / 1024))

echo "🎯 HYBRID STRATEGY 2+3 DOCUMENT PROCESSOR"
echo "==========================================="
echo "File: $FILE_NAME"
echo "Size: ${FILE_SIZE_KB}KB ($FILE_SIZE bytes)"
echo ""

# Determine processing strategy
if [ "$FILE_SIZE" -lt 30720 ]; then
    # <30KB - STANDARD Processing
    STRATEGY="🟢 STANDARD"
    STRATEGY_CODE="STANDARD"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Direct RAG pipeline"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Execute STANDARD processing commands:"
    echo "   rag_memory___storeDocument id=\"$FILE_NAME\" content=\"\$(cat '$FILE_PATH')\""
    echo "   rag_memory___chunkDocument documentId=\"$FILE_NAME\""
    echo "   rag_memory___embedChunks documentId=\"$FILE_NAME\""
    echo "   rag_memory___extractTerms documentId=\"$FILE_NAME\""
    echo "   rag_memory___searchNodes query=\"[extract key concepts]\" limit=10"
    echo "   rag_memory___createEntities entities=\"[based on extracted terms]\""
    echo "   rag_memory___linkEntitiesToDocument documentId=\"$FILE_NAME\" entityNames=\"[entity list]\""
    
elif [ "$FILE_SIZE" -lt 102400 ]; then
    # 30-100KB - PROGRESSIVE Processing
    STRATEGY="🟡 PROGRESSIVE"
    STRATEGY_CODE="PROGRESSIVE"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Section-by-section with structure preservation"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Use progressive processing helper:"
    echo "   make process-large-doc file=\"$FILE_PATH\""
    echo "   [Then execute all provided rag_memory___ commands]"
    
else
    # >100KB - PROGRESSIVE + CHUNKED FALLBACK
    STRATEGY="🔴 PROGRESSIVE_CHUNKED"
    STRATEGY_CODE="PROGRESSIVE_CHUNKED"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Progressive + timeout-resistant chunking"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Use enhanced progressive processing:"
    echo "   make process-large-doc file=\"$FILE_PATH\""
    echo "   [Monitor for timeout-resistant chunking fallbacks]"
    echo "   [Execute all provided rag_memory___ commands sequentially]"
fi

echo ""
echo "🎯 PROVEN STRATEGY BENEFITS:"
case "$STRATEGY_CODE" in
    "STANDARD")
        echo "   ✅ Fast processing (no section splitting needed)"
        echo "   ✅ Maintains document context integrity"
        echo "   ✅ Optimal for documents with unified content"
        ;;
    "PROGRESSIVE")
        echo "   ✅ Preserves document structure via markdown headers"
        echo "   ✅ Prevents timeout failures with section processing"
        echo "   ✅ Maintains semantic relationships between sections"
        ;;
    "PROGRESSIVE_CHUNKED")
        echo "   ✅ Handles massive documents (proven up to 145KB)"
        echo "   ✅ Timeout-resistant fallback for oversized sections"
        echo "   ✅ Zero failure rate in production testing"
        ;;
esac

echo ""
echo "📊 NEXT VERIFICATION STEPS:"
echo "   📋 GUIDANCE: rag_memory___getKnowledgeGraphStats"
echo "   📋 GUIDANCE: rag_memory___hybridSearch query=\"$FILE_NAME content overview\" limit=5"
echo ""
echo "⚠️  STRATEGY GUIDANCE COMPLETE - NO ACTUAL RAG PROCESSING PERFORMED"
echo "🤖 AI AGENT MUST NOW EXECUTE ALL PROVIDED RAG COMMANDS"
