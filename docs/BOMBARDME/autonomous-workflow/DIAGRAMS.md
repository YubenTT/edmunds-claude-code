# System Diagrams - Autonomous Workflow System

**Visual architecture and data flow diagrams**

---

## 1. High-Level System Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                         USER INTERFACE LAYER                         │
│                                                                      │
│  ┌────────────────┐  ┌───────────────┐  ┌──────────────────────┐  │
│  │  /implement    │  │   Progress    │  │   Approval Gates     │  │
│  │   Command      │→ │ Visualization │→ │    Controller        │  │
│  └────────────────┘  └───────────────┘  └──────────────────────┘  │
│                                                                      │
└──────────────────────────────────┬───────────────────────────────────┘
                                   ↓
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                       ORCHESTRATION ENGINE                           │
│                                                                      │
│  ┌────────────────┐  ┌───────────────┐  ┌──────────────────────┐  │
│  │  State         │  │   Workflow    │  │   Phase              │  │
│  │  Machine       │→ │  Controller   │→ │   Executor           │  │
│  └────────────────┘  └───────────────┘  └──────────────────────┘  │
│                                                                      │
└──────────────────────────────────┬───────────────────────────────────┘
                                   ↓
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                       INTELLIGENCE LAYER                             │
│                                                                      │
│  ┌────────────────┐  ┌───────────────┐  ┌──────────────────────┐  │
│  │  Question      │  │  Error        │  │   Decision           │  │
│  │  Engine        │  │  Recovery     │  │   Engine             │  │
│  └────────────────┘  └───────────────┘  └──────────────────────┘  │
│                                                                      │
└──────────────────────────────────┬───────────────────────────────────┘
                                   ↓
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                        EXECUTION LAYER                               │
│                                                                      │
│  ┌────────────────┐  ┌───────────────┐  ┌──────────────────────┐  │
│  │  Agent         │  │   Task        │  │   Test               │  │
│  │  Coordinator   │→ │   Executor    │→ │   Runner             │  │
│  └────────────────┘  └───────────────┘  └──────────────────────┘  │
│                                                                      │
└──────────────────────────────────┬───────────────────────────────────┘
                                   ↓
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                    EXISTING COMMAND LAYER                            │
│                                                                      │
│  /spec-create  /spec-design  /spec-tasks  /spec-execute            │
│  /api-new  /component-new  /types-gen  /lint  /test                │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 2. State Machine Flow

```
                    ┌─────────────┐
                    │ INITIALIZED │
                    └──────┬──────┘
                           │
                    [parse input]
                           │
                           ↓
                    ┌─────────────┐
              ┌────→│ QUESTIONING │
              │     └──────┬──────┘
              │            │
              │     [user answers]
              │            │
              │            ↓
              │     ┌──────────────────┐
              │     │ REQUIREMENTS     │
              │     │ ANALYSIS         │
              │     └──────┬───────────┘
              │            │
              │     [analyze complete]
              │            │
              │            ↓
              │     ┌──────────────────┐
              │     │ SPECIFICATION    │
              │     └──────┬───────────┘
              │            │
              │     [spec generated]
              │            │
              │            ↓
              │     ┌──────────────────┐
              │     │ APPROVAL_PENDING │◄──────┐
              │     └──────┬───────────┘       │
              │            │                    │
              │     [user approves]             │
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ DESIGN           │       │
              │     └──────┬───────────┘       │
              │            │                    │
              │     [design complete]           │
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ TASK_BREAKDOWN   │       │
              │     └──────┬───────────┘       │
              │            │                    │
              │     [tasks created]             │
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ IMPLEMENTATION   │───────┤
              │     └──────┬───────────┘       │
              │            │                    │
              │     [code complete]       [change request]
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ TESTING          │       │
              │     └──────┬───────────┘       │
              │            │                    │
              │     [tests pass]                │
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ REVIEW           │       │
              │     └──────┬───────────┘       │
              │            │                    │
              │     [review pass]               │
              │            │                    │
              │            ↓                    │
              │     ┌──────────────────┐       │
              │     │ APPROVAL_PENDING │───────┘
              │     └──────┬───────────┘
              │            │
              │     [user approves]
              │            │
              │            ↓
              │     ┌──────────────────┐
              │     │ COMPLETION       │
              │     └──────┬───────────┘
              │            │
              │     [finalize]
              │            │
              │            ↓
              │     ┌──────────────────┐
              │     │ COMPLETED        │
              │     └──────────────────┘
              │
              │            ↓
              │     ┌──────────────────┐
              └─────│ ERROR_RECOVERY   │
                    └──────────────────┘
                           │
                    [fix applied]
                           │
                           ↓
                  [return to previous state]
```

