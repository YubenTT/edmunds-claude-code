# Progress System - Real-Time Workflow Visualization

**Version**: 1.0.0
**Part of**: Autonomous Workflow System
**Date**: 2025-11-15

---

## Overview

The Progress System provides real-time, user-friendly visualization of autonomous workflow execution. Users see exactly what's happening, how long it will take, and can track progress without technical knowledge.

**Core Principle**: Show value and progress, not technical details.

---

## Progress Visualization Hierarchy

```
┌─────────────────────────────────────────────────┐
│ LEVEL 1: Feature Overview                      │
│ - Feature name                                  │
│ - Overall progress percentage                   │
│ - Estimated time remaining                      │
└─────────────────────────────────────────────────┘
            ↓
┌─────────────────────────────────────────────────┐
│ LEVEL 2: Phase Progress                        │
│ - Current phase (name, status, time)           │
│ - All phases (completed, current, pending)     │
└─────────────────────────────────────────────────┘
            ↓
┌─────────────────────────────────────────────────┐
│ LEVEL 3: Task Breakdown                        │
│ - Completed tasks (collapsed)                  │
│ - Current task (expanded with progress)        │
│ - Pending tasks (preview)                      │
└─────────────────────────────────────────────────┘
            ↓
┌─────────────────────────────────────────────────┐
│ LEVEL 4: Live Activity Log                     │
│ - Current action                                │
│ - Recent completions                           │
│ - Error notifications                          │
└─────────────────────────────────────────────────┘
```

---

## Visual Design

### Complete Progress View

```
🎯 Feature: "User Dashboard with Real-Time Analytics"
════════════════════════════════════════════════════════════

📊 Overall Progress: [████████████████░░░░] 68% complete
⏱️  Estimated completion: 12 minutes

─────────────────────────────────────────────────────────────

📋 Phase 1: Planning (3 min)
   ✅ Requirements analyzed
   ✅ Technical design created
   ✅ 12 tasks identified
   Status: Completed in 2m 45s

🔨 Phase 2: Implementation (25 min)
   [████████████████░░░░] 8/12 tasks complete

   ✅ 01. Create analytics database schema
   ✅ 02. Build analytics aggregation API
   ✅ 03. Implement chart components
   ✅ 04. Add real-time data subscription
   ✅ 05. Create dashboard layout
   ✅ 06. Write API unit tests
   ✅ 07. Write component tests
   ✅ 08. Add E2E tests

   ⏳ 09. Optimize query performance (in progress...)
      [██████████░░░░░░░░░░] 50%
      └─ Analyzing slow queries
      └─ Adding database indexes
      └─ Testing performance improvements

   ⏸️  10. Add loading states and error handling
   ⏸️  11. Implement accessibility features
   ⏸️  12. Generate documentation

   Status: In Progress (16m elapsed, ~9m remaining)

🔍 Phase 3: Quality Review (5 min)
   ⏸️  Security audit
   ⏸️  Performance validation
   ⏸️  Accessibility check

💾 Phase 4: Finalization (2 min)
   ⏸️  Final code review
   ⏸️  Git commit
   ⏸️  Summary generation

─────────────────────────────────────────────────────────────

📝 Recent Activity:
   [16:42] ✅ Task 08 completed: E2E tests passing
   [16:43] 🔧 Task 09 started: Optimizing performance
   [16:44] 📊 Added index on analytics.created_at column
   [16:45] 🔧 Analyzing query execution plans

─────────────────────────────────────────────────────────────
```

---

## Data Structures

### Progress Status Model

