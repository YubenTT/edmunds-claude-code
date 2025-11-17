# Yuben Player - Requirements Analysis
**Version:** 0.1 (Draft - Pending Stakeholder Input)
**Date:** 2025-11-16
**Status:** Initial Analysis - Requires Clarification

---

## Executive Summary

Yuben Player is a proposed iOS music player application that integrates Google Drive as a cloud storage backend for high-quality audio playback. The app targets users who store music libraries in Google Drive and need seamless, offline-capable playback with iOS system integration (background audio, lock screen controls).

**Key Differentiator:** Direct Google Drive integration with offline caching, eliminating need for local iTunes/Files sync while maintaining native iOS audio experience.

---

## 1. User Personas (DRAFT - Needs Validation)

### Primary Persona: "Cloud Music Enthusiast"
**Name:** Alex
**Age:** 25-35
**Technical Level:** Intermediate
**Context:**
- Stores personal music collection (WAV/lossless files) in Google Drive
- Uses multiple devices; wants centralized music library
- Values audio quality (hence WAV format requirement)
- Limited iPhone storage; can't sync entire library locally

**Goals:**
- Access entire music library from iPhone without storage constraints
- High-quality playback experience matching native Music app
- Offline access for commute/travel without streaming data
- Seamless integration with iOS (lock screen, AirPods, CarPlay)

**Pain Points:**
- Existing solutions (VLC, Files app) lack proper iOS audio integration
- Cloud music services (Spotify, Apple Music) don't support personal WAV libraries
- Manual file sync is tedious and storage-intensive

### Secondary Persona: "Minimalist Listener" (TBD)
**Context:** Casual user with smaller music collection, values simplicity
**Validation Needed:** Is this a target user or out of scope?

---

## 2. Core User Flows

### Flow 1: First-Time Setup
```
1. Download app from App Store
2. Tap "Connect Google Drive"
3. Authenticate via Google OAuth
4. [NEEDS CLARIFICATION] Select music folder OR app auto-discovers music files?
5. App displays available music
6. [Optional] Download tracks/playlists for offline
7. Begin playback
```

**Open Questions:**
- Single folder selection or full Drive access?
- Auto-discovery of music files or manual folder designation?
- Initial sync behavior (index only vs. auto-download)?

### Flow 2: Stream & Play Music (Online)
```
1. Browse music library (by folder/file?)
2. Tap track to play
3. Audio buffers and plays with "zero latency" experience
4. Lock screen shows controls + metadata
5. Background playback continues when switching apps
```

**Critical Path:** Streaming WAV → Buffer strategy → Zero latency perception

### Flow 3: Offline Download & Playback
```
1. Select track/playlist
2. Tap "Download for Offline"
3. Files download in background with progress indicator
4. Downloaded indicator shows on track
5. Offline playback works identically to streaming
```

**Open Questions:**
- Storage management UI?
- Download prioritization/queue?
- Auto-deletion of cached files?

### Flow 4: Playlist Management
```
1. Create new playlist (name it)
2. Add tracks from library
3. Reorder tracks
4. [NEEDS CLARIFICATION] Save playlist where? (Local only? Google Drive folder?)
5. Play playlist with queue management
```

**Open Questions:**
- Playlist persistence strategy (local DB vs. Google Drive)?
- Smart playlists or manual only?
- Playlist sharing/export?

### Flow 5: Lock Screen Interaction
```
1. Music playing in background
2. Lock iPhone
3. Lock screen displays: Album art, track title, artist, playback controls
4. Control playback via lock screen or Control Center
5. [Expected] AirPods/headphone controls work
```

**Technical Dependency:** iOS MediaPlayer framework + AVAudioSession

---

## 3. Functional Requirements Breakdown

### 3.1 Audio Playback (CORE)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-1.1 | Play WAV audio files | P0 (MVP) | Minimum viable format |
| FR-1.2 | Background audio playback | P0 (MVP) | iOS background modes |
| FR-1.3 | Lock screen controls | P0 (MVP) | Now Playing info + controls |
| FR-1.4 | Zero latency playback | P0 (MVP) | **Define:** < 500ms? Instant? Gapless? |
| FR-1.5 | 120Hz smooth UI on iPhone 11+ | P1 (MVP) | ProMotion on 13 Pro+, 60Hz on 11/12 |
| FR-1.6 | Gapless playback between tracks | P2 (Phase 2) | Assumed requirement for music app |
| FR-1.7 | Play other formats (FLAC, MP3, AAC) | TBD | Scope clarification needed |
| FR-1.8 | Playback speed control | P3 (Future) | Nice-to-have |
| FR-1.9 | Equalizer | P3 (Future) | Nice-to-have |

