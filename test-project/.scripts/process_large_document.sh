#!/bin/bash

# process_large_document.sh - Progressive processing for large documents (>10KB or >200 lines)
# Based on critical lesson: /critical-lessons/about-large-documents-processing.md

if [ -z "$1" ]; then
    echo "❌ Error: File path is required"
    echo "Usage: make process-large-doc file=\"path/to/large/file.md\""
    exit 1
fi

FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")
FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
LINE_COUNT=$(wc -l < "$FILE_PATH")

echo "📊 Analyzing document: $FILE_NAME"
echo "   Size: ${FILE_SIZE} bytes"
echo "   Lines: ${LINE_COUNT}"

# Check if document needs progressive processing
if [ "$FILE_SIZE" -lt 10240 ] && [ "$LINE_COUNT" -lt 200 ]; then
    echo "✅ Document is small enough for normal processing"
    echo "   Use: rag_memory___storeDocument id=\"$FILE_NAME\" content=\"\$(cat $FILE_PATH)\""
    exit 0
fi

echo "⚠️  Large document detected - using progressive processing strategy"

# Create temporary directory for sections
TEMP_DIR="/tmp/doc_sections_$$"
mkdir -p "$TEMP_DIR"

# STEP 1: Analyze structure (first 1000 lines)
echo "🔍 Step 1: Analyzing document structure..."
head -1000 "$FILE_PATH" > "$TEMP_DIR/analysis_sample.txt"

# STEP 2: Identify sections via markdown headers
echo "🔍 Step 2: Identifying natural sections..."
grep -n "^#" "$FILE_PATH" > "$TEMP_DIR/headers.txt" 2>/dev/null || echo "No markdown headers found"

# STEP 3: Split into sections based on headers or line count
echo "📤 Step 3: Creating manageable sections..."

if [ -s "$TEMP_DIR/headers.txt" ]; then
    # Split by markdown sections
    echo "   Splitting by markdown headers..."
    SECTION_NUM=1
    CURRENT_LINE=1
    
    while IFS=: read -r line_num header_text; do
        if [ "$SECTION_NUM" -gt 1 ]; then
            # Extract previous section
            PREV_END=$((line_num - 1))
            sed -n "${CURRENT_LINE},${PREV_END}p" "$FILE_PATH" > "$TEMP_DIR/section_${SECTION_NUM}.md"
            echo "   Created section $SECTION_NUM: lines $CURRENT_LINE-$PREV_END"
        fi
        CURRENT_LINE="$line_num"
        SECTION_NUM=$((SECTION_NUM + 1))
    done < "$TEMP_DIR/headers.txt"
    
    # Last section
    sed -n "${CURRENT_LINE},\$p" "$FILE_PATH" > "$TEMP_DIR/section_${SECTION_NUM}.md"
    echo "   Created final section $SECTION_NUM: lines $CURRENT_LINE-end"
    
else
    # Split by line count (every 150 lines to stay under 200 limit)
    echo "   No headers found - splitting by line count (150 lines per section)..."
    split -l 150 -d "$FILE_PATH" "$TEMP_DIR/section_"
    
    # Rename to .md files
    for file in "$TEMP_DIR"/section_*; do
        if [ ! "${file##*.}" = "md" ]; then
            mv "$file" "${file}.md"
        fi
    done
fi

# STEP 4: Process each section with size check
echo "🚀 Step 4: Processing sections into RAG system..."
SECTION_COUNT=0

for section_file in "$TEMP_DIR"/section_*.md; do
    if [ -f "$section_file" ]; then
        SECTION_COUNT=$((SECTION_COUNT + 1))
        SECTION_NAME="${FILE_NAME}_section_${SECTION_COUNT}"
        SECTION_SIZE=$(stat -f%z "$section_file" 2>/dev/null || stat -c%s "$section_file" 2>/dev/null)
        
        echo "   Processing $SECTION_NAME (${SECTION_SIZE} bytes)..."
        
        if [ "$SECTION_SIZE" -gt 30720 ]; then
            echo "   ⚠️  Section still large (>30KB) - applying chunked fallback"
            # Further split large sections
            split -l 100 -d "$section_file" "${section_file}_chunk_"
            for chunk in "${section_file}_chunk_"*; do
                CHUNK_NAME="${SECTION_NAME}_$(basename "$chunk")"
                echo "      Processing chunk: $CHUNK_NAME"
                echo "      📋 GUIDANCE: rag_memory___storeDocument id=\"$CHUNK_NAME\" content=\"\$(cat '$chunk')\""
                echo "      📋 GUIDANCE: rag_memory___chunkDocument documentId=\"$CHUNK_NAME\""
                echo "      📋 GUIDANCE: rag_memory___embedChunks documentId=\"$CHUNK_NAME\""
            done
        else
            echo "   📋 GUIDANCE: rag_memory___storeDocument id=\"$SECTION_NAME\" content=\"\$(cat '$section_file')\""
            echo "   📋 GUIDANCE: rag_memory___chunkDocument documentId=\"$SECTION_NAME\""
            echo "   📋 GUIDANCE: rag_memory___embedChunks documentId=\"$SECTION_NAME\""
        fi
    fi
done

# STEP 5: Create parent document with section references
echo "📋 Step 5: Creating document index..."
SECTION_LIST=""
for i in $(seq 1 $SECTION_COUNT); do
    SECTION_LIST="${SECTION_LIST}${FILE_NAME}_section_${i}, "
done
SECTION_LIST=${SECTION_LIST%, }

DOC_INDEX="# Document Index: $FILE_NAME

Original file: $FILE_PATH
Total sections: $SECTION_COUNT  
Section IDs: $SECTION_LIST

This large document was processed using progressive strategy to maintain semantic integrity.
Query individual sections for detailed content, or use hybridSearch for cross-section discovery.
"

echo "📋 GUIDANCE: rag_memory___storeDocument id=\"${FILE_NAME}_index\" content=\"$DOC_INDEX\""

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "⚠️  DOCUMENT STRUCTURE ANALYSIS COMPLETE - NO RAG PROCESSING PERFORMED"
echo "   📊 Created $SECTION_COUNT section analysis from $FILE_NAME"
echo "   🤖 AI AGENT MUST NOW PROCESS EACH SECTION USING RAG TOOLS"
echo ""
echo "   ⚠️  THIS SCRIPT ONLY PROVIDED GUIDANCE - NO ACTUAL RAG PROCESSING PERFORMED"
echo "   💡 AI AGENT MUST EXECUTE THESE COMMANDS:"
echo "      1. Run the rag_memory___storeDocument commands above"
echo "      2. Extract terms: rag_memory___extractTerms for each section"
echo "      3. Create entities: rag_memory___createEntities based on extracted terms"
echo "      4. Test with: rag_memory___hybridSearch query=\"[document topic]\" useGraph=true"
echo ""
echo "📖 Critical lesson applied: Helper scripts provide honest guidance only"