```typescript
interface ProgressStatus {
  // Top-level workflow info
  workflow: WorkflowInfo

  // Phase breakdown
  phases: PhaseProgress[]

  // Task details
  tasks: TaskProgress[]

  // Live activity
  activities: Activity[]

  // Performance metrics
  metrics: ProgressMetrics

  // Time estimates
  estimates: TimeEstimates
}

interface WorkflowInfo {
  id: string
  featureName: string
  status: 'RUNNING' | 'PAUSED' | 'COMPLETED' | 'FAILED'
  startTime: Date
  endTime?: Date
  progress: number // 0-100
}

interface PhaseProgress {
  id: string
  name: string
  displayName: string // User-friendly name
  status: PhaseStatus
  order: number

  // Timing
  estimatedDuration: number // milliseconds
  startTime?: Date
  endTime?: Date
  elapsedTime: number

  // Content
  items: PhaseItem[]

  // Progress
  progress: number // 0-100

  // Dependencies
  dependsOn: string[] // Phase IDs
  blockedBy?: string[] // If waiting on something
}

type PhaseStatus =
  | 'PENDING'        // Not started yet
  | 'IN_PROGRESS'    // Currently executing
  | 'COMPLETED'      // Successfully finished
  | 'FAILED'         // Error occurred
  | 'SKIPPED'        // Skipped (conditional)
  | 'WAITING'        // Waiting for dependency

interface PhaseItem {
  description: string
  status: 'PENDING' | 'IN_PROGRESS' | 'COMPLETED' | 'FAILED'
  icon?: string
  timestamp?: Date
}

interface TaskProgress {
  id: string
  number: number
  title: string
  description: string
  category: TaskCategory

  // Status
  status: TaskStatus
  progress: number // 0-100

  // Timing
  estimatedDuration: number
  startTime?: Date
  endTime?: Date
  elapsedTime: number

  // Error handling
  error?: TaskError
  retryCount: number
  maxRetries: number

  // Subtasks
  subtasks?: Subtask[]

  // Dependencies
  dependsOn: string[] // Task IDs
  blockedBy?: string[] // If waiting on something
}

type TaskStatus =
  | 'PENDING'
  | 'WAITING'        // Waiting for dependencies
  | 'IN_PROGRESS'
  | 'TESTING'        // Running tests
  | 'COMPLETED'
  | 'FAILED'
  | 'RETRYING'       // Auto-retry in progress
  | 'SKIPPED'

type TaskCategory =
  | 'DATABASE'       // Schema, migrations
  | 'API'           // Backend endpoints
  | 'UI'            // Components, pages
  | 'TESTING'       // Test creation
  | 'DOCUMENTATION' // Docs generation
  | 'QUALITY'       // Linting, formatting
  | 'INTEGRATION'   // Feature integration

interface Subtask {
  description: string
  status: 'PENDING' | 'IN_PROGRESS' | 'COMPLETED'
  progress?: number
}

interface Activity {
  id: string
  timestamp: Date
  type: ActivityType
  message: string
  icon: string
  metadata?: Record<string, any>
}

type ActivityType =
  | 'PHASE_START'
  | 'PHASE_COMPLETE'
  | 'TASK_START'
  | 'TASK_COMPLETE'
  | 'TASK_FAILED'
  | 'ERROR_RECOVERY'
  | 'USER_INTERVENTION'
  | 'MILESTONE'
  | 'INFO'

interface ProgressMetrics {
  // Task metrics
  totalTasks: number
  completedTasks: number
  failedTasks: number
  skippedTasks: number

  // Phase metrics
  totalPhases: number
  completedPhases: number

  // Quality metrics
  testsRun: number
  testsPassed: number
  testsFailed: number

  // Code metrics
  filesCreated: number
  filesModified: number
  linesOfCode: number

  // Error metrics
  errorsEncountered: number
  errorsAutoFixed: number
  errorsEscalated: number
}

interface TimeEstimates {
  total: number              // Total estimated duration
  elapsed: number           // Time elapsed so far
  remaining: number         // Estimated time remaining

  // Completion estimates
  estimatedCompletionTime: Date
  confidenceLevel: 'LOW' | 'MEDIUM' | 'HIGH'

  // Phase estimates
  phaseEstimates: Map<string, number>
}
```

---

## Progress Calculation Algorithms

### Overall Progress Calculation

