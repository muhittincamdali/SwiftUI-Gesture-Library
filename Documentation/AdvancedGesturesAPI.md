# Advanced Gestures API Reference

Complete API reference for advanced gesture functionality in SwiftUI Gesture Library.

## Overview

The Advanced Gestures API provides sophisticated gesture recognition capabilities for complex touch interactions including drag, pinch, rotation, swipe, and pan gestures with advanced features like velocity tracking, haptic feedback, and performance optimization.

## Core Components

### DragGestureRecognizer

Recognizes drag gestures with velocity and direction tracking.

```swift
public class DragGestureRecognizer: GestureRecognizer {
    public init(configuration: DragConfiguration = .default)
    public func getTranslation() -> CGSize
    public func getVelocity() -> CGPoint
    public func getDirection() -> DragDirection?
    public func getDistance() -> CGFloat
}
```

### PinchGestureRecognizer

Recognizes pinch gestures with scaling and rotation support.

```swift
public class PinchGestureRecognizer: GestureRecognizer {
    public init(configuration: PinchConfiguration = .default)
    public func getScale() -> CGFloat
    public func getRotation() -> CGFloat
    public func getCenter() -> CGPoint?
    public func getVelocity() -> CGPoint
}
```

### RotationGestureRecognizer

Recognizes rotation gestures with angle and center point tracking.

```swift
public class RotationGestureRecognizer: GestureRecognizer {
    public init(configuration: RotationConfiguration = .default)
    public func getAngle() -> CGFloat
    public func getCenter() -> CGPoint?
    public func getVelocity() -> CGFloat
    public func getDirection() -> RotationDirection?
}
```

### SwipeGestureRecognizer

Recognizes swipe gestures with direction and distance tracking.

```swift
public class SwipeGestureRecognizer: GestureRecognizer {
    public init(configuration: SwipeConfiguration = .default)
    public func getDirection() -> SwipeDirection?
    public func getVelocity() -> CGPoint
    public func getDistance() -> CGFloat
    public func getDuration() -> TimeInterval
}
```

### PanGestureRecognizer

Recognizes pan gestures with translation and velocity tracking.

```swift
public class PanGestureRecognizer: GestureRecognizer {
    public init(configuration: PanConfiguration = .default)
    public func getTranslation() -> CGSize
    public func getVelocity() -> CGPoint
    public func getLocation() -> CGPoint
    public func getState() -> PanState
}
```

## Configuration Types

### DragConfiguration

```swift
public struct DragConfiguration {
    public let minimumDistance: CGFloat
    public let coordinateSpace: CoordinateSpace
    public let enableVelocity: Bool
    public let enableDirection: Bool
    public let enableDistance: Bool
    public let enableHapticFeedback: Bool
    
    public static let `default` = DragConfiguration(
        minimumDistance: 10.0,
        coordinateSpace: .local,
        enableVelocity: true,
        enableDirection: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
    
    public static let constrained = DragConfiguration(
        minimumDistance: 10.0,
        coordinateSpace: .local,
        enableVelocity: true,
        enableDirection: true,
        enableDistance: true,
        enableHapticFeedback: false
    )
}
```

### PinchConfiguration

```swift
public struct PinchConfiguration {
    public let minimumScale: CGFloat
    public let maximumScale: CGFloat
    public let coordinateSpace: CoordinateSpace
    public let enableRotation: Bool
    public let enableCenter: Bool
    public let enableVelocity: Bool
    public let enableHapticFeedback: Bool
    
    public static let `default` = PinchConfiguration(
        minimumScale: 0.5,
        maximumScale: 3.0,
        coordinateSpace: .local,
        enableRotation: true,
        enableCenter: true,
        enableVelocity: true,
        enableHapticFeedback: true
    )
    
    public static let precise = PinchConfiguration(
        minimumScale: 0.1,
        maximumScale: 10.0,
        coordinateSpace: .local,
        enableRotation: true,
        enableCenter: true,
        enableVelocity: true,
        enableHapticFeedback: false
    )
}
```

### RotationConfiguration

```swift
public struct RotationConfiguration {
    public let minimumAngle: CGFloat
    public let maximumAngle: CGFloat
    public let coordinateSpace: CoordinateSpace
    public let enableCenter: Bool
    public let enableVelocity: Bool
    public let enableDirection: Bool
    public let enableHapticFeedback: Bool
    
    public static let `default` = RotationConfiguration(
        minimumAngle: 5.0,
        maximumAngle: 360.0,
        coordinateSpace: .local,
        enableCenter: true,
        enableVelocity: true,
        enableDirection: true,
        enableHapticFeedback: true
    )
    
    public static let constrained = RotationConfiguration(
        minimumAngle: 10.0,
        maximumAngle: 180.0,
        coordinateSpace: .local,
        enableCenter: true,
        enableVelocity: true,
        enableDirection: true,
        enableHapticFeedback: false
    )
}
```

### SwipeConfiguration

