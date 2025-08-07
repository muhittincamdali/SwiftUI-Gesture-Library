# Basic Gestures API Reference

Complete API reference for basic gesture functionality in SwiftUI Gesture Library.

## Overview

The Basic Gestures API provides essential gesture recognition capabilities for common touch interactions including taps, long presses, and touch events.

## Core Components

### TapGestureRecognizer

Recognizes tap gestures with configurable parameters.

```swift
public class TapGestureRecognizer: GestureRecognizer {
    public init(configuration: TapConfiguration = .default)
    public func getTapCount() -> Int
    public func getTapLocation() -> CGPoint?
    public func getTapTimestamp() -> TimeInterval?
}
```

### LongPressGestureRecognizer

Recognizes long press gestures with duration and pressure control.

```swift
public class LongPressGestureRecognizer: GestureRecognizer {
    public init(configuration: LongPressConfiguration = .default)
    public func getPressDuration() -> TimeInterval?
    public func getPressLocation() -> CGPoint?
    public func getPressureValue() -> CGFloat?
}
```

### TouchGestureRecognizer

Recognizes basic touch events including touch down, move, and up.

```swift
public class TouchGestureRecognizer: GestureRecognizer {
    public init(configuration: TouchConfiguration = .default)
    public func getTouchLocation() -> CGPoint?
    public func getTouchPhase() -> TouchPhase?
    public func getTouchTimestamp() -> TimeInterval?
}
```

## Configuration Types

### TapConfiguration

```swift
public struct TapConfiguration {
    public let numberOfTaps: Int
    public let minimumDuration: TimeInterval
    public let maximumDuration: TimeInterval
    public let maximumDistance: CGFloat
    
    public static let `default` = TapConfiguration(
        numberOfTaps: 1,
        minimumDuration: 0.1,
        maximumDuration: 0.5,
        maximumDistance: 10.0
    )
    
    public static let doubleTap = TapConfiguration(
        numberOfTaps: 2,
        minimumDuration: 0.1,
        maximumDuration: 0.5,
        maximumDistance: 50.0
    )
    
    public static let tripleTap = TapConfiguration(
        numberOfTaps: 3,
        minimumDuration: 0.1,
        maximumDuration: 0.5,
        maximumDistance: 50.0
    )
}
```

### LongPressConfiguration

```swift
public struct LongPressConfiguration {
    public let minimumDuration: TimeInterval
    public let maximumDistance: CGFloat
    public let pressureSensitivity: CGFloat
    public let enableHapticFeedback: Bool
    
    public static let `default` = LongPressConfiguration(
        minimumDuration: 0.5,
        maximumDistance: 10.0,
        pressureSensitivity: 0.5,
        enableHapticFeedback: true
    )
}
```

### TouchConfiguration

```swift
public struct TouchConfiguration {
    public let enableTouchDown: Bool
    public let enableTouchMove: Bool
    public let enableTouchUp: Bool
    public let enablePressureSensitivity: Bool
    
    public static let `default` = TouchConfiguration(
        enableTouchDown: true,
        enableTouchMove: true,
        enableTouchUp: true,
        enablePressureSensitivity: false
    )
}
```

## Gesture Results

### TapGestureResult

```swift
public struct TapGestureResult {
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let tapCount: Int
    public let duration: TimeInterval
    public let pressure: CGFloat?
}
```

### LongPressGestureResult

```swift
public struct LongPressGestureResult {
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let duration: TimeInterval
    public let pressure: CGFloat?
    public let intensity: CGFloat
}
```

### TouchGestureResult

```swift
public struct TouchGestureResult {
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let phase: TouchPhase
    public let pressure: CGFloat?
    public let velocity: CGPoint?
}
```

## Usage Examples

### Single Tap Gesture

```swift
let tapRecognizer = TapGestureRecognizer()
tapRecognizer.delegate = self

// Register with gesture engine
gestureEngine.registerRecognizer(tapRecognizer)

// Handle tap events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let tapResult = gesture as? TapGestureResult {
        print("Tap detected at: \(tapResult.location)")
        print("Tap count: \(tapResult.tapCount)")
    }
}
```

### Long Press Gesture

```swift
let longPressRecognizer = LongPressGestureRecognizer(
    configuration: LongPressConfiguration(
        minimumDuration: 1.0,
        maximumDistance: 20.0,
        pressureSensitivity: 0.3,
        enableHapticFeedback: true
    )
)

longPressRecognizer.delegate = self
gestureEngine.registerRecognizer(longPressRecognizer)

// Handle long press events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let longPressResult = gesture as? LongPressGestureResult {
        print("Long press detected at: \(longPressResult.location)")
        print("Duration: \(longPressResult.duration)s")
        print("Pressure: \(longPressResult.pressure ?? 0.0)")
    }
}
```

### Touch Event Handling

```swift
let touchRecognizer = TouchGestureRecognizer(
    configuration: TouchConfiguration(
        enableTouchDown: true,
        enableTouchMove: true,
        enableTouchUp: true,
        enablePressureSensitivity: true
    )
)

touchRecognizer.delegate = self
gestureEngine.registerRecognizer(touchRecognizer)

// Handle touch events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let touchResult = gesture as? TouchGestureResult {
        switch touchResult.phase {
        case .began:
            print("Touch began at: \(touchResult.location)")
        case .moved:
            print("Touch moved to: \(touchResult.location)")
        case .ended:
            print("Touch ended at: \(touchResult.location)")
        }
    }
}
```

## Performance Considerations

### Memory Management

- Gesture recognizers are automatically cleaned up when unregistered
- Use weak references for delegates to prevent retain cycles
- Reset recognizers when switching between different gesture contexts

### Performance Optimization

- Limit the number of concurrent recognizers for better performance
- Use appropriate configuration parameters to reduce false positives
- Monitor gesture recognition latency in performance-critical applications

### Best Practices

- Always validate gesture results before processing
- Implement proper error handling for gesture recognition failures
- Use haptic feedback sparingly to maintain good user experience
- Test gesture recognition on various device types and screen sizes

## Error Handling

### Common Errors

```swift
public enum BasicGestureError: Error {
    case invalidConfiguration
    case recognitionTimeout
    case insufficientTouchData
    case gestureConflict
    case unsupportedPlatform
}
```

### Error Handling Example

```swift
func gestureRecognizer(_ recognizer: GestureRecognizer, didFailWithError error: Error) {
    if let basicError = error as? BasicGestureError {
        switch basicError {
        case .invalidConfiguration:
            print("Invalid gesture configuration")
        case .recognitionTimeout:
            print("Gesture recognition timed out")
        case .insufficientTouchData:
            print("Insufficient touch data for recognition")
        case .gestureConflict:
            print("Gesture conflict detected")
        case .unsupportedPlatform:
            print("Gesture not supported on this platform")
        }
    }
}
```

## Platform Support

- **iOS 15.0+**: Full support for all basic gestures
- **macOS 12.0+**: Limited support (no pressure sensitivity)
- **tvOS 15.0+**: Limited support (focus-based interactions)
- **watchOS 8.0+**: Limited support (crown-based interactions)

## Accessibility

### VoiceOver Support

- All basic gestures are compatible with VoiceOver
- Gesture recognizers respect VoiceOver accessibility settings
- Alternative input methods are supported for accessibility users

### Switch Control Support

- Basic gestures work with Switch Control
- Customizable gesture recognition for switch control users
- Support for alternative input devices
