# /implement Command Specification

**Version**: 1.0.0
**Status**: Design Complete
**Date**: 2025-11-15

---

## Overview

The `/implement` command is the master entry point for the Autonomous Workflow System. It takes a natural language feature description and autonomously executes the entire development workflow from specification to deployment.

**One command. Complete feature.**

---

## Command Syntax

### Basic Usage

```bash
/implement <feature description>
```

### With Options

```bash
/implement [options] <feature description>
```

---

## Command Options

### Execution Mode

```bash
--mode <mode>
```

**Options**:
- `autonomous` (default): Fully autonomous, minimal intervention
- `hybrid`: Pause at approval gates
- `manual`: Ask before each major step
- `dry-run`: Show plan without executing

**Examples**:
```bash
/implement --mode autonomous "Add user dashboard"
/implement --mode hybrid "Real-time chat feature"
/implement --mode dry-run "Payment integration"
```

### Approval Gates

```bash
--approve <gates>
--skip-approval <gates>
```

**Gate Types**:
- `spec`: After specification created
- `design`: After technical design created
- `final`: After implementation complete
- `all`: All gates
- `none`: No gates

**Examples**:
```bash
/implement --approve spec,final "User settings page"
/implement --skip-approval all "Simple bug fix"
```

### Verbosity Level

```bash
--verbose <level>
-v <level>
```

**Levels**:
- `minimal`: Show only phases and completion
- `normal` (default): Show phases and tasks
- `verbose`: Show all details and activities
- `debug`: Show debug information

**Examples**:
```bash
/implement -v minimal "Quick feature"
/implement --verbose debug "Complex feature (need details)"
```

### Configuration

```bash
--config <file>
```

Load configuration from file:

```bash
/implement --config .claude/workflows/my-config.json "Feature"
```

### Resume

```bash
--resume <workflow-id>
```

Resume a paused or interrupted workflow:

```bash
/implement --resume wf_abc123def456
```

### List Workflows

```bash
--list
```

Show all workflows (active and completed):

```bash
/implement --list
```

---

## Full Command Examples

### Example 1: Simple Feature

```bash
/implement "Add user profile page with avatar upload"
```

**Output**:
```
🎯 Analyzing feature request...

📋 Let me ask you a few quick questions:

1. PERMISSIONS: Who can edit user profiles?
   Context: Determines authorization model
   Options:
     1. Only the user themselves
     2. Admins can edit anyone
     3. Team leads can edit their team
     4. Let me decide [Default]

   Your choice (or Enter for default): 1

2. DATA: What information should profiles include?
   Context: Determines database schema
   Examples:
     - Basic: Name, email, avatar
     - Extended: + Bio, location, social links
     - Full: + Skills, interests, preferences

   Your choice: Extended

✅ Got it! Building your feature...

════════════════════════════════════════════════════════════

🎯 Feature: "User Profile Page with Avatar Upload"
📊 Overall Progress: [████░░░░░░░░░░░░░░░░] 20% complete
⏱️  Estimated completion: 18 minutes

─────────────────────────────────────────────────────────────

📋 Phase 1: Planning (3 min)
   ⏳ Creating specification...

[... continues with real-time progress ...]
```

### Example 2: Complex Feature with Options

```bash
/implement --mode hybrid --verbose normal "Real-time collaboration feature with presence indicators and live cursor tracking"
```

### Example 3: Dry Run

```bash
/implement --mode dry-run "Implement Stripe payment integration"
```

**Output**:
```
🎯 DRY RUN MODE - No code will be generated

Feature: Stripe Payment Integration

📋 Analysis Complete

Questions I would ask:
1. What payment methods to support? (card, bank transfer, etc.)
2. Do you need subscription support?
3. Should we handle webhooks for payment status?

Estimated workflow:

Phase 1: Planning (5 min)
  - Analyze requirements
  - Create specification
  - Design architecture
  - Identify 18 tasks

Phase 2: Implementation (45 min)
  - Create payment database tables
  - Build Stripe integration API
  - Implement webhook handlers
  - Create checkout UI components
  - Add payment confirmation page
  - Write comprehensive tests
  - (+ 12 more tasks)

Phase 3: Quality Review (8 min)
  - Security audit (PCI compliance)
  - Performance testing
  - Error handling validation

Phase 4: Finalization (2 min)
  - Code review
  - Documentation
  - Git commit

Total estimated time: ~60 minutes
Total estimated tasks: 18

Would generate:
  - 3 database tables
  - 4 API endpoints
  - 6 UI components
  - 15+ test files
  - Complete documentation

Ready to execute? (y/n):
```

### Example 4: Resume Workflow

```bash
# List workflows
/implement --list

# Resume specific workflow
/implement --resume wf_20251115_143022_user_dashboard
```

