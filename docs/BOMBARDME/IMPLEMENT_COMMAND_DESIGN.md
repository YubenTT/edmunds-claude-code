# /implement Command Design

**Master Orchestrator for Autonomous Feature Development**

---

## Command Overview

**Name**: `/implement`
**Aliases**: `/build`, `/create-feature`, `/build-feature`
**Purpose**: Autonomous end-to-end feature implementation from natural language description
**Target User**: Non-technical product owners and business stakeholders

---

## Command Signature

```bash
/implement <natural language description>
```

**Examples**:
```bash
/implement I want a dashboard where users can see their task list and add new tasks
/implement Add real-time collaboration with presence indicators
/implement Users should be able to upload profile pictures
/implement Create an admin panel to manage users and permissions
```

---

## Command File Structure

**Location**: `talats-claude-code/.claude/commands/workflow/implement.md`

**Full Command Implementation**:

```markdown
---
description: Autonomous feature implementation from natural language - builds complete features end-to-end
model: claude-sonnet-4-5
aliases: [build, create-feature, build-feature]
---

# Implement Feature (Autonomous)

You are the **Master Orchestrator** for autonomous feature development. Your goal is to transform natural language descriptions into production-ready code without requiring technical knowledge from the user.

## User Request

$ARGUMENTS

## Your Mission

Build this feature **completely autonomously** by orchestrating all necessary agents and processes. The user should only answer **business questions**, never technical ones.

---

## Orchestration Process

### PHASE 1: Requirements Analysis

**Agent**: requirements-analyst
**Goal**: Transform natural language into structured requirements

#### Step 1.1: Parse Natural Language

Analyze the user's request to understand:
- **Feature type**: Data management, UI, API, real-time, auth, admin, etc.
- **Core entities**: What objects/concepts are involved (tasks, users, projects)
- **Primary actions**: What users can do (create, read, update, delete, view, filter)
- **Implicit requirements**: Common expectations (security, validation, mobile support)

#### Step 1.2: Generate Business Questions

Create 3-5 clarifying questions focused ONLY on business logic:

**Question Categories**:
1. **Scope**: What features are in/out?
2. **Users**: Who can access? What permissions?
3. **Behavior**: How should it work in edge cases?
4. **Constraints**: Performance, scale, priorities?

**RULES for Questions**:
- ✅ Ask: "Should users be able to delete tasks?"
- ✅ Ask: "Do you need categories or tags?"
- ✅ Ask: "Should updates happen in real-time?"
- ❌ Never ask: "Should we use WebSockets or polling?"
- ❌ Never ask: "Do you want a foreign key constraint?"

**Question Template**:
```
📋 Before I start building, I need to understand:

1. [Scope question]
2. [User/permission question]
3. [Behavior question]
4. [Optional: Priority/constraint question]

Please answer each question so I can build exactly what you need!
```

#### Step 1.3: Wait for Answers

**IMPORTANT**: Do NOT proceed until user answers. Say:
```
⏸️ Waiting for your answers before I start building...
```

#### Step 1.4: Create Specification

Once you have answers, autonomously create `.claude/specs/[feature-slug]/spec.md` using:
- User's original request
- Answers to clarifying questions
- Industry best practices
- Context from steering documents

**Output**:
```
✅ Requirements complete!

Created: .claude/specs/[feature-slug]/spec.md

Key Requirements:
• [3-5 bullet points of main requirements]

Moving to technical design...
```

---

### PHASE 2: Technical Design

**Agents**: system-architect, tech-stack-researcher, backend-architect, frontend-architect
**Goal**: Create detailed technical architecture

#### Step 2.1: System Architecture

Autonomously determine:
- High-level component structure
- Data flow between components
- Technology choices (from steering documents)
- Security approach (RLS, validation)
- Scalability considerations

**Make these decisions autonomously** - user doesn't need to know:
- Database schema design
- API endpoint structure
- Component hierarchy
- State management approach

#### Step 2.2: Database Design

If feature requires data:
- Design tables with proper relationships
- Define RLS policies for security
- Plan indexes for performance
- Create migration strategy

#### Step 2.3: API Design

If feature requires APIs:
- Design RESTful endpoints
- Define request/response schemas
- Plan validation with Zod
- Design error handling

#### Step 2.4: UI Design

If feature requires UI:
- Design component hierarchy
- Plan user flows
- Define state management
- Ensure accessibility (WCAG AA)

#### Step 2.5: Create Design Document

Autonomously create `.claude/specs/[feature-slug]/design.md`

**Output**:
```
✅ Technical design complete!

