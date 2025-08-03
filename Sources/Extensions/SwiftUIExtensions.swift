import SwiftUI
import Foundation

/// Comprehensive SwiftUI extensions for gesture integration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    
    // MARK: - Tap Gesture Extensions
    
    /// Adds a custom tap gesture to the view
    /// - Parameters:
    ///   - configuration: Tap configuration
    ///   - onTap: Closure called when tap is detected
    /// - Returns: Modified view with tap gesture
    func customTapGesture(configuration: TapConfiguration = .default, onTap: @escaping () -> Void) -> some View {
        modifier(TapGestureViewModifier(configuration: configuration, onTap: onTap))
    }
    
    /// Adds a double tap gesture to the view
    /// - Parameter onDoubleTap: Closure called when double tap is detected
    /// - Returns: Modified view with double tap gesture
    func customDoubleTapGesture(onDoubleTap: @escaping () -> Void) -> some View {
        customTapGesture(configuration: .doubleTap, onTap: onDoubleTap)
    }
    
    /// Adds a triple tap gesture to the view
    /// - Parameter onTripleTap: Closure called when triple tap is detected
    /// - Returns: Modified view with triple tap gesture
    func customTripleTapGesture(onTripleTap: @escaping () -> Void) -> some View {
        customTapGesture(configuration: .tripleTap, onTap: onTripleTap)
    }
    
    // MARK: - Swipe Gesture Extensions
    
    /// Adds a custom swipe gesture to the view
    /// - Parameters:
    ///   - configuration: Swipe configuration
    ///   - onSwipe: Closure called when swipe is detected
    /// - Returns: Modified view with swipe gesture
    func customSwipeGesture(configuration: SwipeConfiguration = .default, onSwipe: @escaping (SwipeDirection) -> Void) -> some View {
        modifier(SwipeGestureViewModifier(configuration: configuration, onSwipe: onSwipe))
    }
    
    /// Adds a horizontal swipe gesture to the view
    /// - Parameter onSwipe: Closure called when horizontal swipe is detected
    /// - Returns: Modified view with horizontal swipe gesture
    func customHorizontalSwipeGesture(onSwipe: @escaping (SwipeDirection) -> Void) -> some View {
        customSwipeGesture(configuration: .horizontal, onSwipe: onSwipe)
    }
    
    /// Adds a vertical swipe gesture to the view
    /// - Parameter onSwipe: Closure called when vertical swipe is detected
    /// - Returns: Modified view with vertical swipe gesture
    func customVerticalSwipeGesture(onSwipe: @escaping (SwipeDirection) -> Void) -> some View {
        customSwipeGesture(configuration: .vertical, onSwipe: onSwipe)
    }
    
    // MARK: - Pinch Gesture Extensions
    
    /// Adds a custom pinch gesture to the view
    /// - Parameters:
    ///   - configuration: Pinch configuration
    ///   - onPinch: Closure called when pinch is detected
    /// - Returns: Modified view with pinch gesture
    func customPinchGesture(configuration: PinchConfiguration = .default, onPinch: @escaping (CGFloat) -> Void) -> some View {
        modifier(PinchGestureViewModifier(configuration: configuration, onPinch: onPinch))
    }
    
    /// Adds a precise pinch gesture to the view
    /// - Parameter onPinch: Closure called when precise pinch is detected
    /// - Returns: Modified view with precise pinch gesture
    func customPrecisePinchGesture(onPinch: @escaping (CGFloat) -> Void) -> some View {
        customPinchGesture(configuration: .precise, onPinch: onPinch)
    }
    
    /// Adds a freeform pinch gesture to the view
    /// - Parameter onPinch: Closure called when freeform pinch is detected
    /// - Returns: Modified view with freeform pinch gesture
    func customFreeformPinchGesture(onPinch: @escaping (CGFloat) -> Void) -> some View {
        customPinchGesture(configuration: .freeform, onPinch: onPinch)
    }
    
    // MARK: - Rotation Gesture Extensions
    
    /// Adds a custom rotation gesture to the view
    /// - Parameters:
    ///   - configuration: Rotation configuration
    ///   - onRotationChanged: Closure called when rotation changes
    ///   - onRotationEnded: Closure called when rotation ends
    /// - Returns: Modified view with rotation gesture
    func customRotationGesture(
        configuration: RotationConfiguration = .default,
        onRotationChanged: @escaping (CGFloat) -> Void,
        onRotationEnded: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(RotationGestureViewModifier(
            configuration: configuration,
            onRotationChanged: onRotationChanged,
            onRotationEnded: onRotationEnded
        ))
    }
    
    /// Adds a precise rotation gesture to the view
    /// - Parameters:
    ///   - onRotationChanged: Closure called when rotation changes
    ///   - onRotationEnded: Closure called when rotation ends
    /// - Returns: Modified view with precise rotation gesture
    func customPreciseRotationGesture(
        onRotationChanged: @escaping (CGFloat) -> Void,
        onRotationEnded: @escaping (CGFloat) -> Void
    ) -> some View {
        customRotationGesture(
            configuration: .precise,
            onRotationChanged: onRotationChanged,
            onRotationEnded: onRotationEnded
        )
    }
    
    // MARK: - Pan Gesture Extensions
    
    /// Adds a custom pan gesture to the view
    /// - Parameters:
    ///   - configuration: Pan configuration
    ///   - onPanChanged: Closure called when pan changes
    ///   - onPanEnded: Closure called when pan ends
    /// - Returns: Modified view with pan gesture
    func customPanGesture(
        configuration: PanConfiguration = .default,
        onPanChanged: @escaping (CGPoint) -> Void,
        onPanEnded: @escaping (CGPoint, CGPoint) -> Void
    ) -> some View {
        modifier(PanGestureViewModifier(
            configuration: configuration,
            onPanChanged: onPanChanged,
            onPanEnded: onPanEnded
        ))
    }
    
    /// Adds a constrained pan gesture to the view
    /// - Parameters:
    ///   - onPanChanged: Closure called when pan changes
    ///   - onPanEnded: Closure called when pan ends
    /// - Returns: Modified view with constrained pan gesture
    func customConstrainedPanGesture(
        onPanChanged: @escaping (CGPoint) -> Void,
        onPanEnded: @escaping (CGPoint, CGPoint) -> Void
    ) -> some View {
        customPanGesture(
            configuration: .constrained,
            onPanChanged: onPanChanged,
            onPanEnded: onPanEnded
        )
    }
    
    /// Adds a freeform pan gesture to the view
    /// - Parameters:
    ///   - onPanChanged: Closure called when pan changes
    ///   - onPanEnded: Closure called when pan ends
    /// - Returns: Modified view with freeform pan gesture
    func customFreeformPanGesture(
        onPanChanged: @escaping (CGPoint) -> Void,
        onPanEnded: @escaping (CGPoint, CGPoint) -> Void
    ) -> some View {
        customPanGesture(
            configuration: .freeform,
            onPanChanged: onPanChanged,
            onPanEnded: onPanEnded
        )
    }
    
    // MARK: - Long Press Gesture Extensions
    
    /// Adds a custom long press gesture to the view
    /// - Parameters:
    ///   - configuration: Long press configuration
    ///   - onLongPress: Closure called when long press is detected
    /// - Returns: Modified view with long press gesture
    func customLongPressGesture(configuration: LongPressConfiguration = .default, onLongPress: @escaping () -> Void) -> some View {
        modifier(LongPressGestureViewModifier(configuration: configuration, onLongPress: onLongPress))
    }
    
    /// Adds a short long press gesture to the view
    /// - Parameter onLongPress: Closure called when short long press is detected
    /// - Returns: Modified view with short long press gesture
    func customShortLongPressGesture(onLongPress: @escaping () -> Void) -> some View {
        customLongPressGesture(configuration: .short, onLongPress: onLongPress)
    }
    
    /// Adds a long long press gesture to the view
    /// - Parameter onLongPress: Closure called when long long press is detected
    /// - Returns: Modified view with long long press gesture
    func customLongLongPressGesture(onLongPress: @escaping () -> Void) -> some View {
        customLongPressGesture(configuration: .long, onLongPress: onLongPress)
    }
    
    /// Adds a precise long press gesture to the view
    /// - Parameter onLongPress: Closure called when precise long press is detected
    /// - Returns: Modified view with precise long press gesture
    func customPreciseLongPressGesture(onLongPress: @escaping () -> Void) -> some View {
        customLongPressGesture(configuration: .precise, onLongPress: onLongPress)
    }
    
    // MARK: - Combined Gesture Extensions
    
    /// Adds multiple gestures to the view
    /// - Parameters:
    ///   - gestures: Array of gesture modifiers
    /// - Returns: Modified view with multiple gestures
    func customGestures(@ViewBuilder gestures: () -> some View) -> some View {
        self.modifier(CombinedGesturesModifier(gestures: gestures))
    }
    
    /// Adds tap and swipe gestures to the view
    /// - Parameters:
    ///   - onTap: Closure called when tap is detected
    ///   - onSwipe: Closure called when swipe is detected
    /// - Returns: Modified view with tap and swipe gestures
    func customTapAndSwipeGesture(
        onTap: @escaping () -> Void,
        onSwipe: @escaping (SwipeDirection) -> Void
    ) -> some View {
        customTapGesture(onTap: onTap)
            .customSwipeGesture(onSwipe: onSwipe)
    }
    
    /// Adds pinch and rotation gestures to the view
    /// - Parameters:
    ///   - onPinch: Closure called when pinch is detected
    ///   - onRotation: Closure called when rotation is detected
    /// - Returns: Modified view with pinch and rotation gestures
    func customPinchAndRotationGesture(
        onPinch: @escaping (CGFloat) -> Void,
        onRotation: @escaping (CGFloat) -> Void
    ) -> some View {
        customPinchGesture(onPinch: onPinch)
            .customRotationGesture(
                onRotationChanged: onRotation,
                onRotationEnded: { _ in }
            )
    }
}

