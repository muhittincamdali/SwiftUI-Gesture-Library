//
//  GestureKit.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

/// GestureKit - Advanced gesture library for SwiftUI
///
/// GestureKit provides a collection of advanced, customizable gestures for SwiftUI
/// applications with support for iOS, macOS, visionOS, and more.
///
/// ## Features
/// - 👆 Advanced tap gestures (multi-tap, long press variations)
/// - 🤏 Pinch and zoom with momentum
/// - 🔄 Rotation gestures
/// - ✋ Pan and drag with velocity tracking
/// - 📱 Swipe gestures in all directions
/// - 🎯 Combined gesture compositions
/// - 🌟 Custom gesture recognizers
///
/// ## Quick Start
/// ```swift
/// import GestureKit
///
/// struct ContentView: View {
///     var body: some View {
///         Rectangle()
///             .onSwipe(.left) { print("Swiped left!") }
///             .onPinch { scale in print("Scale: \(scale)") }
///             .onDoubleTap { print("Double tapped!") }
///     }
/// }
/// ```
public enum GestureKit {
    /// Library version
    public static let version = "1.0.0"
}

// MARK: - Swipe Direction

/// Direction for swipe gestures
public enum SwipeDirection: CaseIterable, Sendable {
    case left
    case right
    case up
    case down
    
    /// Angle range for the direction (in radians)
    var angleRange: ClosedRange<Double> {
        switch self {
        case .right: return -Double.pi/4...Double.pi/4
        case .down: return Double.pi/4...3*Double.pi/4
        case .left: return (3*Double.pi/4...Double.pi)
        case .up: return (-3*Double.pi/4)...(-Double.pi/4)
        }
    }
}

// MARK: - Swipe Gesture

/// A swipe gesture modifier
public struct SwipeGesture: ViewModifier {
    let direction: SwipeDirection
    let minimumDistance: CGFloat
    let action: () -> Void
    
    @State private var offset: CGSize = .zero
    
    public init(
        direction: SwipeDirection,
        minimumDistance: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.direction = direction
        self.minimumDistance = minimumDistance
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: minimumDistance)
                    .onEnded { value in
                        let horizontal = value.translation.width
                        let vertical = value.translation.height
                        
                        let swipeDirection: SwipeDirection? = {
                            if abs(horizontal) > abs(vertical) {
                                return horizontal > 0 ? .right : .left
                            } else {
                                return vertical > 0 ? .down : .up
                            }
                        }()
                        
                        if swipeDirection == direction {
                            action()
                        }
                    }
            )
    }
}

// MARK: - Double Tap Gesture

/// A double tap gesture modifier
public struct DoubleTapGesture: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2) {
                action()
            }
    }
}

// MARK: - Triple Tap Gesture

/// A triple tap gesture modifier
public struct TripleTapGesture: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 3) {
                action()
            }
    }
}

// MARK: - Long Press Gesture

/// A customizable long press gesture modifier
public struct CustomLongPressGesture: ViewModifier {
    let minimumDuration: Double
    let onStart: (() -> Void)?
    let onEnd: (() -> Void)?
    
    @State private var isPressing = false
    
    public init(
        minimumDuration: Double = 0.5,
        onStart: (() -> Void)? = nil,
        onEnd: (() -> Void)? = nil
    ) {
        self.minimumDuration = minimumDuration
        self.onStart = onStart
        self.onEnd = onEnd
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: minimumDuration)
                    .onChanged { _ in
                        if !isPressing {
                            isPressing = true
                            onStart?()
                        }
                    }
                    .onEnded { _ in
                        isPressing = false
                        onEnd?()
                    }
            )
    }
}

// MARK: - Pinch Gesture

/// A pinch gesture modifier
public struct PinchGesture: ViewModifier {
    let onChanged: (CGFloat) -> Void
    let onEnded: ((CGFloat) -> Void)?
    
    @State private var currentScale: CGFloat = 1.0
    
    public init(
        onChanged: @escaping (CGFloat) -> Void,
        onEnded: ((CGFloat) -> Void)? = nil
    ) {
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentScale = value.magnification
                        onChanged(currentScale)
                    }
                    .onEnded { value in
                        onEnded?(value.magnification)
                        currentScale = 1.0
                    }
            )
    }
}

// MARK: - Rotation Gesture

/// A rotation gesture modifier
public struct RotationGestureModifier: ViewModifier {
    let onChanged: (Angle) -> Void
    let onEnded: ((Angle) -> Void)?
    
    @State private var currentRotation: Angle = .zero
    
    public init(
        onChanged: @escaping (Angle) -> Void,
        onEnded: ((Angle) -> Void)? = nil
    ) {
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        currentRotation = value
                        onChanged(value)
                    }
                    .onEnded { value in
                        onEnded?(value)
                        currentRotation = .zero
                    }
            )
    }
}

