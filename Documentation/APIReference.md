# API Reference

<!-- TOC START -->
## Table of Contents
- [API Reference](#api-reference)
- [Core Components](#core-components)
  - [GestureEngine](#gestureengine)
  - [GestureRecognizer](#gesturerecognizer)
- [Gesture Recognizers](#gesture-recognizers)
  - [TapGestureRecognizer](#tapgesturerecognizer)
  - [SwipeGestureRecognizer](#swipegesturerecognizer)
  - [PinchGestureRecognizer](#pinchgesturerecognizer)
  - [RotationGestureRecognizer](#rotationgesturerecognizer)
  - [PanGestureRecognizer](#pangesturerecognizer)
  - [LongPressGestureRecognizer](#longpressgesturerecognizer)
  - [DragGestureRecognizer](#draggesturerecognizer)
  - [MultiTouchGestureRecognizer](#multitouchgesturerecognizer)
- [SwiftUI Extensions](#swiftui-extensions)
  - [View Extensions](#view-extensions)
- [Configuration Types](#configuration-types)
  - [GestureConfiguration](#gestureconfiguration)
  - [TapConfiguration](#tapconfiguration)
  - [SwipeConfiguration](#swipeconfiguration)
  - [PinchConfiguration](#pinchconfiguration)
  - [RotationConfiguration](#rotationconfiguration)
  - [PanConfiguration](#panconfiguration)
  - [LongPressConfiguration](#longpressconfiguration)
  - [DragConfiguration](#dragconfiguration)
  - [MultiTouchConfiguration](#multitouchconfiguration)
- [Enums and Types](#enums-and-types)
  - [GestureType](#gesturetype)
  - [GestureState](#gesturestate)
  - [SwipeDirection](#swipedirection)
  - [PanDirection](#pandirection)
  - [MultiTouchPattern](#multitouchpattern)
  - [TouchEvent](#touchevent)
  - [TouchPhase](#touchphase)
  - [TouchType](#touchtype)
- [Haptic Feedback](#haptic-feedback)
  - [HapticFeedbackManager](#hapticfeedbackmanager)
  - [HapticConfiguration](#hapticconfiguration)
- [Performance Monitoring](#performance-monitoring)
  - [PerformanceMetrics](#performancemetrics)
- [Error Handling](#error-handling)
  - [GestureError](#gestureerror)
- [Usage Examples](#usage-examples)
  - [Basic Usage](#basic-usage)
  - [Advanced Usage](#advanced-usage)
  - [Custom Gesture Recognizer](#custom-gesture-recognizer)
- [Best Practices](#best-practices)
<!-- TOC END -->


Complete API reference for SwiftUI Gesture Library.

## Core Components

### GestureEngine

The main orchestrator for gesture recognition and processing.

```swift
public class GestureEngine: ObservableObject {
    @Published public private(set) var currentState: GestureState
    
    public func registerRecognizer(_ recognizer: GestureRecognizer)
    public func unregisterRecognizer(_ recognizer: GestureRecognizer)
    public func processTouchEvent(_ event: TouchEvent)
    public func reset()
    public func getPerformanceMetrics() -> PerformanceMetrics
}
```

### GestureRecognizer

Base class for all gesture recognizers.

```swift
public class GestureRecognizer: Identifiable, ObservableObject {
    @Published public private(set) var state: GestureRecognizerState
    public let type: GestureType
    public weak var delegate: GestureRecognizerDelegate?
    
    public func processTouchEvent(_ event: TouchEvent)
    public func reset()
    public func isValidGesture() -> Bool
}
```

## Gesture Recognizers

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

## SwiftUI Extensions

### View Extensions

```swift
public extension View {
    // Tap Gestures
    func customTapGesture(configuration: TapConfiguration = .default, onTap: @escaping () -> Void) -> some View
    func customDoubleTapGesture(onDoubleTap: @escaping () -> Void) -> some View
    func customTripleTapGesture(onTripleTap: @escaping () -> Void) -> some View
    
    // Swipe Gestures
    func customSwipeGesture(configuration: SwipeConfiguration = .default, onSwipe: @escaping (SwipeDirection) -> Void) -> some View
    func customHorizontalSwipeGesture(onSwipe: @escaping (SwipeDirection) -> Void) -> some View
    func customVerticalSwipeGesture(onSwipe: @escaping (SwipeDirection) -> Void) -> some View
    
    // Pinch Gestures
    func customPinchGesture(configuration: PinchConfiguration = .default, onPinch: @escaping (CGFloat) -> Void) -> some View
    func customPrecisePinchGesture(onPinch: @escaping (CGFloat) -> Void) -> some View
    func customFreeformPinchGesture(onPinch: @escaping (CGFloat) -> Void) -> some View
    
    // Rotation Gestures
    func customRotationGesture(configuration: RotationConfiguration = .default, onRotationChanged: @escaping (CGFloat) -> Void, onRotationEnded: @escaping (CGFloat) -> Void) -> some View
    func customPreciseRotationGesture(onRotationChanged: @escaping (CGFloat) -> Void, onRotationEnded: @escaping (CGFloat) -> Void) -> some View
    
    // Pan Gestures
    func customPanGesture(configuration: PanConfiguration = .default, onPanChanged: @escaping (CGPoint) -> Void, onPanEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View
    func customConstrainedPanGesture(onPanChanged: @escaping (CGPoint) -> Void, onPanEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View
    func customFreeformPanGesture(onPanChanged: @escaping (CGPoint) -> Void, onPanEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View
    
    // Long Press Gestures
    func customLongPressGesture(configuration: LongPressConfiguration = .default, onLongPress: @escaping () -> Void) -> some View
    func customShortLongPressGesture(onLongPress: @escaping () -> Void) -> some View
    func customLongLongPressGesture(onLongPress: @escaping () -> Void) -> some View
    func customPreciseLongPressGesture(onLongPress: @escaping () -> Void) -> some View
    
    // Drag Gestures
    func customDragGesture(configuration: DragConfiguration = .default, onDragChanged: @escaping (CGPoint) -> Void, onDragEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View
    
    // Multi-Touch Gestures
    func customMultiTouchGesture(configuration: MultiTouchConfiguration = .default, onMultiTouch: @escaping (MultiTouchPattern, [CGPoint]) -> Void) -> some View
    
    // Combined Gestures
    func customGestures(@ViewBuilder gestures: () -> some View) -> some View
    func customTapAndSwipeGesture(onTap: @escaping () -> Void, onSwipe: @escaping (SwipeDirection) -> Void) -> some View
    func customPinchAndRotationGesture(onPinch: @escaping (CGFloat) -> Void, onRotation: @escaping (CGFloat) -> Void) -> some View
    
    // Gesture State Monitoring
    func customGestureStateMonitor(onStateChange: @escaping (GestureState) -> Void) -> some View
    func customHapticFeedback(_ hapticManager: HapticFeedbackManager) -> some View
    
    // Accessibility Support
    func customAccessibleGesture(_ accessibilityLabel: String) -> some View
    func customVoiceOverGesture(_ voiceOverHint: String) -> some View
}
```

## Configuration Types

### GestureConfiguration

```swift
public struct GestureConfiguration {
    public let enableHapticFeedback: Bool
    public let enablePerformanceMonitoring: Bool
    public let maxConcurrentGestures: Int
    public let recognitionTimeout: TimeInterval
}
```

### TapConfiguration

```swift
public struct TapConfiguration {
    public let numberOfTaps: Int
    public let minimumTapDuration: TimeInterval
    public let maximumTapDuration: TimeInterval
    public let maxTimeBetweenTaps: TimeInterval
    public let maxTapDistance: CGFloat
    public let requireSameLocation: Bool
}
```

### SwipeConfiguration

```swift
public struct SwipeConfiguration {
    public let minimumVelocity: CGFloat
    public let allowedDirections: SwipeDirectionSet
    public let minimumDistance: CGFloat
    public let maximumDuration: TimeInterval
}
```

### PinchConfiguration

```swift
public struct PinchConfiguration {
    public let minimumScaleChange: CGFloat
    public let minimumScale: CGFloat
    public let maximumScale: CGFloat
    public let enableHapticFeedback: Bool
    public let enableScaleSnapping: Bool
    public let snapScales: [CGFloat]
}
```

### RotationConfiguration

```swift
public struct RotationConfiguration {
    public let minimumRotationAngle: CGFloat
    public let maximumRotationAngle: CGFloat
    public let hapticThreshold: CGFloat
    public let enableHapticFeedback: Bool
    public let enableAngleSnapping: Bool
    public let snapAngles: [CGFloat]
}
```

### PanConfiguration

```swift
public struct PanConfiguration {
    public let minimumDistance: CGFloat
    public let boundaries: PanBoundaries?
    public let enableHapticFeedback: Bool
    public let enableMomentum: Bool
    public let maximumVelocity: CGFloat
}
```

### LongPressConfiguration

```swift
public struct LongPressConfiguration {
    public let minimumPressDuration: TimeInterval
    public let maximumPressDuration: TimeInterval
    public let maximumMovementDistance: CGFloat
    public let enableHapticFeedback: Bool
    public let numberOfTouchesRequired: Int
}
```

### DragConfiguration

```swift
public struct DragConfiguration {
    public let minimumDistance: CGFloat
    public let minimumVelocity: CGFloat
    public let boundaries: DragBoundaries?
    public let enableHapticFeedback: Bool
    public let enableMomentum: Bool
    public let momentumMultiplier: CGFloat
}
```

### MultiTouchConfiguration

```swift
public struct MultiTouchConfiguration {
    public let minimumTouchPoints: Int
    public let maximumTouchPoints: Int
    public let minimumHistorySize: Int
    public let maxHistorySize: Int
    public let enablePatternRecognition: Bool
}
```

## Enums and Types

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

### GestureState

```swift
public enum GestureState {
    case idle
    case singleGesture(GestureRecognizer)
    case multiGesture([GestureRecognizer])
}
```

### SwipeDirection

```swift
public enum SwipeDirection {
    case up
    case down
    case left
    case right
    case upLeft
    case upRight
    case downLeft
    case downRight
}
```

### PanDirection

```swift
public enum PanDirection {
    case up
    case down
    case left
    case right
    case upLeft
    case upRight
    case downLeft
    case downRight
}
```

### MultiTouchPattern

```swift
public enum MultiTouchPattern {
    case pinch
    case rotation
    case spread
    case custom
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

### TouchPhase

```swift
public enum TouchPhase {
    case began
    case moved
    case ended
    case cancelled
}
```

### TouchType

```swift
public enum TouchType {
    case finger
    case pencil
    case stylus
}
```

## Haptic Feedback

### HapticFeedbackManager

```swift
public class HapticFeedbackManager: ObservableObject {
    @Published public private(set) var currentIntensity: Float
    @Published public var isEnabled: Bool
    
    public func triggerFeedback(for gestureType: GestureType)
    public func triggerCustomFeedback(intensity: Float = 1.0)
    public func setIntensity(_ intensity: Float)
    public func setEnabled(_ enabled: Bool)
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

## Performance Monitoring

### PerformanceMetrics

```swift
public struct PerformanceMetrics {
    public private(set) var averageProcessingTime: TimeInterval
    public private(set) var totalEventsProcessed: Int
    public private(set) var recognitionAccuracy: Double
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

## Usage Examples

### Basic Usage

```swift
import SwiftUI
import SwiftUIGestureLibrary

struct ContentView: View {
    @StateObject private var gestureEngine = GestureEngine()
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 200)
            .customTapGesture {
                print("Tap detected!")
            }
            .customSwipeGesture { direction in
                print("Swipe detected: \(direction)")
            }
    }
}
```

### Advanced Usage

```swift
struct AdvancedGestureView: View {
    @StateObject private var gestureEngine = GestureEngine(
        configuration: GestureConfiguration(
            enableHapticFeedback: true,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: 3,
            recognitionTimeout: 2.0
        )
    )
    
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 150, height: 150)
            .customPinchGesture { scale in
                print("Pinch scale: \(scale)")
            }
            .customRotationGesture(
                onRotationChanged: { angle in
                    print("Rotation angle: \(angle)")
                },
                onRotationEnded: { finalAngle in
                    print("Final rotation: \(finalAngle)")
                }
            )
    }
}
```

### Custom Gesture Recognizer

```swift
class CustomGestureRecognizer: GestureRecognizer {
    override func validateGesture() -> Bool {
        // Custom validation logic
        return touchEvents.count >= 5
    }
    
    override func checkForRecognition() {
        // Custom recognition logic
        if isValidGesture() {
            state = .recognized
        }
    }
}
```

## Best Practices

1. **Performance Optimization**
   - Use appropriate gesture configurations
   - Monitor performance metrics
   - Reset gesture engines when switching contexts

2. **Memory Management**
   - Call `reset()` when appropriate
   - Limit touch event history
   - Use weak references in delegates

3. **Error Handling**
   - Implement proper error handling
   - Validate gesture configurations
   - Handle edge cases gracefully

4. **Accessibility**
   - Add accessibility labels
   - Support VoiceOver
   - Provide alternative interaction methods

5. **Testing**
   - Write comprehensive unit tests
   - Test edge cases
   - Validate performance benchmarks 