// MARK: - Combined Gestures Modifier

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CombinedGesturesModifier: ViewModifier {
    private let gestures: () -> some View
    
    public init(@ViewBuilder gestures: @escaping () -> some View) {
        self.gestures = gestures
    }
    
    public func body(content: Content) -> some View {
        content.overlay(gestures())
    }
}

// MARK: - Gesture State Extensions

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    
    /// Adds gesture state monitoring to the view
    /// - Parameter onStateChange: Closure called when gesture state changes
    /// - Returns: Modified view with gesture state monitoring
    func customGestureStateMonitor(onStateChange: @escaping (GestureState) -> Void) -> some View {
        self.onReceive(GestureEngine().$currentState) { state in
            onStateChange(state)
        }
    }
    
    /// Adds haptic feedback to gesture interactions
    /// - Parameter hapticManager: Haptic feedback manager
    /// - Returns: Modified view with haptic feedback
    func customHapticFeedback(_ hapticManager: HapticFeedbackManager) -> some View {
        self.onReceive(hapticManager.$currentIntensity) { intensity in
            // Haptic feedback integration
        }
    }
}

// MARK: - Accessibility Extensions

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    
    /// Adds accessibility support to gestures
    /// - Parameter accessibilityLabel: Accessibility label for the gesture
    /// - Returns: Modified view with accessibility support
    func customAccessibleGesture(_ accessibilityLabel: String) -> some View {
        self.accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits(.allowsDirectInteraction)
    }
    
    /// Adds VoiceOver support to gestures
    /// - Parameter voiceOverHint: VoiceOver hint for the gesture
    /// - Returns: Modified view with VoiceOver support
    func customVoiceOverGesture(_ voiceOverHint: String) -> some View {
        self.accessibilityHint(voiceOverHint)
            .accessibilityAddTraits(.allowsDirectInteraction)
    }
} 