// MARK: - Pan Gesture with Velocity

/// A pan gesture modifier with velocity tracking
public struct PanGesture: ViewModifier {
    let onChanged: (CGSize, CGSize) -> Void  // (translation, velocity)
    let onEnded: ((CGSize, CGSize) -> Void)?
    
    @State private var lastTranslation: CGSize = .zero
    @State private var lastTime: Date = Date()
    
    public init(
        onChanged: @escaping (CGSize, CGSize) -> Void,
        onEnded: ((CGSize, CGSize) -> Void)? = nil
    ) {
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let now = Date()
                        let dt = now.timeIntervalSince(lastTime)
                        
                        let velocity: CGSize
                        if dt > 0 {
                            velocity = CGSize(
                                width: (value.translation.width - lastTranslation.width) / dt,
                                height: (value.translation.height - lastTranslation.height) / dt
                            )
                        } else {
                            velocity = .zero
                        }
                        
                        lastTranslation = value.translation
                        lastTime = now
                        
                        onChanged(value.translation, velocity)
                    }
                    .onEnded { value in
                        let now = Date()
                        let dt = now.timeIntervalSince(lastTime)
                        
                        let velocity: CGSize
                        if dt > 0 && dt < 0.1 {
                            velocity = CGSize(
                                width: (value.translation.width - lastTranslation.width) / dt,
                                height: (value.translation.height - lastTranslation.height) / dt
                            )
                        } else {
                            velocity = .zero
                        }
                        
                        onEnded?(value.translation, velocity)
                        lastTranslation = .zero
                    }
            )
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a swipe gesture in the specified direction
    /// - Parameters:
    ///   - direction: The swipe direction
    ///   - minimumDistance: Minimum distance for swipe recognition
    ///   - action: Action to perform on swipe
    func onSwipe(
        _ direction: SwipeDirection,
        minimumDistance: CGFloat = 50,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(SwipeGesture(direction: direction, minimumDistance: minimumDistance, action: action))
    }
    
    /// Adds swipe gestures in all directions
    /// - Parameter action: Action with direction parameter
    func onSwipeAny(perform action: @escaping (SwipeDirection) -> Void) -> some View {
        self
            .onSwipe(.left) { action(.left) }
            .onSwipe(.right) { action(.right) }
            .onSwipe(.up) { action(.up) }
            .onSwipe(.down) { action(.down) }
    }
    
    /// Adds a double tap gesture
    /// - Parameter action: Action to perform
    func onDoubleTap(perform action: @escaping () -> Void) -> some View {
        modifier(DoubleTapGesture(action: action))
    }
    
    /// Adds a triple tap gesture
    /// - Parameter action: Action to perform
    func onTripleTap(perform action: @escaping () -> Void) -> some View {
        modifier(TripleTapGesture(action: action))
    }
    
    /// Adds a customizable long press gesture
    /// - Parameters:
    ///   - minimumDuration: Minimum press duration
    ///   - onStart: Called when press starts
    ///   - onEnd: Called when press ends
    func onLongPress(
        minimumDuration: Double = 0.5,
        onStart: (() -> Void)? = nil,
        onEnd: (() -> Void)? = nil
    ) -> some View {
        modifier(CustomLongPressGesture(minimumDuration: minimumDuration, onStart: onStart, onEnd: onEnd))
    }
    
    /// Adds a pinch gesture
    /// - Parameters:
    ///   - onChanged: Called during pinch with scale
    ///   - onEnded: Called when pinch ends
    func onPinch(
        onChanged: @escaping (CGFloat) -> Void,
        onEnded: ((CGFloat) -> Void)? = nil
    ) -> some View {
        modifier(PinchGesture(onChanged: onChanged, onEnded: onEnded))
    }
    
    /// Adds a rotation gesture
    /// - Parameters:
    ///   - onChanged: Called during rotation with angle
    ///   - onEnded: Called when rotation ends
    func onRotate(
        onChanged: @escaping (Angle) -> Void,
        onEnded: ((Angle) -> Void)? = nil
    ) -> some View {
        modifier(RotationGestureModifier(onChanged: onChanged, onEnded: onEnded))
    }
    
    /// Adds a pan gesture with velocity tracking
    /// - Parameters:
    ///   - onChanged: Called during pan with translation and velocity
    ///   - onEnded: Called when pan ends
    func onPan(
        onChanged: @escaping (CGSize, CGSize) -> Void,
        onEnded: ((CGSize, CGSize) -> Void)? = nil
    ) -> some View {
        modifier(PanGesture(onChanged: onChanged, onEnded: onEnded))
    }
}
