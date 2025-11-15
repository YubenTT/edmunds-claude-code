# Example Interactions - Autonomous Implementation

Complete end-to-end examples showing how non-technical users interact with the autonomous `/implement` command.

---

## Example 1: Simple Feature - Task Management

**User Profile**: Product Manager, no coding experience

### User Input

```
/implement I want a dashboard where users can see their task list and add new tasks
```

### AI Response - Phase 1: Analysis

```
🔍 Analyzing feature: "task dashboard"

I understand you want to build:
• A page where users see their tasks
• Ability to add new tasks

This is a **Data Management + User Interface** feature.

📝 Before I start building, I need to understand a few things:

1. Should users be able to edit existing tasks?
   (yes / no)

2. Should users be able to delete tasks?
   (yes / no)

3. Do you want categories or tags for organizing tasks?
   (categories / tags / both / neither)

4. Should the task list update in real-time when someone adds a task?
   (yes / no - real-time means instant updates without refreshing)

5. Who should see the tasks?
   (only-owner / team-members / everyone)

Please answer each question so I can build exactly what you need!

⏸️ Waiting for your answers...
```

### User Answers

```
1. yes
2. yes
3. categories
4. yes
5. only-owner
```

### AI Response - Phase 2: Specification

```
✅ Got it! Creating specification...

📋 Specification Complete

Feature: Task Dashboard
Type: CRUD with real-time updates
Security: User-specific data (only you see your tasks)

Key Requirements:
• Task list view with real-time updates
• Create new tasks with category assignment
• Edit existing tasks (title, description, category)
• Delete tasks
• Category management
• Filter by category
• User isolation (RLS)

Moving to technical design...
```

### AI Response - Phase 3: Design

```
🏗️ Designing architecture...

Database Design:
   ✓ Table: tasks (id, user_id, title, description, category_id, status, created_at, updated_at)
   ✓ Table: categories (id, user_id, name, color, created_at)
   ✓ RLS policies: Users see only their own data
   ✓ Indexes: user_id, category_id, status

API Design:
   ✓ GET /api/tasks - List all tasks with filtering
   ✓ POST /api/tasks - Create new task
   ✓ PATCH /api/tasks/[id] - Update task
   ✓ DELETE /api/tasks/[id] - Delete task
   ✓ GET /api/categories - List categories
   ✓ POST /api/categories - Create category

UI Design:
   ✓ Page: /dashboard/tasks
   ✓ Component: TaskList (server component with real-time subscription)
   ✓ Component: TaskCard (displays single task with actions)
   ✓ Component: AddTaskForm (form with validation)
   ✓ Component: EditTaskDialog (modal for editing)
   ✓ Component: CategoryFilter (filter dropdown)
   ✓ Component: CategoryBadge (visual category indicator)

Real-time:
   ✓ Supabase Realtime subscription on tasks table
   ✓ Auto-update on insert/update/delete
   ✓ Reconnection handling

✅ Design approved (17 components identified)

Moving to task planning...
```

### AI Response - Phase 4: Task Planning

```
🔨 Breaking design into tasks...

✅ Task Planning Complete

Generated 18 tasks organized by dependencies:

Database Layer:
   01. Create tasks table migration
   02. Create categories table migration
   03. Add RLS policies
   04. Generate TypeScript types

API Layer:
   05. Implement GET /api/tasks
   06. Implement POST /api/tasks
   07. Implement PATCH /api/tasks/[id]
   08. Implement DELETE /api/tasks/[id]
   09. Implement GET /api/categories
   10. Implement POST /api/categories

UI Layer:
   11. Create TaskList component
   12. Create TaskCard component
   13. Create AddTaskForm component
   14. Create EditTaskDialog component
   15. Create CategoryFilter component
   16. Create dashboard page
   17. Integrate real-time subscriptions

Testing:
   18. Write E2E tests for complete user flow

Estimated time: 35-40 minutes

Starting implementation now...
```

### AI Response - Phase 5: Implementation (Real-time updates)