**Assumptions Requiring Validation:**
- "Zero latency" = perceived instant playback (< 300ms from tap to audio)
- WAV support implies uncompressed PCM audio (various bit depths/sample rates)

### 3.2 Google Drive Integration (CORE)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-2.1 | Google OAuth authentication | P0 (MVP) | Standard OAuth 2.0 flow |
| FR-2.2 | Browse user's Google Drive folders | P0 (MVP) | **Scope TBD:** Full Drive or designated folder? |
| FR-2.3 | Stream audio files from Google Drive | P0 (MVP) | Partial download/streaming |
| FR-2.4 | Refresh library (manual sync) | P0 (MVP) | Pull latest changes from Drive |
| FR-2.5 | Auto-sync on app launch | P1 (MVP) | Background refresh |
| FR-2.6 | Handle file changes/deletions | P1 (Phase 2) | Graceful handling of missing files |
| FR-2.7 | Support shared folders | P2 (Phase 2) | Access music shared by others |
| FR-2.8 | Search across Drive files | P2 (Phase 2) | Metadata/filename search |
| FR-2.9 | Multiple account support | P3 (Future) | Switch between Google accounts |

**Critical Questions:**
- Folder structure interpretation (folders = albums/playlists)?
- File metadata source (embedded tags vs. filename parsing)?

### 3.3 Offline Mode (CORE)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-3.1 | Download tracks for offline playback | P0 (MVP) | Core offline capability |
| FR-3.2 | Offline indicator on tracks | P0 (MVP) | UI clarity |
| FR-3.3 | Download playlists | P1 (MVP) | Batch download |
| FR-3.4 | Storage usage display | P1 (MVP) | Show used space |
| FR-3.5 | Manual cache management (delete downloads) | P1 (MVP) | User control |
| FR-3.6 | Storage limit setting | P2 (Phase 2) | Auto-manage cache size |
| FR-3.7 | Auto-download on Wi-Fi | P2 (Phase 2) | Smart caching |
| FR-3.8 | Download queue with priority | P2 (Phase 2) | UX enhancement |
| FR-3.9 | Pre-cache next track in playlist | P1 (MVP) | Supports zero-latency goal |

### 3.4 Playlist Management
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-4.1 | Create playlists | P0 (MVP) | Basic functionality |
| FR-4.2 | Add/remove tracks from playlists | P0 (MVP) | Basic functionality |
| FR-4.3 | Reorder tracks in playlist | P1 (MVP) | UX expectation |
| FR-4.4 | Delete playlists | P0 (MVP) | Basic functionality |
| FR-4.5 | Persist playlists locally | P0 (MVP) | SQLite or Core Data |
| FR-4.6 | Sync playlists to Google Drive | P2 (Phase 2) | Cross-device support |
| FR-4.7 | Import M3U/playlists from Drive | P2 (Phase 2) | Interoperability |
| FR-4.8 | Smart playlists (auto-generated) | P3 (Future) | Advanced feature |
| FR-4.9 | Playlist folders/organization | P3 (Future) | Power user feature |

### 3.5 Library Organization & Metadata
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-5.1 | Display track title, artist, album | P0 (MVP) | **Source TBD:** Tags vs. filename |
| FR-5.2 | Display album artwork | P1 (MVP) | Embedded or folder.jpg? |
| FR-5.3 | Browse by folder structure | P0 (MVP) | Mirror Google Drive hierarchy |
| FR-5.4 | Browse by artist/album (metadata) | P2 (Phase 2) | Requires tag parsing |
| FR-5.5 | Search library | P1 (MVP) | Basic text search |
| FR-5.6 | Sort tracks (name, date, duration) | P2 (Phase 2) | UX enhancement |
| FR-5.7 | Recently played history | P2 (Phase 2) | Usage tracking |
| FR-5.8 | Favorites/liked tracks | P2 (Phase 2) | User curation |

**Critical Decision:** Metadata strategy significantly impacts architecture
- Option A: Filename-based only (simple, fast)
- Option B: Parse ID3/embedded tags (richer, complex, requires downloading headers)

