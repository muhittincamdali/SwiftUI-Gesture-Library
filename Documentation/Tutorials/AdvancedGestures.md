# Advanced Gestures Tutorial

<!-- TOC START -->
## Table of Contents
- [Advanced Gestures Tutorial](#advanced-gestures-tutorial)
- [🎯 Complex Gesture Combinations](#-complex-gesture-combinations)
  - [Gesture Chaining](#gesture-chaining)
  - [Conditional Gesture Recognition](#conditional-gesture-recognition)
- [🎮 Custom Gesture Patterns](#-custom-gesture-patterns)
  - [Multi-Touch Pattern Recognition](#multi-touch-pattern-recognition)
  - [Gesture State Monitoring](#gesture-state-monitoring)
- [🎨 Advanced Haptic Feedback](#-advanced-haptic-feedback)
  - [Custom Haptic Patterns](#custom-haptic-patterns)
  - [Gesture-Specific Haptic Feedback](#gesture-specific-haptic-feedback)
- [🚀 Performance Optimization](#-performance-optimization)
  - [Efficient Gesture Handling](#efficient-gesture-handling)
  - [Memory Management](#memory-management)
- [🎯 Accessibility Integration](#-accessibility-integration)
  - [VoiceOver Support](#voiceover-support)
  - [Switch Control Support](#switch-control-support)
- [🔧 Custom Gesture Recognizers](#-custom-gesture-recognizers)
  - [Creating Custom Gestures](#creating-custom-gestures)
  - [Custom Gesture Integration](#custom-gesture-integration)
- [📊 Performance Monitoring](#-performance-monitoring)
  - [Real-time Performance Tracking](#real-time-performance-tracking)
- [🎉 Advanced Examples](#-advanced-examples)
  - [Interactive Photo Viewer](#interactive-photo-viewer)
<!-- TOC END -->


Learn how to create complex and advanced gesture interactions using the SwiftUI Gesture Library.

## 🎯 Complex Gesture Combinations

### Gesture Chaining

Combine multiple gestures to create complex interactions:

```swift
struct ComplexGestureView: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .rotationEffect(.radians(rotation))
            .offset(offset)
            .customPinchGesture { newScale in
                scale = newScale
            }
            .customRotationGesture(
                onRotationChanged: { angle in
                    rotation = angle
                },
                onRotationEnded: { finalAngle in
                    rotation = finalAngle
                }
            )
            .customPanGesture(
                onPanChanged: { translation in
                    offset = translation
                },
                onPanEnded: { translation, velocity in
                    offset = translation
                }
            )
    }
}
```

### Conditional Gesture Recognition

Create gestures that only activate under specific conditions:

```swift
struct ConditionalGestureView: View {
    @State private var isGestureEnabled = true
    @State private var gestureCount = 0
    
    var body: some View {
        VStack {
            Text("Gesture Count: \(gestureCount)")
                .font(.title)
            
            Rectangle()
                .fill(Color.green)
                .frame(width: 150, height: 150)
                .customTapGesture(
                    configuration: TapConfiguration(
                        numberOfTaps: 1,
                        minimumTapDuration: 0.1,
                        maximumTapDuration: 0.5,
                        maxTimeBetweenTaps: 0.3,
                        maxTapDistance: 10.0,
                        requireSameLocation: false
                    )
                ) {
                    if isGestureEnabled {
                        gestureCount += 1
                    }
                }
                .customLongPressGesture(
                    configuration: LongPressConfiguration(
                        minimumPressDuration: 1.0,
                        maximumPressDuration: 3.0,
                        maximumMovementDistance: 5.0,
                        enableHapticFeedback: true,
                        numberOfTouchesRequired: 1
                    )
                ) {
                    isGestureEnabled.toggle()
                }
        }
    }
}
```

## 🎮 Custom Gesture Patterns

### Multi-Touch Pattern Recognition

Create custom multi-touch gesture patterns:

```swift
struct MultiTouchPatternView: View {
    @State private var detectedPattern: String = "None"
    
    var body: some View {
        VStack {
            Text("Detected Pattern: \(detectedPattern)")
                .font(.title2)
                .padding()
            
            Rectangle()
                .fill(Color.purple)
                .frame(width: 300, height: 300)
                .customMultiTouchGesture(
                    configuration: MultiTouchConfiguration(
                        minimumTouchPoints: 2,
                        maximumTouchPoints: 5,
                        minimumHistorySize: 3,
                        maxHistorySize: 10,
                        enablePatternRecognition: true
                    )
                ) { pattern, touchPoints in
                    switch pattern {
                    case .pinch:
                        detectedPattern = "Pinch"
                    case .rotation:
                        detectedPattern = "Rotation"
                    case .spread:
                        detectedPattern = "Spread"
                    case .custom:
                        detectedPattern = "Custom Pattern"
                    }
                }
        }
    }
}
```

### Gesture State Monitoring

Monitor gesture states for advanced interactions:

```swift
struct GestureStateMonitorView: View {
    @StateObject private var gestureEngine = GestureEngine()
    @State private var currentState: String = "Idle"
    
    var body: some View {
        VStack {
            Text("Gesture State: \(currentState)")
                .font(.title2)
                .padding()
            
            Rectangle()
                .fill(Color.orange)
                .frame(width: 200, height: 200)
                .customGestureStateMonitor { state in
                    switch state {
                    case .idle:
                        currentState = "Idle"
                    case .singleGesture(let recognizer):
                        currentState = "Single Gesture: \(recognizer.type)"
                    case .multiGesture(let recognizers):
                        currentState = "Multi Gesture: \(recognizers.count) gestures"
                    }
                }
                .customTapGesture {
                    // Tap action
                }
                .customSwipeGesture { direction in
                    // Swipe action
                }
        }
    }
}
```

## 🎨 Advanced Haptic Feedback

### Custom Haptic Patterns

Create sophisticated haptic feedback patterns:

```swift
struct AdvancedHapticView: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
                .customTapGesture {
                    hapticManager.triggerFeedback(for: .tap)
                }
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .customLongPressGesture {
                    hapticManager.triggerCustomFeedback(intensity: 0.8)
                }
            
            Rectangle()
                .fill(Color.green)
                .frame(width: 100, height: 100)
                .customPinchGesture { scale in
                    if scale > 1.5 {
                        hapticManager.triggerCustomFeedback(intensity: 1.0)
                    }
                }
        }
    }
}
```

### Gesture-Specific Haptic Feedback

Provide different haptic feedback for different gestures:

```swift
struct GestureSpecificHapticView: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    var body: some View {
        Rectangle()
            .fill(Color.cyan)
            .frame(width: 250, height: 250)
            .customTapGesture {
                hapticManager.triggerFeedback(for: .tap)
            }
            .customSwipeGesture { direction in
                switch direction {
                case .left, .right:
                    hapticManager.triggerCustomFeedback(intensity: 0.6)
                case .up, .down:
                    hapticManager.triggerCustomFeedback(intensity: 0.8)
                default:
                    hapticManager.triggerCustomFeedback(intensity: 1.0)
                }
            }
            .customPinchGesture { scale in
                if scale > 2.0 {
                    hapticManager.triggerCustomFeedback(intensity: 1.0)
                } else if scale < 0.5 {
                    hapticManager.triggerCustomFeedback(intensity: 0.4)
                }
            }
    }
}
```

## 🚀 Performance Optimization

### Efficient Gesture Handling

Optimize gesture performance for smooth interactions:

```swift
struct OptimizedGestureView: View {
    @StateObject private var gestureEngine = GestureEngine(
        configuration: GestureConfiguration(
            enableHapticFeedback: true,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: 2,
            recognitionTimeout: 1.5
        )
    )
    
    var body: some View {
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 200, height: 200)
            .customTapGesture {
                // Optimized tap handling
            }
            .customPanGesture(
                onPanChanged: { translation in
                    // Real-time pan updates
                },
                onPanEnded: { translation, velocity in
                    // Final pan state
                }
            )
            .onDisappear {
                gestureEngine.reset()
            }
    }
}
```

### Memory Management

Proper memory management for gesture recognizers:

```swift
struct MemoryOptimizedView: View {
    @StateObject private var gestureEngine = GestureEngine()
    
    var body: some View {
        Rectangle()
            .fill(Color.magenta)
            .frame(width: 200, height: 200)
            .customGestures {
                Group {
                    customTapGesture {
                        // Tap action
                    }
                    customSwipeGesture { direction in
                        // Swipe action
                    }
                }
            }
            .onDisappear {
                // Clean up resources
                gestureEngine.reset()
            }
    }
}
```

## 🎯 Accessibility Integration

### VoiceOver Support

Make gestures accessible to VoiceOver users:

```swift
struct AccessibleGestureView: View {
    var body: some View {
        Rectangle()
            .fill(Color.teal)
            .frame(width: 200, height: 200)
            .customAccessibleGesture("Double tap to activate special feature")
            .customTapGesture(
                configuration: TapConfiguration(numberOfTaps: 2)
            ) {
                // Accessible tap action
            }
    }
}
```

### Switch Control Support

Support switch control for users with motor impairments:

```swift
struct SwitchControlGestureView: View {
    var body: some View {
        Rectangle()
            .fill(Color.indigo)
            .frame(width: 200, height: 200)
            .customVoiceOverGesture("Use switch control to activate gesture")
            .customLongPressGesture(
                configuration: LongPressConfiguration(
                    minimumPressDuration: 2.0,
                    maximumPressDuration: 5.0,
                    maximumMovementDistance: 20.0,
                    enableHapticFeedback: true,
                    numberOfTouchesRequired: 1
                )
            ) {
                // Switch control action
            }
    }
}
```

## 🔧 Custom Gesture Recognizers

### Creating Custom Gestures

Build your own gesture recognizers:

```swift
class CustomGestureRecognizer: GestureRecognizer {
    private var touchEvents: [TouchEvent] = []
    private let minimumEvents: Int = 5
    
    override func validateGesture() -> Bool {
        return touchEvents.count >= minimumEvents
    }
    
    override func checkForRecognition() {
        if isValidGesture() {
            state = .recognized
        }
    }
    
    override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        touchEvents.append(event)
    }
    
    override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        touchEvents.append(event)
    }
    
    override func reset() {
        super.reset()
        touchEvents.removeAll()
    }
}
```

### Custom Gesture Integration

Integrate custom gestures with SwiftUI:

```swift
struct CustomGestureView: View {
    @StateObject private var customRecognizer = CustomGestureRecognizer()
    
    var body: some View {
        Rectangle()
            .fill(Color.brown)
            .frame(width: 200, height: 200)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let event = TouchEvent(
                            location: value.location,
                            timestamp: value.time.timeIntervalSince1970,
                            phase: .moved,
                            pressure: 1.0,
                            type: .finger
                        )
                        customRecognizer.processTouchEvent(event)
                    }
            )
    }
}
```

## 📊 Performance Monitoring

### Real-time Performance Tracking

Monitor gesture performance in real-time:

```swift
struct PerformanceMonitorView: View {
    @StateObject private var gestureEngine = GestureEngine(
        configuration: GestureConfiguration(
            enablePerformanceMonitoring: true
        )
    )
    @State private var metrics: PerformanceMetrics?
    
    var body: some View {
        VStack {
            if let metrics = metrics {
                Text("Avg Processing Time: \(String(format: "%.3f", metrics.averageProcessingTime))s")
                Text("Total Events: \(metrics.totalEventsProcessed)")
                Text("Accuracy: \(String(format: "%.1f", metrics.recognitionAccuracy * 100))%")
            }
            
            Rectangle()
                .fill(Color.pink)
                .frame(width: 200, height: 200)
                .customTapGesture {
                    self.metrics = gestureEngine.getPerformanceMetrics()
                }
        }
    }
}
```

## 🎉 Advanced Examples

### Interactive Photo Viewer

Create an interactive photo viewer with advanced gestures:

```swift
struct InteractivePhotoViewer: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    @State private var isZoomed = false
    
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .rotationEffect(.radians(rotation))
                .offset(offset)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .customPinchGesture { newScale in
                    scale = newScale
                    isZoomed = newScale > 1.0
                }
                .customRotationGesture(
                    onRotationChanged: { angle in
                        rotation = angle
                    },
                    onRotationEnded: { finalAngle in
                        rotation = finalAngle
                    }
                )
                .customPanGesture(
                    onPanChanged: { translation in
                        if isZoomed {
                            offset = translation
                        }
                    },
                    onPanEnded: { translation, velocity in
                        if isZoomed {
                            offset = translation
                        }
                    }
                )
                .customDoubleTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if isZoomed {
                            scale = 1.0
                            offset = .zero
                            isZoomed = false
                        } else {
                            scale = 2.0
                            isZoomed = true
                        }
                    }
                }
        }
    }
}
```

This tutorial covers advanced gesture techniques that will help you create sophisticated and responsive user interactions in your SwiftUI applications.

For more examples and detailed implementation patterns, see the `Examples/` directory. 