```
🔨 Implementing feature...

[████████████████] 01/18 Creating tasks table migration
   ✓ Created: supabase/migrations/20251115120001_create_tasks.sql
   ✓ Migration tested: Rollback successful
   ✓ Duration: 1m 23s

[████████████████] 02/18 Creating categories table migration
   ✓ Created: supabase/migrations/20251115120002_create_categories.sql
   ✓ Foreign key constraint added
   ✓ Duration: 1m 10s

[████████████████] 03/18 Adding RLS policies
   ✓ Created: supabase/migrations/20251115120003_add_rls_policies.sql
   ✓ Policies: SELECT, INSERT, UPDATE, DELETE (user_id = auth.uid())
   ✓ Duration: 2m 05s

[████████████████] 04/18 Generating TypeScript types
   ✓ Generated: src/lib/supabase/types.ts
   ✓ Types: Database, Tables, Task, Category
   ✓ Duration: 0m 45s

[████████████████] 05/18 Implementing GET /api/tasks
   ✓ Created: src/app/api/tasks/route.ts
   ✓ Created: src/lib/validations/task-schema.ts
   ✓ Created: src/app/api/tasks/route.test.ts
   ✓ Features: Filtering, sorting, pagination
   ✓ Tests: 8/8 passing
   ✓ Duration: 3m 20s

[████████████████] 06/18 Implementing POST /api/tasks
   ✓ Updated: src/app/api/tasks/route.ts
   ✓ Updated: src/app/api/tasks/route.test.ts
   ✓ Validation: Zod schema (title, description, category_id)
   ✓ Tests: 12/12 passing
   ✓ Duration: 2m 15s

[████████████████] 07/18 Implementing PATCH /api/tasks/[id]
   ✓ Created: src/app/api/tasks/[id]/route.ts
   ✓ Created: src/app/api/tasks/[id]/route.test.ts
   ✓ Validation: Ownership check
   ✓ Tests: 10/10 passing
   ✓ Duration: 2m 40s

[████████████████] 08/18 Implementing DELETE /api/tasks/[id]
   ✓ Updated: src/app/api/tasks/[id]/route.ts
   ✓ Updated: src/app/api/tasks/[id]/route.test.ts
   ✓ Tests: 15/15 passing
   ✓ Duration: 1m 50s

[████████████████] 09/18 Implementing GET /api/categories
   ✓ Created: src/app/api/categories/route.ts
   ✓ Created: src/app/api/categories/route.test.ts
   ✓ Tests: 6/6 passing
   ✓ Duration: 2m 10s

[████████████████] 10/18 Implementing POST /api/categories
   ✓ Updated: src/app/api/categories/route.ts
   ✓ Updated: src/app/api/categories/route.test.ts
   ✓ Tests: 10/10 passing
   ✓ Duration: 1m 55s

[████████████████] 11/18 Creating TaskList component
   ✓ Created: src/components/features/tasks/TaskList.tsx
   ✓ Created: src/components/features/tasks/TaskList.test.tsx
   ✓ Features: Loading state, empty state, error handling
   ✓ Tests: 7/7 passing
   ✓ Duration: 3m 30s

[████████████████] 12/18 Creating TaskCard component
   ✓ Created: src/components/features/tasks/TaskCard.tsx
   ✓ Created: src/components/features/tasks/TaskCard.test.tsx
   ✓ Features: Edit/delete actions, category badge, status toggle
   ✓ Accessibility: Keyboard navigation, ARIA labels
   ✓ Tests: 9/9 passing
   ✓ Duration: 4m 15s

[████████████████] 13/18 Creating AddTaskForm component
   ✓ Created: src/components/features/tasks/AddTaskForm.tsx
   ✓ Created: src/components/features/tasks/AddTaskForm.test.tsx
   ✓ Features: Form validation, category dropdown, loading state
   ✓ Tests: 11/11 passing
   ✓ Duration: 3m 45s

[████████████████] 14/18 Creating EditTaskDialog component
   ✓ Created: src/components/features/tasks/EditTaskDialog.tsx
   ✓ Created: src/components/features/tasks/EditTaskDialog.test.tsx
   ✓ Features: Modal dialog, pre-filled form, cancel/save
   ✓ Tests: 8/8 passing
   ✓ Duration: 3m 20s

[████████████████] 15/18 Creating CategoryFilter component
   ✓ Created: src/components/features/tasks/CategoryFilter.tsx
   ✓ Created: src/components/features/tasks/CategoryFilter.test.tsx
   ✓ Features: Dropdown filter, "All categories" option
   ✓ Tests: 5/5 passing
   ✓ Duration: 2m 30s

[████████████████] 16/18 Creating dashboard page
   ✓ Created: src/app/dashboard/tasks/page.tsx
   ✓ Layout: Header, filter bar, task list, add form
   ✓ Responsive: Mobile, tablet, desktop
   ✓ Duration: 2m 55s

[████████████████] 17/18 Integrating real-time subscriptions
   ✓ Created: src/lib/hooks/useRealtimeTasks.ts
   ✓ Created: src/lib/hooks/useRealtimeTasks.test.ts
   ✓ Features: Subscribe to changes, auto-update, reconnect
   ✓ Updated: TaskList component to use hook
   ✓ Tests: 6/6 passing
   ✓ Duration: 4m 10s

[████████████████] 18/18 Writing E2E tests
   ✓ Created: tests/e2e/task-dashboard.spec.ts
   ✓ Tests: Create task, edit task, delete task, filter, real-time
   ✓ Tests: 14/14 passing
   ✓ Duration: 5m 20s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Implementation complete! (38 minutes)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### AI Response - Phase 6: Quality Assurance

```
🔒 Running security audit...