---

## 3. Question Engine Flow

```
┌─────────────────────┐
│  Feature Request    │
│  (Natural Language) │
└──────────┬──────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Requirement Analyzer                │
│  ┌────────────────────────────────┐ │
│  │ • Extract entities             │ │
│  │ • Identify actions             │ │
│  │ • Map relationships            │ │
│  │ • Detect ambiguities           │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Ambiguity Detector                  │
│  ┌────────────────────────────────┐ │
│  │ Pattern Matching:              │ │
│  │ • PERMISSION patterns          │ │
│  │ • SCOPE patterns               │ │
│  │ • DATA patterns                │ │
│  │ • UX patterns                  │ │
│  │ • INTEGRATION patterns         │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Question Generator                  │
│  ┌────────────────────────────────┐ │
│  │ For each ambiguity:            │ │
│  │ • Categorize (SCOPE/PERM/etc)  │ │
│  │ • Generate question text       │ │
│  │ • Add context explanation      │ │
│  │ • Provide examples             │ │
│  │ • Suggest default answer       │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Question Prioritizer                │
│  ┌────────────────────────────────┐ │
│  │ Score each question:           │ │
│  │ • Business logic impact (x3)   │ │
│  │ • UX impact (x2)               │ │
│  │ • Blocks implementation (x2)   │ │
│  │ • Can be defaulted (-1)        │ │
│  │                                │ │
│  │ Sort by score                  │ │
│  │ Take top 5                     │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Question Presenter                  │
│  ┌────────────────────────────────┐ │
│  │ Display:                       │ │
│  │ • Category + Priority          │ │
│  │ • Question                     │ │
│  │ • Context                      │ │
│  │ • Examples (if applicable)     │ │
│  │ • Default (if available)       │ │
│  │                                │ │
│  │ Get user input                 │ │
│  │ Validate answer                │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────┐
│  Answers Map         │
│  (Question ID → Answer)
└──────────────────────┘
```

---

## 4. Error Recovery Flow

```
┌─────────────────────┐
│  Error Detected     │
└──────────┬──────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Error Classifier                    │
│  ┌────────────────────────────────┐ │
│  │ • Detect error type            │ │
│  │ • Assign severity              │ │
│  │ • Extract context              │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
      ┌────┴────┐
      │         │
RECOVERABLE   ESCALATE   FATAL
      │         │           │
      ↓         ↓           ↓
┌─────────┐ ┌────────┐ ┌────────┐
│Auto-Fix │ │  Ask   │ │  Fail  │
│ (3x)    │ │  User  │ │Workflow│
└────┬────┘ └───┬────┘ └────────┘
     │          │
     ↓          ↓
┌──────────────────────────────────────┐
│  Fix Strategy Generator              │
│  ┌────────────────────────────────┐ │
│  │ Type Error:                    │ │
│  │ 1. Add type annotations        │ │
│  │ 2. Fix imports                 │ │
│  │ 3. Update definitions          │ │
│  │                                │ │
│  │ Test Failure:                  │ │
│  │ 1. Update expectations         │ │
│  │ 2. Add setup                   │ │
│  │ 3. Fix implementation          │ │
│  │                                │ │
│  │ Dependency Error:              │ │
│  │ 1. Install package             │ │
│  │ 2. Update package.json         │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────┐
│  Apply Fix           │
│  (Attempt 1/3)       │
└──────────┬───────────┘
           │
           ↓
      ┌────┴────┐
      │         │
    SUCCESS   FAILURE
      │         │
      ↓         ↓
┌──────────┐ ┌──────────┐
│Continue  │ │  Retry   │
│Workflow  │ │(Attempt 2)│
└──────────┘ └─────┬────┘
                   │
              [3 attempts]
                   │
                   ↓
            ┌──────────────┐
            │  Escalate    │
            │  to User     │
            └──────┬───────┘
                   │
                   ↓
            ┌──────────────┐
            │ User Provides│
            │  Guidance    │
            └──────┬───────┘
                   │
                   ↓
            ┌──────────────┐
            │ Apply User   │
            │  Solution    │
            └──────┬───────┘
                   │
                   ↓
            ┌──────────────┐
            │  Continue    │
            │  Workflow    │
            └──────────────┘
```

---

## 5. Agent Coordination Flow

