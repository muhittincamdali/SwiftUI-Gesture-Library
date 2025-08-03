# Gesture Recognizers API Reference

Complete API reference for all gesture recognizers in the SwiftUI Gesture Library.

## Core Gesture Recognizers

### TapGestureRecognizer

Recognizes tap gestures with configurable parameters.

```swift
public class TapGestureRecognizer: GestureRecognizer {
    public init(configuration: TapConfiguration = .default)
    public func getCurrentScale() -> CGFloat
    public func getScaleChange() -> CGFloat
    public func getPinchCenter() -> CGPoint?
}
```

**Configuration Options:**
- `numberOfTaps`: Number of taps required (1, 2, 3)
- `minimumTapDuration`: Minimum duration for a tap
- `maximumTapDuration`: Maximum duration for a tap
- `maxTimeBetweenTaps`: Maximum time between taps for multi-tap
- `maxTapDistance`: Maximum distance between taps
- `requireSameLocation`: Whether taps must be at the same location

**Usage Example:**
```swift
let tapRecognizer = TapGestureRecognizer(
    configuration: TapConfiguration(
        numberOfTaps: 2,
        minimumTapDuration: 0.1,
        maximumTapDuration: 0.5,
        maxTimeBetweenTaps: 0.3,
        maxTapDistance: 10.0,
        requireSameLocation: false
    )
)
```

### SwipeGestureRecognizer

Recognizes swipe gestures with velocity tracking.

```swift
public class SwipeGestureRecognizer: GestureRecognizer {
    public init(configuration: SwipeConfiguration = .default)
    public func getSwipeDirection() -> SwipeDirection?
    public func getSwipeVelocity() -> CGPoint
    public func getSwipeDistance() -> CGFloat
}
```

**Configuration Options:**
- `minimumVelocity`: Minimum velocity required for recognition
- `allowedDirections`: Set of allowed swipe directions
- `minimumDistance`: Minimum distance for swipe recognition
- `maximumDuration`: Maximum duration for swipe gesture

**Usage Example:**
```swift
let swipeRecognizer = SwipeGestureRecognizer(
    configuration: SwipeConfiguration(
        minimumVelocity: 500.0,
        allowedDirections: [.left, .right, .up, .down],
        minimumDistance: 50.0,
        maximumDuration: 1.0
    )
)
```

### PinchGestureRecognizer

Recognizes pinch gestures with scaling support.

```swift
public class PinchGestureRecognizer: GestureRecognizer {
    public init(configuration: PinchConfiguration = .default)
    public func getCurrentScale() -> CGFloat
    public func getScaleChange() -> CGFloat
    public func getPinchCenter() -> CGPoint?
}
```

**Configuration Options:**
- `minimumScaleChange`: Minimum scale change for recognition
- `minimumScale`: Minimum allowed scale value
- `maximumScale`: Maximum allowed scale value
- `enableHapticFeedback`: Whether to enable haptic feedback
- `enableScaleSnapping`: Whether to snap to specific scales
- `snapScales`: Array of scale values to snap to

**Usage Example:**
```swift
let pinchRecognizer = PinchGestureRecognizer(
    configuration: PinchConfiguration(
        minimumScaleChange: 0.1,
        minimumScale: 0.5,
        maximumScale: 3.0,
        enableHapticFeedback: true,
        enableScaleSnapping: true,
        snapScales: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
    )
)
```

### RotationGestureRecognizer

Recognizes rotation gestures with angle tracking.

```swift
public class RotationGestureRecognizer: GestureRecognizer {
    public init(configuration: RotationConfiguration = .default)
    public func getCurrentRotation() -> CGFloat
    public func getCurrentRotationDegrees() -> CGFloat
    public func getRotationVelocity() -> CGFloat
}
```

**Configuration Options:**
- `minimumRotationAngle`: Minimum rotation angle for recognition
- `maximumRotationAngle`: Maximum rotation angle allowed
- `hapticThreshold`: Threshold for haptic feedback
- `enableHapticFeedback`: Whether to enable haptic feedback
- `enableAngleSnapping`: Whether to snap to specific angles
- `snapAngles`: Array of angle values to snap to

**Usage Example:**
```swift
let rotationRecognizer = RotationGestureRecognizer(
    configuration: RotationConfiguration(
        minimumRotationAngle: 0.1,
        maximumRotationAngle: 2 * .pi,
        hapticThreshold: 0.5,
        enableHapticFeedback: true,
        enableAngleSnapping: true,
        snapAngles: [0, .pi/2, .pi, 3*.pi/2, 2*.pi]
    )
)
```

### PanGestureRecognizer

Recognizes pan gestures with momentum tracking.

```swift
public class PanGestureRecognizer: GestureRecognizer {
    public init(configuration: PanConfiguration = .default)
    public func getPanTranslation() -> CGPoint
    public func getPanVelocity() -> CGPoint
    public func getPanDirection() -> PanDirection?
}
```

**Configuration Options:**
- `minimumDistance`: Minimum distance for pan recognition
- `boundaries`: Optional pan boundaries
- `enableHapticFeedback`: Whether to enable haptic feedback
- `enableMomentum`: Whether to enable momentum tracking
- `maximumVelocity`: Maximum allowed velocity