```typescript
class ProgressCalculator {
  calculateOverallProgress(status: ProgressStatus): number {
    // Weight phases by estimated duration
    const totalWeight = status.phases.reduce(
      (sum, p) => sum + p.estimatedDuration,
      0
    )

    const completedWeight = status.phases.reduce(
      (sum, p) => sum + (p.progress / 100) * p.estimatedDuration,
      0
    )

    return Math.round((completedWeight / totalWeight) * 100)
  }

  calculatePhaseProgress(phase: PhaseProgress): number {
    if (phase.status === 'COMPLETED') return 100
    if (phase.status === 'PENDING') return 0

    // Calculate based on completed items
    const completedItems = phase.items.filter(
      i => i.status === 'COMPLETED'
    ).length

    const totalItems = phase.items.length

    return Math.round((completedItems / totalItems) * 100)
  }

  calculateTaskProgress(task: TaskProgress): number {
    if (task.status === 'COMPLETED') return 100
    if (task.status === 'PENDING') return 0

    // If has subtasks, calculate from subtask completion
    if (task.subtasks && task.subtasks.length > 0) {
      const completedSubtasks = task.subtasks.filter(
        s => s.status === 'COMPLETED'
      ).length
      return Math.round((completedSubtasks / task.subtasks.length) * 100)
    }

    // Otherwise, estimate based on elapsed time
    const timeProgress = Math.min(
      (task.elapsedTime / task.estimatedDuration) * 100,
      95 // Cap at 95% until actually complete
    )

    return Math.round(timeProgress)
  }
}
```

### Time Estimation

```typescript
class TimeEstimator {
  estimateRemainingTime(status: ProgressStatus): number {
    // Use historical data to adjust estimates
    const velocity = this.calculateVelocity(status)

    const remainingWork = status.tasks
      .filter(t => t.status === 'PENDING' || t.status === 'IN_PROGRESS')
      .reduce((sum, t) => sum + t.estimatedDuration, 0)

    // Adjust by velocity factor
    return remainingWork * velocity
  }

  private calculateVelocity(status: ProgressStatus): number {
    // Compare actual vs. estimated time for completed tasks
    const completedTasks = status.tasks.filter(
      t => t.status === 'COMPLETED'
    )

    if (completedTasks.length === 0) return 1.0 // No data yet

    const totalEstimated = completedTasks.reduce(
      (sum, t) => sum + t.estimatedDuration,
      0
    )

    const totalActual = completedTasks.reduce(
      (sum, t) => sum + t.elapsedTime,
      0
    )

    // Velocity > 1 means slower than estimated
    // Velocity < 1 means faster than estimated
    const velocity = totalActual / totalEstimated

    // Clamp to reasonable range (0.5x - 2x)
    return Math.max(0.5, Math.min(2.0, velocity))
  }

  estimateCompletionTime(status: ProgressStatus): Date {
    const remaining = this.estimateRemainingTime(status)
    return new Date(Date.now() + remaining)
  }

  getConfidenceLevel(status: ProgressStatus): 'LOW' | 'MEDIUM' | 'HIGH' {
    const completedTasks = status.tasks.filter(
      t => t.status === 'COMPLETED'
    ).length

    const totalTasks = status.tasks.length
    const completionRatio = completedTasks / totalTasks

    // More completed tasks = higher confidence
    if (completionRatio < 0.2) return 'LOW'
    if (completionRatio < 0.6) return 'MEDIUM'
    return 'HIGH'
  }
}
```

---

## Progress Visualization Components

### Phase Visualizer

```typescript
class PhaseVisualizer {
  renderPhase(phase: PhaseProgress, isCurrent: boolean): string {
    const icon = this.getPhaseIcon(phase.status)
    const progressBar = isCurrent ? this.createProgressBar(phase.progress) : ''
    const duration = this.formatDuration(phase)

    let output = `\n${icon} ${phase.displayName} (${duration})\n`

    if (isCurrent) {
      output += `   ${progressBar}\n`
    }

    // Show phase items
    phase.items.forEach(item => {
      const itemIcon = this.getItemIcon(item.status)
      output += `   ${itemIcon} ${item.description}\n`
    })

    // Show status
    const statusText = this.getStatusText(phase)
    output += `   Status: ${statusText}\n`

    return output
  }

  private getPhaseIcon(status: PhaseStatus): string {
    const icons = {
      COMPLETED: '✅',
      IN_PROGRESS: '🔨',
      PENDING: '⏸️',
      FAILED: '❌',
      SKIPPED: '⏭️',
      WAITING: '⏳'
    }
    return icons[status] || '❓'
  }

  private getItemIcon(status: string): string {
    const icons = {
      COMPLETED: '✅',
      IN_PROGRESS: '⏳',
      PENDING: '⏸️',
      FAILED: '❌'
    }
    return icons[status] || '○'
  }

  private formatDuration(phase: PhaseProgress): string {
    if (phase.status === 'COMPLETED') {
      return `Completed in ${this.formatTime(phase.elapsedTime)}`
    }

    if (phase.status === 'IN_PROGRESS') {
      return `${this.formatTime(phase.elapsedTime)} elapsed, ~${this.formatTime(phase.estimatedDuration - phase.elapsedTime)} remaining`
    }

    return `~${this.formatTime(phase.estimatedDuration)}`
  }

  private formatTime(ms: number): string {
    const seconds = Math.floor(ms / 1000)
    const minutes = Math.floor(seconds / 60)
    const hours = Math.floor(minutes / 60)

    if (hours > 0) {
      return `${hours}h ${minutes % 60}m`
    }
    if (minutes > 0) {
      return `${minutes}m ${seconds % 60}s`
    }
    return `${seconds}s`
  }
}
```

