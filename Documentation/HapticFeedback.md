# Haptic Feedback Documentation

<!-- TOC START -->
## Table of Contents
- [Haptic Feedback Documentation](#haptic-feedback-documentation)
- [Overview](#overview)
- [HapticFeedbackManager](#hapticfeedbackmanager)
  - [Basic Usage](#basic-usage)
  - [Configuration](#configuration)
- [Custom Haptic Feedback](#custom-haptic-feedback)
  - [Intensity Control](#intensity-control)
  - [Pattern Sequences](#pattern-sequences)
- [Gesture-Specific Feedback](#gesture-specific-feedback)
  - [Tap Gestures](#tap-gestures)
  - [Swipe Gestures](#swipe-gestures)
  - [Pinch Gestures](#pinch-gestures)
  - [Rotation Gestures](#rotation-gestures)
  - [Long Press Gestures](#long-press-gestures)
- [Advanced Features](#advanced-features)
  - [Performance Monitoring](#performance-monitoring)
  - [Accessibility Support](#accessibility-support)
  - [Battery Optimization](#battery-optimization)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
- [API Reference](#api-reference)
  - [HapticFeedbackManager](#hapticfeedbackmanager)
  - [HapticConfiguration](#hapticconfiguration)
  - [HapticPerformanceMetrics](#hapticperformancemetrics)
- [Examples](#examples)
  - [Basic Haptic Integration](#basic-haptic-integration)
  - [Advanced Haptic Patterns](#advanced-haptic-patterns)
<!-- TOC END -->


Complete guide to haptic feedback integration in SwiftUI Gesture Library.

## Overview

The haptic feedback system provides tactile responses to gesture interactions, enhancing user experience through physical feedback.

## HapticFeedbackManager

### Basic Usage

```swift
import SwiftUIGestureLibrary

@StateObject private var hapticManager = HapticFeedbackManager()

// Trigger feedback for specific gestures
hapticManager.triggerFeedback(for: .tap)
hapticManager.triggerFeedback(for: .swipe)
hapticManager.triggerFeedback(for: .pinch)
hapticManager.triggerFeedback(for: .rotation)
hapticManager.triggerFeedback(for: .longPress)
```

### Configuration

```swift
let hapticManager = HapticFeedbackManager(
    configuration: HapticConfiguration(
        defaultIntensity: 1.0,
        enableAdvancedHaptics: true,
        enableCustomPatterns: true,
        autoResetEngine: true
    )
)
```

## Custom Haptic Feedback

### Intensity Control

```swift
// Custom intensity feedback
hapticManager.triggerCustomFeedback(intensity: 0.5)  // Light feedback
hapticManager.triggerCustomFeedback(intensity: 0.8)  // Medium feedback
hapticManager.triggerCustomFeedback(intensity: 1.0)  // Strong feedback
```

### Pattern Sequences

```swift
// Create custom haptic patterns
hapticManager.triggerCustomFeedback(intensity: 0.3)
DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    hapticManager.triggerCustomFeedback(intensity: 0.6)
}
DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
    hapticManager.triggerCustomFeedback(intensity: 1.0)
}
```

## Gesture-Specific Feedback

### Tap Gestures

```swift
.customTapGesture {
    hapticManager.triggerFeedback(for: .tap)
}
```

### Swipe Gestures

```swift
.customSwipeGesture { direction in
    hapticManager.triggerFeedback(for: .swipe)
}
```

### Pinch Gestures

```swift
.customPinchGesture { scale in
    if scale > 1.5 {
        hapticManager.triggerCustomFeedback(intensity: 0.8)
    }
}
```

### Rotation Gestures

```swift
.customRotationGesture(
    onRotationChanged: { angle in
        // Continuous feedback during rotation
    },
    onRotationEnded: { finalAngle in
        hapticManager.triggerFeedback(for: .rotation)
    }
)
```

### Long Press Gestures

```swift
.customLongPressGesture {
    hapticManager.triggerFeedback(for: .longPress)
}
```

## Advanced Features

### Performance Monitoring

```swift
// Monitor haptic performance
let metrics = hapticManager.getPerformanceMetrics()
print("Haptic response time: \(metrics.responseTime)ms")
```

### Accessibility Support

```swift
// Enable accessibility haptic feedback
hapticManager.setAccessibilityEnabled(true)
```

### Battery Optimization

```swift
// Enable battery optimization
hapticManager.setBatteryOptimizationEnabled(true)
```

## Best Practices

1. **Use Appropriate Intensity**: Match haptic intensity to gesture importance
2. **Avoid Overuse**: Don't trigger haptics for every minor interaction
3. **Consider Accessibility**: Ensure haptics work with accessibility features
4. **Test on Device**: Always test haptic feedback on physical devices
5. **Battery Awareness**: Use haptics sparingly to preserve battery life

## Troubleshooting

### Common Issues

1. **No Haptic Feedback**
   - Check device haptic capability
   - Verify haptic feedback is enabled in system settings
   - Ensure proper initialization

2. **Inconsistent Feedback**
   - Check intensity values
   - Verify timing between haptic calls
   - Test on different devices

3. **Performance Issues**
   - Reduce haptic frequency
   - Use lower intensity values
   - Enable battery optimization

## API Reference

### HapticFeedbackManager

```swift
public class HapticFeedbackManager: ObservableObject {
    @Published public private(set) var currentIntensity: Float
    @Published public var isEnabled: Bool
    
    public func triggerFeedback(for gestureType: GestureType)
    public func triggerCustomFeedback(intensity: Float = 1.0)
    public func setIntensity(_ intensity: Float)
    public func setEnabled(_ enabled: Bool)
    public func getPerformanceMetrics() -> HapticPerformanceMetrics
}
```

### HapticConfiguration

```swift
public struct HapticConfiguration {
    public let defaultIntensity: Float
    public let enableAdvancedHaptics: Bool
    public let enableCustomPatterns: Bool
    public let autoResetEngine: Bool
}
```

### HapticPerformanceMetrics

```swift
public struct HapticPerformanceMetrics {
    public let responseTime: TimeInterval
    public let totalTriggers: Int
    public let averageIntensity: Float
}
```

## Examples

### Basic Haptic Integration

```swift
struct HapticExampleView: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 200)
            .customTapGesture {
                hapticManager.triggerFeedback(for: .tap)
            }
    }
}
```

### Advanced Haptic Patterns

```swift
struct AdvancedHapticView: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    var body: some View {
        VStack {
            Button("Light Feedback") {
                hapticManager.triggerCustomFeedback(intensity: 0.3)
            }
            
            Button("Medium Feedback") {
                hapticManager.triggerCustomFeedback(intensity: 0.6)
            }
            
            Button("Strong Feedback") {
                hapticManager.triggerCustomFeedback(intensity: 1.0)
            }
        }
    }
}
```

For more examples, see the `Examples/` directory. 