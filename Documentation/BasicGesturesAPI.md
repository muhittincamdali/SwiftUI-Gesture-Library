# 👆 Basic Gestures API

## Overview

The Basic Gestures API provides essential gesture recognition for common touch interactions including tap, long press, and touch events.

## Core Classes

### TapGestureManager

Manages tap gesture recognition and handling.

```swift
class TapGestureManager {
    // MARK: - Properties
    private var configuration: TapGestureConfiguration
    private var activeGestures: [TapGesture]
    
    // MARK: - Initialization
    init()
    
    // MARK: - Configuration
    func configure(_ config: TapGestureConfiguration)
    
    // MARK: - Gesture Management
    func addSingleTapGesture(to view: UIView, gesture: SingleTapGesture, completion: @escaping (Result<TapResult, GestureError>) -> Void)
    func addDoubleTapGesture(to view: UIView, gesture: DoubleTapGesture, completion: @escaping (Result<TapResult, GestureError>) -> Void)
    func addTripleTapGesture(to view: UIView, gesture: TripleTapGesture, completion: @escaping (Result<TapResult, GestureError>) -> Void)
    func addMultiTapGesture(to view: UIView, gesture: MultiTapGesture, completion: @escaping (Result<TapResult, GestureError>) -> Void)
    
    // MARK: - Utility
    func removeAllGestures()
    func getActiveGestureCount() -> Int
}
```

### LongPressGestureManager

Manages long press gesture recognition and handling.

```swift
class LongPressGestureManager {
    // MARK: - Properties
    private var configuration: LongPressGestureConfiguration
    private var activeGestures: [LongPressGesture]
    
    // MARK: - Initialization
    init()
    
    // MARK: - Configuration
    func configure(_ config: LongPressGestureConfiguration)
    
    // MARK: - Gesture Management
    func addLongPressGesture(to view: UIView, gesture: LongPressGesture, completion: @escaping (Result<LongPressResult, GestureError>) -> Void)
    func addVariableLongPressGesture(to view: UIView, gesture: VariableLongPressGesture, completion: @escaping (Result<VariableLongPressResult, GestureError>) -> Void)
    
    // MARK: - Utility
    func removeAllGestures()
    func getActiveGestureCount() -> Int
}
```

## Configuration Classes

### TapGestureConfiguration

```swift
struct TapGestureConfiguration {
    var enableSingleTap: Bool = true
    var enableDoubleTap: Bool = true
    var enableTripleTap: Bool = false
    var enableMultiTap: Bool = false
    
    var minimumTapDuration: TimeInterval = 0.1
    var maximumTapDuration: TimeInterval = 0.5
    var maximumTapDistance: CGFloat = 50.0
    
    var enableHapticFeedback: Bool = true
    var enableVisualFeedback: Bool = true
}
```

### LongPressGestureConfiguration

```swift
struct LongPressGestureConfiguration {
    var enableMinimumDuration: Bool = true
    var enableMaximumDistance: Bool = true
    var enablePressureSensitivity: Bool = true
    var enableHapticFeedback: Bool = true
    
    var defaultMinimumDuration: TimeInterval = 0.5
    var defaultMaximumDistance: CGFloat = 10.0
    var defaultPressureSensitivity: Float = 0.5
}
```

## Gesture Classes

### SingleTapGesture

```swift
struct SingleTapGesture {
    let count: Int
    let minimumDuration: TimeInterval
    let maximumDuration: TimeInterval
    
    init(count: Int = 1, minimumDuration: TimeInterval = 0.1, maximumDuration: TimeInterval = 0.5)
}
```

### DoubleTapGesture

```swift
struct DoubleTapGesture {
    let count: Int
    let minimumDuration: TimeInterval
    let maximumDuration: TimeInterval
    let maximumDistance: CGFloat
    
    init(count: Int = 2, minimumDuration: TimeInterval = 0.1, maximumDuration: TimeInterval = 0.5, maximumDistance: CGFloat = 50.0)
}
```

### LongPressGesture

```swift
struct LongPressGesture {
    let minimumDuration: TimeInterval
    let maximumDistance: CGFloat
    let pressureSensitivity: Float
    
    init(minimumDuration: TimeInterval = 0.5, maximumDistance: CGFloat = 10.0, pressureSensitivity: Float = 0.5)
}
```

### VariableLongPressGesture

```swift
struct VariableLongPressGesture {
    let minimumDuration: TimeInterval
    let maximumDuration: TimeInterval
    let pressureSensitivity: Float
    
    init(minimumDuration: TimeInterval = 0.3, maximumDuration: TimeInterval = 2.0, pressureSensitivity: Float = 0.3)
}
```

## Result Classes

### TapResult

```swift
struct TapResult {
    let location: CGPoint
    let timestamp: TimeInterval
    let count: Int
    let duration: TimeInterval
    let pressure: Float
}
```

### LongPressResult

```swift
struct LongPressResult {
    let location: CGPoint
    let duration: TimeInterval
    let pressure: Float
    let intensity: Float
}
```

### VariableLongPressResult

```swift
struct VariableLongPressResult {
    let location: CGPoint
    let duration: TimeInterval
    let pressure: Float
    let intensity: Float
    let variableDuration: TimeInterval
}
```

## Usage Examples

### Single Tap Gesture

