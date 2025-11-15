# Question Framework - Intelligent Business Question System

**Version**: 1.0.0
**Part of**: Autonomous Workflow System
**Date**: 2025-11-15

---

## Overview

The Question Framework ensures AI asks only **essential business questions**, never technical implementation details. This maximizes autonomy while maintaining product quality and user intent alignment.

**Core Principle**: If it doesn't affect user experience or business logic, don't ask.

---

## Question Categories

### 1. SCOPE Questions

**What to ask**: Which features to include or exclude

**Examples - GOOD**:
```
❓ Should users be able to edit tasks after creation?
   Context: This affects whether we need edit history tracking.
   Default: Yes (most apps allow editing)

❓ Do you want bulk operations (select multiple items at once)?
   Context: Adds complexity but improves UX for power users.
   Default: No (start simple, add later if needed)

❓ Should this feature be available on mobile devices?
   Context: Affects responsive design approach.
   Default: Yes (mobile-first design)
```

**Examples - BAD** (Too Technical):
```
❌ Should I implement optimistic updates?
   → AI decides: Yes (better UX, standard pattern)

❌ Do you want React Query or SWR for data fetching?
   → AI decides: Based on project tech stack

❌ Should I use a modal or a slide-over for this?
   → AI decides: Based on UX best practices
```

### 2. PERMISSIONS Questions

**What to ask**: Authorization and access control rules

**Examples - GOOD**:
```
❓ Who can delete projects?
   Context: Determines permission model
   Options:
   - Only the project creator
   - Any team member
   - Only admins
   Default: Only the project creator

❓ Should team members see each other's private tasks?
   Context: Affects privacy and collaboration model
   Default: No (privacy by default)

❓ Can users share this data publicly (outside the organization)?
   Context: Security and compliance consideration
   Default: No (keep data private)
```

**Examples - BAD**:
```
❌ Should I implement Row Level Security?
   → AI decides: Yes (always secure by default)

❌ Do you want JWT or session-based auth?
   → AI decides: Based on tech stack (already using Supabase JWT)

❌ Should I add rate limiting?
   → AI decides: Yes (always protect APIs)
```

### 3. DATA Questions

**What to ask**: What information to store and how to structure it

**Examples - GOOD**:
```
❓ What information should we collect for user profiles?
   Context: Determines database schema
   Examples:
   - Basic: Name, email, avatar
   - Extended: Bio, location, social links
   - Full: + Skills, interests, preferences
   Default: Basic (can extend later)

❓ Should we keep a history of status changes?
   Context: Enables audit trails but increases storage
   Default: Yes (important for accountability)

❓ How long should we keep deleted items?
   Context: Recovery vs. storage costs
   Options:
   - Soft delete (keep forever, mark as deleted)
   - 30-day retention then hard delete
   - Immediate hard delete
   Default: 30-day retention
```

**Examples - BAD**:
```
❌ Should I use UUID or auto-increment IDs?
   → AI decides: UUID (secure, distributed-friendly)

❌ What database indexes should I create?
   → AI decides: Based on query patterns

❌ Should I normalize or denormalize this data?
   → AI decides: Based on access patterns
```

### 4. UX Questions

**What to ask**: User interaction patterns and workflows

**Examples - GOOD**:
```
❓ How should users add items to the list?
   Context: Affects interaction pattern
   Options:
   - Click "Add" button, then fill form
   - Inline add (type directly in list)
   - Quick add bar at top
   Default: Inline add (fastest workflow)

❓ Should changes save automatically or require clicking "Save"?
   Context: Trade-off between safety and convenience
   Default: Auto-save (modern expectation)

❓ Do you want real-time updates (see other users' changes live)?
   Context: Adds complexity but improves collaboration
   Default: Yes (important for multi-user apps)
```

**Examples - BAD**:
```
❌ Should I use Framer Motion or CSS transitions?
   → AI decides: Based on animation complexity

❌ Do you want light/dark mode?
   → AI decides: Yes (standard feature)

❌ Should I use a drawer or modal component?
   → AI decides: Based on UX patterns
```

### 5. INTEGRATION Questions

**What to ask**: How feature connects with existing functionality

