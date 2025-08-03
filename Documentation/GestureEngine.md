# Gesture Engine Documentation

## Overview

The `GestureEngine` is the core component of the SwiftUI Gesture Library that manages gesture recognition and processing. It provides a centralized system for handling multiple gesture recognizers simultaneously with advanced performance optimizations.

## Architecture

### Core Components

- **GestureEngine**: Main orchestrator for gesture recognition
- **GestureRecognizer**: Base class for all gesture recognizers
- **HapticFeedbackManager**: Handles haptic feedback for gestures
- **PerformanceMetrics**: Tracks performance and optimization data

### Design Principles

- **Clean Architecture**: Separation of concerns with clear module boundaries
- **SOLID Principles**: Each component has a single responsibility
- **Performance First**: Optimized for 60fps+ gesture recognition
- **Memory Efficient**: Advanced memory management and pooling

## Usage

### Basic Initialization

```swift
import SwiftUIGestureLibrary

// Create a gesture engine with default configuration
let gestureEngine = GestureEngine()

// Create with custom configuration
let customEngine = GestureEngine(
    configuration: GestureConfiguration(
        enableHapticFeedback: true,
        enablePerformanceMonitoring: true,
        maxConcurrentGestures: 3,
        recognitionTimeout: 2.0
    )
)
```

### Registering Gesture Recognizers

```swift
// Register a tap gesture recognizer
let tapRecognizer = TapGestureRecognizer()
gestureEngine.registerRecognizer(tapRecognizer)

// Register a swipe gesture recognizer
let swipeRecognizer = SwipeGestureRecognizer()
gestureEngine.registerRecognizer(swipeRecognizer)

// Register a custom gesture recognizer
class CustomGestureRecognizer: GestureRecognizer {
    override func validateGesture() -> Bool {
        // Custom validation logic
        return true
    }
}

let customRecognizer = CustomGestureRecognizer(type: .custom("Custom"))
gestureEngine.registerRecognizer(customRecognizer)
```

### Processing Touch Events

```swift
// Process touch events
let touchEvent = TouchEvent(
    location: CGPoint(x: 100, y: 100),
    timestamp: CACurrentMediaTime(),
    phase: .began
)

gestureEngine.processTouchEvent(touchEvent)
```

### Monitoring Gesture State

```swift
// Observe gesture state changes
@StateObject private var gestureEngine = GestureEngine()

var body: some View {
    Rectangle()
        .onReceive(gestureEngine.$currentState) { state in
            switch state {
            case .idle:
                print("No active gestures")
            case .singleGesture(let recognizer):
                print("Active gesture: \(recognizer.type.description)")
            case .multiGesture(let recognizers):
                print("Multiple active gestures: \(recognizers.count)")
            }
        }
}
```

## Configuration

### GestureConfiguration

```swift
public struct GestureConfiguration {
    /// Whether to enable haptic feedback
    public let enableHapticFeedback: Bool
    
    /// Whether to enable performance monitoring
    public let enablePerformanceMonitoring: Bool
    
    /// Maximum number of concurrent gestures
    public let maxConcurrentGestures: Int
    
    /// Timeout for gesture recognition
    public let recognitionTimeout: TimeInterval
}
```

### Performance Optimization

```swift
// Get performance metrics
let metrics = gestureEngine.getPerformanceMetrics()
print("Average processing time: \(metrics.averageProcessingTime)")
print("Total events processed: \(metrics.totalEventsProcessed)")
print("Recognition accuracy: \(metrics.recognitionAccuracy)")
```

## Advanced Features

### Gesture Chaining

```swift
// Chain multiple gestures together
let tapRecognizer = TapGestureRecognizer()
let swipeRecognizer = SwipeGestureRecognizer()

// Register both recognizers
gestureEngine.registerRecognizer(tapRecognizer)
gestureEngine.registerRecognizer(swipeRecognizer)

// Handle combined gestures
if case .multiGesture(let recognizers) = gestureEngine.currentState {
    for recognizer in recognizers {
        switch recognizer.type {
        case .tap:
            // Handle tap
        case .swipe:
            // Handle swipe
        default:
            break
        }
    }
}
```