```
┌──────────────────────────────────────┐
│  Workflow Phase                      │
│  (e.g., DESIGN)                      │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Phase Agent Mapper                  │
│  ┌────────────────────────────────┐ │
│  │ DESIGN Phase requires:         │ │
│  │ • system-architect (primary)   │ │
│  │ • backend-architect (database) │ │
│  │ • frontend-architect (ui)      │ │
│  │ • tech-stack-researcher        │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Dependency Graph Builder            │
│  ┌────────────────────────────────┐ │
│  │ Level 1: [system-architect]    │ │
│  │           ↓                    │ │
│  │ Level 2: [backend-architect,   │ │
│  │           frontend-architect]  │ │
│  │           ↓                    │ │
│  │ Level 3: [tech-stack-          │ │
│  │           researcher]          │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Parallel Executor                   │
│  ┌────────────────────────────────┐ │
│  │ Execute Level 1:               │ │
│  │   system-architect             │ │
│  │                                │ │
│  │ Wait for completion            │ │
│  │                                │ │
│  │ Execute Level 2 (parallel):    │ │
│  │   backend-architect  ║         │ │
│  │   frontend-architect ║         │ │
│  │                                │ │
│  │ Wait for both                  │ │
│  │                                │ │
│  │ Execute Level 3:               │ │
│  │   tech-stack-researcher        │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Result Aggregator                   │
│  ┌────────────────────────────────┐ │
│  │ Merge results:                 │ │
│  │ • Architecture diagram         │ │
│  │ • Database schema              │ │
│  │ • Component hierarchy          │ │
│  │ • Technology choices           │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────┐
│  Phase Complete      │
│  (Move to next)      │
└──────────────────────┘
```

---

## 6. Task Execution Flow

```
┌──────────────────────┐
│  Task List           │
│  [12 tasks]          │
└──────────┬───────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Dependency Analyzer                 │
│  ┌────────────────────────────────┐ │
│  │ Task 01: [] (no dependencies)  │ │
│  │ Task 02: [] (no dependencies)  │ │
│  │ Task 03: [01, 02] (depends on) │ │
│  │ Task 04: [01] (depends on)     │ │
│  │ Task 05: [03, 04] (depends on) │ │
│  │ ...                            │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Task Scheduler                      │
│  ┌────────────────────────────────┐ │
│  │ Batch 1 (parallel):            │ │
│  │   Task 01 ║ Task 02            │ │
│  │                                │ │
│  │ Batch 2 (parallel):            │ │
│  │   Task 03 ║ Task 04            │ │
│  │                                │ │
│  │ Batch 3:                       │ │
│  │   Task 05                      │ │
│  │                                │ │
│  │ ...                            │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Execute Batch (max 3 concurrent)    │
└──────────┬───────────────────────────┘
           │
           ↓ (for each task)
┌──────────────────────────────────────┐
│  Task Executor                       │
│  ┌────────────────────────────────┐ │
│  │ 1. Load task definition        │ │
│  │ 2. Determine task type         │ │
│  │ 3. Select command/agent        │ │
│  │ 4. Execute                     │ │
│  │ 5. Verify output               │ │
│  │ 6. Run tests                   │ │
│  │ 7. Mark complete               │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
      ┌────┴────┐
      │         │
    SUCCESS   ERROR
      │         │
      ↓         ↓
┌──────────┐ ┌──────────────┐
│Next Task │ │Error Recovery│
└──────────┘ └──────┬───────┘
                    │
              [retry/escalate]
                    │
                    ↓
             ┌──────────────┐
             │  Continue    │
             │  or Fail     │
             └──────────────┘
```

---

## 7. Progress Calculation Flow