### Task Visualizer

```typescript
class TaskVisualizer {
  renderTasks(tasks: TaskProgress[]): string {
    const grouped = this.groupTasksByStatus(tasks)

    let output = '\n📋 Tasks:\n'
    output += '─'.repeat(60) + '\n\n'

    // Show completed count (collapsed)
    if (grouped.completed.length > 0) {
      output += `✅ ${grouped.completed.length} tasks completed\n\n`
    }

    // Show in-progress task (expanded)
    grouped.inProgress.forEach(task => {
      output += this.renderTaskExpanded(task)
    })

    // Show pending tasks (first 3)
    const pendingToShow = grouped.pending.slice(0, 3)
    pendingToShow.forEach(task => {
      output += this.renderTaskCollapsed(task)
    })

    // Show remaining count
    if (grouped.pending.length > 3) {
      output += `   ... ${grouped.pending.length - 3} more tasks\n`
    }

    return output
  }

  private renderTaskExpanded(task: TaskProgress): string {
    const progressBar = this.createProgressBar(task.progress)

    let output = `⏳ ${task.number}. ${task.title}\n`
    output += `   ${progressBar}\n`

    // Show subtasks if available
    if (task.subtasks && task.subtasks.length > 0) {
      task.subtasks.forEach(subtask => {
        const icon = subtask.status === 'COMPLETED' ? '✅' : '○'
        output += `   └─ ${icon} ${subtask.description}\n`
      })
    }

    output += '\n'
    return output
  }

  private renderTaskCollapsed(task: TaskProgress): string {
    return `⏸️  ${task.number}. ${task.title}\n`
  }

  private groupTasksByStatus(tasks: TaskProgress[]) {
    return {
      completed: tasks.filter(t => t.status === 'COMPLETED'),
      inProgress: tasks.filter(t => t.status === 'IN_PROGRESS'),
      pending: tasks.filter(t => t.status === 'PENDING'),
      failed: tasks.filter(t => t.status === 'FAILED')
    }
  }

  private createProgressBar(progress: number, width: number = 20): string {
    const filled = Math.floor((progress / 100) * width)
    const empty = width - filled
    return `[${█'.repeat(filled)}${'░'.repeat(empty)}] ${progress}%`
  }
}
```

### Activity Log Visualizer

```typescript
class ActivityLogVisualizer {
  renderRecentActivities(activities: Activity[], limit: number = 5): string {
    const recent = activities.slice(-limit).reverse()

    let output = '\n📝 Recent Activity:\n'

    recent.forEach(activity => {
      const time = this.formatTimestamp(activity.timestamp)
      output += `   [${time}] ${activity.icon} ${activity.message}\n`
    })

    return output
  }

  private formatTimestamp(date: Date): string {
    return date.toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: false
    })
  }
}
```

---

## Real-Time Updates

### Progress Streaming

```typescript
class ProgressStreamer {
  private updateInterval: number = 1000 // 1 second
  private subscribers: Set<ProgressSubscriber> = new Set()

  async streamProgress(workflowId: string): Promise<void> {
    const interval = setInterval(async () => {
      const status = await this.fetchProgressStatus(workflowId)

      // Notify all subscribers
      this.notifySubscribers(status)

      // Update display
      this.updateDisplay(status)

    }, this.updateInterval)

    // Clean up when workflow completes
    await this.waitForCompletion(workflowId)
    clearInterval(interval)
  }