```swift
public struct SwipeConfiguration {
    public let minimumDistance: CGFloat
    public let minimumVelocity: CGFloat
    public let maximumDuration: TimeInterval
    public let allowedDirections: Set<SwipeDirection>
    public let enableVelocity: Bool
    public let enableDistance: Bool
    public let enableHapticFeedback: Bool
    
    public static let `default` = SwipeConfiguration(
        minimumDistance: 50.0,
        minimumVelocity: 100.0,
        maximumDuration: 0.5,
        allowedDirections: [.left, .right, .up, .down],
        enableVelocity: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
    
    public static let horizontal = SwipeConfiguration(
        minimumDistance: 50.0,
        minimumVelocity: 100.0,
        maximumDuration: 0.5,
        allowedDirections: [.left, .right],
        enableVelocity: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
    
    public static let vertical = SwipeConfiguration(
        minimumDistance: 50.0,
        minimumVelocity: 100.0,
        maximumDuration: 0.5,
        allowedDirections: [.up, .down],
        enableVelocity: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
}
```

### PanConfiguration

```swift
public struct PanConfiguration {
    public let minimumDistance: CGFloat
    public let coordinateSpace: CoordinateSpace
    public let enableVelocity: Bool
    public let enableLocation: Bool
    public let enableState: Bool
    public let enableHapticFeedback: Bool
    
    public static let `default` = PanConfiguration(
        minimumDistance: 10.0,
        coordinateSpace: .local,
        enableVelocity: true,
        enableLocation: true,
        enableState: true,
        enableHapticFeedback: true
    )
}
```

## Gesture Results

### DragGestureResult

```swift
public struct DragGestureResult {
    public let translation: CGSize
    public let velocity: CGPoint
    public let direction: DragDirection?
    public let distance: CGFloat
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let isConstrained: Bool
}
```

### PinchGestureResult

```swift
public struct PinchGestureResult {
    public let scale: CGFloat
    public let rotation: CGFloat
    public let center: CGPoint?
    public let velocity: CGPoint
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let isZooming: Bool
}
```

### RotationGestureResult

```swift
public struct RotationGestureResult {
    public let angle: CGFloat
    public let center: CGPoint?
    public let velocity: CGFloat
    public let direction: RotationDirection?
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let isSnapped: Bool
    public let snappedAngle: CGFloat?
}
```

### SwipeGestureResult

```swift
public struct SwipeGestureResult {
    public let direction: SwipeDirection
    public let velocity: CGPoint
    public let distance: CGFloat
    public let duration: TimeInterval
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let isQuick: Bool
}
```

### PanGestureResult

```swift
public struct PanGestureResult {
    public let translation: CGSize
    public let velocity: CGPoint
    public let location: CGPoint
    public let state: PanState
    public let timestamp: TimeInterval
    public let isActive: Bool
}
```

## Direction Enums

### DragDirection

```swift
public enum DragDirection {
    case left
    case right
    case up
    case down
    case diagonal
    case none
}
```

### RotationDirection

```swift
public enum RotationDirection {
    case clockwise
    case counterclockwise
    case none
}
```

### SwipeDirection

```swift
public enum SwipeDirection {
    case left
    case right
    case up
    case down
    case diagonal
    case none
}
```

### PanState

```swift
public enum PanState {
    case began
    case changed
    case ended
    case cancelled
}
```

## Usage Examples

### Drag Gesture

```swift
let dragRecognizer = DragGestureRecognizer(
    configuration: DragConfiguration(
        minimumDistance: 10.0,
        coordinateSpace: .local,
        enableVelocity: true,
        enableDirection: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
)

dragRecognizer.delegate = self
gestureEngine.registerRecognizer(dragRecognizer)

// Handle drag events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let dragResult = gesture as? DragGestureResult {
        print("Drag detected")
        print("Translation: \(dragResult.translation)")
        print("Velocity: \(dragResult.velocity)")
        print("Direction: \(dragResult.direction?.description ?? "None")")
        print("Distance: \(dragResult.distance)")
    }
}
```

### Pinch Gesture

```swift
let pinchRecognizer = PinchGestureRecognizer(
    configuration: PinchConfiguration(
        minimumScale: 0.1,
        maximumScale: 10.0,
        coordinateSpace: .local,
        enableRotation: true,
        enableCenter: true,
        enableVelocity: true,
        enableHapticFeedback: true
    )
)

pinchRecognizer.delegate = self
gestureEngine.registerRecognizer(pinchRecognizer)

// Handle pinch events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let pinchResult = gesture as? PinchGestureResult {
        print("Pinch detected")
        print("Scale: \(pinchResult.scale)")
        print("Rotation: \(pinchResult.rotation)°")
        print("Center: \(pinchResult.center?.description ?? "None")")
        print("Is Zooming: \(pinchResult.isZooming)")
    }
}
```

### Rotation Gesture