```swift
// Create tap gesture manager
let tapGestureManager = TapGestureManager()

// Configure tap gestures
let tapConfig = TapGestureConfiguration()
tapConfig.enableSingleTap = true
tapConfig.enableDoubleTap = true
tapConfig.enableHapticFeedback = true

// Setup tap gesture manager
tapGestureManager.configure(tapConfig)

// Create single tap gesture
let singleTapGesture = SingleTapGesture(
    count: 1,
    minimumDuration: 0.1,
    maximumDuration: 0.5
)

// Add single tap gesture
tapGestureManager.addSingleTapGesture(
    to: customView,
    gesture: singleTapGesture
) { result in
    switch result {
    case .success(let tap):
        print("✅ Single tap detected")
        print("Location: \(tap.location)")
        print("Timestamp: \(tap.timestamp)")
    case .failure(let error):
        print("❌ Single tap gesture failed: \(error)")
    }
}
```

### Double Tap Gesture

```swift
// Create double tap gesture
let doubleTapGesture = DoubleTapGesture(
    count: 2,
    minimumDuration: 0.1,
    maximumDuration: 0.5,
    maximumDistance: 50.0
)

// Add double tap gesture
tapGestureManager.addDoubleTapGesture(
    to: customView,
    gesture: doubleTapGesture
) { result in
    switch result {
    case .success(let tap):
        print("✅ Double tap detected")
        print("Location: \(tap.location)")
        print("Interval: \(tap.duration)s")
    case .failure(let error):
        print("❌ Double tap gesture failed: \(error)")
    }
}
```

### Long Press Gesture

```swift
// Create long press gesture manager
let longPressGestureManager = LongPressGestureManager()

// Configure long press gestures
let longPressConfig = LongPressGestureConfiguration()
longPressConfig.enableMinimumDuration = true
longPressConfig.enableMaximumDistance = true
longPressConfig.enablePressureSensitivity = true
longPressConfig.enableHapticFeedback = true

// Setup long press gesture manager
longPressGestureManager.configure(longPressConfig)

// Create long press gesture
let longPressGesture = LongPressGesture(
    minimumDuration: 0.5,
    maximumDistance: 10.0,
    pressureSensitivity: 0.5
)

// Add long press gesture
longPressGestureManager.addLongPressGesture(
    to: customView,
    gesture: longPressGesture
) { result in
    switch result {
    case .success(let press):
        print("✅ Long press detected")
        print("Location: \(press.location)")
        print("Duration: \(press.duration)s")
        print("Pressure: \(press.pressure)")
    case .failure(let error):
        print("❌ Long press gesture failed: \(error)")
    }
}
```

### Variable Long Press Gesture

```swift
// Create variable long press gesture
let variableLongPressGesture = VariableLongPressGesture(
    minimumDuration: 0.3,
    maximumDuration: 2.0,
    pressureSensitivity: 0.3
)

// Add variable long press gesture
longPressGestureManager.addVariableLongPressGesture(
    to: customView,
    gesture: variableLongPressGesture
) { result in
    switch result {
    case .success(let press):
        print("✅ Variable long press detected")
        print("Duration: \(press.duration)s")
        print("Intensity: \(press.intensity)")
    case .failure(let error):
        print("❌ Variable long press gesture failed: \(error)")
    }
}
```

## Error Handling

### GestureError

```swift
enum GestureError: Error {
    case invalidConfiguration
    case gestureNotFound
    case recognitionFailed
    case timeout
    case cancelled
}
```

### Error Handling Example

```swift
tapGestureManager.addSingleTapGesture(
    to: customView,
    gesture: singleTapGesture
) { result in
    switch result {
    case .success(let tap):
        // Handle successful tap
        handleTap(tap)
    case .failure(let error):
        switch error {
        case .invalidConfiguration:
            print("Invalid gesture configuration")
        case .gestureNotFound:
            print("Gesture not found")
        case .recognitionFailed:
            print("Gesture recognition failed")
        case .timeout:
            print("Gesture timeout")
        case .cancelled:
            print("Gesture cancelled")
        }
    }
}
```

## Performance Considerations

### Memory Management

- Gesture managers automatically clean up resources
- Gesture recognizers are weakly referenced
- Configuration objects are lightweight

### Thread Safety

- All public methods are thread-safe
- Gesture recognition runs on the main thread
- Completion handlers are called on the main thread

### Battery Optimization

- Gesture recognition is optimized for battery life
- Inactive gestures are automatically paused
- Haptic feedback can be disabled to save battery

## Best Practices

### 1. Configure Before Use

```swift
// ✅ Good: Configure before adding gestures
let config = TapGestureConfiguration()
config.enableSingleTap = true
tapGestureManager.configure(config)

// ❌ Avoid: Adding gestures without configuration
tapGestureManager.addSingleTapGesture(...)
```

### 2. Handle Errors Gracefully

```swift
// ✅ Good: Proper error handling
tapGestureManager.addSingleTapGesture(...) { result in
    switch result {
    case .success(let tap):
        handleTap(tap)
    case .failure(let error):
        handleError(error)
    }
}
```

### 3. Clean Up Resources

```swift
// ✅ Good: Clean up when done
deinit {
    tapGestureManager.removeAllGestures()
    longPressGestureManager.removeAllGestures()
}
```

## Related Documentation

- [Advanced Gestures API](AdvancedGesturesAPI.md)
- [Custom Gestures API](CustomGesturesAPI.md)
- [Gesture Training API](GestureTrainingAPI.md)
- [Performance API](PerformanceAPI.md)