  subscribe(callback: (status: ProgressStatus) => void): () => void {
    const subscriber = { callback }
    this.subscribers.add(subscriber)

    // Return unsubscribe function
    return () => this.subscribers.delete(subscriber)
  }

  private notifySubscribers(status: ProgressStatus): void {
    this.subscribers.forEach(subscriber => {
      try {
        subscriber.callback(status)
      } catch (error) {
        console.error('Subscriber callback error:', error)
      }
    })
  }

  private updateDisplay(status: ProgressStatus): void {
    // Clear console and redraw
    console.clear()

    const visualizer = new ProgressVisualizer()
    const output = visualizer.render(status)

    console.log(output)
  }
}
```

### Incremental Updates

```typescript
class IncrementalUpdater {
  private lastStatus: ProgressStatus | null = null

  renderUpdate(newStatus: ProgressStatus): void {
    if (!this.lastStatus) {
      // First render - show everything
      this.renderFull(newStatus)
    } else {
      // Incremental render - show only changes
      this.renderDiff(this.lastStatus, newStatus)
    }

    this.lastStatus = newStatus
  }

  private renderDiff(old: ProgressStatus, updated: ProgressStatus): void {
    // Find what changed
    const changes = this.detectChanges(old, updated)

    // Update only changed elements
    changes.forEach(change => {
      this.updateElement(change)
    })
  }

  private detectChanges(
    old: ProgressStatus,
    updated: ProgressStatus
  ): Change[] {
    const changes: Change[] = []

    // Check overall progress
    if (old.workflow.progress !== updated.workflow.progress) {
      changes.push({
        type: 'PROGRESS',
        element: 'workflow',
        oldValue: old.workflow.progress,
        newValue: updated.workflow.progress
      })
    }

    // Check phase changes
    old.phases.forEach((oldPhase, i) => {
      const newPhase = updated.phases[i]
      if (oldPhase.status !== newPhase.status) {
        changes.push({
          type: 'PHASE_STATUS',
          element: `phase-${i}`,
          oldValue: oldPhase.status,
          newValue: newPhase.status
        })
      }
    })

    // Check task changes
    old.tasks.forEach((oldTask, i) => {
      const newTask = updated.tasks[i]
      if (oldTask.status !== newTask.status || oldTask.progress !== newTask.progress) {
        changes.push({
          type: 'TASK_UPDATE',
          element: `task-${i}`,
          oldValue: oldTask,
          newValue: newTask
        })
      }
    })

    return changes
  }
}
```

---

## Progress Milestones

### Milestone Definitions

```typescript
interface Milestone {
  id: string
  name: string
  description: string
  condition: (status: ProgressStatus) => boolean
  celebration: string
  importance: 'LOW' | 'MEDIUM' | 'HIGH'
}

const MILESTONES: Milestone[] = [
  {
    id: 'planning-complete',
    name: 'Planning Complete',
    description: 'Requirements analyzed and tasks defined',
    condition: (s) => s.phases[0]?.status === 'COMPLETED',
    celebration: '📋 Planning phase complete! Ready to build.',
    importance: 'MEDIUM'
  },
  {
    id: 'halfway-done',
    name: 'Halfway There',
    description: '50% of tasks completed',
    condition: (s) => s.workflow.progress >= 50,
    celebration: '🎉 Halfway done! Keep it up!',
    importance: 'MEDIUM'
  },
  {
    id: 'implementation-complete',
    name: 'Implementation Complete',
    description: 'All code written',
    condition: (s) => s.phases.find(p => p.name === 'IMPLEMENTATION')?.status === 'COMPLETED',
    celebration: '💻 All code written! Running final checks...',
    importance: 'HIGH'
  },
  {
    id: 'tests-passing',
    name: 'All Tests Passing',
    description: '100% test success rate',
    condition: (s) => {
      const { testsRun, testsPassed } = s.metrics
      return testsRun > 0 && testsRun === testsPassed
    },
    celebration: '✅ All tests passing! Quality looks great.',
    importance: 'HIGH'
  },
  {
    id: 'feature-complete',
    name: 'Feature Complete',
    description: 'Everything done and ready',
    condition: (s) => s.workflow.status === 'COMPLETED',
    celebration: '🚀 Feature complete! Ready for review.',
    importance: 'HIGH'
  }
]

