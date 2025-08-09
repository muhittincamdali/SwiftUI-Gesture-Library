# Migration Guide

<!-- TOC START -->
## Table of Contents
- [Migration Guide](#migration-guide)
- [Migrating from 1.x to 2.x](#migrating-from-1x-to-2x)
  - [Breaking Changes](#breaking-changes)
    - [Package Structure](#package-structure)
    - [API Changes](#api-changes)
    - [Minimum iOS Version](#minimum-ios-version)
  - [New Features](#new-features)
    - [Advanced Haptic Feedback](#advanced-haptic-feedback)
    - [Performance Monitoring](#performance-monitoring)
    - [Gesture Chaining](#gesture-chaining)
  - [Migration Steps](#migration-steps)
  - [Deprecated APIs](#deprecated-apis)
  - [Performance Improvements](#performance-improvements)
  - [Testing Migration](#testing-migration)
  - [Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
    - [Getting Help](#getting-help)
- [Migrating from 2.0 to 2.1](#migrating-from-20-to-21)
  - [New Features](#new-features)
    - [Enhanced Haptic Feedback](#enhanced-haptic-feedback)
    - [Advanced Gesture Configurations](#advanced-gesture-configurations)
    - [Accessibility Improvements](#accessibility-improvements)
  - [Bug Fixes](#bug-fixes)
  - [Performance Enhancements](#performance-enhancements)
<!-- TOC END -->


This guide helps you migrate from previous versions of SwiftUI Gesture Library to the latest version.

## Migrating from 1.x to 2.x

### Breaking Changes

#### Package Structure
The library is now distributed as a Swift Package with multiple targets:

```swift
// Old (1.x)
import SwiftUIGestureLibrary

// New (2.x)
import SwiftUIGestureLibrary
import SwiftUIGestureLibraryCore
import SwiftUIGestureLibraryHaptics
```

#### API Changes
Many gesture APIs have been updated for better performance:

```swift
// Old (1.x)
let gestureEngine = GestureEngine()

// New (2.x)
let gestureEngine = GestureEngine(
    configuration: GestureConfiguration(
        enableHapticFeedback: true,
        enablePerformanceMonitoring: true,
        maxConcurrentGestures: 3,
        recognitionTimeout: 2.0
    )
)
```

#### Minimum iOS Version
Updated minimum iOS version to 15.0:

```swift
// Old (1.x)
@available(iOS 14.0, *)

// New (2.x)
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
```

### New Features

#### Advanced Haptic Feedback
```swift
// New in 2.x
let hapticManager = HapticFeedbackManager(
    configuration: HapticConfiguration(
        defaultIntensity: 1.0,
        enableAdvancedHaptics: true,
        enableCustomPatterns: true,
        autoResetEngine: true
    )
)
```

#### Performance Monitoring
```swift
// New in 2.x
let metrics = gestureEngine.getPerformanceMetrics()
print("Average processing time: \(metrics.averageProcessingTime)")
print("Total events processed: \(metrics.totalEventsProcessed)")
```

#### Gesture Chaining
```swift
// New in 2.x
.customTapAndSwipeGesture(
    onTap: { print("Tap detected") },
    onSwipe: { direction in print("Swipe: \(direction)") }
)
```

### Migration Steps

1. **Update Package Dependencies**
   ```swift
   dependencies: [
       .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "2.1.0")
   ]
   ```

2. **Update Import Statements**
   ```swift
   import SwiftUIGestureLibrary
   ```

3. **Update Gesture Engine Initialization**
   ```swift
   // Old
   let engine = GestureEngine()
   
   // New
   let engine = GestureEngine(
       configuration: GestureConfiguration(
           enableHapticFeedback: true,
           enablePerformanceMonitoring: true,
           maxConcurrentGestures: 3,
           recognitionTimeout: 2.0
       )
   )
   ```

4. **Update Gesture Recognizers**
   ```swift
   // Old
   let tapRecognizer = TapGestureRecognizer()
   
   // New
   let tapRecognizer = TapGestureRecognizer(configuration: .doubleTap)
   ```

5. **Update SwiftUI Extensions**
   ```swift
   // Old
   .gesture(TapGesture().onEnded { _ in })
   
   // New
   .customTapGesture { print("Tap detected") }
   ```

### Deprecated APIs

The following APIs have been deprecated and will be removed in version 3.0:

- `GestureEngine.legacyInit()`
- `TapGestureRecognizer.legacyConfiguration`
- `SwipeGestureRecognizer.legacyDirection`

### Performance Improvements

Version 2.x includes significant performance improvements:

- **60fps+ gesture recognition**
- **Memory optimization**
- **Battery efficiency**
- **Reduced latency**

### Testing Migration

After migration, run your test suite to ensure compatibility:

```bash
swift test
```

### Troubleshooting

#### Common Issues

1. **Compilation Errors**
   - Ensure minimum iOS version is 15.0+
   - Update import statements
   - Check API changes

2. **Runtime Errors**
   - Verify gesture configurations
   - Check delegate implementations
   - Validate touch event handling

3. **Performance Issues**
   - Monitor performance metrics
   - Optimize gesture configurations
   - Reduce concurrent gestures

#### Getting Help

- Check the [API Documentation](GestureEngine.md)
- Review [Examples](../Examples/)
- Open an [Issue](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/issues)

## Migrating from 2.0 to 2.1

### New Features

#### Enhanced Haptic Feedback
```swift
// New in 2.1
hapticManager.triggerCustomFeedback(intensity: 0.8)
```

#### Advanced Gesture Configurations
```swift
// New in 2.1
let preciseConfig = TapConfiguration.precise
let freeformConfig = PinchConfiguration.freeform
```

#### Accessibility Improvements
```swift
// New in 2.1
.customAccessibleGesture("Tap to activate")
.customVoiceOverGesture("Double tap to zoom")
```

### Bug Fixes

- Fixed memory leak in long-running gesture sequences
- Resolved crash when combining certain gesture types
- Fixed accessibility gesture conflicts

### Performance Enhancements

- 15% improvement in gesture recognition accuracy
- 20% reduction in memory usage
- Enhanced error handling for edge cases 