# Getting Started with SwiftUI Gesture Library

<!-- TOC START -->
## Table of Contents
- [Getting Started with SwiftUI Gesture Library](#getting-started-with-swiftui-gesture-library)
- [🚀 Quick Setup](#-quick-setup)
  - [1. Installation](#1-installation)
  - [2. Import the Library](#2-import-the-library)
  - [3. Basic Implementation](#3-basic-implementation)
- [📱 Supported Platforms](#-supported-platforms)
- [🎯 Available Gestures](#-available-gestures)
  - [Basic Gestures](#basic-gestures)
  - [Advanced Gestures](#advanced-gestures)
- [🎮 Haptic Feedback](#-haptic-feedback)
- [🔧 Configuration](#-configuration)
  - [Gesture Engine Configuration](#gesture-engine-configuration)
  - [Custom Gesture Configuration](#custom-gesture-configuration)
- [🎨 SwiftUI Integration](#-swiftui-integration)
  - [View Modifiers](#view-modifiers)
  - [Combined Gestures](#combined-gestures)
- [🚀 Performance Optimization](#-performance-optimization)
  - [Best Practices](#best-practices)
  - [Memory Management](#memory-management)
- [🎯 Accessibility Support](#-accessibility-support)
  - [VoiceOver Integration](#voiceover-integration)
  - [Switch Control Support](#switch-control-support)
- [🔍 Debugging](#-debugging)
  - [Enable Debug Logging](#enable-debug-logging)
  - [Performance Metrics](#performance-metrics)
- [📚 Next Steps](#-next-steps)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🆘 Support](#-support)
<!-- TOC END -->


Welcome to the SwiftUI Gesture Library! This guide will help you get started with advanced gesture recognition in your SwiftUI applications.

## 🚀 Quick Setup

### 1. Installation

Add the library to your project using Swift Package Manager:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "2.1.0")
]
```

### 2. Import the Library

```swift
import SwiftUI
import SwiftUIGestureLibrary
```

### 3. Basic Implementation

```swift
struct ContentView: View {
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 200)
            .customTapGesture {
                print("Tap detected!")
            }
    }
}
```

## 📱 Supported Platforms

- **iOS 15.0+**
- **macOS 12.0+**
- **tvOS 15.0+**
- **watchOS 8.0+**

## 🎯 Available Gestures

### Basic Gestures

1. **Tap Gestures**
   - Single tap
   - Double tap
   - Triple tap

2. **Swipe Gestures**
   - Horizontal swipes
   - Vertical swipes
   - Diagonal swipes

3. **Pinch Gestures**
   - Zoom in/out
   - Scale detection

4. **Rotation Gestures**
   - Clockwise/counterclockwise
   - Angle tracking

### Advanced Gestures

1. **Pan Gestures**
   - Drag with momentum
   - Boundary constraints

2. **Long Press Gestures**
   - Configurable duration
   - Movement tolerance

3. **Multi-Touch Gestures**
   - Complex patterns
   - Touch point tracking

## 🎮 Haptic Feedback

Enable haptic feedback for enhanced user experience:

```swift
struct HapticExampleView: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 150, height: 150)
            .customTapGesture {
                hapticManager.triggerFeedback(for: .tap)
            }
    }
}
```

## 🔧 Configuration

### Gesture Engine Configuration

```swift
@StateObject private var gestureEngine = GestureEngine(
    configuration: GestureConfiguration(
        enableHapticFeedback: true,
        enablePerformanceMonitoring: true,
        maxConcurrentGestures: 3,
        recognitionTimeout: 2.0
    )
)
```

### Custom Gesture Configuration

```swift
.customTapGesture(
    configuration: TapConfiguration(
        numberOfTaps: 2,
        minimumTapDuration: 0.1,
        maximumTapDuration: 0.5,
        maxTimeBetweenTaps: 0.3,
        maxTapDistance: 10.0,
        requireSameLocation: false
    )
) {
    print("Double tap detected!")
}
```

## 🎨 SwiftUI Integration

### View Modifiers

Use the provided view modifiers for easy integration:

```swift
Rectangle()
    .fill(Color.blue)
    .frame(width: 200, height: 200)
    .customTapGesture { /* action */ }
    .customSwipeGesture { direction in /* action */ }
    .customPinchGesture { scale in /* action */ }
    .customRotationGesture(
        onRotationChanged: { angle in /* action */ },
        onRotationEnded: { finalAngle in /* action */ }
    )
```

### Combined Gestures

Combine multiple gestures for complex interactions:

```swift
Rectangle()
    .fill(Color.blue)
    .frame(width: 200, height: 200)
    .customGestures {
        Group {
            customTapGesture { /* tap action */ }
            customSwipeGesture { direction in /* swipe action */ }
            customPinchGesture { scale in /* pinch action */ }
        }
    }
```

## 🚀 Performance Optimization

### Best Practices

1. **Limit Concurrent Gestures**
   ```swift
   GestureConfiguration(maxConcurrentGestures: 2)
   ```

2. **Use Appropriate Timeouts**
   ```swift
   GestureConfiguration(recognitionTimeout: 1.5)
   ```

3. **Enable Performance Monitoring**
   ```swift
   GestureConfiguration(enablePerformanceMonitoring: true)
   ```

### Memory Management

```swift
// Reset gesture engine when switching contexts
.onDisappear {
    gestureEngine.reset()
}
```

## 🎯 Accessibility Support

### VoiceOver Integration

```swift
.customAccessibleGesture("Double tap to activate")
```

### Switch Control Support

```swift
.customVoiceOverGesture("Use switch control to activate gesture")
```

## 🔍 Debugging

### Enable Debug Logging

```swift
GestureConfiguration(enableDebugLogging: true)
```

### Performance Metrics

```swift
let metrics = gestureEngine.getPerformanceMetrics()
print("Average processing time: \(metrics.averageProcessingTime)")
print("Total events processed: \(metrics.totalEventsProcessed)")
print("Recognition accuracy: \(metrics.recognitionAccuracy)")
```

## 📚 Next Steps

1. **Explore Examples**: Check the `Examples/` directory for complete implementations
2. **Read Documentation**: Visit the `Documentation/` directory for detailed guides
3. **Review API Reference**: See `Documentation/APIReference.md` for complete API documentation
4. **Check Migration Guide**: If upgrading, see `Documentation/Migration.md`

## 🤝 Contributing

We welcome contributions! Please see `CONTRIBUTING.md` for guidelines.

## 📄 License

This project is licensed under the MIT License. See `LICENSE` for details.

## 🆘 Support

- **Issues**: Report bugs and feature requests on GitHub
- **Documentation**: Check the `Documentation/` directory
- **Examples**: See the `Examples/` directory for usage patterns

---

Happy coding with SwiftUI Gesture Library! 🎉 