---

## Interactive Flow

### Step 1: Feature Analysis

```
🎯 Analyzing feature request...

Detected:
  - Entities: User, Profile, Avatar
  - Actions: Create, Edit, Upload, View
  - Complexity: Medium
  - Estimated time: 20-30 minutes
```

### Step 2: Question Phase

```
📋 I have 3 quick questions:

[Interactive questioning as shown in examples above]
```

### Step 3: Plan Confirmation (if mode=hybrid)

```
📋 SPECIFICATION REVIEW

Feature: User Profile Page

Requirements:
  • Users can view their own profile
  • Users can edit: name, bio, location, social links
  • Users can upload/change avatar (PNG, JPG, max 5MB)
  • Profile data persists to database
  • Real-time avatar preview before upload
  • Responsive design (mobile + desktop)

Technical Approach:
  • Next.js page: /app/profile/page.tsx
  • API endpoint: /api/profile (GET, PUT)
  • Supabase table: profiles
  • File storage: Supabase Storage bucket
  • Components: ProfileForm, AvatarUpload, ProfileView
  • Tests: API tests, component tests, E2E tests

Tasks: 12 identified
Estimated time: 22 minutes

Approve this plan? (y/n/edit): _
```

### Step 4: Execution with Progress

```
✅ Plan approved! Starting implementation...

════════════════════════════════════════════════════════════

🎯 Feature: "User Profile Page"
📊 Overall Progress: [████████░░░░░░░░░░░░] 40% complete
⏱️  Estimated completion: 13 minutes

─────────────────────────────────────────────────────────────

📋 Phase 1: Planning
   ✅ Requirements analyzed
   ✅ Technical design created
   ✅ 12 tasks identified
   Status: Completed in 2m 15s

🔨 Phase 2: Implementation (20 min)
   [████████░░░░░░░░░░░░] 5/12 tasks complete

   ✅ 01. Create profiles database table
   ✅ 02. Set up avatar storage bucket
   ✅ 03. Build profile API endpoint
   ✅ 04. Create ProfileForm component
   ✅ 05. Create AvatarUpload component

   ⏳ 06. Implement profile page (in progress...)
      [██████████░░░░░░░░░░] 50%
      └─ Creating page layout
      └─ Adding form submission
      └─ Implementing validation

   ⏸️  07. Add image optimization
   ⏸️  08. Write API tests
   ⏸️  09. Write component tests
   ⏸️  10. Add E2E tests
   ⏸️  11. Generate documentation
   ⏸️  12. Final review

   Status: In Progress (9m elapsed, ~11m remaining)

📝 Recent Activity:
   [14:42] ✅ Task 04 completed: ProfileForm component
   [14:43] ✅ Task 05 completed: AvatarUpload component
   [14:44] 🔧 Task 06 started: Profile page implementation
   [14:45] 📝 Added profile page with form layout

─────────────────────────────────────────────────────────────
```

### Step 5: Error Handling

```
❌ Task 06 failed: Type error in ProfilePage component

🤔 Analyzing error...
🔧 Applying fix (attempt 1/3)...
   Strategy: Add missing type annotation for user prop

✅ Fixed! Continuing...
```

or if auto-fix fails:

```
❌ Task 06 failed after 3 attempts

❓ I need your help:

The profile page layout needs clarification. I'm unsure about:
1. Should the avatar be on the left or top of the form?
2. Should we show a preview of unsaved changes?

Your guidance: _
```

### Step 6: Milestone Celebrations

```
═══════════════════════════════════════════════════════════
🎉 MILESTONE ACHIEVED!
💻 All code written! Running final checks...
═══════════════════════════════════════════════════════════
```

### Step 7: Final Approval (if mode=hybrid or mode=manual)

```
═══════════════════════════════════════════════════════════
📋 FINAL REVIEW - Feature Complete
═══════════════════════════════════════════════════════════

✅ Implementation Summary:

Files Created (8):
  • app/profile/page.tsx
  • components/ProfileForm.tsx
  • components/AvatarUpload.tsx
  • app/api/profile/route.ts
  • lib/db/migrations/20251115_add_profiles.sql
  • tests/api/profile.test.ts
  • tests/components/ProfileForm.test.ts
  • tests/e2e/profile.spec.ts

Files Modified (2):
  • lib/supabase/types.ts (added Profile type)
  • app/layout.tsx (added profile link)

Code Quality:
  ✅ TypeScript strict mode: passing
  ✅ Linting: no errors
  ✅ Tests: 12/12 passing
  ✅ Type coverage: 100%
  ✅ Security audit: no issues
  ✅ Performance: excellent

Documentation:
  ✅ API documentation generated
  ✅ Component props documented
  ✅ README updated

─────────────────────────────────────────────────────────────

Next steps:
  1. Review the code
  2. Test the feature manually
  3. Approve to commit

Approve and commit? (y/n/changes): _
```