### 3.6 System Integration (iOS)
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-6.1 | Lock screen Now Playing | P0 (MVP) | MPNowPlayingInfoCenter |
| FR-6.2 | Control Center integration | P0 (MVP) | Standard iOS integration |
| FR-6.3 | Headphone/AirPods button controls | P0 (MVP) | AVAudioSession remote commands |
| FR-6.4 | CarPlay support | P2 (Phase 2) | Driving use case |
| FR-6.5 | Siri integration | P3 (Future) | "Play [song] in Yuben Player" |
| FR-6.6 | Widgets | P3 (Future) | Home screen presence |
| FR-6.7 | Shortcuts app integration | P3 (Future) | Automation |

---

## 4. Non-Functional Requirements

### 4.1 Performance
| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-1.1 | Playback start latency | < 300ms (online), < 100ms (offline) | P0 |
| NFR-1.2 | UI frame rate | 120fps on iPhone 13 Pro+, 60fps on 11/12 | P1 |
| NFR-1.3 | Smooth scrolling in large libraries | 60fps minimum for 1000+ tracks | P1 |
| NFR-1.4 | App launch time | < 2s to main screen | P1 |
| NFR-1.5 | Background download speed | Max available bandwidth, pausable | P1 |
| NFR-1.6 | Battery efficiency | < 5% drain per hour of playback | P2 |
| NFR-1.7 | Memory footprint | < 150MB baseline, < 300MB during playback | P2 |

**Critical for "120Hz Performance":**
- Main thread must never block on I/O operations
- All network requests on background threads
- Efficient list rendering (lazy loading, cell reuse)
- Pre-loading and caching strategies

### 4.2 Reliability & Stability
| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-2.1 | Crash-free rate | > 99.5% | P0 |
| NFR-2.2 | Handle network interruptions gracefully | Auto-retry, clear error states | P0 |
| NFR-2.3 | Handle Google Drive API errors | Graceful degradation, user feedback | P0 |
| NFR-2.4 | Playback continuity during interruptions | Resume after call/notification | P0 |
| NFR-2.5 | Data consistency (playlists, cache) | No data loss on app termination | P0 |

### 4.3 Security & Privacy
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| NFR-3.1 | Secure OAuth token storage | P0 | iOS Keychain |
| NFR-3.2 | No data collection beyond app functionality | P0 | Privacy-focused |
| NFR-3.3 | HTTPS for all Google Drive communication | P0 | TLS 1.3+ |
| NFR-3.4 | Local storage encryption | P2 | FileProtection API |
| NFR-3.5 | Privacy policy compliance (App Store) | P0 | Required for release |
| NFR-3.6 | No third-party analytics/tracking | TBD | Business decision |

### 4.4 Usability & Accessibility
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| NFR-4.1 | Intuitive UI for beginner users | P0 | Clear navigation, minimal learning curve |
| NFR-4.2 | Support Dynamic Type (text scaling) | P1 | iOS accessibility |
| NFR-4.3 | VoiceOver compatibility | P2 | Screen reader support |
| NFR-4.4 | Dark mode support | P1 | iOS standard |
| NFR-4.5 | Localization (multi-language) | P3 | Start with English only |
| NFR-4.6 | Onboarding tutorial for first launch | P2 | Reduce support burden |

**"Beginner-Friendly Development":**
- Interpretation needed: Is the *developer* a beginner, or should the *app UX* be beginner-friendly?
- If developer is beginner: Impacts technology choices (SwiftUI vs. UIKit, third-party frameworks)

### 4.5 Compatibility
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| NFR-5.1 | iOS 15+ support | P0 | Balances features vs. device coverage |
| NFR-5.2 | iPhone 11 and newer optimization | P0 | As specified |
| NFR-5.3 | iPad support | TBD | Out of scope or future? |
| NFR-5.4 | Landscape orientation support | P2 | Edge case but expected |

---

## 5. Feature Prioritization

### MVP (Phase 1) - "Core Experience"
**Goal:** Functional music player with Google Drive integration for early adopters
**Timeline Estimate:** TBD (Depends on development resources)

**Must-Have:**
1. Google Drive authentication & folder browsing
2. Stream WAV files from Drive with < 500ms perceived latency
3. Basic playback controls (play, pause, next, previous, seek)
4. Background playback + lock screen controls
5. Download tracks for offline playback
6. Basic playlist creation (name, add/remove tracks, play)
7. Simple library view (folder-based or flat list)
8. Storage management (see usage, manually delete cached files)
9. 60fps UI performance minimum (120Hz optimization if achievable)