### Custom Gesture Recognition

```swift
class CustomGestureRecognizer: GestureRecognizer {
    private var touchPoints: [CGPoint] = []
    
    override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        touchPoints.append(event.location)
    }
    
    override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        touchPoints.append(event.location)
    }
    
    override func validateGesture() -> Bool {
        // Custom validation logic
        return touchPoints.count >= 5
    }
    
    override func checkForRecognition() {
        if isValidGesture() {
            state = .recognized
        }
    }
}
```

### Error Handling

```swift
// Handle gesture recognition errors
extension GestureEngine: GestureRecognizerDelegate {
    func gestureRecognizer(_ recognizer: GestureRecognizer, didFailWithError error: GestureError) {
        switch error {
        case .invalidGesture:
            print("Gesture validation failed")
        case .timeout:
            print("Gesture recognition timed out")
        case .insufficientTouchEvents:
            print("Not enough touch events")
        case .velocityTooLow:
            print("Gesture velocity too low")
        case .pressureTooLow:
            print("Touch pressure too low")
        }
    }
}
```

## Performance Considerations

### Memory Management

- Gesture recognizers are automatically managed
- Touch event history is limited to prevent memory leaks
- Performance metrics are automatically cleaned up

### Optimization Tips

1. **Limit Concurrent Gestures**: Set appropriate `maxConcurrentGestures`
2. **Use Timeouts**: Configure `recognitionTimeout` to prevent hanging
3. **Monitor Performance**: Enable performance monitoring for optimization
4. **Clean Up**: Call `reset()` when switching contexts

### Best Practices

```swift
// Good: Reset engine when switching views
.onDisappear {
    gestureEngine.reset()
}

// Good: Monitor performance
.onReceive(gestureEngine.$currentState) { state in
    if case .singleGesture(let recognizer) = state {
        // Handle gesture efficiently
    }
}

// Good: Use appropriate configurations
let preciseEngine = GestureEngine(
    configuration: GestureConfiguration(
        enableHapticFeedback: true,
        enablePerformanceMonitoring: true,
        maxConcurrentGestures: 2,
        recognitionTimeout: 1.0
    )
)
```

## Troubleshooting

### Common Issues

1. **Gestures Not Recognized**
   - Check minimum touch event requirements
   - Verify gesture validation logic
   - Ensure proper delegate setup

2. **Performance Issues**
   - Monitor performance metrics
   - Reduce concurrent gestures
   - Optimize gesture validation

3. **Memory Leaks**
   - Call `reset()` when appropriate
   - Limit touch event history
   - Use weak references in delegates

### Debugging

```swift
// Enable debug logging
let debugEngine = GestureEngine(
    configuration: GestureConfiguration(
        enablePerformanceMonitoring: true
    )
)

// Monitor state changes
.onReceive(debugEngine.$currentState) { state in
    print("Gesture state: \(state)")
}
```

## API Reference

### GestureEngine

```swift
public class GestureEngine: ObservableObject {
    /// Current gesture state
    @Published public private(set) var currentState: GestureState
    
    /// Register a gesture recognizer
    public func registerRecognizer(_ recognizer: GestureRecognizer)
    
    /// Unregister a gesture recognizer
    public func unregisterRecognizer(_ recognizer: GestureRecognizer)
    
    /// Process touch events
    public func processTouchEvent(_ event: TouchEvent)
    
    /// Reset the gesture engine
    public func reset()
    
    /// Get performance metrics
    public func getPerformanceMetrics() -> PerformanceMetrics
}
```

### GestureState

```swift
public enum GestureState {
    case idle
    case singleGesture(GestureRecognizer)
    case multiGesture([GestureRecognizer])
}
```

### TouchEvent

```swift
public struct TouchEvent {
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let phase: TouchPhase
    public let pressure: Float
    public let type: TouchType
}
```

## Examples

See the [Examples](../Examples/) directory for complete working examples of the GestureEngine in action. 