**Examples - GOOD**:
```
❓ Should tasks sync with the calendar feature?
   Context: You have an existing calendar - integrate?
   Default: Yes (better user experience)

❓ When a project is deleted, what happens to its tasks?
   Context: Data integrity consideration
   Options:
   - Delete all tasks
   - Move tasks to "Orphaned" project
   - Ask user to reassign tasks
   Default: Delete all tasks (cascade delete)

❓ Should this send email notifications?
   Context: You have email infrastructure set up
   Default: Yes (configurable per user)
```

**Examples - BAD**:
```
❌ Should I use REST or GraphQL for this API?
   → AI decides: REST (matches existing API style)

❌ Do you want webhook support?
   → AI decides: No (not mentioned in requirements)

❌ Should I cache this data?
   → AI decides: Yes (performance optimization)
```

---

## Question Generation Algorithm

### Phase 1: Requirement Analysis

```typescript
interface RequirementAnalysis {
  // Extract entities
  entities: Entity[] // User, Task, Project, etc.

  // Extract actions
  actions: Action[] // Create, Edit, Delete, Share, etc.

  // Identify relationships
  relationships: Relationship[] // User owns Project, Project contains Tasks

  // Detect ambiguities
  ambiguities: Ambiguity[]
}

// Example
const analysis = {
  entities: ['User', 'Task', 'Dashboard'],
  actions: ['view', 'create', 'edit', 'delete', 'share'],
  relationships: [
    { from: 'User', to: 'Task', type: 'owns' },
    { from: 'Dashboard', to: 'Task', type: 'displays' }
  ],
  ambiguities: [
    {
      type: 'PERMISSION',
      text: 'edit tasks',
      question: 'Can users edit other users\' tasks?'
    },
    {
      type: 'SCOPE',
      text: 'dashboard',
      question: 'Should dashboard show all tasks or just user\'s tasks?'
    }
  ]
}
```

### Phase 2: Ambiguity Detection

```typescript
const AMBIGUITY_PATTERNS = {
  PERMISSION: [
    /who can (view|edit|delete|share)/i,
    /access control/i,
    /permissions/i,
    /restrict/i
  ],

  SCOPE: [
    /should (we|users) be able to/i,
    /do you want/i,
    /include/i,
    /support for/i
  ],

  DATA: [
    /what (data|information) (should|to)/i,
    /store/i,
    /keep track of/i,
    /history/i
  ],

  UX: [
    /how (should|do) users/i,
    /user experience/i,
    /workflow/i,
    /interaction/i
  ],

  INTEGRATION: [
    /integrate with/i,
    /connect to/i,
    /sync with/i,
    /webhook/i
  ]
}

function detectAmbiguities(request: string): Ambiguity[] {
  const ambiguities: Ambiguity[] = []

  // Check for permission ambiguities
  if (hasMultipleUsers(request) && !hasExplicitPermissions(request)) {
    ambiguities.push({
      category: 'PERMISSION',
      priority: 'CRITICAL',
      text: 'User access rights not specified',
      technicalQuestion: 'How to implement authorization?',
      businessQuestion: 'Who can perform which actions?'
    })
  }

  // Check for scope ambiguities
  if (hasVagueTerms(request, ['dashboard', 'analytics', 'reporting'])) {
    ambiguities.push({
      category: 'SCOPE',
      priority: 'HIGH',
      text: 'Feature scope unclear',
      technicalQuestion: 'What components to build?',
      businessQuestion: 'Which metrics/data to show?'
    })
  }

  return ambiguities
}
```

### Phase 3: Question Prioritization

