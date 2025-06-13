# Makefile for Memory System v4.1 Operations

# Ensure scripts are executable and system is ready
.PHONY: all setup new-epic new-plan complete-plan log status clean

all: setup

setup:
	@chmod +x .scripts/*.sh
	@echo "🛠️  All scripts are now executable."
	@echo "✅ Memory System v4.1 is ready for operation."

# --- Protocol Automation ---

# Creates a new EPIC file
# Usage: make new-epic title="High Level Mission Description"
new-epic:
	@.scripts/new_epic.sh "$(title)"

# Creates a new PLAN file
# Usage: make new-plan epic="epic-filename" title="Specific Plan Title"
new-plan:
	@.scripts/new_plan.sh "$(epic)" "$(title)"

# Completes and archives a plan
# Usage: make complete-plan name="plan-filename"
complete-plan:
	@.scripts/complete_plan.sh "$(name)"

# Logs a quick update to the main status file
# Usage: make log message="Completed database migration"
log:
	@.scripts/log_update.sh "$(message)"

# Shows current system status
status:
	@.scripts/show_status.sh

# Check if current EPIC is complete (all PHASEs marked [x])
check-epic:
	@.scripts/check_epic_completion.sh

# Analyze documents and determine processing strategy (Hybrid Strategy 2+3)
# Usage: make analyze-docs path="path/to/docs/directory"
analyze-docs:
	@.scripts/analyze_documents.sh "$(path)"

# Process document using hybrid strategy based on size
# Usage: make process-doc file="path/to/document.md" 
process-doc:
	@.scripts/process_document_hybrid.sh "$(file)"

# Legacy: Process large documents progressively
# Usage: make process-large-doc file="path/to/large/file.md"
process-large-doc:
	@.scripts/process_large_document.sh "$(file)"

# Clean up temporary files and validate structure
clean:
	@.scripts/cleanup.sh

# Initialize a git repository if not already done
git-init:
	@if [ ! -d ../.git ]; then 	cd .. && git init; 		cd .. && git add .; 		cd .. && git commit -m "Initial Memory System v3.0 bootstrap"; 		echo "📦 Git repository initialized"; 	else 		echo "📦 Git repository already exists"; 	fi