Checking:
   ✓ Row Level Security enabled on all tables
   ✓ RLS policies tested with multiple users
   ✓ Zod validation on all API inputs
   ✓ Authentication required on all endpoints
   ✓ No SQL injection vulnerabilities
   ✓ No XSS vulnerabilities
   ✓ Error messages don't expose sensitive data
   ✓ Environment variables not committed

Security Score: ✅ 10/10 - All checks passed

⚡ Running performance check...

Checking:
   ✓ Database indexes on user_id, category_id
   ✓ Pagination implemented (20 tasks per page)
   ✓ No N+1 query patterns detected
   ✓ React components memoized appropriately
   ✓ Images optimized (N/A - no images)
   ✓ Bundle size: 142KB (within limits)
   ✓ Lighthouse score: 98/100

Performance Score: ✅ 9/10 - Optimized

Moving to documentation...
```

### AI Response - Phase 7: Documentation & Delivery

```
📚 Generating documentation...

   ✓ Created: docs/features/task-dashboard.md
   ✓ Updated: README.md (added feature to list)
   ✓ Generated: API documentation for endpoints

✅ Documentation complete!

🎯 Creating git commit...

   ✓ Staged all changes (28 files)
   ✓ Commit message: "feat(tasks): implement task dashboard with real-time updates"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FEATURE COMPLETE AND READY FOR DEPLOYMENT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Feature: Task Dashboard
🕐 Duration: 38 minutes
📁 Files Created: 23
📝 Files Modified: 5
✅ Tests: 107/107 passing
🔒 Security: 10/10
⚡ Performance: 9/10

═══════════════════════════════════════════════════

WHAT WAS BUILT:

Database:
• tasks table: Stores user tasks with title, description, category, status
• categories table: User-defined categories with colors
• RLS policies: Users can only see/modify their own data
• Indexes: Optimized queries on user_id and category_id

API Endpoints:
• GET /api/tasks - List tasks with filtering and pagination
• POST /api/tasks - Create new task with validation
• PATCH /api/tasks/[id] - Update existing task
• DELETE /api/tasks/[id] - Delete task (with ownership check)
• GET /api/categories - List user's categories
• POST /api/categories - Create new category

UI Components:
• TaskList - Displays all tasks with real-time updates
• TaskCard - Individual task with edit/delete actions
• AddTaskForm - Form to create new tasks
• EditTaskDialog - Modal to edit existing tasks
• CategoryFilter - Dropdown to filter by category
• CategoryBadge - Visual indicator of task category

Features:
• Real-time updates (see new tasks instantly)
• Category management (create and assign categories)
• Task filtering by category
• Edit tasks inline
• Delete tasks with confirmation
• Mobile responsive design
• Keyboard accessible
• Screen reader friendly

Tests:
• 61 unit tests
• 32 integration tests
• 14 E2E tests
• 100% of acceptance criteria covered

═══════════════════════════════════════════════════

TO SEE IT IN ACTION:

1. Start development server:
   npm run dev

2. Open in browser:
   http://localhost:3000/dashboard/tasks

3. Test the feature:
   - Click "Add Task" to create a task
   - Enter title, description, select category
   - See it appear in the list instantly
   - Click edit icon to modify task
   - Click delete icon to remove task
   - Use category filter to filter tasks
   - Open in second browser tab to see real-time updates

═══════════════════════════════════════════════════

TO DEPLOY:

Vercel (automatic):
   git push
   → Vercel will auto-deploy in ~2 minutes

Manual deployment:
   npm run build
   npm start

Database:
   supabase db push  # Push migrations to production
   npm run gen-types # Regenerate types

═══════════════════════════════════════════════════

NEXT STEPS:

Everything is working perfectly! Want to enhance it?

Here are some ideas:
• "Add due dates to tasks"
• "Add task priority levels (low/medium/high)"
• "Add ability to archive completed tasks"
• "Add search functionality"
• "Add task statistics dashboard"

