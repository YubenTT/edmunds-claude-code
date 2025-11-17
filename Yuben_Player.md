# Yuben Player - Product Requirements Document (PRD)

**Version:** 1.0 (Production Ready)
**Date:** 2025-11-17
**Status:** Final - Ready for Development
**Platform:** iOS (Native Swift/SwiftUI)
**Target Devices:** iPhone 11+ (iOS 15+)

---

## 🎯 Executive Summary

**Yuben Player** is a native iOS music player application that seamlessly integrates Google Drive as a cloud music library. It enables users to stream and download high-quality WAV audio files with near-instant playback, full iOS system integration (lock screen controls, background playback), and smooth 120Hz performance on supported devices.

### Key Differentiators
- ✅ **Direct Google Drive Integration** - No manual file management
- ✅ **Near-Zero Latency Playback** - 1.5-6ms for offline, <500ms for streaming
- ✅ **Full iOS Integration** - Lock screen, CarPlay, AirPods controls
- ✅ **Smart Offline Mode** - Progressive downloads with intelligent caching
- ✅ **Buttery Smooth UI** - 120Hz on iPhone 13 Pro+, 60fps minimum on all devices

---

## 📋 Table of Contents

1. [Product Vision](#product-vision)
2. [User Personas](#user-personas)
3. [Core Features](#core-features)
4. [Technical Architecture](#technical-architecture)
5. [Technology Stack](#technology-stack)
6. [Implementation Roadmap](#implementation-roadmap)
7. [Zero-Coder Development Guide](#zero-coder-development-guide)
8. [Performance Requirements](#performance-requirements)
9. [Security & Privacy](#security--privacy)
10. [Testing Strategy](#testing-strategy)
11. [Deployment Guide](#deployment-guide)

---

## 🎨 Product Vision

### Problem Statement
Music enthusiasts who store large, high-quality audio libraries (WAV/lossless) in Google Drive face these challenges:
- **Storage Constraints:** Can't sync entire library to iPhone due to limited storage
- **Poor Integration:** Existing solutions (VLC, Files app) lack proper iOS audio integration
- **Streaming Issues:** Generic cloud apps have high latency and poor offline support
- **No Native Experience:** Missing lock screen controls, background playback, and system integration

### Solution
A **native iOS music player** that treats Google Drive as a first-class cloud music library, providing:
- Instant access to your entire music collection
- Smart offline caching for zero-latency playback
- Full iOS system integration (identical to Apple Music experience)
- Intelligent storage management

### Success Criteria
- ✅ 95%+ playback success rate
- ✅ <500ms playback start time (streaming), <100ms (offline)
- ✅ 100% background audio reliability
- ✅ 60fps minimum UI performance (120Hz on supported devices)
- ✅ Zero critical crashes in production

---

## 👥 User Personas

### Primary Persona: "The Audiophile Minimalist"
**Name:** Alex, 28
**Occupation:** Software Engineer
**Technical Level:** Advanced

**Characteristics:**
- Stores 50GB+ of lossless music (WAV/FLAC) in Google Drive
- iPhone 13 Pro with 128GB storage (can't fit entire library)
- Values audio quality and smooth user experience
- Uses AirPods Pro, expects seamless integration
- Commutes daily, needs reliable offline playback

**Goals:**
- Access entire music library without storage constraints
- Zero-compromise audio quality
- Native iOS experience (lock screen, background audio)
- Offline access for subway commute

**Pain Points:**
- VLC feels clunky, missing iOS integration
- Google Drive app has poor audio controls
- Manual file syncing is tedious
- Streaming has annoying delays

### Secondary Persona: "The Mobile Music Collector"
**Name:** Sarah, 35
**Occupation:** Designer
**Technical Level:** Intermediate

**Characteristics:**
- Manages music collection in Google Drive (organized in folders)
- iPhone 11 with limited storage
- Creates curated playlists for different moods
- Wants simple, intuitive interface

**Goals:**
- Easy playlist management
- Smooth browsing of large music library
- Download favorite playlists for offline
- No technical complexity

---

## ⚡ Core Features

### Phase 1: MVP (Months 1-3)

#### 1. Google Drive Integration
**Priority:** P0 (Critical)

**User Stories:**
- As a user, I can sign in with my Google account using OAuth
- As a user, I can browse my Google Drive folders to find music
- As a user, I can select a "Music Folder" as my library root
- As a user, I see all WAV files from my selected folder in the app

**Technical Requirements:**
- Google Sign-In SDK for OAuth 2.0
- Google Drive API v3 integration
- Folder browsing with pagination support
- File filtering (WAV, MP3 formats)
- Token refresh management

**Acceptance Criteria:**
- ✅ OAuth login completes in <3 seconds
- ✅ Folder browsing supports 1000+ files without lag
- ✅ Handles network errors gracefully with retry
- ✅ Tokens auto-refresh before expiration

#### 2. Audio Playback Engine
**Priority:** P0 (Critical)

**User Stories:**
- As a user, I can tap a track and hear it play within 500ms
- As a user, I can control playback (play, pause, skip, seek)
- As a user, playback continues when I lock my phone
- As a user, I see playback controls on my lock screen

**Technical Requirements:**
- AVAudioEngine for low-latency playback (1.5-6ms)
- Background audio mode enabled in capabilities
- MPNowPlayingInfoCenter for lock screen metadata
- MPRemoteCommandCenter for remote controls
- Progressive download for streaming (start playing at 5MB buffered)
- Pre-caching next track in playlist

**Implementation Details:**

```swift
// Audio Session Configuration
let audioSession = AVAudioSession.sharedInstance()
try audioSession.setCategory(.playback, mode: .default)
try audioSession.setActive(true)
try audioSession.setPreferredIOBufferDuration(0.005) // 5ms for zero latency

// AVAudioEngine Setup
let audioEngine = AVAudioEngine()
let playerNode = AVAudioPlayerNode()
audioEngine.attach(playerNode)
audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)
try audioEngine.start()

// Lock Screen Integration
func updateNowPlaying(track: Track) {
    var nowPlayingInfo = [String: Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
    nowPlayingInfo[MPMediaItemPropertyArtist] = track.artist
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.duration
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
}
```

**Acceptance Criteria:**
- ✅ Offline playback starts in <100ms
- ✅ Streaming playback starts in <500ms (good network)
- ✅ Background audio continues for 8+ hours
- ✅ Lock screen shows track info and controls
- ✅ AirPods controls work (play/pause/skip)

#### 3. Offline Downloads & Caching
**Priority:** P0 (Critical)

**User Stories:**
- As a user, I can download tracks for offline playback
- As a user, I see download progress for large files
- As a user, I see which tracks are available offline
- As a user, I can manage storage (delete cached files)

**Technical Requirements:**
- Progressive download with URLSession
- Background download support
- LRU cache eviction strategy
- Storage usage tracking
- Download queue management

**Architecture:**

```
┌─────────────────────────────────────┐
│       CacheManager                  │
├─────────────────────────────────────┤
│  Temporary Cache (cachesDirectory) │
│  - Recently played tracks           │
│  - Auto-eviction (LRU)              │
│  - 500MB limit                      │
├─────────────────────────────────────┤
│  Downloads (documentsDirectory)     │
│  - User-requested offline tracks    │
│  - Manual deletion only             │
│  - User-configurable limit          │
└─────────────────────────────────────┘
```

**Implementation Example:**

```swift
class CacheManager {
    let maxCacheSize: Int64 = 500_000_000 // 500MB

    func downloadFile(file: DriveFile, progress: @escaping (Double) -> Void) async throws -> URL {
        let fetcher = driveService.fetcherService.fetcher(withURLString: downloadURL)
        fetcher.destinationFileURL = destinationURL // Write directly to disk

        fetcher.downloadProgressBlock = { bytesWritten, totalWritten, totalExpected in
            let progress = Double(totalWritten) / Double(totalExpected)
            DispatchQueue.main.async { progress(progress) }
        }

        try await fetcher.beginFetch()
        return destinationURL
    }

    func evictOldCachedFilesIfNeeded() throws {
        // LRU eviction logic
    }
}
```

**Acceptance Criteria:**
- ✅ Download 100MB file in <2 minutes (good Wi-Fi)
- ✅ Progress updates every 100ms
- ✅ Downloads survive app restart
- ✅ Cache eviction keeps size under limit
- ✅ Storage UI shows accurate usage

#### 4. Playlist Management
**Priority:** P0 (Critical)

**User Stories:**
- As a user, I can create new playlists with custom names
- As a user, I can add/remove tracks from playlists
- As a user, I can reorder tracks in a playlist
- As a user, I can play a playlist with queue management

**Technical Requirements:**
- Core Data for playlist persistence
- Drag-and-drop reordering
- Queue management (next/previous)
- Auto-advance to next track

**Data Model:**

```swift
@Entity
class Playlist {
    @Attribute var id: UUID
    @Attribute var name: String
    @Attribute var createdDate: Date
    @Relationship var tracks: [PlaylistTrack] // Ordered
}

@Entity
class PlaylistTrack {
    @Attribute var id: UUID
    @Attribute var driveFileID: String
    @Attribute var order: Int
    @Relationship var playlist: Playlist
}

@Entity
class Track {
    @Attribute var driveFileID: String
    @Attribute var name: String
    @Attribute var duration: Double
    @Attribute var isDownloaded: Bool
    @Attribute var localFileURL: String?
    @Attribute var lastPlayed: Date?
}
```

**Acceptance Criteria:**
- ✅ Create playlist in <1 second
- ✅ Reorder 100+ tracks without lag
- ✅ Playlist persists after app restart
- ✅ Auto-advance works 100% of time

#### 5. Library Browser
**Priority:** P0 (Critical)

**User Stories:**
- As a user, I can browse my music by folders
- As a user, I can see track names and durations
- As a user, I can scroll smoothly through 1000+ tracks
- As a user, I can search for tracks by name

**Technical Requirements:**
- SwiftUI List with lazy loading
- Virtualized scrolling
- Basic text search (filename-based)
- 60fps minimum scrolling performance

**UI Structure:**

```
LibraryView
├── FolderListView (Root folders)
│   └── TrackListView (Files in folder)
│       ├── TrackRow (Reusable cell)
│       │   ├── Track name
│       │   ├── Duration
│       │   └── Download indicator
│       └── SearchBar
└── PlaylistsView
    └── PlaylistDetailView
```

**Acceptance Criteria:**
- ✅ Scroll 1000+ tracks at 60fps
- ✅ Search returns results in <200ms
- ✅ Tap-to-play latency <100ms

### Phase 2: Enhancements (Months 4-6)

#### 6. Metadata & Album Art
- Parse ID3 tags from audio files
- Display album artwork (embedded or folder.jpg)
- Browse by Artist/Album/Genre

#### 7. Advanced Playback
- Gapless playback between tracks
- Playback queue visualization
- Shuffle and repeat modes
- Sleep timer

#### 8. UI/UX Polish
- Dark mode support
- 120Hz optimization for all screens
- Animated transitions
- Haptic feedback

#### 9. Auto-Sync
- Background refresh of library
- Detect file changes on Drive
- Auto-download new tracks in followed folders

### Phase 3: Advanced Features (Months 7-9)

#### 10. CarPlay Integration
- CarPlay audio UI
- Voice control support

#### 11. Cloud Playlist Sync
- Save playlists to Google Drive as M3U
- Cross-device playlist sync

#### 12. Advanced Features
- Equalizer
- Lyrics display
- Shared folder support
- Multiple Google accounts

---

## 🏗️ Technical Architecture

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Yuben Player App                     │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
┌───────▼────────┐ ┌─────▼──────┐ ┌───────▼────────┐
│  UI Layer      │ │ Audio      │ │ Cloud Sync     │
│  (SwiftUI)     │ │ Engine     │ │ Manager        │
└───────┬────────┘ └─────┬──────┘ └───────┬────────┘
        │                 │                 │
┌───────▼─────────────────▼─────────────────▼────────┐
│              Business Logic Layer                  │
│  - AudioPlayerManager                              │
│  - GoogleDriveManager                              │
│  - CacheManager                                    │
│  - PlaylistManager                                 │
└───────┬────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────┐
│              Data Layer                            │
│  - Core Data (Playlists, Metadata)                │
│  - FileManager (Downloaded/Cached audio)          │
│  - Keychain (OAuth tokens)                        │
│  - UserDefaults (Preferences)                     │
└───────┬────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────┐
│              External Services                     │
│  - Google Drive API v3                            │
│  - Google Sign-In SDK                             │
│  - iOS MediaPlayer Framework                      │
│  - AVFoundation                                   │
└────────────────────────────────────────────────────┘
```

### Key Components

#### 1. AudioPlayerManager
**Responsibilities:**
- Manage AVAudioEngine and AVAudioPlayerNode
- Handle playback state (playing, paused, stopped)
- Update lock screen metadata
- Process remote commands (play/pause/skip)
- Pre-cache next track in queue

**Interface:**
```swift
class AudioPlayerManager: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTrack: Track?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    func play(track: Track) async throws
    func pause()
    func resume()
    func seek(to time: TimeInterval)
    func skipToNext()
    func skipToPrevious()
    func setQueue(_ tracks: [Track])
}
```

#### 2. GoogleDriveManager
**Responsibilities:**
- OAuth authentication with Google
- Browse folders and list files
- Download files (streaming + offline)
- Refresh access tokens
- Handle API errors

**Interface:**
```swift
class GoogleDriveManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var selectedFolder: DriveFolder?

    func signIn(presenting: UIViewController) async throws
    func signOut()
    func listFolders() async throws -> [DriveFolder]
    func listFiles(in folder: DriveFolder) async throws -> [DriveFile]
    func downloadFile(_ file: DriveFile, progress: @escaping (Double) -> Void) async throws -> URL
    func streamFile(_ file: DriveFile) async throws -> URL
}
```

#### 3. CacheManager
**Responsibilities:**
- Manage temporary cache (LRU eviction)
- Manage permanent downloads
- Track storage usage
- Provide file URLs for playback

**Interface:**
```swift
class CacheManager {
    func cacheFile(_ file: DriveFile, data: Data) throws
    func downloadFile(_ file: DriveFile) async throws -> URL
    func getCachedFileURL(for fileID: String) -> URL?
    func getDownloadedFileURL(for fileID: String) -> URL?
    func getStorageUsage() -> StorageInfo
    func evictCache() throws
    func deleteDownload(fileID: String) throws
}
```

#### 4. PlaylistManager
**Responsibilities:**
- CRUD operations for playlists
- Track ordering and queue management
- Core Data persistence

**Interface:**
```swift
class PlaylistManager: ObservableObject {
    @Published var playlists: [Playlist] = []

    func createPlaylist(name: String) -> Playlist
    func deletePlaylist(_ playlist: Playlist)
    func addTrack(_ track: Track, to playlist: Playlist)
    func removeTrack(_ track: Track, from playlist: Playlist)
    func reorderTracks(in playlist: Playlist, from: IndexSet, to: Int)
    func fetchPlaylists() -> [Playlist]
}
```

### File Structure

```
YubenPlayer/
├── App/
│   ├── YubenPlayerApp.swift          // @main entry point
│   └── ContentView.swift              // Root SwiftUI view
│
├── Models/
│   ├── Track.swift                    // Core Data entity
│   ├── Playlist.swift                 // Core Data entity
│   ├── DriveFile.swift                // Google Drive file model
│   ├── DriveFolder.swift              // Google Drive folder model
│   └── CoreDataStack.swift            // Core Data setup
│
├── Managers/
│   ├── AudioPlayerManager.swift       // AVAudioEngine wrapper
│   ├── GoogleDriveManager.swift       // Drive API + OAuth
│   ├── CacheManager.swift             // Caching logic
│   └── PlaylistManager.swift          // Playlist CRUD
│
├── Views/
│   ├── Library/
│   │   ├── LibraryView.swift          // Main library screen
│   │   ├── FolderListView.swift       // Browse folders
│   │   └── TrackListView.swift        // Track list
│   ├── NowPlaying/
│   │   ├── NowPlayingView.swift       // Full-screen player
│   │   └── MiniPlayerView.swift       // Bottom bar player
│   ├── Playlists/
│   │   ├── PlaylistsView.swift        // Playlist list
│   │   └── PlaylistDetailView.swift   // Playlist editor
│   └── Settings/
│       ├── SettingsView.swift         // App settings
│       ├── StorageView.swift          // Storage management
│       └── AccountView.swift          // Google account
│
├── Utilities/
│   ├── Extensions.swift               // Swift extensions
│   ├── Constants.swift                // App constants
│   └── Logger.swift                   // Logging utility
│
└── Resources/
    ├── Assets.xcassets                // Images, colors
    ├── Info.plist                     // App configuration
    └── YubenPlayer.xcdatamodeld       // Core Data schema
```

---

## 🛠️ Technology Stack

### **Recommended Stack (Final Decision)**

| Layer | Technology | Reasoning |
|-------|-----------|-----------|
| **Language** | Swift 5.9+ | Native, performant, modern |
| **UI Framework** | SwiftUI | Declarative, beginner-friendly, 120Hz support |
| **Minimum iOS** | iOS 15.0+ | Balances features vs device coverage |
| **Audio Engine** | AVAudioEngine + AVAudioPlayerNode | 1.5-6ms latency, professional grade |
| **Background Audio** | AVAudioSession (.playback category) | Standard iOS background audio |
| **Lock Screen** | MPNowPlayingInfoCenter + MPRemoteCommandCenter | Native iOS media controls |
| **Google Drive** | GoogleAPIClientForREST/Drive + GoogleSignIn-iOS | Official Google SDKs |
| **Database** | Core Data (SwiftData for iOS 17+) | Native persistence, no external dependencies |
| **Networking** | URLSession | Native, supports background downloads |
| **Storage** | FileManager + Keychain | Native file I/O and secure token storage |
| **State Management** | SwiftUI @StateObject + @ObservedObject | Built-in reactive pattern |

### **Why Native Swift (Not React Native/Flutter)?**

| Consideration | Native Swift | React Native | Flutter |
|--------------|--------------|--------------|---------|
| Audio Latency | ✅ 1.5-6ms | ❌ 20-50ms | ❌ 15-30ms |
| Lock Screen Controls | ✅ Direct API access | ⚠️ Requires native modules | ⚠️ Requires platform channels |
| Background Audio | ✅ Reliable | ⚠️ Can be unstable | ⚠️ Complex setup |
| 120Hz Performance | ✅ Native ProMotion | ❌ Limited support | ✅ Good support |
| Beginner-Friendly | ✅ Clear tutorials | ⚠️ Need JS + iOS | ⚠️ Need Dart + iOS |
| App Size | ✅ ~10MB | ❌ 40-60MB | ❌ 30-50MB |
| Recommendation | **BEST CHOICE** | Not suitable | Not suitable |

**Verdict:** Native Swift is the **only viable option** for zero-latency audio and reliable lock screen controls.

### **Dependencies (via Swift Package Manager)**

```swift
dependencies: [
    // Google Drive Integration
    .package(url: "https://github.com/google/google-api-objectivec-client-for-rest.git", from: "3.0.0"),
    .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0"),

    // Optional: Better logging
    .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
]
```

---

## 🗺️ Implementation Roadmap

### **Phase 1: MVP (Months 1-3)**

#### Month 1: Foundation
**Week 1-2: Project Setup & Authentication**
- ✅ Create Xcode project (SwiftUI, iOS 15+)
- ✅ Set up Google Cloud Console project
- ✅ Configure OAuth 2.0 credentials
- ✅ Implement Google Sign-In flow
- ✅ Test authentication on real device

**Week 3-4: Google Drive Integration**
- ✅ Implement folder browsing
- ✅ List files with pagination
- ✅ Display files in SwiftUI List
- ✅ Handle token refresh

**Deliverable:** User can sign in and browse their Google Drive

#### Month 2: Core Playback
**Week 5-6: Audio Playback Engine**
- ✅ Set up AVAudioEngine with AVAudioPlayerNode
- ✅ Configure background audio session
- ✅ Implement play/pause/seek controls
- ✅ Test with local WAV files first

**Week 7-8: Streaming & Lock Screen**
- ✅ Implement progressive download streaming
- ✅ Set up MPNowPlayingInfoCenter
- ✅ Implement MPRemoteCommandCenter handlers
- ✅ Test lock screen controls thoroughly

**Deliverable:** User can stream music from Drive and control it on lock screen

#### Month 3: Offline & Playlists
**Week 9-10: Download & Caching**
- ✅ Implement download manager
- ✅ Build cache management system
- ✅ Create storage UI
- ✅ Test with large files (100MB+)

**Week 11-12: Playlist & Polish**
- ✅ Set up Core Data models
- ✅ Implement playlist CRUD
- ✅ Build queue management
- ✅ Bug fixes and testing

**Deliverable:** Full MVP ready for TestFlight beta

### **Phase 2: Enhancements (Months 4-6)**

#### Month 4: Metadata & UI
- Parse ID3 tags
- Album artwork display
- Dark mode support
- Improved UI animations

#### Month 5: Advanced Playback
- Gapless playback
- Shuffle/repeat modes
- Queue visualization
- Sleep timer

#### Month 6: Performance Optimization
- 120Hz optimization
- Large library handling (10,000+ tracks)
- Memory optimization
- Battery usage optimization

**Deliverable:** App Store release candidate

### **Phase 3: Advanced Features (Months 7-9)**

#### Month 7: CarPlay
- CarPlay UI implementation
- Voice control integration

#### Month 8: Cloud Sync
- Playlist sync to Drive
- Auto-sync improvements

#### Month 9: Premium Features
- Equalizer
- Lyrics
- Multiple accounts

**Deliverable:** Version 1.5 with premium features

---

## 👨‍💻 Zero-Coder Development Guide

### **Prerequisites**

#### Hardware
- ✅ Mac with M1/M2/M3 processor (you have this!)
- ✅ iPhone 11 or newer for testing
- ✅ Lightning/USB-C cable for device connection

#### Software
- ✅ macOS 13 (Ventura) or later
- ✅ Xcode 15+ (free from Mac App Store)
- ✅ Paid Apple Developer Account ($99/year - required for device testing)

### **Step-by-Step Setup Guide**

#### Step 1: Install Xcode (15 minutes)

```bash
# Open Mac App Store
# Search for "Xcode"
# Click "Get" / "Install" (it's ~14GB, takes 30-60 minutes)

# After installation, launch Xcode
# It will ask to install additional components - click "Install"

# Verify installation
xcode-select --install
```

#### Step 2: Set Up Apple Developer Account (30 minutes)

1. Go to https://developer.apple.com
2. Click "Account" → Sign in with Apple ID
3. Enroll in Apple Developer Program ($99/year)
4. Wait for approval email (usually 24-48 hours)

#### Step 3: Set Up Google Cloud Project (20 minutes)

1. **Create Project:**
   - Go to https://console.cloud.google.com
   - Click "Create Project" → Name it "Yuben Player"
   - Click "Create"

2. **Enable Google Drive API:**
   - In left menu: "APIs & Services" → "Library"
   - Search "Google Drive API"
   - Click "Enable"

3. **Create OAuth Credentials:**
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth client ID"
   - Application type: "iOS"
   - Name: "Yuben Player iOS"
   - Bundle ID: `com.yourname.yubenplayer` (remember this!)
   - Click "Create"
   - **Download the JSON file** (you'll need the client ID)

4. **Configure OAuth Consent Screen:**
   - Go to "OAuth consent screen"
   - User type: "External"
   - Fill in app name, email
   - Add scopes: `https://www.googleapis.com/auth/drive.readonly`
   - Save

#### Step 4: Create Xcode Project (10 minutes)

1. **Launch Xcode**
2. **Create New Project:**
   - Click "Create a new Xcode project"
   - Choose "App" template
   - Click "Next"

3. **Configure Project:**
   ```
   Product Name: Yuben Player
   Team: [Select your developer account]
   Organization Identifier: com.yourname
   Bundle Identifier: com.yourname.yubenplayer (must match Google Cloud!)
   Interface: SwiftUI
   Language: Swift
   Use Core Data: ✓ (check this!)
   Include Tests: ✓ (recommended)
   ```
   - Click "Next"
   - Choose location to save project
   - Click "Create"

4. **Configure Capabilities:**
   - Select project in left sidebar
   - Select "Yuben Player" target
   - Go to "Signing & Capabilities" tab
   - Click "+ Capability"
   - Add "Background Modes"
   - Check "Audio, AirPlay, and Picture in Picture"

#### Step 5: Add Dependencies (15 minutes)

1. **In Xcode, select project in left sidebar**
2. **Go to project settings → "Package Dependencies" tab**
3. **Click "+" button**
4. **Add Google Sign-In:**
   ```
   URL: https://github.com/google/GoogleSignIn-iOS
   Dependency Rule: Up to Next Major Version: 7.0.0
   Click "Add Package"
   Select "GoogleSignIn" and "GoogleSignInSwift"
   Click "Add Package"
   ```

5. **Click "+" again, add Google Drive API:**
   ```
   URL: https://github.com/google/google-api-objectivec-client-for-rest
   Dependency Rule: Up to Next Major Version: 3.0.0
   Click "Add Package"
   Select "GoogleAPIClientForREST_Drive"
   Click "Add Package"
   ```

#### Step 6: Configure Info.plist (10 minutes)

1. **In Xcode, find "Info.plist" in left sidebar**
2. **Right-click → "Open As" → "Source Code"**
3. **Add this inside `<dict>` tag:**

```xml
<!-- Google Sign-In Configuration -->
<key>GIDClientID</key>
<string>YOUR-CLIENT-ID.apps.googleusercontent.com</string>

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>

<!-- Background Audio -->
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>

<!-- Privacy Descriptions (required for App Store) -->
<key>NSMicrophoneUsageDescription</key>
<string>Yuben Player does not access your microphone.</string>

<key>NSAppleMusicUsageDescription</key>
<string>Yuben Player plays music from your Google Drive.</string>
```

**Replace `YOUR-CLIENT-ID` with your actual Google Cloud client ID!**

#### Step 7: Connect iPhone for Testing (15 minutes)

1. **Connect iPhone to Mac with cable**
2. **On iPhone:**
   - Go to Settings → General → About
   - Tap software version 5 times to enable Developer Mode
   - Restart iPhone
   - Confirm "Enable Developer Mode"

3. **In Xcode:**
   - Select your iPhone from device dropdown (top toolbar)
   - If prompted, click "Trust" on iPhone
   - Wait for Xcode to process symbols

4. **Run Test App:**
   - Click "Play" button (▶️) in Xcode
   - App should build and launch on your iPhone
   - If you see "Hello, World!" → Success!

### **Starter Code Templates**

#### Template 1: Google Sign-In View

Create new file: `Views/Auth/SignInView.swift`

```swift
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignInView: View {
    @EnvironmentObject var driveManager: GoogleDriveManager
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 30) {
            // App Logo/Title
            VStack(spacing: 10) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("Yuben Player")
                    .font(.largeTitle)
                    .bold()

                Text("Your Google Drive Music Library")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Sign-In Button
            GoogleSignInButton(action: signIn)
                .frame(height: 50)
                .padding(.horizontal, 40)

            if isSigningIn {
                ProgressView()
                    .padding()
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }

    func signIn() {
        isSigningIn = true
        errorMessage = nil

        Task {
            do {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootViewController = windowScene.windows.first?.rootViewController else {
                    throw NSError(domain: "No root view controller", code: -1)
                }

                try await driveManager.signIn(presenting: rootViewController)
                isSigningIn = false
            } catch {
                isSigningIn = false
                errorMessage = "Sign-in failed: \(error.localizedDescription)"
            }
        }
    }
}
```

#### Template 2: GoogleDriveManager (Starter)

Create new file: `Managers/GoogleDriveManager.swift`

```swift
import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

@MainActor
class GoogleDriveManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: GIDGoogleUser?

    private let driveService = GTLRDriveService()
    private let scopes = ["https://www.googleapis.com/auth/drive.readonly"]

    init() {
        // Restore previous sign-in
        restorePreviousSignIn()
    }

    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else { return }

            if let user = user {
                Task { @MainActor in
                    self.currentUser = user
                    self.configureDriveService(with: user)
                    self.isAuthenticated = true
                }
            }
        }
    }

    func signIn(presenting viewController: UIViewController) async throws {
        guard let clientID = GIDConfiguration.default?.clientID else {
            throw NSError(domain: "No client ID configured", code: -1)
        }

        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = signInConfig

        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController,
            hint: nil,
            additionalScopes: scopes
        )

        currentUser = result.user
        configureDriveService(with: result.user)
        isAuthenticated = true
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        currentUser = nil
        isAuthenticated = false
    }

    private func configureDriveService(with user: GIDGoogleUser) {
        driveService.authorizer = user.fetcherAuthorizer
    }

    // TODO: Add methods for listing folders, downloading files, etc.
}
```

#### Template 3: AudioPlayerManager (Starter)

Create new file: `Managers/AudioPlayerManager.swift`

```swift
import Foundation
import AVFoundation
import MediaPlayer

@MainActor
class AudioPlayerManager: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTrack: Track?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var audioEngine: AVAudioEngine!
    private var playerNode: AVAudioPlayerNode!
    private var audioFile: AVAudioFile?

    private var displayLink: CADisplayLink?

    init() {
        setupAudioSession()
        setupAudioEngine()
        setupRemoteCommands()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)

            // Zero latency configuration
            try audioSession.setPreferredIOBufferDuration(0.005) // 5ms
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)

        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }

    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.skipToNext()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.skipToPrevious()
            return .success
        }
    }

    func play(fileURL: URL) {
        do {
            audioFile = try AVAudioFile(forReading: fileURL)

            guard let audioFile = audioFile else { return }

            playerNode.scheduleFile(audioFile, at: nil) { [weak self] in
                // Track finished playing
                Task { @MainActor in
                    self?.skipToNext()
                }
            }

            playerNode.play()
            isPlaying = true

            duration = Double(audioFile.length) / audioFile.fileFormat.sampleRate
            startDisplayLink()
            updateNowPlaying()

        } catch {
            print("Failed to play file: \(error)")
        }
    }

    func pause() {
        playerNode.pause()
        isPlaying = false
        stopDisplayLink()
    }

    func resume() {
        playerNode.play()
        isPlaying = true
        startDisplayLink()
    }

    func play() {
        if isPlaying {
            return
        } else {
            resume()
        }
    }

    func skipToNext() {
        // TODO: Implement queue management
        print("Skip to next")
    }

    func skipToPrevious() {
        // TODO: Implement queue management
        print("Skip to previous")
    }

    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updatePlaybackTime))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120)
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updatePlaybackTime() {
        guard let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(forNodeTime: nodeTime),
              let audioFile = audioFile else { return }

        currentTime = Double(playerTime.sampleTime) / playerTime.sampleRate
    }

    private func updateNowPlaying() {
        var nowPlayingInfo = [String: Any]()

        if let track = currentTrack {
            nowPlayingInfo[MPMediaItemPropertyTitle] = track.name
            nowPlayingInfo[MPMediaItemPropertyArtist] = "Unknown Artist" // TODO: Parse metadata
        }

        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

// Placeholder Track model
struct Track: Identifiable {
    let id: String
    let name: String
    let fileURL: URL?
}
```

### **Learning Resources for Beginners**

#### Essential Tutorials (In Order)

1. **Swift Basics** (1-2 weeks)
   - 📖 Apple's Swift Book: https://docs.swift.org/swift-book/
   - 🎥 Stanford CS193p SwiftUI: https://cs193p.sites.stanford.edu/
   - ⏱️ Commitment: 2-3 hours/day

2. **SwiftUI Fundamentals** (1 week)
   - 📖 Apple's SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui
   - 🎯 Focus: Views, State, Navigation, Lists
   - ⏱️ Commitment: 1-2 hours/day

3. **AVFoundation Audio** (3-5 days)
   - 📖 Apple's AVFoundation Guide: https://developer.apple.com/av-foundation/
   - 🎥 Ray Wenderlich AVAudioEngine: https://www.raywenderlich.com
   - 🎯 Build simple audio player first

4. **Background Audio & Lock Screen** (2-3 days)
   - 📖 Apple's "Enabling Background Audio": https://developer.apple.com/documentation/avfoundation/media_playback/
   - 🎯 Implement MPNowPlayingInfoCenter

5. **Google Drive API** (1 week)
   - 📖 Google Drive iOS Quickstart: https://developers.google.com/drive/api/quickstart/ios
   - 🎯 Build simple file browser first

#### Recommended Learning Path (10-12 Weeks for Beginner)

```
Week 1-2: Swift Basics
  ├── Variables, functions, classes
  ├── Optionals, error handling
  └── Build simple calculator app

Week 3-4: SwiftUI Fundamentals
  ├── Views, modifiers, navigation
  ├── State management (@State, @Binding)
  └── Build simple to-do list app

Week 5: AVFoundation Basics
  ├── Play local audio files
  ├── Add play/pause/seek controls
  └── Build simple local music player

Week 6: Background Audio
  ├── Configure background modes
  ├── Implement lock screen controls
  └── Test thoroughly on device

Week 7-8: Google Drive Integration
  ├── OAuth authentication
  ├── Browse folders
  ├── Download files
  └── Build simple Drive file browser

Week 9-10: Core Data & Playlists
  ├── Learn Core Data basics
  ├── Create playlist models
  └── Implement CRUD operations

Week 11-12: Integration & Polish
  ├── Combine all components
  ├── Bug fixes
  ├── UI improvements
  └── TestFlight beta release
```

#### Daily Coding Routine (For Beginners)

```
Morning (1-2 hours):
  ├── 30 min: Watch tutorial video
  ├── 30 min: Read documentation
  └── 30 min: Code along with tutorial

Evening (1-2 hours):
  ├── 60 min: Work on your project
  ├── 30 min: Debug and test
  └── 15 min: Plan next day's tasks
```

### **Common Beginner Pitfalls & Solutions**

#### Pitfall 1: "Xcode won't run on my iPhone"
**Solution:**
```
1. Check: iPhone is unlocked
2. Check: Developer Mode enabled (Settings → Privacy & Security → Developer Mode)
3. Check: Trusted this computer (popup on iPhone)
4. Check: Same Apple ID in Xcode and iPhone
5. Restart both devices if still failing
```

#### Pitfall 2: "Google Sign-In not working"
**Solution:**
```
1. Verify Info.plist has correct GIDClientID
2. Verify CFBundleURLSchemes matches your client ID
3. Check Bundle Identifier matches Google Cloud Console
4. Run on REAL device (simulator won't work for OAuth)
```

#### Pitfall 3: "Lock screen controls not appearing"
**Solution:**
```
1. Don't use .mixWithOthers in audio session category
2. Set MPNowPlayingInfo AFTER starting playback
3. Test on device, not simulator
4. Background Modes capability must be enabled
```

#### Pitfall 4: "App crashes when playing audio"
**Solution:**
```
1. Check file exists before playing
2. Wrap audio operations in do-catch
3. Ensure audio session is active
4. Check console logs for specific error
```

### **Testing Checklist (Before Each Build)**

```
□ App builds without errors
□ App launches on real iPhone
□ Google Sign-In flow completes
□ Can browse at least one folder
□ Can play at least one WAV file
□ Lock screen shows track info
□ Play/pause works on lock screen
□ App continues playing when locked
□ No crashes after 5 minutes of playback
```

---

## ⚡ Performance Requirements

### **Latency Targets**

| Scenario | Target | Measurement |
|----------|--------|-------------|
| Offline playback start | < 100ms | Tap to first audio |
| Streaming playback start (good network) | < 500ms | Tap to first audio |
| Streaming playback start (poor network) | < 2s | With loading indicator |
| Skip to next track (offline) | < 100ms | Command to audio |
| Lock screen response | < 50ms | Tap to visual feedback |
| Seek operation | < 200ms | Slider to audio change |

**How to Achieve:**
- Use AVAudioEngine (not AVPlayer) for <10ms audio latency
- Pre-cache next track in queue (download starts when current track reaches 50%)
- Set `preferredIOBufferDuration` to 0.005 (5ms)
- Schedule files with AVAudioPlayerNode for instant playback

### **UI Performance Targets**

| Screen | Frame Rate | Measurement |
|--------|-----------|-------------|
| Library scrolling (< 1000 tracks) | 120fps on iPhone 13 Pro+ | Instruments FPS gauge |
| Library scrolling (1000-10,000 tracks) | 60fps minimum | Instruments FPS gauge |
| Now Playing animations | 120fps on iPhone 13 Pro+ | CADisplayLink |
| Search results | < 200ms | Keystroke to display |
| App launch to main screen | < 2s | Cold start |

**How to Achieve:**
- Use SwiftUI `LazyVStack` for virtualized scrolling
- Offload image loading to background thread
- Minimize view hierarchy depth
- Use `CADisplayLink` with `preferredFrameRateRange(60...120)`

### **Resource Usage Targets**

| Resource | Target | Constraint |
|----------|--------|------------|
| Memory baseline | < 100MB | Without playback |
| Memory during playback | < 200MB | Single track |
| Memory with large library (10k tracks) | < 300MB | Metadata only, not files |
| Battery drain (offline playback) | < 5% per hour | iPhone 13 Pro test |
| Battery drain (streaming) | < 8% per hour | iPhone 13 Pro test |
| Storage cache size | 500MB max | Auto-eviction |
| Network bandwidth (streaming) | Adaptive | Max 10 Mbps |

### **Optimization Techniques**

#### 1. Audio Engine Configuration (Zero Latency)

```swift
// Configure for minimum latency
let audioSession = AVAudioSession.sharedInstance()
try audioSession.setCategory(.playback, mode: .default, options: [])
try audioSession.setPreferredSampleRate(48000) // Match hardware
try audioSession.setPreferredIOBufferDuration(0.005) // 5ms = 240 samples at 48kHz

// Use AVAudioEngine, not AVPlayer
let audioEngine = AVAudioEngine()
let playerNode = AVAudioPlayerNode()

// Pre-load file into buffer for instant playback
let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts) {
    // Track finished
}
```

#### 2. List Performance (Smooth Scrolling)

```swift
// Use LazyVStack, not VStack
ScrollView {
    LazyVStack {
        ForEach(tracks) { track in
            TrackRow(track: track)
                .onAppear {
                    // Load more tracks if needed (pagination)
                    if track.id == tracks.last?.id {
                        loadMoreTracks()
                    }
                }
        }
    }
}

// Keep TrackRow simple (no heavy computations)
struct TrackRow: View {
    let track: Track

    var body: some View {
        HStack {
            // Async image loading
            AsyncImage(url: track.artworkURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text(track.name)
                Text(track.artist).font(.caption).foregroundColor(.gray)
            }

            Spacer()

            if track.isDownloaded {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}
```

#### 3. Pre-Caching Next Track

```swift
class AudioPlayerManager {
    private var queue: [Track] = []
    private var currentIndex = 0
    private var nextTrackPreloaded = false

    func playTrack(at index: Int) {
        currentIndex = index
        let track = queue[index]

        // Play current track
        play(fileURL: track.localURL ?? streamURL(for: track))

        // Pre-load next track
        preloadNextTrack()
    }

    private func preloadNextTrack() {
        guard currentIndex + 1 < queue.count else { return }
        let nextTrack = queue[currentIndex + 1]

        // If not downloaded, start downloading in background
        if !nextTrack.isDownloaded {
            Task {
                await cacheManager.preloadFile(nextTrack.driveFile)
            }
        }
    }
}
```

#### 4. Memory Management

```swift
// Implement didReceiveMemoryWarning
class LibraryViewModel: ObservableObject {
    func handleMemoryWarning() {
        // Clear image cache
        imageCache.removeAll()

        // Trim track list to visible items only
        tracks = Array(tracks.prefix(100))

        // Force garbage collection
        autoreleasepool {
            // Heavy cleanup
        }
    }
}
```

---

## 🔒 Security & Privacy

### **Security Requirements**

#### 1. OAuth Token Storage
**Requirement:** Store OAuth tokens securely in iOS Keychain

```swift
import Security

class KeychainManager {
    static func saveToken(_ token: String, forKey key: String) {
        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // Remove old
        SecItemAdd(query as CFDictionary, nil)
    }

    static func getToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
```

#### 2. HTTPS Only
- ✅ All Google Drive API calls use HTTPS (enforced by SDK)
- ✅ Enable App Transport Security (ATS) in Info.plist

#### 3. Local File Protection

```swift
// Encrypt downloaded files with iOS Data Protection
let attributes = [FileAttributeKey.protectionKey: FileProtectionType.complete]
try FileManager.default.setAttributes(attributes, ofItemAtPath: fileURL.path)
```

### **Privacy Requirements**

#### 1. Minimal Data Collection
- ✅ **NO analytics tracking** (unless user opts in)
- ✅ **NO third-party SDKs** (except Google for Drive access)
- ✅ **NO crash reporting by default**
- ✅ **NO device fingerprinting**

#### 2. Privacy Policy (Required for App Store)

**Template:**

```
Yuben Player Privacy Policy

Last updated: [Date]

Data Collection:
- We do NOT collect any personal information
- We do NOT track your usage
- We do NOT share data with third parties

Google Drive Access:
- You authenticate directly with Google
- We only access files you explicitly select
- OAuth tokens are stored securely on your device
- We cannot access your data without your permission

Local Storage:
- Downloaded music files are stored on your device
- Playlists are stored locally using Core Data
- No cloud backup of playlists (unless you enable iCloud)

Contact:
For privacy questions, email: privacy@yubenplayer.com
```

#### 3. Info.plist Privacy Descriptions

```xml
<key>NSAppleMusicUsageDescription</key>
<string>Yuben Player does not access your Apple Music library. This permission is required by iOS for audio playback.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Yuben Player does not use your microphone.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Yuben Player does not access your photos.</string>
```

### **App Store Review Preparation**

#### Required Materials
1. ✅ **Privacy Policy URL** (host on website or GitHub Pages)
2. ✅ **Demo Google Account** (for reviewer to test)
3. ✅ **Demo Video** (showing all features)
4. ✅ **App Description** (clear, accurate)
5. ✅ **Screenshots** (all required sizes)

#### Common Rejection Reasons & Solutions

| Reason | Solution |
|--------|----------|
| "App requires login without explanation" | Add clear onboarding screen explaining Google Drive integration |
| "Unclear functionality" | Improve app description and screenshots |
| "Crashes during review" | Test thoroughly, provide demo account, add error handling |
| "Privacy policy missing" | Host privacy policy and add URL in App Store Connect |
| "Background audio not justified" | Clearly state "music player app" in description |

---

## 🧪 Testing Strategy

### **Unit Testing**

**Priority Components:**
1. AudioPlayerManager (playback logic)
2. CacheManager (storage logic)
3. PlaylistManager (CRUD operations)
4. GoogleDriveManager (API calls - use mocks)

**Example Test:**

```swift
import XCTest
@testable import YubenPlayer

class PlaylistManagerTests: XCTestCase {
    var playlistManager: PlaylistManager!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        // Use in-memory Core Data for testing
        mockContext = createInMemoryContext()
        playlistManager = PlaylistManager(context: mockContext)
    }

    func testCreatePlaylist() {
        let playlist = playlistManager.createPlaylist(name: "Test Playlist")

        XCTAssertNotNil(playlist)
        XCTAssertEqual(playlist.name, "Test Playlist")
        XCTAssertEqual(playlist.tracks.count, 0)
    }

    func testAddTrackToPlaylist() {
        let playlist = playlistManager.createPlaylist(name: "Test")
        let track = Track(driveFileID: "123", name: "Song.wav")

        playlistManager.addTrack(track, to: playlist)

        XCTAssertEqual(playlist.tracks.count, 1)
        XCTAssertEqual(playlist.tracks.first?.driveFileID, "123")
    }
}
```

### **Integration Testing**

**Test Scenarios:**

```
1. End-to-End Playback Flow:
   ├── Sign in with Google
   ├── Browse folders
   ├── Select track
   ├── Stream and play
   ├── Lock phone
   ├── Verify lock screen controls work
   └── Unlock and verify playback continues

2. Offline Download Flow:
   ├── Download track
   ├── Enable airplane mode
   ├── Play downloaded track
   ├── Verify playback works
   └── Disable airplane mode

3. Playlist Flow:
   ├── Create playlist
   ├── Add 10 tracks
   ├── Reorder tracks
   ├── Play playlist
   ├── Verify queue advances correctly
   └── Verify next track pre-loads
```

### **Device Testing Matrix**

| Device | iOS Version | Screen Size | Test Focus |
|--------|-------------|-------------|------------|
| iPhone 11 | 15.0 | 6.1" | Minimum spec, 60Hz |
| iPhone 13 Pro | 17.0 | 6.1" | 120Hz ProMotion |
| iPhone 15 Pro Max | 17.0 | 6.7" | Latest hardware |
| iPad Pro (optional) | 17.0 | 12.9" | iPad compatibility |

### **Performance Testing**

**Use Xcode Instruments:**

```
1. Time Profiler:
   - Identify slow functions
   - Target: No single function > 16ms (60fps)

2. Allocations:
   - Track memory usage
   - Identify leaks
   - Target: < 200MB during playback

3. Network:
   - Monitor download speeds
   - Identify network bottlenecks
   - Verify progressive streaming

4. Energy Log:
   - Measure battery impact
   - Target: < 5% per hour (offline)
```

### **Automated Testing (CI/CD)**

**GitHub Actions Workflow:**

```yaml
name: iOS CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.0.app

      - name: Build and Test
        run: |
          xcodebuild test \
            -scheme YubenPlayer \
            -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
            -enableCodeCoverage YES

      - name: Upload Coverage
        run: bash <(curl -s https://codecov.io/bash)
```

---

## 🚀 Deployment Guide

### **TestFlight Beta (Recommended First Step)**

#### Step 1: Prepare Build

```bash
# In Xcode
# 1. Select "Any iOS Device (arm64)" as destination
# 2. Product → Archive
# 3. Wait for archive to complete (5-10 minutes)
```

#### Step 2: Upload to App Store Connect

```bash
# After archive completes:
# 1. Window → Organizer
# 2. Select your archive
# 3. Click "Distribute App"
# 4. Select "App Store Connect"
# 5. Click "Upload"
# 6. Wait for upload (10-30 minutes)
```

#### Step 3: Configure TestFlight

```
1. Go to App Store Connect (appstoreconnect.apple.com)
2. Select "Yuben Player"
3. Go to "TestFlight" tab
4. Wait for build to appear (10-30 minutes)
5. Add "What to Test" notes
6. Add internal testers (up to 100, no review needed)
7. OR submit for external testing (up to 10,000, requires review)
```

#### Step 4: Invite Testers

```
Internal Testers (Instant):
- Add email addresses in TestFlight
- They receive invite email
- Install TestFlight app on iPhone
- Accept invite and download

External Testers (1-2 day review):
- Create public link or add emails
- Submit for review
- Wait for approval
- Share link with testers
```

### **App Store Release**

#### Preparation Checklist

```
□ Privacy policy URL live
□ Support URL or email configured
□ App icon (1024x1024)
□ Screenshots for all device sizes:
  - 6.7" (iPhone 15 Pro Max)
  - 6.5" (iPhone 11 Pro Max)
  - 5.5" (iPhone 8 Plus)
□ App description written (170 char subtitle, 4000 char description)
□ Keywords selected (100 char max, comma-separated)
□ Age rating completed
□ TestFlight beta tested with 10+ users
```

#### Submission Steps

```
1. In App Store Connect:
   - Click "+ Version" (e.g., "1.0")
   - Fill in all metadata
   - Add screenshots
   - Select your build from TestFlight
   - Click "Submit for Review"

2. Wait for review (typically 24-48 hours)

3. Common review notes:
   - May request demo account
   - May ask questions about Google Drive access
   - May request clarification on features

4. If approved:
   - Release automatically or manually
   - Monitor crash reports
   - Respond to user reviews
```

### **Versioning Strategy**

```
1.0.0 - MVP Release
├── Audio playback from Google Drive
├── Lock screen controls
├── Offline downloads
└── Basic playlists

1.1.0 - First Update
├── Bug fixes from 1.0
├── Dark mode
└── Improved caching

1.5.0 - Major Update
├── Metadata parsing
├── Album artwork
├── Gapless playback
└── 120Hz optimization

2.0.0 - Premium Features
├── CarPlay support
├── Equalizer
├── Cloud playlist sync
└── Multiple accounts
```

---

## 📊 Success Metrics & KPIs

### **MVP Success Criteria (First 3 Months)**

| Metric | Target | Measurement |
|--------|--------|-------------|
| TestFlight installs | 50+ | TestFlight Analytics |
| Crash-free rate | > 99% | Xcode Organizer |
| Average session duration | > 20 minutes | Custom analytics |
| D7 retention | > 40% | Custom analytics |
| App Store rating | > 4.0 stars | App Store Connect |
| Playback success rate | > 95% | Error logging |

### **Growth Metrics (6-12 Months)**

| Metric | 6-Month Target | 12-Month Target |
|--------|----------------|-----------------|
| Total downloads | 1,000+ | 10,000+ |
| Monthly active users | 500+ | 5,000+ |
| Average rating | 4.5+ stars | 4.7+ stars |
| Crash-free rate | 99.5%+ | 99.9%+ |

### **Feature Adoption Metrics**

| Feature | Success Criteria |
|---------|------------------|
| Offline downloads | 70%+ users download at least 1 track |
| Playlists | 50%+ users create at least 1 playlist |
| Background playback | 90%+ of sessions use background audio |
| Lock screen controls | 80%+ of users interact with lock screen |

---

## 🎯 Next Steps

### **Immediate Actions (This Week)**

1. ✅ **Read this entire PRD** (you're doing it!)
2. ✅ **Set up development environment:**
   - Install Xcode from Mac App Store
   - Enroll in Apple Developer Program ($99/year)
   - Create Google Cloud Console project
   - Configure OAuth credentials
3. ✅ **Create Xcode project:**
   - Use the setup guide in "Zero-Coder Development Guide" section
   - Add dependencies (Google Sign-In, Drive API)
   - Configure Info.plist
4. ✅ **Validate on real device:**
   - Run template app on your iPhone
   - Verify "Hello World" appears
   - Test Google Sign-In flow

### **Week 1-2: Authentication & Drive Browsing**

```
Day 1-2: Implement Google Sign-In
  ├── Create SignInView.swift
  ├── Test OAuth flow on device
  └── Verify token storage in Keychain

Day 3-4: Implement Drive folder browsing
  ├── Create GoogleDriveManager methods
  ├── List folders with API
  └── Display folders in SwiftUI List

Day 5-7: Implement file browsing
  ├── List WAV files in selected folder
  ├── Display files in SwiftUI List
  ├── Add pagination for large folders
  └── Test with your real Google Drive
```

### **Week 3-4: Core Audio Playback**

```
Day 1-3: Local audio playback
  ├── Set up AVAudioEngine
  ├── Configure background audio session
  ├── Play local WAV file
  └── Add play/pause/seek controls

Day 4-5: Lock screen integration
  ├── Implement MPNowPlayingInfoCenter
  ├── Implement MPRemoteCommandCenter
  └── Test lock screen controls thoroughly

Day 6-7: Streaming from Drive
  ├── Download file to temp cache
  ├── Play from cache
  └── Test with various file sizes
```

### **Week 5-6: Downloads & Caching**

```
Day 1-2: Download manager
  ├── Implement progressive download
  ├── Show progress UI
  └── Save to documents directory

Day 3-4: Cache management
  ├── Implement LRU eviction
  ├── Track storage usage
  └── Build storage settings UI

Day 5-7: Integration
  ├── Combine streaming + downloads
  ├── Pre-cache next track logic
  └── Test offline mode
```

### **Week 7-8: Playlists & Queue**

```
Day 1-2: Core Data setup
  ├── Create Playlist and Track models
  ├── Test CRUD operations
  └── Persist playlists

Day 3-5: Playlist UI
  ├── Create playlist view
  ├── Add/remove tracks UI
  ├── Reorder tracks
  └── Delete playlists

Day 6-7: Queue management
  ├── Implement queue in AudioPlayerManager
  ├── Auto-advance to next track
  └── Test queue with playlists
```

### **Week 9-12: Polish & Beta Testing**

```
Week 9: Bug fixes
  ├── Fix all critical bugs
  ├── Handle edge cases
  └── Improve error messages

Week 10: UI polish
  ├── Improve visual design
  ├── Add loading states
  ├── Smooth animations
  └── Dark mode support

Week 11: Testing
  ├── Test on multiple devices
  ├── Performance profiling
  ├── Fix memory leaks
  └── Battery testing

Week 12: TestFlight
  ├── Create App Store Connect listing
  ├── Upload first beta build
  ├── Invite 10-20 beta testers
  └── Gather feedback
```

---

## 📚 Appendix

### **A. Glossary**

| Term | Definition |
|------|------------|
| **AVAudioEngine** | iOS framework for low-latency audio processing |
| **AVAudioSession** | iOS service managing app's audio behavior |
| **Core Data** | Apple's object graph and persistence framework |
| **Google Drive API** | RESTful API for accessing Google Drive |
| **LRU Cache** | Least Recently Used cache eviction strategy |
| **MPNowPlayingInfoCenter** | iOS service for lock screen media metadata |
| **MPRemoteCommandCenter** | iOS service for remote playback commands |
| **OAuth 2.0** | Industry-standard authentication protocol |
| **Progressive Download** | Downloading file while simultaneously playing it |
| **SwiftUI** | Apple's declarative UI framework |
| **WAV** | Uncompressed audio format (Waveform Audio File Format) |

### **B. File Format Support**

| Format | Extension | Supported | Priority |
|--------|-----------|-----------|----------|
| WAV (PCM) | .wav | ✅ Yes | P0 (MVP) |
| MP3 | .mp3 | ✅ Yes | P1 (Phase 2) |
| FLAC | .flac | ⚠️ Requires decoder | P2 (Phase 2) |
| ALAC | .m4a | ✅ Yes (native) | P2 (Phase 2) |
| AAC | .m4a, .aac | ✅ Yes (native) | P2 (Phase 2) |
| OGG Vorbis | .ogg | ❌ No | P3 (Future) |

**Note:** AVAudioEngine supports WAV, MP3, AAC, and ALAC natively. FLAC requires third-party decoder.

### **C. Google Drive API Quota**

| Operation | Quota (Free Tier) | Notes |
|-----------|-------------------|-------|
| Queries per day | 1 billion | Essentially unlimited for single-user app |
| Queries per 100 seconds | 1,000 | Affects large folder browsing |
| Download bandwidth | Unlimited | But user's Drive storage counts against quota |

**Cost:** Free for typical usage. Paid plan needed only for apps with 100,000+ users.

### **D. Device Specifications**

| Device | Screen | Refresh Rate | Audio Latency | Release Year |
|--------|--------|--------------|---------------|--------------|
| iPhone 11 | 6.1" LCD | 60Hz | ~8ms | 2019 |
| iPhone 12 | 6.1" OLED | 60Hz | ~6ms | 2020 |
| iPhone 13 Pro | 6.1" OLED | 120Hz | ~4ms | 2021 |
| iPhone 14 Pro | 6.1" OLED | 120Hz | ~4ms | 2022 |
| iPhone 15 Pro | 6.1" OLED | 120Hz | ~3ms | 2023 |

**Target Spec:** iPhone 11+ means supporting 60Hz minimum, 120Hz on Pro models.

### **E. Estimated Costs**

| Item | Cost | Frequency | Notes |
|------|------|-----------|-------|
| Apple Developer Program | $99 | Annual | Required for device testing + App Store |
| Google Cloud (Drive API) | $0 | - | Free tier sufficient for MVP |
| macOS/Xcode | Free | - | Included with Mac |
| Test Device (iPhone 11+) | $0 | - | Assuming you own one |
| **Total Year 1** | **$99** | - | Plus your time investment |

**Note:** If scaling to 100,000+ users, may need Google Workspace (starts at $6/user/month).

### **F. Comparison with Competitors**

| Feature | Yuben Player | CloudBeats | Evermusic | VLC |
|---------|--------------|------------|-----------|-----|
| Google Drive | ✅ Native | ✅ Yes | ✅ Yes | ❌ No |
| Lock screen controls | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Basic |
| Offline downloads | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| 120Hz UI | ✅ Yes | ❌ No | ❌ No | ❌ No |
| Zero-latency playback | ✅ <500ms | ⚠️ 1-2s | ⚠️ 1-2s | ✅ Fast |
| Native iOS feel | ✅ SwiftUI | ⚠️ Custom | ⚠️ Custom | ❌ Poor |
| Playlist management | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| Price | Free | $9.99 | $9.99 | Free |

**Competitive Advantage:**
1. 120Hz buttery smooth UI
2. Near-instant playback (< 500ms)
3. Native iOS design (SwiftUI)
4. Free (no paywalls for basic features)

---

## ✅ Final Checklist

Before starting development, confirm:

- [ ] I have a Mac with M1/M2/M3 processor
- [ ] I have an iPhone 11 or newer for testing
- [ ] I have $99 for Apple Developer Program
- [ ] I have a Google account for Drive API setup
- [ ] I have 10-20 hours/week to dedicate
- [ ] I understand this is a 3-6 month project
- [ ] I've read this entire PRD
- [ ] I've bookmarked key learning resources

**Ready to build? Start with "Zero-Coder Development Guide" section!**

---

## 📞 Support & Community

### Getting Help

1. **Xcode Issues:**
   - Apple Developer Forums: https://developer.apple.com/forums/
   - Stack Overflow (tag: swiftui, ios)

2. **Google Drive API:**
   - Stack Overflow (tag: google-drive-api)
   - Google Drive API Support: https://developers.google.com/drive/api/support

3. **General iOS Development:**
   - Ray Wenderlich Forums: https://forums.raywenderlich.com/
   - Swift Forums: https://forums.swift.org/
   - iOS Dev Slack: https://ios-developers.io/

4. **Audio Development:**
   - Audio Developer Conference: https://audio.dev/
   - iOS Audio Slack channel

### Recommended Books

1. **"SwiftUI by Tutorials"** by Ray Wenderlich
2. **"iOS Apprentice"** by Ray Wenderlich (for absolute beginners)
3. **"Core Data by Tutorials"** by Ray Wenderlich
4. **"Advanced iOS App Architecture"** by Ray Wenderlich

---

**Document Version:** 1.0
**Last Updated:** 2025-11-17
**Status:** ✅ Ready for Development

**Good luck building Yuben Player! 🎵🚀**