**Out of MVP:**
- Advanced metadata parsing (use filenames for MVP)
- Album artwork
- Search functionality
- Auto-sync
- CarPlay

**MVP Success Criteria:**
- User can authenticate with Google Drive
- User can play a WAV file from Drive within 5 seconds of opening app
- Playback continues in background and responds to lock screen controls
- User can download a file and play it offline on airplane mode
- App doesn't crash during 1-hour playback session

### Phase 2 - "Polish & Enhancements"
**Goal:** Feature parity with established music players

**Features:**
1. Metadata parsing (ID3 tags, artist/album organization)
2. Album artwork display
3. Search across library
4. Auto-sync on app launch
5. Smart caching (pre-load next track)
6. Gapless playback
7. 120Hz UI optimization across all screens
8. Dark mode
9. Improved playlist management (reorder, bulk operations)
10. Storage limit settings with auto-management

### Phase 3 - "Advanced Features"
**Goal:** Differentiation and power user features

**Features:**
1. CarPlay support
2. Playlist sync to Google Drive (cross-device)
3. Smart playlists
4. Equalizer
5. Lyrics display
6. Shared folder support
7. Multiple Google account support
8. Widgets and Siri integration

---

## 6. Technical Constraints & Considerations

### 6.1 Platform Constraints
| Constraint | Impact | Mitigation |
|------------|--------|------------|
| iOS background execution limits | 30s background time unless audio playing | Use background audio mode (required anyway) |
| App Store review requirements | Functionality must be clear, OAuth properly implemented | Follow Apple guidelines, prepare demo |
| Google Drive API rate limits | Quota on requests (10k/day free tier) | Implement caching, efficient queries, pagination |
| WAV file sizes (uncompressed) | Slow streaming, high bandwidth usage | Smart buffering, encourage offline downloads |
| iPhone storage limitations | Users may have limited space | Clear storage management UI, configurable limits |

### 6.2 Google Drive API Considerations
- **API Version:** Google Drive API v3 (current)
- **Key Operations:**
  - Files.list (browse folders)
  - Files.get (download/stream files)
  - Changes.watch (detect file changes) - for auto-sync
- **Partial Download:** Support Range requests for streaming large files
- **Quota Management:** Free tier = 1 billion queries/day (ample for single-user app)
- **Authentication:** OAuth 2.0 with offline access (refresh tokens)

### 6.3 Audio Playback Architecture
**Recommended Stack:**
- **AVFoundation** (iOS native audio framework)
  - AVPlayer or AVAudioPlayer for playback
  - AVAudioSession for background mode and system integration
  - MPNowPlayingInfoCenter for lock screen
  - MPRemoteCommandCenter for controls

**Zero Latency Strategy:**
1. **Streaming:** Use HTTP range requests to download first 1-5MB immediately
2. **Caching:** Implement aggressive pre-caching of next track in playlist
3. **Offline:** Direct file playback from local cache (sub-100ms)
4. **Buffer Management:** Maintain 30-60 second buffer during streaming

**WAV Format Notes:**
- Uncompressed: 10MB/minute (44.1kHz, 16-bit stereo)
- Streaming challenge: Large files, no seeking without downloading headers
- Solution: Progressive download with buffering

### 6.4 UI Framework Decision (Beginner-Friendly Context)
**Option A: SwiftUI**
- ✅ Modern, declarative, easier for beginners
- ✅ Built-in 120Hz support
- ❌ Less control over complex animations
- ❌ Some bugs in earlier iOS versions
- **Recommendation:** If targeting iOS 15+, good choice for beginner developer

**Option B: UIKit**
- ✅ Mature, extensive documentation and Stack Overflow support
- ✅ Fine-grained control for performance optimization
- ❌ Steeper learning curve
- ❌ More boilerplate code
- **Recommendation:** Better for advanced performance tuning

**Hybrid Approach:** SwiftUI with UIKit for performance-critical components

### 6.5 Data Persistence
**Local Storage Needs:**
- Playlist definitions
- Downloaded audio files
- Cached metadata
- OAuth tokens (Keychain)
- User preferences

**Recommended Stack:**
- **Core Data** or **SwiftData:** For playlists, metadata, app state
- **File System (Documents directory):** For downloaded audio files
- **UserDefaults:** For simple preferences
- **Keychain:** For OAuth tokens