Just tell me what you'd like and I'll build it!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Questions? Issues? Just let me know!
```

---

## Example 2: Complex Feature - Real-time Collaboration

**User Profile**: Business Analyst, some technical understanding but not a developer

### User Input

```
/implement I need a collaboration system where team members can see who's working on what
```

### AI Response - Phase 1: Analysis

```
🔍 Analyzing feature: "collaboration system"

This is a **complex feature** involving multiple components:
• Real-time presence tracking
• User activity monitoring
• Team management
• Possibly notifications and permissions

📋 Before I design this, I need to understand your priorities:

1. What's most important to show:
   a) Who's viewing a task right now (real-time presence)
   b) Who last edited a task (activity history)
   c) Both

2. How should presence be displayed:
   a) Small avatars on each task
   b) Separate "active users" sidebar
   c) Both

3. Should team members get notifications when:
   - Someone comments on a task they're watching? (yes/no)
   - Someone edits a task they're working on? (yes/no)
   - Someone joins the project? (yes/no)

4. How large are teams typically:
   a) Small (2-5 people)
   b) Medium (6-20 people)
   c) Large (20+ people)

5. This is a complex feature. Would you prefer:
   a) Build everything at once (2-3 hours)
   b) Build MVP first, then enhance (45min MVP + future enhancements)

Please answer each question!
```

### User Answers

```
1. c (both)
2. c (both)
3. yes, yes, no
4. b (medium teams)
5. b (MVP first)
```

### AI Response - Phase 2: Specification

```
✅ Smart choice! Building MVP first.

