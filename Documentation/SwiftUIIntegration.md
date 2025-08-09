# SwiftUI Integration Documentation

<!-- TOC START -->
## Table of Contents
- [SwiftUI Integration Documentation](#swiftui-integration-documentation)
- [Overview](#overview)
- [Basic Integration](#basic-integration)
  - [Import the Library](#import-the-library)
  - [Simple Gesture Integration](#simple-gesture-integration)
- [View Modifiers](#view-modifiers)
  - [Tap Gestures](#tap-gestures)
  - [Swipe Gestures](#swipe-gestures)
  - [Pinch Gestures](#pinch-gestures)
  - [Rotation Gestures](#rotation-gestures)
  - [Pan Gestures](#pan-gestures)
  - [Long Press Gestures](#long-press-gestures)
  - [Multi-Touch Gestures](#multi-touch-gestures)
- [Combined Gestures](#combined-gestures)
  - [Multiple Gestures on Same View](#multiple-gestures-on-same-view)
  - [Gesture Chaining](#gesture-chaining)
- [State Management](#state-management)
  - [Gesture State Monitoring](#gesture-state-monitoring)
  - [Haptic Feedback Integration](#haptic-feedback-integration)
- [Configuration](#configuration)
  - [Gesture Engine Configuration](#gesture-engine-configuration)
  - [Custom Gesture Configuration](#custom-gesture-configuration)
- [Accessibility Support](#accessibility-support)
  - [VoiceOver Integration](#voiceover-integration)
  - [Switch Control Support](#switch-control-support)
- [Performance Optimization](#performance-optimization)
  - [Memory Management](#memory-management)
  - [Performance Monitoring](#performance-monitoring)
- [Advanced Patterns](#advanced-patterns)
  - [Conditional Gestures](#conditional-gestures)
  - [Gesture with Animation](#gesture-with-animation)
  - [Complex Gesture Combinations](#complex-gesture-combinations)
- [Error Handling](#error-handling)
  - [Gesture Error Handling](#gesture-error-handling)
- [Testing](#testing)
  - [Unit Testing Gestures](#unit-testing-gestures)
  - [UI Testing](#ui-testing)
- [Best Practices](#best-practices)
- [Examples](#examples)
  - [Complete Example](#complete-example)
<!-- TOC END -->


Complete guide to integrating SwiftUI Gesture Library with SwiftUI applications.

## Overview

The SwiftUI Gesture Library provides seamless integration with SwiftUI through custom view modifiers and extensions.

## Basic Integration

### Import the Library

```swift
import SwiftUI
import SwiftUIGestureLibrary
```

### Simple Gesture Integration

```swift
struct BasicGestureView: View {
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

## View Modifiers

### Tap Gestures

```swift
.customTapGesture {
    // Single tap action
}

.customDoubleTapGesture {
    // Double tap action
}

.customTapGesture(configuration: TapConfiguration(numberOfTaps: 3)) {
    // Triple tap action
}
```

### Swipe Gestures

```swift
.customSwipeGesture { direction in
    // Swipe action with direction
}

.customHorizontalSwipeGesture { direction in
    // Horizontal swipe only
}

.customVerticalSwipeGesture { direction in
    // Vertical swipe only
}
```

### Pinch Gestures

```swift
.customPinchGesture { scale in
    // Pinch action with scale
}

.customPrecisePinchGesture { scale in
    // Precise pinch with higher accuracy
}
```

### Rotation Gestures

```swift
.customRotationGesture(
    onRotationChanged: { angle in
        // Continuous rotation updates
    },
    onRotationEnded: { finalAngle in
        // Final rotation value
    }
)
```

### Pan Gestures

```swift
.customPanGesture(
    onPanChanged: { translation in
        // Continuous pan updates
    },
    onPanEnded: { translation, velocity in
        // Final pan with velocity
    }
)
```

### Long Press Gestures

```swift
.customLongPressGesture {
    // Long press action
}

.customLongPressGesture(
    configuration: LongPressConfiguration(
        minimumPressDuration: 1.0,
        maximumMovementDistance: 10.0
    )
) {
    // Custom long press
}
```

### Multi-Touch Gestures

```swift
.customMultiTouchGesture { pattern, touchPoints in
    // Multi-touch pattern recognition
}
```

## Combined Gestures

### Multiple Gestures on Same View

```swift
Rectangle()
    .fill(Color.blue)
    .frame(width: 200, height: 200)
    .customTapGesture {
        print("Tap detected")
    }
    .customSwipeGesture { direction in
        print("Swipe detected: \(direction)")
    }
    .customPinchGesture { scale in
        print("Pinch detected: \(scale)")
    }
```

### Gesture Chaining

```swift
.customGestures {
    Group {
        customTapGesture {
            // Tap action
        }
        customSwipeGesture { direction in
            // Swipe action
        }
        customPinchGesture { scale in
            // Pinch action
        }
    }
}
```

## State Management

### Gesture State Monitoring

```swift
.customGestureStateMonitor { state in
    switch state {
    case .idle:
        print("No active gesture")
    case .singleGesture(let recognizer):
        print("Single gesture: \(recognizer.type)")
    case .multiGesture(let recognizers):
        print("Multiple gestures: \(recognizers.count)")
    }
}
```

### Haptic Feedback Integration

```swift
.customHapticFeedback(hapticManager)
```

## Configuration

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
    // Custom tap configuration
}
```

## Accessibility Support

### VoiceOver Integration

```swift
.customAccessibleGesture("Double tap to activate feature")
```

### Switch Control Support

```swift
.customVoiceOverGesture("Use switch control to activate gesture")
```

## Performance Optimization

### Memory Management

```swift
.onDisappear {
    gestureEngine.reset()
}
```

### Performance Monitoring

```swift
.onAppear {
    let metrics = gestureEngine.getPerformanceMetrics()
    print("Performance: \(metrics)")
}
```

## Advanced Patterns

### Conditional Gestures

```swift
struct ConditionalGestureView: View {
    @State private var isGestureEnabled = true
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 200)
            .customTapGesture {
                if isGestureEnabled {
                    // Perform action
                }
            }
    }
}
```

### Gesture with Animation

```swift
struct AnimatedGestureView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .customPinchGesture { newScale in
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = newScale
                }
            }
    }
}
```

### Complex Gesture Combinations

```swift
struct ComplexGestureView: View {
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    
    var body: some View {
        Rectangle()
            .fill(Color.purple)
            .frame(width: 200, height: 200)
            .offset(offset)
            .scaleEffect(scale)
            .rotationEffect(.radians(rotation))
            .customPanGesture(
                onPanChanged: { translation in
                    offset = translation
                }
            )
            .customPinchGesture { newScale in
                scale = newScale
            }
            .customRotationGesture(
                onRotationChanged: { angle in
                    rotation = angle
                }
            )
    }
}
```

## Error Handling

### Gesture Error Handling

```swift
.customTapGesture {
    // Handle successful tap
}
.onGestureError { error in
    switch error {
    case .invalidGesture:
        print("Invalid gesture detected")
    case .timeout:
        print("Gesture timeout")
    case .insufficientTouchEvents:
        print("Insufficient touch events")
    default:
        print("Unknown gesture error")
    }
}
```

## Testing

### Unit Testing Gestures

```swift
import XCTest
@testable import SwiftUIGestureLibrary

class GestureTests: XCTestCase {
    func testTapGesture() {
        let recognizer = TapGestureRecognizer()
        // Test tap gesture recognition
    }
}
```

### UI Testing

```swift
import XCTest

class GestureUITests: XCTestCase {
    func testTapGestureInUI() {
        let app = XCUIApplication()
        app.launch()
        
        let tapArea = app.otherElements["tapArea"]
        tapArea.tap()
        
        // Verify tap was detected
    }
}
```

## Best Practices

1. **Use Appropriate Modifiers**: Choose the right gesture modifier for your use case
2. **Handle State Properly**: Manage gesture state and cleanup resources
3. **Consider Performance**: Monitor gesture performance and optimize when needed
4. **Test Thoroughly**: Test gestures on different devices and conditions
5. **Accessibility First**: Ensure gestures work with accessibility features
6. **Error Handling**: Always handle potential gesture errors
7. **Memory Management**: Reset gesture engines when views disappear

## Examples

### Complete Example

```swift
struct CompleteGestureExample: View {
    @StateObject private var gestureEngine = GestureEngine()
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    @State private var offset = CGSize.zero
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .scaleEffect(scale)
                        .rotationEffect(.radians(rotation))
                        .offset(offset)
                        .shadow(radius: 10)
                    
                    VStack {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("Interactive Gestures")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .customPinchGesture { newScale in
                    scale = newScale
                    hapticManager.triggerFeedback(for: .pinch)
                }
                .customRotationGesture(
                    onRotationChanged: { angle in
                        rotation = angle
                    },
                    onRotationEnded: { finalAngle in
                        rotation = finalAngle
                        hapticManager.triggerFeedback(for: .rotation)
                    }
                )
                .customPanGesture(
                    onPanChanged: { translation in
                        offset = translation
                    },
                    onPanEnded: { translation, velocity in
                        offset = translation
                        hapticManager.triggerFeedback(for: .pan)
                    }
                )
                .customDoubleTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scale = 1.0
                        rotation = 0.0
                        offset = .zero
                    }
                    hapticManager.triggerFeedback(for: .tap)
                }
                
                Button("Reset") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scale = 1.0
                        rotation = 0.0
                        offset = .zero
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("SwiftUI Integration")
        }
    }
}
```

For more examples and detailed implementation patterns, see the `Examples/` directory. 