### 6.6 Networking
**Requirements:**
- Google Drive API integration
- OAuth authentication
- Large file downloads (streaming + offline)
- Background downloads

**Recommended Stack:**
- **URLSession:** Native iOS networking (supports background downloads)
- **Google Sign-In SDK:** Simplifies OAuth flow
- **Google API Client Library:** Optional (can use REST API directly)

---

## 7. Risk Analysis

### High-Risk Items

#### 7.1 **"Zero Latency" Expectation** 🔴 HIGH RISK
**Risk:** Physically impossible to stream large WAV files with true zero latency
- **Impact:** User dissatisfaction if expectation not met
- **Likelihood:** HIGH (WAV files are 10MB/min, network latency exists)
- **Mitigation:**
  1. Define "zero latency" precisely (< 300ms? < 1s?)
  2. Implement aggressive pre-caching (download next track in background)
  3. Set user expectation: "Instant for downloaded, fast for streaming"
  4. Always cache first 5MB of streamed track before playback
  5. UI feedback (buffer indicator) for streaming

**Recommendation:** Redefine as "Perceived instant playback" with specific targets:
- Offline: < 100ms
- Streaming (good connection): < 500ms
- Streaming (poor connection): < 2s with loading indicator

#### 7.2 **120Hz Performance with Large Libraries** 🟡 MEDIUM-HIGH RISK
**Risk:** Scrolling through 1000+ track library may not maintain 120fps
- **Impact:** App feels sluggish, doesn't meet specification
- **Likelihood:** MEDIUM (depends on implementation quality)
- **Mitigation:**
  1. Use lazy loading (virtualized lists)
  2. Minimize cell complexity (avoid heavy image processing per cell)
  3. Background thread for metadata loading
  4. Profile with Instruments on target devices
  5. May need to compromise on 120Hz for older devices (iPhone 11 is 60Hz anyway)

**Note:** iPhone 11 and 12 are 60Hz; iPhone 13 Pro+ are 120Hz (ProMotion)
- Specification may have error: "120Hz on iPhone 11+" impossible (11 doesn't support it)

#### 7.3 **Google Drive API Reliability** 🟡 MEDIUM RISK
**Risk:** API downtime, rate limiting, authentication issues
- **Impact:** App unusable when Drive is down
- **Likelihood:** LOW-MEDIUM (Google is reliable, but outages happen)
- **Mitigation:**
  1. Graceful offline mode (cached library remains usable)
  2. Clear error messages with retry options
  3. Implement exponential backoff for retries
  4. Cache library index locally
  5. User education: "Offline downloads recommended for reliable access"

#### 7.4 **Beginner Developer Complexity** 🔴 HIGH RISK (if developer is beginner)
**Risk:** Project is complex for a beginner (OAuth, background audio, cloud sync, performance optimization)
- **Impact:** Extended timeline, potential abandonment, buggy release
- **Likelihood:** HIGH if solo beginner developer
- **Mitigation:**
  1. Use high-level frameworks (SwiftUI, Combine, Google Sign-In SDK)
  2. Phased approach (MVP with minimal features first)
  3. Leverage open-source libraries where appropriate
  4. Consider third-party services (Firebase for auth instead of raw OAuth?)
  5. Extensive testing on real devices
  6. Code reviews or mentorship

**Recommendation:** Clarify if "beginner-friendly" means:
- A) Beginner developer building it → Simplify architecture, extend timeline
- B) Beginner user experience → Focus on UX simplicity, doesn't constrain tech choices

### Medium-Risk Items

#### 7.5 **App Store Approval** 🟡 MEDIUM RISK
**Risk:** Rejection for vague functionality, privacy issues, or Google Drive access concerns
- **Mitigation:** Clear app description, privacy policy, demonstrate legitimate use case

#### 7.6 **Battery Drain** 🟡 MEDIUM RISK
**Risk:** Streaming high-bitrate audio + constant network access drains battery quickly
- **Mitigation:** Optimize buffering, encourage offline downloads, implement battery-saving mode

#### 7.7 **Storage Management UX** 🟡 MEDIUM RISK
**Risk:** Users fill up iPhone storage with downloads, blame app
- **Mitigation:** Clear UI showing storage usage, warnings before device full, auto-cleanup options

### Low-Risk Items
- OAuth implementation (well-documented, SDKs available)
- Basic audio playback (AVFoundation is mature)
- Lock screen integration (standard iOS APIs)