📋 MVP Specification (What I'll build now):

Phase 1 - MVP:
• Real-time presence: See who's viewing each task (avatars on task cards)
• Activity log: See who last edited and when
• Basic active users sidebar
• Team member list page

Phase 2 - Future Enhancements (you can request later):
• Notification system for comments/edits
• Advanced activity tracking with full history
• Typing indicators
• Presence on other pages (not just tasks)

Building Phase 1 now. You can request Phase 2 anytime by saying:
"/implement Add notifications to collaboration system"

Moving to technical design...
```

### AI Response - Phase 3: Design

```
🏗️ Designing MVP architecture...

Database Design:
   ✓ Table: presence (id, user_id, resource_type, resource_id, last_seen_at)
   ✓ Table: activity_log (id, user_id, action, resource_type, resource_id, metadata, created_at)
   ✓ View: active_users (aggregates presence data)
   ✓ RLS policies: Team members can see each other's presence
   ✓ Auto-cleanup: Remove stale presence after 2 minutes

API Design:
   ✓ POST /api/presence/heartbeat - Update user presence
   ✓ GET /api/presence/[resource] - Get active users for resource
   ✓ GET /api/activity - Get activity log
   ✓ WebSocket channel for real-time updates

UI Design:
   ✓ Component: PresenceAvatars (shows active users on task card)
   ✓ Component: ActiveUsersSidebar (list of all active users)
   ✓ Component: ActivityFeed (shows recent activity)
   ✓ Component: UserAvatar (reusable avatar component)
   ✓ Hook: usePresence (manages WebSocket connection)
   ✓ Hook: useHeartbeat (sends heartbeat every 30 seconds)

Real-time:
   ✓ Supabase Realtime for presence broadcasts
   ✓ Heartbeat system (every 30 seconds)
   ✓ Automatic cleanup of stale presence
   ✓ Reconnection handling

✅ Design approved (12 components for MVP)

Moving to task planning...
```

### AI Response - Phase 4: Task Planning

```
🔨 Breaking MVP into tasks...

✅ Task Planning Complete

Generated 15 tasks:

Database Layer (3 tasks):
   01. Create presence and activity_log tables
   02. Add RLS policies for team access
   03. Create cleanup function for stale presence

API Layer (4 tasks):
   04. Implement presence heartbeat endpoint
   05. Implement presence query endpoint
   06. Implement activity log endpoint
   07. Set up WebSocket channels

UI Layer (6 tasks):
   08. Create usePresence hook
   09. Create useHeartbeat hook
   10. Create UserAvatar component
   11. Create PresenceAvatars component
   12. Create ActiveUsersSidebar component
   13. Create ActivityFeed component

Integration (1 task):
   14. Integrate presence into task cards and dashboard

Testing (1 task):
   15. Write E2E tests for collaboration flow

Estimated time: 45-50 minutes

Starting implementation now...
```

### AI Response - Phase 5: Implementation (Abbreviated)

```
🔨 Implementing MVP...

[████████████████] 01/15 Creating presence tables ✓ (2m 15s)
[████████████████] 02/15 Adding RLS policies ✓ (1m 45s)
[████████████████] 03/15 Creating cleanup function ✓ (2m 30s)
[████████████████] 04/15 Implementing heartbeat endpoint ✓ (3m 10s)
[████████████████] 05/15 Implementing presence query ✓ (2m 20s)
[████████████████] 06/15 Implementing activity log ✓ (2m 55s)
[████████████████] 07/15 Setting up WebSocket ✓ (3m 40s)
[████████████████] 08/15 Creating usePresence hook ✓ (4m 15s)
[████████████████] 09/15 Creating useHeartbeat hook ✓ (2m 50s)
[████████████████] 10/15 Creating UserAvatar ✓ (3m 25s)
[████████████████] 11/15 Creating PresenceAvatars ✓ (4m 30s)
[████████████████] 12/15 Creating ActiveUsersSidebar ✓ (5m 15s)
[████████████████] 13/15 Creating ActivityFeed ✓ (4m 45s)
[████████████████] 14/15 Integrating into dashboard ✓ (3m 20s)
[████████████████] 15/15 Writing E2E tests ✓ (6m 10s)

✅ Implementation complete! (47 minutes)
```

### AI Response - Phase 6: Completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ COLLABORATION MVP COMPLETE!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Feature: Real-time Collaboration (MVP)
🕐 Duration: 47 minutes
✅ Tests: 83/83 passing

WHAT WAS BUILT:

Real-time Presence:
• See who's viewing each task (avatars appear on task cards)
• Shows up to 5 avatars, "+3 more" for additional users
• Updates instantly when users join/leave
• Auto-cleanup after 2 minutes of inactivity
• Reconnects automatically if connection drops

Activity Tracking:
• See who last edited each task
• Activity feed shows recent actions
• Timestamps (e.g., "2 minutes ago")
• Filter by action type

Active Users Sidebar:
• Shows all active team members
• Status indicators (viewing, editing, idle)
• Click avatar to filter tasks they're viewing
• Real-time updates

Technical Details:
• WebSocket connection for instant updates
• Heartbeat every 30 seconds
• Automatic reconnection
• Optimized for up to 20 concurrent users
• Works on mobile

═══════════════════════════════════════════════════

TO TEST:

1. Start server: npm run dev

2. Open http://localhost:3000/dashboard/tasks in TWO browser windows

3. In window 1: Open a task

4. In window 2: See avatar appear on that task

5. Try:
   - Edit a task in one window, see activity update in other
   - Close one window, see avatar disappear after 2 minutes
   - Open sidebar to see all active users

═══════════════════════════════════════════════════

WHAT'S NOT IN MVP (Phase 2):

Want these next? Just ask!

• Notifications when someone comments
• Notifications when someone edits "your" task
• Typing indicators (see what someone is typing)
• Full activity history (currently shows last 50)
• Presence on other pages (currently just tasks)

Just say:
"/implement Add notifications to collaboration system"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This gives you the core collaboration features!
Your team can now see who's working on what in real-time.

Questions or want to add Phase 2 features?
```

### User Follow-up

```
This is perfect! Can you add one more thing: show a "typing" indicator when someone is editing a task description?
```

### AI Response - Iteration

```
Great idea! Adding typing indicators...

🔨 Implementation plan:

This is a small enhancement to existing collaboration system.

I'll:
1. Add typing_status to presence broadcasts
2. Update usePresence hook to track typing state
3. Add TypingIndicator component
4. Integrate into EditTaskDialog

This will take about 8-10 minutes.

Building now...

[████████████████] 1/4 Updating presence schema ✓ (1m 30s)
[████████████████] 2/4 Updating usePresence hook ✓ (2m 45s)
[████████████████] 3/4 Creating TypingIndicator component ✓ (3m 20s)
[████████████████] 4/4 Integrating into task editing ✓ (2m 15s)

✅ Typing indicators added! (9 minutes)

Now when someone starts typing in the task description field, others see:
"[User Name] is typing..."

The indicator disappears 2 seconds after they stop typing.

Try it:
1. Open same task in two windows
2. Start typing in one
3. See "is typing..." in the other

Done! Anything else you'd like to add?
```

---

## Example 3: From Written PRD

**User Profile**: Product Owner with detailed written requirements

### User Setup

User creates `.claude/specs/ideas.md`:

```markdown
# Feature Ideas

## Customer Feedback System

### Overview
Allow customers to submit product feedback, vote on others' suggestions, and see what we're working on.

### User Capabilities
Customers can:
- Submit feedback with title and description
- Attach screenshots (optional)
- Vote up feedback they agree with
- Comment on feedback submissions
- See status of their submissions (new/reviewing/planned/in-progress/shipped)
- Get email when status changes
- Filter by status and category
- Sort by votes, date, or comments

Admins can:
- Review submissions
- Change status
- Merge duplicate submissions
- Categorize feedback (bug/feature/improvement)
- Add internal notes (not visible to customers)
- Bulk operations (approve multiple, etc.)

### Public Roadmap
- Public page showing "planned" and "in-progress" items
- Shows timeline/quarter if available
- No sensitive info exposed
- Can be shared via URL

### Business Requirements
- Must handle 1000+ submissions
- Mobile-friendly (many users on mobile)
- Must be accessible (WCAG AA)
- Email notifications via SendGrid
- Voting should prevent spam (1 vote per user per item)

### Timeline
- Priority: High
- Ship MVP: 2 weeks
- Full version: 1 month

### Out of Scope (for now)
- Private beta access
- Customer accounts (use email for now)
- Integration with Jira (manual for now)
```

### User Input

```
/implement Build the Customer Feedback System from ideas.md
```

### AI Response - Phase 1: Analysis

```
🔍 Reading your PRD from .claude/specs/ideas.md...

✅ Found comprehensive specification!

I understand you want:
• Customer feedback submission and voting
• Admin review and management interface
• Public roadmap
• Email notifications
• Mobile-friendly and accessible

Your PRD is very detailed! I just have a few clarifying questions:

1. For customer identification (since no accounts yet):
   How should we verify emails to prevent spam voting?
   a) Send magic link to vote (verified email)
   b) Allow voting without verification (simpler, but riskier)
   c) Require sign-in with Google/GitHub (OAuth)

2. For screenshot uploads:
   Maximum file size?
   a) 5MB (reasonable for screenshots)
   b) 10MB (higher quality, larger uploads)

3. For email notifications:
   You mentioned SendGrid. Do you have an account set up?
   (yes/no - if no, I can stub it out for now)

4. For the roadmap timeline:
   Should admins enter specific dates or just quarters (Q1 2025)?
   a) Specific dates (e.g., "March 15, 2025")
   b) Quarters (e.g., "Q1 2025")
   c) Both options available

5. Your PRD mentions MVP in 2 weeks. Should I:
   a) Build everything from the PRD now (2-3 hours of AI work)
   b) Build core features first, admin features later
```

### User Answers

```
1. a (magic link)
2. a (5MB)
3. yes (SendGrid configured)
4. b (quarters)
5. a (build everything)
```

### AI Response - Phase 2: Specification

```
✅ Perfect! I have everything I need.

Building complete Customer Feedback System based on your PRD.

📋 Specification Summary:

Customer Features:
• Submit feedback (title, description, optional screenshot)
• Vote on feedback (magic link verification)
• Comment on submissions
• Filter and sort
• Email notifications on status changes
• View public roadmap

Admin Features:
• Review dashboard
• Status management workflow
• Category assignment
• Merge duplicates
• Bulk operations
• Internal notes
• Admin-only views

Technical Approach:
• Email verification via magic links (15min expiry)
• SendGrid for emails
• Image upload to Supabase Storage
• Voting spam prevention (1 per email per item)
• Responsive design (mobile-first)
• WCAG AA accessibility
• Performance: Optimized for 1000+ submissions

This is a large feature. Estimated time: 2.5-3 hours

Moving to technical design...
```

### AI Response - Phase 3: Design (Abbreviated)

```
🏗️ Designing architecture...

Database Design:
   ✓ feedback_submissions (15 fields)
   ✓ feedback_votes (with email verification)
   ✓ feedback_comments
   ✓ feedback_categories
   ✓ admin_notes (private)
   ✓ email_verifications (magic links)
   ✓ 8 RLS policies
   ✓ 12 indexes

API Design:
   ✓ 18 endpoints across 4 resources
   ✓ Admin auth middleware
   ✓ Rate limiting on submission/voting
   ✓ SendGrid email service integration

UI Design:
   ✓ 23 components
   ✓ 6 pages (customer + admin)
   ✓ Mobile responsive layouts
   ✓ Accessibility features throughout

✅ Design complete (41 components identified)

Moving to task planning...
```

### AI Response - Phase 4: Implementation (Very Abbreviated)

```
🔨 Implementing complete system...

Generated 32 tasks in 6 categories:
• Database (5 tasks)
• API Layer (8 tasks)
• Customer UI (7 tasks)
• Admin UI (6 tasks)
• Email Service (3 tasks)
• Testing (3 tasks)

[Progress over 2.5 hours...]

✅ Implementation complete! (2 hours 38 minutes)
```

### AI Response - Phase 5: Completion Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ CUSTOMER FEEDBACK SYSTEM COMPLETE!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 Feature: Complete customer feedback platform
🕐 Duration: 2 hours 38 minutes
📁 Files Created: 67
✅ Tests: 218/218 passing
🔒 Security: All checks passed
⚡ Performance: Optimized for 1000+ items

═══════════════════════════════════════════════════

WHAT WAS BUILT:

Customer-Facing Pages:
• /feedback - Browse all feedback with filters
• /feedback/submit - Submit new feedback
• /feedback/[id] - View single feedback with comments
• /roadmap - Public roadmap view

Admin Pages:
• /admin/feedback - Review dashboard
• /admin/feedback/[id] - Detailed review interface
• /admin/categories - Category management

Features:
✓ Submit feedback with optional screenshots (max 5MB)
✓ Vote on feedback (verified email via magic link)
✓ Comment system with threading
✓ Status workflow (new → reviewing → planned → in-progress → shipped)
✓ Admin review dashboard with bulk operations
✓ Merge duplicate submissions
✓ Category management
✓ Internal admin notes
✓ Email notifications via SendGrid:
  - Verification emails for voting
  - Status change notifications
  - Comment notifications
✓ Public roadmap with quarterly timeline
✓ Advanced filters (status, category, votes, date)
✓ Spam prevention (1 vote per email per item)
✓ Mobile-responsive design
✓ WCAG AA accessibility
✓ Performance optimized for 1000+ submissions

Database:
• 6 tables with proper relationships
• RLS policies for security
• Indexes for performance
• Automatic cleanup of expired magic links

Security:
✓ Email verification for voting
✓ Admin-only routes protected
✓ Rate limiting on submissions (5 per hour per IP)
✓ File upload validation (type, size)
✓ XSS protection on user content
✓ No sensitive data in public API

Performance:
✓ Pagination (20 items per page)
✓ Image optimization
✓ Database indexes on all foreign keys
✓ Efficient voting queries
✓ Bundle size: 287KB

═══════════════════════════════════════════════════

SETUP REQUIRED:

1. Add SendGrid API key to environment:
   SENDGRID_API_KEY=your_key_here
   SENDGRID_FROM_EMAIL=feedback@yourdomain.com

2. Configure storage bucket (automatic):
   Already configured: feedback-screenshots

3. Push database migrations:
   supabase db push

═══════════════════════════════════════════════════

TO TEST:

Customer Flow:
1. Go to http://localhost:3000/feedback
2. Click "Submit Feedback"
3. Fill in title, description, upload screenshot
4. Click vote on an item
5. Check email for magic link
6. Click link to verify vote
7. Add comment
8. Check public roadmap

Admin Flow:
1. Go to http://localhost:3000/admin/feedback
2. See all submissions
3. Click one to review
4. Change status to "planned"
5. Add internal note
6. Try bulk status update
7. Try merging duplicates

═══════════════════════════════════════════════════

EMAIL TEMPLATES:

Created 4 email templates:
• Vote verification (magic link)
• Status change notification
• New comment notification
• Submission received confirmation

All emails are branded and mobile-friendly.

═══════════════════════════════════════════════════

ANALYTICS:

Built-in analytics available at /admin/feedback:
• Total submissions by status
• Votes over time
• Top categories
• Response time metrics
• Customer engagement stats

═══════════════════════════════════════════════════

NEXT STEPS:

Everything from your PRD is implemented!

Out-of-scope items you can request later:
• "Add private beta access with invite codes"
• "Add customer accounts instead of email-only"
• "Integrate with Jira API for syncing"

Want any of these? Just ask!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your comprehensive feedback system is ready to deploy!

Questions or want to make changes?
```

---

## Example 4: Error Handling & Recovery

**Scenario**: Implementation encounters an error

### User Input

```
/implement Add a payment system where users can upgrade to premium
```

### AI Response - Initial

```
🔍 Analyzing feature: "payment system"

📋 Questions:

1. Which payment provider:
   a) Stripe (recommended)
   b) PayPal
   c) Both