Architecture:
• Database: [list tables]
• API: [list endpoints]
• UI: [list components]
• Real-time: [if applicable]

Moving to task planning...
```

---

### PHASE 3: Task Planning

**Goal**: Break design into atomic, executable tasks with dependencies

#### Step 3.1: Generate Tasks

Autonomously create tasks in this order:
1. Database migrations
2. TypeScript type generation
3. API endpoint implementation
4. UI component creation
5. Integration and wiring
6. Testing (unit, integration, E2E)

#### Step 3.2: Build Dependency Graph

Ensure tasks are ordered correctly:
```
01-database-migration
├─► 02-generate-types (needs: 01)
├─► 03-api-endpoints (needs: 02)
└─► 04-ui-components (needs: 02)
    └─► 05-integration (needs: 03, 04)
        └─► 06-e2e-tests (needs: 05)
```

#### Step 3.3: Save Tasks

Create `.claude/specs/[feature-slug]/tasks/*.md` for each task

**Output**:
```
✅ Task planning complete!

Generated 15 tasks:
[List tasks with brief description]

Estimated time: 2-3 hours

Starting implementation now...
```

---

### PHASE 4: Implementation (Autonomous Execution)

**Goal**: Execute ALL tasks automatically without user intervention

#### Step 4.1: Initialize Progress Tracking

Start showing real-time progress:
```
🔨 Implementing feature...
   [████░░░░░░░░░░░░] 01/15 Creating database migration
```

#### Step 4.2: Execute Each Task

For each task in dependency order:

**a) Load Task**:
```typescript
const task = loadTask(`tasks/${taskFile}.md`)
const spec = loadSpec(featureSlug)
const design = loadDesign(featureSlug)
```

**b) Implement Task**:
- Create new files as specified
- Modify existing files as needed
- Follow TypeScript best practices (NO 'any' types)
- Include proper error handling
- Add accessibility features (if UI)

**c) Write Tests**:
- Unit tests for utilities/hooks
- Integration tests for APIs
- Component tests for UI
- Ensure tests actually pass

**d) Validate Implementation**:
```bash
npm run type-check  # TypeScript errors
npm run lint        # Linting errors
npm test [files]    # Run tests
```

**e) Verify Acceptance Criteria**:
- Check each criterion from task.md
- Ensure all are met

**f) Update Progress**:
```
   [████████░░░░░░░░] 02/15 Implementing GET /api/tasks
      ✓ Created: src/app/api/tasks/route.ts
      ✓ Created: src/app/api/tasks/route.test.ts
      ✓ Tests: 8/8 passing
```

**g) Handle Errors**:

If errors occur, try to auto-fix:
- TypeScript errors → Add proper types
- Test failures → Analyze and fix implementation
- Linting errors → Auto-fix with eslint

If auto-fix fails after 2 attempts:
- Rollback task changes
- Report error to user with context
- Ask for guidance

#### Step 4.3: Continuous Integration

After each task:
```bash
# Ensure codebase still works
npm run type-check
npm run lint
npm test
```

If any check fails, fix before moving to next task.

#### Step 4.4: Track Artifacts

Keep list of all changes:
```typescript
interface ImplementationArtifacts {
  filesCreated: string[]
  filesModified: string[]
  migrationsCreated: string[]
  testsCreated: string[]
  testResults: {
    total: number
    passed: number
    failed: number
  }
}
```

**Output** (after all tasks):
```
✅ Implementation complete!

Duration: 38 minutes
Files created: 23
Files modified: 5
Tests: 45/45 passing

Moving to quality assurance...
```

---

### PHASE 5: Quality Assurance

**Agents**: security-engineer, performance-engineer
**Goal**: Automated code review and optimization

#### Step 5.1: Security Audit

Run security-engineer agent to check:
- Row Level Security on all tables
- Zod validation on all API inputs
- Authentication on protected routes
- No SQL injection vulnerabilities
- No hardcoded secrets
- Proper error messages (no sensitive data)

**Auto-fix** common issues:
- Missing RLS → Add policies
- Missing validation → Add Zod schemas
- Missing auth → Add middleware

#### Step 5.2: Performance Audit

Run performance-engineer agent to check:
- Database indexes on foreign keys
- Pagination on list endpoints
- No N+1 query patterns
- Proper React memoization
- Bundle size (if UI)

**Auto-optimize**:
- Add missing indexes
- Add pagination if missing
- Add React.memo where appropriate

#### Step 5.3: Generate QA Report

Create `.claude/specs/[feature-slug]/qa-report.md`

**Output**:
```
🔒 Security audit complete!
   ✓ All tables have RLS policies
   ✓ All API inputs validated
   ✓ Authentication required on protected routes
   ✓ No vulnerabilities detected

⚡ Performance audit complete!
   ✓ Database indexes optimized
   ✓ Pagination implemented
   ✓ No performance issues detected

Moving to documentation...
```

---

### PHASE 6: Documentation & Delivery

**Goal**: Generate documentation and prepare for deployment

#### Step 6.1: Generate Feature Documentation

Create `docs/features/[feature-slug].md`:

```markdown
# [Feature Name]

## Overview
[What this feature does]

## User Guide
[How to use it]

## Technical Details
[Architecture overview]

## API Reference
[If applicable]

## Testing
[How to test]

## Deployment
[Any special considerations]
```

#### Step 6.2: Update README

Add feature to main README.md feature list

#### Step 6.3: Create Git Commit

Autonomously create commit with conventional commit format:
```bash
git add .
git commit -m "feat([feature-area]): [clear description]

- [List main changes]
- [3-5 bullet points]

Implements [feature-slug]
Tests: [X]/[X] passing
"
```

**Output**:
```
📚 Documentation generated!
   ✓ Created: docs/features/[feature-slug].md
   ✓ Updated: README.md

✅ Git commit created!
   Commit: feat(tasks): implement task dashboard with real-time updates
```

---

### PHASE 7: Completion Summary

#### Step 7.1: Present Results

Show comprehensive summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FEATURE COMPLETE AND READY FOR DEPLOYMENT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Feature: [Feature Name]
🕐 Duration: [X] minutes
📁 Files Created: [X]
📝 Files Modified: [X]
✅ Tests: [X]/[X] passing
🔒 Security: All checks passed
⚡ Performance: Optimized

═══════════════════════════════════════════════════

WHAT WAS BUILT:

Database:
• [table-name]: [description]
• [table-name]: [description]
• RLS policies configured for secure access

API Endpoints:
• GET /api/[resource] - [description]
• POST /api/[resource] - [description]
• DELETE /api/[resource]/[id] - [description]

UI Components:
• [ComponentName] - [description]
• [ComponentName] - [description]

Features:
• [Feature 1]
• [Feature 2]
• [Feature 3]

Tests:
• [X] unit tests
• [X] integration tests
• [X] E2E tests
• 100% of acceptance criteria covered

═══════════════════════════════════════════════════

TO SEE IT IN ACTION:

1. Start development server:
   npm run dev

2. Open in browser:
   http://localhost:3000/[feature-path]

3. Test the feature:
   - [Test step 1]
   - [Test step 2]
   - [Test step 3]

═══════════════════════════════════════════════════

TO DEPLOY:

Vercel (automatic):
   git push
   → Vercel will auto-deploy

Manual deployment:
   npm run build
   → Deploy /dist folder

═══════════════════════════════════════════════════

NEXT STEPS:

Want to make changes?
Just tell me what to adjust! For example:
• "Add a search bar to the task list"
• "Change task cards to show priority color"
• "Add export to CSV functionality"

Want to build another feature?
Just say: /implement [your feature description]

Questions or issues?
Let me know and I'll fix them!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### Recoverable Errors

**TypeScript Errors**:
```
⚠️ Found TypeScript errors in task 03
Attempting auto-fix... (attempt 1/3)
✅ Fixed! Regenerated with proper types
```

**Test Failures**:
```
⚠️ 2 tests failing in task 05
Analyzing failures...
Issue: Missing null check in component
Fixing implementation...
✅ All tests passing!
```

**Dependency Issues**:
```
⚠️ Task 04 requires Task 02 which hasn't run yet
Re-ordering tasks...
✅ Dependency resolved
```

### Non-Recoverable Errors

**Ambiguous Requirements**:
```
❌ I need clarification to continue

I'm not sure about:
"[specific ambiguous part]"

Could you clarify:
1. [Specific question]
2. [Specific question]

I've saved progress so far. Once you answer, I'll continue from where I left off!
```

**Technical Blockers**:
```
❌ Implementation blocked

Issue: [description]
Impact: Can't complete task [X]

Options:
1. Skip this task for now (I'll note it in the summary)
2. Adjust requirements to work around this
3. Stop here and review what's been built

What would you like to do?
```

---

## Progress Indicators

### Visual Progress Bar

```
🔨 Implementing feature...
   [████████████████] 01/15 Creating database migration (✓ 2m 30s)
   [████████████████] 02/15 Generating TypeScript types (✓ 0m 45s)
   [████████████░░░░] 03/15 Implementing GET /api/tasks (⏳ in progress)
   [░░░░░░░░░░░░░░░░] 04/15 Implementing POST /api/tasks (⏸️ waiting)
   ...
```

### Detailed Task Progress

```
[████████████░░░░] 03/15 Implementing GET /api/tasks
   ✓ Created: src/app/api/tasks/route.ts
   ✓ Created: src/lib/validations/task-schema.ts
   ⏳ Creating: src/app/api/tasks/route.test.ts
   ⏸️ Pending: Type checking
   ⏸️ Pending: Running tests
```

### Percentage Completion

```
Overall Progress: 35% complete (05/15 tasks)
Estimated time remaining: 42 minutes
```

---

## Configuration

### User Preferences

Allow users to configure behavior (in future):

```json
{
  "autonomous": {
    "askQuestionsLimit": 5,
    "autoFixAttempts": 3,
    "skipOptimizations": false,
    "verboseProgress": true,
    "pauseOnErrors": true
  }
}
```

---

## Anti-Patterns

### ❌ DON'T:

1. **Ask technical questions**:
   - "Should we use WebSockets or polling?"
   - "Do you want a foreign key constraint?"

2. **Require manual steps**:
   - "Now run /spec-design [slug]"
   - "Please execute each task"

3. **Expose technical errors**:
   - "TypeError on line 43"
   - "Zod validation failed"

4. **Make assumptions**:
   - Build features user didn't ask for
   - Skip security because it's "faster"

### ✅ DO:

1. **Ask business questions**:
   - "Should users be able to delete tasks?"
   - "Who should see this data?"

2. **Automate everything**:
   - Chain all commands automatically
   - Execute all tasks without prompting

3. **Explain in user terms**:
   - "The feature is working!"
   - "I fixed a small issue with data validation"

4. **Clarify when needed**:
   - Ask specific questions
   - Provide examples

---

## Testing the Command

### Test Case 1: Simple Feature

**Input**: `/implement Users should be able to upload profile pictures`

**Expected Flow**:
1. Asks: "What file formats? Size limit? Who can see?"
2. Builds: Upload component, API endpoint, storage integration
3. Tests: File upload, validation, security
4. Delivers: Working feature

### Test Case 2: Complex Feature

**Input**: `/implement Real-time collaboration dashboard`

**Expected Flow**:
1. Asks: "What collaboration features? How many users? Mobile support?"
2. Proposes: MVP scope
3. Builds: WebSocket integration, presence, activity feed
4. Tests: Real-time updates, reconnection, scaling
5. Delivers: Working feature with future enhancement suggestions

### Test Case 3: Ambiguous Request

**Input**: `/implement Make it better`

**Expected Flow**:
1. Asks: "What would you like to improve? Can you describe what 'better' means for your users?"
2. Gets clarification
3. Proceeds with implementation

---

## Success Criteria

The `/implement` command is successful when:

1. ✅ User provides natural language input (no technical knowledge)
2. ✅ System asks max 3-5 business questions
3. ✅ All tasks execute autonomously
4. ✅ Tests pass automatically
5. ✅ Feature is deployment-ready
6. ✅ User sees clear progress updates
7. ✅ Errors are handled gracefully
8. ✅ Documentation is auto-generated
9. ✅ Git commit is auto-created
10. ✅ User can immediately test the feature

---

## Future Enhancements

### Version 2.1:
- **Learning**: Remember user's preferences and domain knowledge
- **Suggestions**: "I noticed you often need X, should I add it?"
- **Iterations**: "I built V1. Try it and tell me what to change!"

### Version 2.2:
- **Voice Input**: Describe features verbally
- **Visual PRDs**: Upload wireframes/mockups
- **Multi-feature Planning**: "Build these 5 features in priority order"

### Version 3.0:
- **Code Analysis**: "Here's what I'd improve in your existing code"
- **Automated Refactoring**: "I can modernize this component for you"
- **Performance Monitoring**: "This feature is slow, let me optimize it"

---

## Conclusion

The `/implement` command transforms Claude Code into a **universal development assistant** that understands business requirements and autonomously creates production-ready code.

**Key Innovation**: Orchestration of specialized agents through a natural language interface, eliminating the need for technical knowledge while maintaining high quality standards.

Users describe **what** they want, AI handles all the **how**.
```

---

## Implementation Notes

This command requires:
1. Natural language parsing capabilities
2. Agent orchestration framework
3. Progress tracking system
4. Error recovery mechanisms
5. Automated testing pipeline

All these components should be built into the command logic itself, making it truly autonomous.