---

## 8. Success Metrics (Draft)

### 8.1 MVP Launch Success Criteria
**Functionality Metrics:**
- ✅ 100% of users can authenticate with Google Drive
- ✅ 95%+ playback success rate (tracks play without errors)
- ✅ < 500ms average playback start time (offline)
- ✅ < 1.5s average playback start time (streaming, good network)
- ✅ 0 critical crashes in 100 hours of testing
- ✅ Background playback works for 95%+ of sessions

**User Experience Metrics:**
- NPS (Net Promoter Score) > 30 among beta testers
- 80%+ of users successfully download a track for offline
- 70%+ of users create at least one playlist

### 8.2 Phase 2 Success Criteria
- 60fps sustained across all screens (120Hz on supported devices)
- < 3% crash rate in production
- 50%+ of users enable auto-sync

### 8.3 Long-Term KPIs (6-12 months post-launch)
- Daily Active Users (DAU) growth
- Retention rate (D7, D30)
- Average session duration (target: 30+ minutes)
- Offline usage percentage (indicates value of offline feature)

---

## 9. Open Questions & Decisions Needed

### Critical (Blocks Development Start)
1. **Google Drive Scope:** Full Drive navigation or single designated folder?
2. **Metadata Strategy:** Filename-based or tag parsing? (Major architecture impact)
3. **Zero Latency Definition:** Specific latency targets for streaming vs. offline?
4. **Beginner-Friendly Context:** Developer skill level or UX requirement?
5. **Audio Format Scope:** WAV only or multi-format (FLAC, MP3, AAC)?
6. **Timeline & Resources:** When is target launch? Solo developer or team?

### Important (Needed for MVP Scope)
7. **Playlist Persistence:** Local only or sync to Google Drive?
8. **Album Artwork:** Required for MVP or Phase 2?
9. **Search Functionality:** MVP or Phase 2?
10. **iPad Support:** In scope or iOS-only?
11. **Monetization Model:** Free, paid, freemium? (Affects feature gating)

### Nice-to-Know (For Future Planning)
12. **CarPlay Priority:** How important for target users?
13. **Multi-Account Support:** Single Google account sufficient?
14. **Competitive Positioning:** Key apps to compare against?
15. **Unique Selling Proposition:** What makes this better than CloudBeats, VLC, etc.?

---

## 10. Next Steps

### Immediate Actions:
1. **Stakeholder Interview:** Answer critical questions above (1-6)
2. **Competitive Analysis:** Audit existing apps (CloudBeats, VLC, Evermusic) for feature comparison
3. **Technical Spike:** Prototype Google Drive streaming + AVFoundation integration (validate "zero latency" feasibility)
4. **Define MVP Scope:** Lock down Phase 1 features based on timeline/resources

### Before Development:
5. **Create Detailed PRD:** Expand this analysis into comprehensive PRD with finalized requirements
6. **Technical Architecture Document:** System design, API contracts, data models
7. **UI/UX Mockups:** Wireframes for key screens (library, player, settings)
8. **Development Environment Setup:** Xcode, Google Cloud Console project, test devices

---

## Appendix A: Assumptions Log

| ID | Assumption | Validation Status |
|----|------------|-------------------|
| A1 | Users have existing music libraries in Google Drive | ❓ Unvalidated |
| A2 | WAV format is primary; other formats are secondary | ❓ Unvalidated |
| A3 | Offline mode is critical (not just nice-to-have) | ✅ Explicit requirement |
| A4 | Background playback is expected to work like Apple Music | ✅ Standard for music apps |
| A5 | iPhone-only (no iPad) for MVP | ❓ Unvalidated |
| A6 | No need for cloud sync of playlists in MVP | ❓ Unvalidated |
| A7 | Developer has iOS development experience | ❓ Unvalidated (conflicts with "beginner-friendly") |
| A8 | No monetization/business model defined yet | ❓ Unvalidated |
| A9 | App should feel like native iOS Music app | ❓ Unvalidated |
| A10 | 120Hz spec is aspirational for iPhone 13 Pro+, not required on all devices | ❓ Needs clarification |

---

## Document Control
- **Author:** Requirements Analyst
- **Version:** 0.1 (Initial Draft)
- **Next Review:** Pending stakeholder feedback
- **Status:** DRAFT - Critical questions must be answered before finalizing