2. What premium plan structure:
   a) Single tier ($X/month)
   b) Multiple tiers (Basic/Pro/Enterprise)
   c) Usage-based pricing

3. Billing cycles:
   a) Monthly only
   b) Monthly and yearly (discount for yearly?)
   c) Custom

4. Free trial:
   a) Yes, 14 days
   b) Yes, 30 days
   c) No free trial

5. Payment method handling:
   a) Credit card only
   b) Credit card + PayPal
   c) Multiple payment methods
```

### User Answers

```
1. a (Stripe)
2. b (multiple tiers)
3. b (monthly and yearly, 20% discount for yearly)
4. a (14 day trial)
5. a (credit card)
```

### AI Response - Building

```
✅ Building payment system with Stripe...

🏗️ Design complete

🔨 Implementing...

[████████] 01/12 Creating subscription tables ✓
[████████] 02/12 Installing Stripe SDK ✓
[████████] 03/12 Implementing webhook handler...

⚠️ Issue detected

I need your Stripe API keys to continue:
- STRIPE_PUBLIC_KEY
- STRIPE_SECRET_KEY
- STRIPE_WEBHOOK_SECRET

Options:
1. I can continue building everything else and you add keys later
2. Pause here while you get keys
3. Build with test mode keys (I'll use Stripe test keys)

What would you prefer?
```

### User Response

```
3 - use test keys for now
```

### AI Response - Recovery

```
✅ Using Stripe test mode

STRIPE_PUBLIC_KEY=pk_test_... (test key)
STRIPE_SECRET_KEY=sk_test_... (test key)
STRIPE_WEBHOOK_SECRET=whsec_test_... (test key)

Note: You'll need to replace these with production keys before going live.

Continuing implementation...

[████████████] 03/12 Implementing webhook handler ✓
[████████████] 04/12 Creating checkout flow ✓
[████████████] 05/12 Building subscription management ✓
...

✅ Payment system complete!

⚠️ BEFORE PRODUCTION:

Replace test keys in .env with production keys:
1. Go to stripe.com/dashboard
2. Copy production API keys
3. Update .env file
4. Restart server

Test mode is perfect for development!
```

---

## Example 5: Ambiguous Request

**Scenario**: User request is too vague

### User Input

```
/implement Make the app better
```

### AI Response

```
🤔 I'd love to help improve your app!

To build something specific, I need to understand what "better" means for you.

Here are some ways I can help:

Performance Improvements:
• "Make the dashboard load faster"
• "Optimize database queries"
• "Reduce bundle size"

User Experience:
• "Add dark mode"
• "Improve mobile layout"
• "Add keyboard shortcuts"

Features:
• "Add [specific feature]"
• "Improve [specific workflow]"

Could you describe:
1. What part of the app should be better?
2. What problem are users having?
3. What would "better" look like to them?

Example:
"Users complain the task list is hard to scan. Make it clearer which tasks are high priority."

What would you like to improve?
```

### User Clarification

```
Users say the task list is overwhelming. They have 100+ tasks and can't find what to focus on.
```

### AI Response

```
✅ Got it! The problem is task overload and prioritization.

I can help with several solutions:

Option A - Smart Filtering:
• Add "Today", "This Week", "Overdue" filters
• Priority indicators (high/medium/low)
• "Focus Mode" showing top 5 tasks

Option B - AI-Powered Prioritization:
• Auto-prioritize based on due dates and dependencies
• "Suggested Next Tasks" section
• Time estimates to plan day

Option C - Better Organization:
• Projects/groups for related tasks
• Drag-and-drop reordering
• Collapsible sections

Option D - All of the above:
• Comprehensive task management overhaul
• Estimated time: 2-3 hours

Which approach would help your users most?
Or describe exactly what you envision?
```

### User Choice

```
Option A sounds perfect - start with that
```

### AI Response

```
Perfect! Building smart filtering system...

[Proceeds with implementation]
```

---

## Key Patterns

These examples demonstrate:

1. **Natural Language Understanding**: AI interprets what user wants
2. **Business Questions Only**: Never asks about technical implementation
3. **Progressive Disclosure**: Breaks complex features into phases
4. **Transparent Progress**: Shows exactly what's happening
5. **Graceful Error Handling**: Recovers from issues autonomously
6. **Iterative Refinement**: Easy to request changes
7. **Context Awareness**: Reads PRDs, understands existing features
8. **Educational**: Explains what was built in user-friendly terms

---

## Summary

The `/implement` command transforms feature descriptions into production-ready code through:
- Intelligent questioning
- Autonomous orchestration
- Real-time transparency
- Graceful error handling
- Complete documentation

**Result**: Non-technical users can build complex features just by describing what they want.