### Step 8: Completion

```
✅ Feature implementation complete!

═══════════════════════════════════════════════════════════
🎉 SUCCESS!
═══════════════════════════════════════════════════════════

Feature: User Profile Page
Status: ✅ Completed successfully
Time: 21m 34s (estimated: 22m)

Summary:
  • 12 tasks completed
  • 8 files created
  • 2 files modified
  • 12 tests passing
  • 0 errors

Git:
  ✅ Committed to: feat/user-profile-page
  📝 Commit: e7a9b2c - "feat: add user profile page with avatar upload"

View changes:
  git show e7a9b2c

Test the feature:
  npm run dev
  # Navigate to /profile

Next steps:
  • Test manually
  • Create PR when ready
  • Deploy to staging

═══════════════════════════════════════════════════════════

Need changes? Run:
  /implement --modify "Add a 'share profile' button"
```

---

## Configuration File

### Config Schema

```json
{
  "mode": "autonomous" | "hybrid" | "manual",
  "verbosity": "minimal" | "normal" | "verbose" | "debug",
  "approvalGates": {
    "spec": true,
    "design": false,
    "final": true
  },
  "execution": {
    "maxConcurrentTasks": 3,
    "maxRetryAttempts": 3,
    "timeoutPerTask": 600000
  },
  "questionEngine": {
    "maxQuestions": 5,
    "autoApplyDefaults": false,
    "categories": ["SCOPE", "PERMISSIONS", "DATA", "UX", "INTEGRATION"]
  },
  "progress": {
    "updateInterval": 1000,
    "showTaskDetails": true,
    "showActivityLog": true,
    "activityLogLimit": 5
  },
  "errorRecovery": {
    "autoRetry": true,
    "maxAutoRetries": 3,
    "escalateAfterFailures": 3
  },
  "output": {
    "useColors": true,
    "useIcons": true,
    "showProgressBars": true,
    "clearScreen": true
  }
}
```

### Example Config File

```json
{
  "mode": "hybrid",
  "verbosity": "normal",
  "approvalGates": {
    "spec": true,
    "design": false,
    "final": true
  },
  "execution": {
    "maxConcurrentTasks": 3
  },
  "questionEngine": {
    "maxQuestions": 3,
    "autoApplyDefaults": true
  }
}
```

---

## Environment Variables

```bash
# Override default config
AUTONOMOUS_WORKFLOW_CONFIG=/path/to/config.json

# Disable colors
NO_COLOR=1

# Verbose logging
DEBUG=autonomous-workflow:*

# Workflow storage location
WORKFLOW_STORAGE_PATH=.claude/workflows
```

---

## Error Codes

| Code | Description | Resolution |
|------|-------------|------------|
| `E001` | Invalid feature description | Provide more details |
| `E002` | Workflow not found | Check workflow ID |
| `E003` | Configuration error | Fix config file |
| `E004` | Permission denied | Check file permissions |
| `E005` | Workflow already running | Wait or cancel existing |
| `E006` | Resume failed | Workflow state corrupted |
| `E007` | Agent execution failed | Check agent configuration |
| `E008` | Timeout | Increase timeout or simplify feature |
| `E009` | Out of resources | Free up disk space/memory |
| `E010` | Unknown error | Check logs |

---

## Keyboard Shortcuts

During workflow execution:

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Pause workflow (can resume later) |
| `Ctrl+Z` | Send to background |
| `q` | Quit (saves state for resume) |
| `p` | Toggle pause |
| `v` | Toggle verbosity |
| `l` | Show activity log |
| `h` | Show help |

---

## Logging

### Log Locations

```
.claude/workflows/[workflow-id]/logs/
├── execution.log       # Main execution log
├── errors.log          # Error details
├── agent-activity.log  # Agent execution logs
└── debug.log           # Debug information (if --verbose debug)
```

### Log Format

```
[2025-11-15 14:42:33] [INFO] [PHASE:IMPLEMENTATION] Starting task 06
[2025-11-15 14:42:35] [DEBUG] [TASK:06] Creating ProfilePage component
[2025-11-15 14:42:38] [ERROR] [TASK:06] Type error: Missing prop type
[2025-11-15 14:42:39] [INFO] [ERROR_RECOVERY] Attempting auto-fix 1/3
[2025-11-15 14:42:41] [SUCCESS] [ERROR_RECOVERY] Fix applied successfully
```

---

## Integration with Existing Commands

### Workflow State Files

Autonomous workflows create standard spec files that work with existing commands:

```
.claude/specs/[feature-slug]/
├── spec.md         # Can use with existing /spec-design
├── design.md       # Can use with existing /spec-tasks
├── tasks/          # Can use with existing /spec-execute
│   ├── 01-task.md
│   ├── 02-task.md
│   └── ...
└── artifacts/
    └── [generated files]
```

### Manual Override

At any point, you can take over manually:

```bash
# Start autonomous
/implement "Feature X"

# [Workflow running...]

# Pause
Ctrl+C

# Continue manually
/spec-execute feature-x 06
```

---

## Best Practices

### Writing Good Feature Descriptions

**Good**:
```
/implement "Add user dashboard with real-time analytics showing task completion rates, active users, and recent activity feed"
```

**Better**:
```
/implement "
Create a user dashboard that shows:
- Task completion rates (daily, weekly, monthly)
- Currently active users with presence indicators
- Recent activity feed with filters
- Should update in real-time
- Accessible on mobile devices
"
```

**Best** (for complex features):
```
/implement --mode hybrid "
Feature: Team collaboration dashboard

Requirements:
- Real-time updates using Supabase subscriptions
- Shows team metrics: completion rates, velocity, blockers
- Individual member cards with status and current task
- Activity timeline with filters (all, my team, mentions)
- Quick actions: assign task, send message, schedule meeting
- Mobile responsive with offline support
- Accessible (WCAG AA compliant)

Integrations:
- Connect with existing task management system
- Sync with calendar for meetings
- Use existing notification system

Permissions:
- Team members see their team only
- Managers see all teams
- Admins see organization-wide
"
```

### When to Use Each Mode

**Autonomous Mode** (default):
- Simple, well-defined features
- Standard CRUD operations
- UI components
- API endpoints
- When you trust AI fully

**Hybrid Mode**:
- Medium complexity features
- New feature categories
- When you want to review key decisions
- Learning/exploring

**Manual Mode**:
- Complex, unique features
- Critical business logic
- Experimental implementations
- When you want full control

**Dry Run**:
- Estimating time/effort
- Understanding scope
- Planning sprints
- Before committing to implementation

---

## FAQ

### Q: Can I modify the feature mid-execution?

**A**: Yes, pause with `Ctrl+C` and use:
```bash
/implement --modify "Add export to CSV feature"
```

### Q: What if I disagree with a technical decision?

**A**: The system makes technical decisions autonomously, but you can override by editing generated files after completion, or use `--mode manual` for full control.

### Q: Can I use this for bug fixes?

**A**: Yes! Simple bug fixes work well:
```bash
/implement "Fix: Users can't delete their own comments (permission error)"
```

### Q: How do I customize the tech stack?

**A**: The system uses your existing tech stack from `CLAUDE.md`. Update that file to change defaults.

### Q: Can multiple workflows run in parallel?

**A**: Currently no. One workflow at a time to maintain focus and resources.

### Q: What happens if my computer crashes?

**A**: Workflow state is saved continuously. Resume with:
```bash
/implement --list
/implement --resume [workflow-id]
```

### Q: Can I share workflows with teammates?

**A**: Yes! Workflow files are in `.claude/workflows/`. Commit to git for team access.

---

## Troubleshooting

### Workflow won't start

```bash
# Check for existing workflows
/implement --list

# Cancel if needed
/implement --cancel [workflow-id]

# Try again
/implement "Your feature"
```

### Resume fails

```bash
# Check workflow state
cat .claude/workflows/[workflow-id]/state.json

# If corrupted, start fresh
rm -rf .claude/workflows/[workflow-id]
/implement "Your feature"
```

### Questions not appearing

```bash
# Check question engine config
cat .claude/autonomous-workflow-config.json

# Try with explicit questions
/implement --mode manual "Your feature"
```

### Progress not updating

```bash
# Check if workflow is running
ps aux | grep autonomous-workflow

# Kill and restart if stuck
/implement --cancel [workflow-id]
/implement --resume [workflow-id]
```

---

## Summary

The `/implement` command provides:

1. **Simple Interface**: One command to build complete features
2. **Flexible Modes**: Autonomous, hybrid, manual, dry-run
3. **Smart Questions**: Asks only essential business questions
4. **Real-Time Progress**: Live updates with accurate estimates
5. **Error Recovery**: Automatic fixing with intelligent escalation
6. **Resumable**: Pause and continue anytime
7. **Configurable**: Extensive customization options
8. **Integrated**: Works with existing command system

**Use it to**: Transform feature ideas into production code with minimal manual intervention.

---

**Ready to build features 10x faster!**

---

**See also**:
- ARCHITECTURE.md - System architecture and design
- QUESTION_FRAMEWORK.md - How questions work
- PROGRESS_SYSTEM.md - How progress tracking works
- IMPLEMENTATION.md - How to build this system
- USER_GUIDE.md - Complete user documentation
- EXAMPLES.md - Real-world usage examples