```typescript
interface QuestionScore {
  question: Question
  score: number
  factors: {
    impactOnBusinessLogic: number    // 0-10
    affectsUserExperience: number    // 0-10
    blocksImplementation: number     // 0-10
    canBeDefaulted: number          // 0-10 (lower is better)
  }
}

function prioritizeQuestions(questions: Question[]): Question[] {
  const scored = questions.map(q => ({
    question: q,
    score: calculateScore(q),
    factors: analyzeFactor(q)
  }))

  // Sort by score (highest first)
  scored.sort((a, b) => b.score - a.score)

  // Take top 5 only
  return scored.slice(0, 5).map(s => s.question)
}

function calculateScore(q: Question): number {
  const factors = analyzeFactor(q)

  // Weighted scoring
  return (
    factors.impactOnBusinessLogic * 3 +
    factors.affectsUserExperience * 2 +
    factors.blocksImplementation * 2 -
    factors.canBeDefaulted * 1
  )
}

// Example scoring
const exampleScores = [
  {
    question: "Who can delete projects?",
    score: 85,
    factors: {
      impactOnBusinessLogic: 10,  // Critical business rule
      affectsUserExperience: 8,   // Major UX impact
      blocksImplementation: 7,    // Must know to build permission system
      canBeDefaulted: 3           // Hard to guess correctly
    }
  },
  {
    question: "Should we add dark mode?",
    score: 35,
    factors: {
      impactOnBusinessLogic: 0,   // No business logic impact
      affectsUserExperience: 7,   // Nice UX feature
      blocksImplementation: 0,    // Can add later
      canBeDefaulted: 8           // Safe default: Yes
    }
  }
]
```

### Phase 4: Question Phrasing

```typescript
function phraseQuestion(ambiguity: Ambiguity): Question {
  const template = getTemplateForCategory(ambiguity.category)

  return {
    id: generateId(),
    category: ambiguity.category,
    priority: ambiguity.priority,

    // Convert technical to business language
    question: template.format(ambiguity),

    // Explain why we're asking
    context: explainContext(ambiguity),

    // Provide concrete examples
    examples: generateExamples(ambiguity),

    // Suggest sensible default
    defaultAnswer: suggestDefault(ambiguity),

    // Validation rules
    validationRules: getValidationRules(ambiguity)
  }
}

const QUESTION_TEMPLATES = {
  PERMISSION: {
    format: (a: Ambiguity) => `Who should be able to ${a.action} ${a.entity}?`,
    contextTemplate: "This determines who has access to this functionality.",
    defaultStrategy: "Most restrictive option (safest)"
  },

  SCOPE: {
    format: (a: Ambiguity) => `Should users be able to ${a.capability}?`,
    contextTemplate: "This affects feature completeness and complexity.",
    defaultStrategy: "Start minimal, add later if needed"
  },

  DATA: {
    format: (a: Ambiguity) => `What ${a.dataType} information should we ${a.action}?`,
    contextTemplate: "This determines database schema and data collection.",
    defaultStrategy: "Collect what's necessary, allow extension"
  },

  UX: {
    format: (a: Ambiguity) => `How should users ${a.action} ${a.entity}?`,
    contextTemplate: "This affects the user interaction pattern.",
    defaultStrategy: "Follow platform conventions"
  },

  INTEGRATION: {
    format: (a: Ambiguity) => `Should this ${a.action} with ${a.existingFeature}?`,
    contextTemplate: "You have existing functionality that could integrate.",
    defaultStrategy: "Integrate if it adds value"
  }
}
```

---

## Question Presentation Patterns

### Pattern 1: Sequential (Interactive)

**Best for**: 2-3 questions, each answer affects next question

```
┌─────────────────────────────────────────────────┐
│ 📋 Let me ask you a few quick questions to     │
│    ensure I build exactly what you need.       │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ PERMISSIONS (Critical)                          │
│                                                 │
│ ❓ Who can delete projects?                     │
│                                                 │
│ Context: This determines your permission model  │
│                                                 │
│ Options:                                        │
│   1. Only the project creator                   │
│   2. Any team member                           │
│   3. Only admins                               │
│   4. Let me decide [Default]                   │
│                                                 │
│ Your choice: _                                  │
└─────────────────────────────────────────────────┘

[User answers, then next question appears]
```

### Pattern 2: Batch (All at Once)

**Best for**: 4-5 independent questions

```
┌─────────────────────────────────────────────────┐
│ 📋 I have 4 questions about your feature.      │
│    Answer all or hit Enter for defaults.       │
└─────────────────────────────────────────────────┘

1. PERMISSIONS: Who can delete projects?
   → [Only the project creator] (default)

2. SCOPE: Should users be able to edit tasks after creation?
   → [Yes] (default)

3. DATA: How long should we keep deleted items?
   → [30 days] (default)

4. UX: Should changes save automatically?
   → [Yes] (default)

Press Enter to accept all defaults, or type question numbers to customize (e.g., "1,3"): _
```