**Usage Example:**
```swift
let panRecognizer = PanGestureRecognizer(
    configuration: PanConfiguration(
        minimumDistance: 10.0,
        boundaries: PanBoundaries(
            minX: 0,
            maxX: 300,
            minY: 0,
            maxY: 500
        ),
        enableHapticFeedback: true,
        enableMomentum: true,
        maximumVelocity: 1000.0
    )
)
```

### LongPressGestureRecognizer

Recognizes long press gestures with timing support.

```swift
public class LongPressGestureRecognizer: GestureRecognizer {
    public init(configuration: LongPressConfiguration = .default)
    public func getPressDuration() -> TimeInterval
    public func getPressStartLocation() -> CGPoint?
    public func hasMoved() -> Bool
}
```

**Configuration Options:**
- `minimumPressDuration`: Minimum duration for long press
- `maximumPressDuration`: Maximum duration for long press
- `maximumMovementDistance`: Maximum movement allowed
- `enableHapticFeedback`: Whether to enable haptic feedback
- `numberOfTouchesRequired`: Number of touches required

**Usage Example:**
```swift
let longPressRecognizer = LongPressGestureRecognizer(
    configuration: LongPressConfiguration(
        minimumPressDuration: 0.5,
        maximumPressDuration: 5.0,
        maximumMovementDistance: 10.0,
        enableHapticFeedback: true,
        numberOfTouchesRequired: 1
    )
)
```

### DragGestureRecognizer

Recognizes drag gestures with momentum tracking.

```swift
public class DragGestureRecognizer: GestureRecognizer {
    public init(configuration: DragConfiguration = .default)
    public func getDragTranslation() -> CGPoint
    public func getDragVelocity() -> CGPoint
    public func getDragMomentum() -> CGPoint
}
```

**Configuration Options:**
- `minimumDistance`: Minimum distance for drag recognition
- `minimumVelocity`: Minimum velocity for recognition
- `boundaries`: Optional drag boundaries
- `enableHapticFeedback`: Whether to enable haptic feedback
- `enableMomentum`: Whether to enable momentum tracking
- `momentumMultiplier`: Multiplier for momentum calculation

**Usage Example:**
```swift
let dragRecognizer = DragGestureRecognizer(
    configuration: DragConfiguration(
        minimumDistance: 5.0,
        minimumVelocity: 100.0,
        boundaries: DragBoundaries(
            minX: -100,
            maxX: 100,
            minY: -100,
            maxY: 100
        ),
        enableHapticFeedback: true,
        enableMomentum: true,
        momentumMultiplier: 0.8
    )
)
```

### MultiTouchGestureRecognizer

Recognizes complex multi-touch gestures.

```swift
public class MultiTouchGestureRecognizer: GestureRecognizer {
    public init(configuration: MultiTouchConfiguration = .default)
    public func getActiveTouchPoints() -> [CGPoint]
    public func getTouchPointCount() -> Int
    public func getGesturePattern() -> MultiTouchPattern?
}
```

**Configuration Options:**
- `minimumTouchPoints`: Minimum number of touch points required
- `maximumTouchPoints`: Maximum number of touch points allowed
- `minimumHistorySize`: Minimum history size for pattern recognition
- `maxHistorySize`: Maximum history size to keep in memory
- `enablePatternRecognition`: Whether to enable pattern recognition

**Usage Example:**
```swift
let multiTouchRecognizer = MultiTouchGestureRecognizer(
    configuration: MultiTouchConfiguration(
        minimumTouchPoints: 2,
        maximumTouchPoints: 5,
        minimumHistorySize: 3,
        maxHistorySize: 10,
        enablePatternRecognition: true
    )
)
```

## Gesture States

### GestureRecognizerState

```swift
public enum GestureRecognizerState {
    case possible
    case began
    case changed
    case ended
    case cancelled
    case failed
    case recognized
}
```

### GestureType

```swift
public enum GestureType {
    case tap
    case doubleTap
    case longPress
    case swipe
    case pan
    case pinch
    case rotation
    case custom(String)
}
```

## Error Handling

### GestureError

```swift
public enum GestureError: Error, LocalizedError {
    case invalidGesture
    case timeout
    case insufficientTouchEvents
    case velocityTooLow
    case pressureTooLow
}
```

## Performance Monitoring

### PerformanceMetrics

```swift
public struct PerformanceMetrics {
    public private(set) var averageProcessingTime: TimeInterval
    public private(set) var totalEventsProcessed: Int
    public private(set) var recognitionAccuracy: Double
}
```

## Best Practices

1. **Configuration**: Use appropriate configurations for your use case
2. **Memory Management**: Reset recognizers when switching contexts
3. **Performance**: Monitor performance metrics for optimization
4. **Error Handling**: Implement proper error handling for edge cases
5. **Accessibility**: Ensure gestures work with accessibility features

## Integration with SwiftUI

All gesture recognizers integrate seamlessly with SwiftUI through view modifiers:

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
    .customPanGesture(
        onPanChanged: { translation in /* action */ },
        onPanEnded: { translation, velocity in /* action */ }
    )
    .customLongPressGesture { /* action */ }
    .customDragGesture(
        onDragChanged: { translation in /* action */ },
        onDragEnded: { translation, velocity in /* action */ }
    )
    .customMultiTouchGesture { pattern, touchPoints in /* action */ }
```

For more detailed examples and advanced usage patterns, see the `Examples/` directory. 