```
┌──────────────────────┐
│  Workflow Status     │
│  (current state)     │
└──────────┬───────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Phase Progress Calculator           │
│  ┌────────────────────────────────┐ │
│  │ For each phase:                │ │
│  │                                │ │
│  │ if COMPLETED:                  │ │
│  │   progress = 100%              │ │
│  │                                │ │
│  │ if IN_PROGRESS:                │ │
│  │   completed_items = count(✅)  │ │
│  │   total_items = count(all)     │ │
│  │   progress = completed/total   │ │
│  │                                │ │
│  │ if PENDING:                    │ │
│  │   progress = 0%                │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Task Progress Calculator            │
│  ┌────────────────────────────────┐ │
│  │ For each task:                 │ │
│  │                                │ │
│  │ if has subtasks:               │ │
│  │   progress = completed/total   │ │
│  │                                │ │
│  │ else:                          │ │
│  │   progress = elapsed/estimated │ │
│  │   cap at 95%                   │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Overall Progress Calculator         │
│  ┌────────────────────────────────┐ │
│  │ Weight by estimated duration:  │ │
│  │                                │ │
│  │ total_weight = sum(            │ │
│  │   phase.estimated_duration     │ │
│  │ )                              │ │
│  │                                │ │
│  │ completed_weight = sum(        │ │
│  │   phase.progress *             │ │
│  │   phase.estimated_duration     │ │
│  │ )                              │ │
│  │                                │ │
│  │ overall =                      │ │
│  │   completed_weight/total_weight│ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────────────────────┐
│  Time Estimator                      │
│  ┌────────────────────────────────┐ │
│  │ Calculate velocity:            │ │
│  │   actual_time = sum(elapsed)   │ │
│  │   estimated_time = sum(est)    │ │
│  │   velocity = actual/estimated  │ │
│  │                                │ │
│  │ Estimate remaining:            │ │
│  │   remaining_work = sum(        │ │
│  │     pending_task.estimated     │ │
│  │   )                            │ │
│  │   remaining_time =             │ │
│  │     remaining_work * velocity  │ │
│  │                                │ │
│  │ ETA = now + remaining_time     │ │
│  └────────────────────────────────┘ │
└──────────┬───────────────────────────┘
           │
           ↓
┌──────────────────────┐
│  Progress Status     │
│  {                   │
│    overall: 68%,     │
│    eta: "12 min",    │
│    phases: [...],    │
│    tasks: [...]      │
│  }                   │
└──────────────────────┘
```

---