### Pattern 3: Progressive (Start with Defaults)

**Best for**: 5+ questions, most have good defaults

```
┌─────────────────────────────────────────────────┐
│ 📋 I've analyzed your request and prepared     │
│    default answers for 6 questions.            │
│                                                 │
│    Review and customize if needed.             │
└─────────────────────────────────────────────────┘

✅ PERMISSIONS: Only project creators can delete
✅ SCOPE: Users can edit tasks after creation
✅ DATA: 30-day retention for deleted items
✅ UX: Auto-save changes
✅ INTEGRATION: Sync with existing calendar
✅ SCOPE: No email notifications

Look good? (y/n): _

[If 'n', show all questions for customization]
```

---

## Intelligent Default Selection

### Default Selection Strategy

```typescript
interface DefaultStrategy {
  category: QuestionCategory
  strategy: DefaultStrategyType
  reasoning: string
}

type DefaultStrategyType =
  | 'MOST_SECURE'        // For security/permissions
  | 'LEAST_COMPLEX'      // For scope decisions
  | 'BEST_UX'            // For UX decisions
  | 'STANDARD_PRACTICE'  // For common patterns
  | 'EXISTING_PATTERN'   // Match existing features

const DEFAULT_STRATEGIES: DefaultStrategy[] = [
  {
    category: 'PERMISSION',
    strategy: 'MOST_SECURE',
    reasoning: 'Default to most restrictive permissions, user can relax later'
  },
  {
    category: 'SCOPE',
    strategy: 'LEAST_COMPLEX',
    reasoning: 'Start with MVP, add features incrementally based on feedback'
  },
  {
    category: 'UX',
    strategy: 'BEST_UX',
    reasoning: 'Follow modern UX patterns (auto-save, real-time updates, etc.)'
  },
  {
    category: 'DATA',
    strategy: 'STANDARD_PRACTICE',
    reasoning: 'Use industry-standard data models (soft delete, audit trails)'
  },
  {
    category: 'INTEGRATION',
    strategy: 'EXISTING_PATTERN',
    reasoning: 'Match patterns from existing features for consistency'
  }
]

function selectDefault(question: Question, context: ProjectContext): Answer {
  const strategy = DEFAULT_STRATEGIES.find(s => s.category === question.category)

  switch (strategy?.strategy) {
    case 'MOST_SECURE':
      return getMostRestrictiveOption(question)

    case 'LEAST_COMPLEX':
      return getSimplestOption(question)

    case 'BEST_UX':
      return getModernUXPattern(question)

    case 'STANDARD_PRACTICE':
      return getIndustryStandard(question)

    case 'EXISTING_PATTERN':
      return matchExistingPattern(question, context)

    default:
      return getFirstOption(question)
  }
}
```

### Examples of Good Defaults

```typescript
const GOOD_DEFAULTS = {
  // PERMISSIONS - Most Secure
  deletePermission: 'Only creator',
  viewPermission: 'Team members only',
  sharePublicly: 'No',

  // SCOPE - Least Complex
  bulkOperations: 'No (add later if needed)',
  advancedFilters: 'No (start with basic)',
  exportFeature: 'No (not in MVP)',

  // UX - Best UX
  saveMode: 'Auto-save',
  realTimeUpdates: 'Yes',
  loadingStates: 'Yes',
  errorHandling: 'User-friendly messages',

  // DATA - Standard Practice
  deletion: 'Soft delete with 30-day retention',
  auditTrail: 'Yes',
  timestamps: 'created_at and updated_at',
  uniqueIds: 'UUID',

  // INTEGRATION - Existing Pattern
  notifications: 'Match existing notification system',
  authentication: 'Use existing auth (Supabase)',
  styling: 'Match existing design system'
}
```

---

## Question Validation Rules

### Input Validation

