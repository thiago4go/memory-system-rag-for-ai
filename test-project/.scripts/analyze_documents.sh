#!/bin/bash

# analyze_documents.sh - Analyze documents and determine processing strategy
# Based on proven Hybrid Strategy 2+3 implementation

if [ -z "$1" ]; then
    echo "❌ Error: Documents directory path is required"
    echo "Usage: make analyze-docs path=\"path/to/docs/directory\""
    exit 1
fi

DOCS_PATH="$1"

if [ ! -d "$DOCS_PATH" ]; then
    echo "❌ Error: Directory '$DOCS_PATH' not found"
    exit 1
fi

echo "🔍 HYBRID STRATEGY 2+3 DOCUMENT ANALYSIS"
echo "======================================="
echo "Directory: $DOCS_PATH"
echo ""

# Initialize counters
STANDARD_COUNT=0
PROGRESSIVE_COUNT=0
PROGRESSIVE_CHUNKED_COUNT=0

# Create analysis report
ANALYSIS_FILE="/tmp/doc_analysis_$$.md"
echo "# Document Processing Strategy Analysis" > "$ANALYSIS_FILE"
echo "Generated: $(date)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

echo "📊 PROCESSING STRATEGY CLASSIFICATION:"
echo ""

for file in "$DOCS_PATH"/*.md "$DOCS_PATH"/*.txt; do
    if [ -f "$file" ]; then
        FILE_NAME=$(basename "$file")
        FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        FILE_SIZE_KB=$((FILE_SIZE / 1024))
        
        # Determine strategy based on proven thresholds
        if [ "$FILE_SIZE" -lt 30720 ]; then
            # <30KB - STANDARD Processing
            STRATEGY="🟢 STANDARD"
            STRATEGY_CODE="STANDARD"
            DESCRIPTION="Direct RAG pipeline: Store → Chunk → Embed → Extract → Link"
            STANDARD_COUNT=$((STANDARD_COUNT + 1))
            
        elif [ "$FILE_SIZE" -lt 102400 ]; then
            # 30-100KB - PROGRESSIVE Processing  
            STRATEGY="🟡 PROGRESSIVE"
            STRATEGY_CODE="PROGRESSIVE"
            DESCRIPTION="Section-by-section processing with structure preservation"
            PROGRESSIVE_COUNT=$((PROGRESSIVE_COUNT + 1))
            
        else
            # >100KB - PROGRESSIVE + CHUNKED FALLBACK
            STRATEGY="🔴 PROGRESSIVE_CHUNKED"
            STRATEGY_CODE="PROGRESSIVE_CHUNKED"
            DESCRIPTION="Progressive + timeout-resistant chunking for oversized sections"
            PROGRESSIVE_CHUNKED_COUNT=$((PROGRESSIVE_CHUNKED_COUNT + 1))
        fi
        
        printf "%-50s %8s KB  %s\n" "$FILE_NAME" "$FILE_SIZE_KB" "$STRATEGY"
        
        # Add to analysis report
        echo "- **$FILE_NAME**: ${FILE_SIZE_KB}KB ($STRATEGY_CODE)" >> "$ANALYSIS_FILE"
        
    fi
done

TOTAL_COUNT=$((STANDARD_COUNT + PROGRESSIVE_COUNT + PROGRESSIVE_CHUNKED_COUNT))

echo ""
echo "📈 STRATEGY DISTRIBUTION:"
echo "🟢 STANDARD Processing:           $STANDARD_COUNT documents"
echo "🟡 PROGRESSIVE Processing:        $PROGRESSIVE_COUNT documents"  
echo "🔴 PROGRESSIVE + CHUNKED:         $PROGRESSIVE_CHUNKED_COUNT documents"
echo "📊 Total Documents:               $TOTAL_COUNT"

if [ "$TOTAL_COUNT" -gt 0 ]; then
    STANDARD_PCT=$((STANDARD_COUNT * 100 / TOTAL_COUNT))
    PROGRESSIVE_PCT=$((PROGRESSIVE_COUNT * 100 / TOTAL_COUNT))
    PROGRESSIVE_CHUNKED_PCT=$((PROGRESSIVE_CHUNKED_COUNT * 100 / TOTAL_COUNT))
    
    echo ""
    echo "📊 Distribution Percentages:"
    echo "   STANDARD: ${STANDARD_PCT}%"
    echo "   PROGRESSIVE: ${PROGRESSIVE_PCT}%"  
    echo "   PROGRESSIVE + CHUNKED: ${PROGRESSIVE_CHUNKED_PCT}%"
fi

# Add distribution to analysis report
echo "" >> "$ANALYSIS_FILE"
echo "## Strategy Distribution" >> "$ANALYSIS_FILE"
echo "- STANDARD: $STANDARD_COUNT documents (${STANDARD_PCT}%)" >> "$ANALYSIS_FILE"
echo "- PROGRESSIVE: $PROGRESSIVE_COUNT documents (${PROGRESSIVE_PCT}%)" >> "$ANALYSIS_FILE"
echo "- PROGRESSIVE + CHUNKED: $PROGRESSIVE_CHUNKED_COUNT documents (${PROGRESSIVE_CHUNKED_PCT}%)" >> "$ANALYSIS_FILE"

echo ""
echo "⚠️  ANALYSIS COMPLETE - NO PROCESSING PERFORMED"
echo "🤖 AI AGENT NEXT STEPS:"
echo ""
echo "1. Store analysis results:"
echo "   📋 GUIDANCE: rag_memory___storeDocument id=\"doc_analysis_$(date +%Y%m%d)\" content=\"\$(cat $ANALYSIS_FILE)\""
echo ""
echo "2. Process documents by strategy:"
echo "   🟢 For STANDARD docs:      make process-doc file=\"path/to/doc.md\""
echo "   🟡 For PROGRESSIVE docs:   make process-doc file=\"path/to/doc.md\""
echo "   🔴 For LARGE docs:         make process-doc file=\"path/to/doc.md\""
echo ""
echo "3. Verify strategy effectiveness:"
echo "   📋 GUIDANCE: rag_memory___getKnowledgeGraphStats"
echo ""
echo "⚠️  THIS SCRIPT PROVIDED ANALYSIS ONLY - AI AGENT MUST EXECUTE PROCESSING"

# Cleanup
rm -f "$ANALYSIS_FILE"