```swift
let rotationRecognizer = RotationGestureRecognizer(
    configuration: RotationConfiguration(
        minimumAngle: 10.0,
        maximumAngle: 180.0,
        coordinateSpace: .local,
        enableCenter: true,
        enableVelocity: true,
        enableDirection: true,
        enableHapticFeedback: true
    )
)

rotationRecognizer.delegate = self
gestureEngine.registerRecognizer(rotationRecognizer)

// Handle rotation events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let rotationResult = gesture as? RotationGestureResult {
        print("Rotation detected")
        print("Angle: \(rotationResult.angle)°")
        print("Direction: \(rotationResult.direction?.description ?? "None")")
        print("Velocity: \(rotationResult.velocity)")
        print("Is Snapped: \(rotationResult.isSnapped)")
    }
}
```

### Swipe Gesture

```swift
let swipeRecognizer = SwipeGestureRecognizer(
    configuration: SwipeConfiguration(
        minimumDistance: 50.0,
        minimumVelocity: 100.0,
        maximumDuration: 0.5,
        allowedDirections: [.left, .right, .up, .down],
        enableVelocity: true,
        enableDistance: true,
        enableHapticFeedback: true
    )
)

swipeRecognizer.delegate = self
gestureEngine.registerRecognizer(swipeRecognizer)

// Handle swipe events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let swipeResult = gesture as? SwipeGestureResult {
        print("Swipe detected")
        print("Direction: \(swipeResult.direction)")
        print("Velocity: \(swipeResult.velocity)")
        print("Distance: \(swipeResult.distance)")
        print("Duration: \(swipeResult.duration)s")
        print("Is Quick: \(swipeResult.isQuick)")
    }
}
```

### Pan Gesture

```swift
let panRecognizer = PanGestureRecognizer(
    configuration: PanConfiguration(
        minimumDistance: 10.0,
        coordinateSpace: .local,
        enableVelocity: true,
        enableLocation: true,
        enableState: true,
        enableHapticFeedback: true
    )
)

panRecognizer.delegate = self
gestureEngine.registerRecognizer(panRecognizer)

// Handle pan events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let panResult = gesture as? PanGestureResult {
        print("Pan detected")
        print("Translation: \(panResult.translation)")
        print("Velocity: \(panResult.velocity)")
        print("Location: \(panResult.location)")
        print("State: \(panResult.state)")
        print("Is Active: \(panResult.isActive)")
    }
}
```

## Performance Considerations

### Memory Management

- Advanced gesture recognizers use more memory than basic ones
- Unregister recognizers when not needed
- Use appropriate configuration parameters to optimize performance
- Monitor memory usage in performance-critical applications

### Performance Optimization

- Limit concurrent advanced gestures for better performance
- Use constrained configurations when full functionality isn't needed
- Disable haptic feedback in performance-critical scenarios
- Monitor gesture recognition latency

### Best Practices

- Always validate gesture results before processing
- Implement proper error handling for gesture recognition failures
- Use haptic feedback sparingly to maintain good user experience
- Test gesture recognition on various device types and screen sizes
- Consider accessibility when implementing advanced gestures

## Error Handling

### Common Errors

```swift
public enum AdvancedGestureError: Error {
    case invalidConfiguration
    case recognitionTimeout
    case insufficientTouchData
    case gestureConflict
    case unsupportedPlatform
    case velocityCalculationFailed
    case directionDetectionFailed
    case centerPointCalculationFailed
}
```

### Error Handling Example

```swift
func gestureRecognizer(_ recognizer: GestureRecognizer, didFailWithError error: Error) {
    if let advancedError = error as? AdvancedGestureError {
        switch advancedError {
        case .invalidConfiguration:
            print("Invalid advanced gesture configuration")
        case .recognitionTimeout:
            print("Advanced gesture recognition timed out")
        case .insufficientTouchData:
            print("Insufficient touch data for advanced gesture recognition")
        case .gestureConflict:
            print("Advanced gesture conflict detected")
        case .unsupportedPlatform:
            print("Advanced gesture not supported on this platform")
        case .velocityCalculationFailed:
            print("Velocity calculation failed")
        case .directionDetectionFailed:
            print("Direction detection failed")
        case .centerPointCalculationFailed:
            print("Center point calculation failed")
        }
    }
}
```

## Platform Support

- **iOS 15.0+**: Full support for all advanced gestures
- **macOS 12.0+**: Limited support (no pressure sensitivity, limited haptics)
- **tvOS 15.0+**: Limited support (focus-based interactions)
- **watchOS 8.0+**: Limited support (crown-based interactions)

## Accessibility

### VoiceOver Support

- Advanced gestures are compatible with VoiceOver
- Gesture recognizers respect VoiceOver accessibility settings
- Alternative input methods are supported for accessibility users

### Switch Control Support

- Advanced gestures work with Switch Control
- Customizable gesture recognition for switch control users
- Support for alternative input devices

### Accessibility Features

- Configurable gesture sensitivity for users with motor impairments
- Alternative gesture patterns for accessibility users
- Support for assistive technologies