```typescript
interface ValidationRule {
  type: ValidationType
  rule: (answer: Answer) => boolean
  errorMessage: string
}

type ValidationType =
  | 'REQUIRED'
  | 'ONE_OF'
  | 'CUSTOM'

// Examples
const validationRules: Record<string, ValidationRule[]> = {
  deletePermission: [
    {
      type: 'REQUIRED',
      rule: (a) => a !== null && a !== '',
      errorMessage: 'This is a critical decision - please select an option'
    },
    {
      type: 'ONE_OF',
      rule: (a) => ['creator', 'team', 'admin'].includes(a),
      errorMessage: 'Please select a valid option'
    }
  ],

  dataRetention: [
    {
      type: 'CUSTOM',
      rule: (a) => {
        if (a === 'immediate') return true
        const days = parseInt(a)
        return !isNaN(days) && days >= 0 && days <= 365
      },
      errorMessage: 'Enter a number between 0-365, or "immediate"'
    }
  ]
}
```

---

## Question Dependency Management

### Conditional Questions

Some questions only matter based on previous answers:

```typescript
interface ConditionalQuestion extends Question {
  condition: (answers: Map<string, Answer>) => boolean
}

// Example
const conditionalQuestions: ConditionalQuestion[] = [
  {
    id: 'bulk-operations',
    question: 'Should users be able to select multiple items?',
    condition: (answers) => {
      // Only ask if we have a list view
      return answers.get('view-type') === 'list'
    }
  },
  {
    id: 'retention-notification',
    question: 'Should we notify users before deleting old items?',
    condition: (answers) => {
      // Only ask if we're auto-deleting
      const retention = answers.get('data-retention')
      return retention !== 'keep-forever'
    }
  }
]

function filterQuestions(
  allQuestions: Question[],
  previousAnswers: Map<string, Answer>
): Question[] {
  return allQuestions.filter(q => {
    if (!('condition' in q)) return true
    return (q as ConditionalQuestion).condition(previousAnswers)
  })
}
```

---

## Anti-Patterns to Avoid

### ❌ Don't Ask: Technical Implementation Details

```typescript
const BAD_QUESTIONS = [
  "Should I use React Query or SWR?",
  "Do you want server or client components?",
  "Should I implement debouncing?",
  "What HTTP status code for validation errors?",
  "Should I use async/await or promises?",
  "Do you want TypeScript interfaces or types?",
  "Should I add loading skeletons?",
  "Do you want optimistic updates?",
  "Should I use CSS Grid or Flexbox?",
  "Do you want Row Level Security?"
]

// AI should decide all of these based on best practices
```

### ❌ Don't Ask: Questions with Obvious Answers

```typescript
const OBVIOUS_QUESTIONS = [
  "Should the app be fast?" // Obviously yes
  "Should we validate user input?" // Obviously yes
  "Should we handle errors gracefully?" // Obviously yes
  "Should the UI be accessible?" // Obviously yes
  "Should we write tests?" // Obviously yes
  "Should the code be maintainable?" // Obviously yes
]
```

### ❌ Don't Ask: Too Many Questions

```typescript
// BAD: Overwhelming the user
const TOO_MANY = 15 // questions

// GOOD: Focused essentials
const OPTIMAL = 2-5 // questions

// Strategy: Ask critical questions, make smart defaults for the rest
```

---

## Testing Question Quality

### Quality Metrics

```typescript
interface QuestionQuality {
  isBusinessFocused: boolean      // Not technical
  isActionable: boolean           // User can answer
  isSpecific: boolean            // Not vague
  hasContext: boolean            // Explains why asking
  hasGoodDefault: boolean        // Sensible fallback
  affectsOutcome: boolean        // Actually matters
}

function assessQuestionQuality(question: Question): QuestionQuality {
  return {
    isBusinessFocused: !containsTechnicalJargon(question.question),
    isActionable: userCanAnswer(question),
    isSpecific: !isVague(question.question),
    hasContext: question.context?.length > 20,
    hasGoodDefault: question.defaultAnswer !== null,
    affectsOutcome: question.priority !== 'LOW'
  }
}

// Good questions score 6/6
// Remove questions scoring < 4/6
```

---

## Summary

The Question Framework ensures:

1. **Minimal Questions**: 2-5 max, only critical business decisions
2. **Business Language**: No technical jargon, user-friendly phrasing
3. **Smart Defaults**: AI makes sensible choices for most decisions
4. **Contextual**: Users understand why each question matters
5. **Efficient**: Conditional questions, batch presentation, progressive disclosure

**Result**: Product managers can build features without technical knowledge.

---

**Next**: See PROGRESS_SYSTEM.md for real-time progress tracking design.