class MilestoneTracker {
  private achievedMilestones: Set<string> = new Set()

  checkMilestones(status: ProgressStatus): Milestone[] {
    const newMilestones: Milestone[] = []

    for (const milestone of MILESTONES) {
      // Skip if already achieved
      if (this.achievedMilestones.has(milestone.id)) {
        continue
      }

      // Check if condition met
      if (milestone.condition(status)) {
        this.achievedMilestones.add(milestone.id)
        newMilestones.push(milestone)

        // Celebrate!
        this.celebrate(milestone)
      }
    }

    return newMilestones
  }

  private celebrate(milestone: Milestone): void {
    console.log('\n' + '═'.repeat(60))
    console.log('🎉 MILESTONE ACHIEVED!')
    console.log(milestone.celebration)
    console.log('═'.repeat(60) + '\n')
  }
}
```

---

## Error Display

### Error Visualization

```typescript
class ErrorVisualizer {
  renderError(error: WorkflowError, task?: TaskProgress): string {
    let output = '\n' + '❌'.repeat(30) + '\n\n'

    // Error header
    output += `❌ Error in: ${error.phase}\n`
    if (task) {
      output += `   Task: ${task.number}. ${task.title}\n`
    }
    output += '\n'

    // User-friendly error message
    output += `Problem: ${this.simplifyErrorMessage(error.message)}\n\n`

    // What we tried
    if (error.attemptedFixes.length > 0) {
      output += 'I tried:\n'
      error.attemptedFixes.forEach((fix, i) => {
        output += `   ${i + 1}. ${fix.description} ${fix.success ? '✅' : '❌'}\n`
      })
      output += '\n'
    }

    // Next steps
    if (error.severity === 'ESCALATE') {
      output += this.renderEscalation(error)
    } else if (error.severity === 'RECOVERABLE') {
      output += 'Retrying automatically...\n'
    }

    output += '\n' + '─'.repeat(60) + '\n'

    return output
  }

  private simplifyErrorMessage(technicalMessage: string): string {
    // Convert technical errors to user-friendly language
    const simplifications: Record<string, string> = {
      'Type \'undefined\' is not assignable': 'Missing type information',
      'Cannot read property': 'Trying to access data that doesn\'t exist',
      'fetch failed': 'Network connection issue',
      'ENOENT': 'File not found',
      'EACCES': 'Permission denied'
    }

    for (const [pattern, simple] of Object.entries(simplifications)) {
      if (technicalMessage.includes(pattern)) {
        return simple
      }
    }

    return technicalMessage
  }

  private renderEscalation(error: WorkflowError): string {
    let output = '❓ I need your help:\n\n'
    output += 'Please provide guidance on:\n'
    // ... escalation questions
    return output
  }
}
```

---

## Performance Considerations

### Update Throttling

```typescript
class ThrottledUpdater {
  private lastUpdate: number = 0
  private minInterval: number = 500 // ms

  shouldUpdate(): boolean {
    const now = Date.now()
    if (now - this.lastUpdate >= this.minInterval) {
      this.lastUpdate = now
      return true
    }
    return false
  }
}
```

### Efficient Rendering

```typescript
class EfficientRenderer {
  // Only re-render changed sections
  private previousRender: Map<string, string> = new Map()

  renderSection(key: string, content: string): void {
    const previous = this.previousRender.get(key)

    // Skip if unchanged
    if (previous === content) {
      return
    }

    // Update only this section
    this.updateSection(key, content)
    this.previousRender.set(key, content)
  }
}
```

---

## Summary

The Progress System provides:

1. **Clear Visibility**: Users see exactly what's happening
2. **Accurate Estimates**: Time predictions based on actual velocity
3. **Progressive Detail**: High-level overview with drill-down capability
4. **Real-Time Updates**: Live progress with minimal latency
5. **User-Friendly**: No technical jargon, business-focused
6. **Celebratory**: Milestones make progress feel rewarding
7. **Error Clarity**: Problems explained in simple terms

**Result**: Users feel in control and informed throughout the autonomous workflow.

---

**Next**: See IMPLEMENTATION.md for step-by-step build plan.