## 8. Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         INPUT LAYER                             │
│                                                                 │
│  User → /implement "feature description"                       │
│                                                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                     PROCESSING LAYER                            │
│                                                                 │
│  Feature Request → Question Engine → Answers                   │
│                         ↓                                       │
│                  Requirements Analysis                          │
│                         ↓                                       │
│                   Specification Creation                        │
│                         ↓                                       │
│                   Technical Design                              │
│                         ↓                                       │
│                   Task Breakdown                                │
│                                                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                      EXECUTION LAYER                            │
│                                                                 │
│  For each task:                                                │
│    Task Definition → Agent/Command → Generated Code            │
│                                    → Tests                     │
│                                    → Documentation             │
│                                                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                      VALIDATION LAYER                           │
│                                                                 │
│  Generated Code → TypeScript Check → Tests → Quality Audit    │
│                                                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                       OUTPUT LAYER                              │
│                                                                 │
│  Artifacts:                                                    │
│    • Specification (spec.md)                                   │
│    • Design (design.md)                                        │
│    • Tasks (tasks/*.md)                                        │
│    • Code (src/...)                                            │
│    • Tests (tests/...)                                         │
│    • Docs (README, API docs)                                   │
│                                                                 │
│  Git Commit → Ready for Review                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                     PERSISTENCE LAYER                           │
│                   (Throughout Process)                          │
│                                                                 │
│  .claude/workflows/[workflow-id]/                              │
│    ├── state.json          (current state, resumable)          │
│    ├── artifacts/          (all generated files)               │
│    │   ├── spec.md                                             │
│    │   ├── design.md                                           │
│    │   ├── tasks/                                              │
│    │   └── code/                                               │
│    └── logs/               (execution logs)                    │
│        ├── execution.log                                       │
│        ├── errors.log                                          │
│        └── debug.log                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    FEEDBACK LAYER                               │
│                  (Real-time Updates)                            │
│                                                                 │
│  Progress Status → Progress Visualizer → Terminal Display     │
│       ↑                                         ↓              │
│       └─────────── Update every 1s ─────────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. Component Interaction Matrix

```
┌────────────────────────────────────────────────────────────────────┐
│ Component Interaction Map                                         │
├────────────────┬───────────────────────────────────────────────────┤
│ Component      │ Interacts With                                   │
├────────────────┼───────────────────────────────────────────────────┤
│ /implement     │ → WorkflowController                             │
│ Command        │ → ConfigLoader                                   │
│                │ → ProgressStreamer                               │
├────────────────┼───────────────────────────────────────────────────┤
│ Workflow       │ → StateMachine                                   │
│ Controller     │ → PhaseExecutor                                  │
│                │ → ApprovalGateController                         │
│                │ → WorkflowStore                                  │
│                │ ← QuestionEngine                                 │
│                │ ← ErrorRecovery                                  │
├────────────────┼───────────────────────────────────────────────────┤
│ Question       │ → RequirementAnalyzer                            │
│ Engine         │ → QuestionGenerator                              │
│                │ → QuestionPresenter                              │
│                │ ← User Input                                     │
├────────────────┼───────────────────────────────────────────────────┤
│ Phase          │ → AgentCoordinator                               │
│ Executor       │ → TaskExecutor                                   │
│                │ → ProgressTracker                                │
│                │ ← WorkflowController                             │
├────────────────┼───────────────────────────────────────────────────┤
│ Agent          │ → Agent Registry                                 │
│ Coordinator    │ → DependencyGraph                                │
│                │ → ParallelExecutor                               │
│                │ ← Individual Agents                              │
├────────────────┼───────────────────────────────────────────────────┤
│ Task           │ → CommandExecutor                                │
│ Executor       │ → TestRunner                                     │
│                │ → ErrorRecovery                                  │
│                │ ← TaskScheduler                                  │
├────────────────┼───────────────────────────────────────────────────┤
│ Error          │ → ErrorClassifier                                │
│ Recovery       │ → FixStrategyGenerator                           │
│                │ → ErrorEscalator                                 │
│                │ ← WorkflowController                             │
├────────────────┼───────────────────────────────────────────────────┤
│ Progress       │ → ProgressCalculator                             │
│ Tracker        │ → TimeEstimator                                  │
│                │ → ProgressVisualizer                             │
│                │ ← All Executors                                  │
├────────────────┼───────────────────────────────────────────────────┤
│ Workflow       │ → File System                                    │
│ Store          │ → ArtifactStore                                  │
│                │ ← WorkflowController                             │
│                │ ← All Components (for state persistence)         │
└────────────────┴───────────────────────────────────────────────────┘
```

---

## 10. File Structure Diagram

```
talats-claude-code/
│
├── .claude/
│   │
│   ├── commands/
│   │   └── workflow/
│   │       └── implement.md ──────────► Master command
│   │
│   ├── lib/
│   │   └── autonomous-workflow/
│   │       │
│   │       ├── Core
│   │       ├── types.ts ───────────────► All interfaces
│   │       ├── constants.ts ────────────► Enums, defaults
│   │       ├── config.ts ───────────────► Configuration
│   │       ├── state-machine.ts ────────► State management
│   │       ├── workflow-controller.ts ──► Main orchestrator
│   │       ├── workflow-store.ts ───────► Persistence
│   │       │
│   │       ├── question-engine/
│   │       │   ├── requirement-analyzer.ts
│   │       │   ├── question-generator.ts
│   │       │   ├── question-presenter.ts
│   │       │   └── ...
│   │       │
│   │       ├── progress/
│   │       │   ├── progress-calculator.ts
│   │       │   ├── progress-visualizer.ts
│   │       │   ├── progress-streamer.ts
│   │       │   └── ...
│   │       │
│   │       ├── error-recovery/
│   │       │   ├── error-classifier.ts
│   │       │   ├── fix-strategy-generator.ts
│   │       │   ├── error-escalator.ts
│   │       │   └── fix-strategies/
│   │       │
│   │       ├── agents/
│   │       │   ├── agent-registry.ts
│   │       │   ├── agent-coordinator.ts
│   │       │   └── ...
│   │       │
│   │       └── __tests__/
│   │           ├── unit/
│   │           └── integration/
│   │
│   ├── specs/
│   │   └── autonomous-workflow/
│   │       ├── README.md ──────────────► Overview
│   │       ├── ARCHITECTURE.md ─────────► System design
│   │       ├── QUESTION_FRAMEWORK.md ───► Questions
│   │       ├── PROGRESS_SYSTEM.md ──────► Progress
│   │       ├── IMPLEMENTATION.md ───────► Build plan
│   │       ├── COMMAND_SPEC.md ─────────► Command docs
│   │       └── DIAGRAMS.md ─────────────► This file
│   │
│   └── workflows/ ──────────────────────► Runtime storage
│       └── [workflow-id]/
│           ├── state.json
│           ├── artifacts/
│           └── logs/
│
└── package.json
```

---

## Summary

These diagrams provide visual representations of:

1. **System Architecture**: Overall component organization
2. **State Machine**: Workflow state transitions
3. **Question Engine**: How questions are generated and asked
4. **Error Recovery**: How errors are handled automatically
5. **Agent Coordination**: How multiple agents work together
6. **Task Execution**: How tasks are scheduled and executed
7. **Progress Calculation**: How progress is computed in real-time
8. **Data Flow**: How data moves through the system
9. **Component Interaction**: How components communicate
10. **File Structure**: Where everything lives

Use these diagrams to understand the system architecture and implementation approach.

---

**For implementation details, see**:
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Detailed component specs
- [IMPLEMENTATION.md](./IMPLEMENTATION.md) - Build roadmap
- [COMMAND_SPEC.md](./COMMAND_SPEC.md) - User-facing documentation
