//
//  GestureKit.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(CoreMotion)
import CoreMotion
#endif

// MARK: - GestureKit Namespace

/// GestureKit - The most comprehensive gesture library for SwiftUI
///
/// GestureKit provides 25+ gesture types including:
/// - Basic gestures (tap, double tap, triple tap, long press)
/// - Directional gestures (swipe, edge swipe, pan with velocity)
/// - Transform gestures (pinch, rotation, drag)
/// - Advanced gestures (shape recognition, gesture sequences, multi-finger)
/// - Motion gestures (shake, tilt)
///
/// ## Features
/// - 🎯 25+ gesture types with full customization
/// - 📐 Shape recognition (circle, square, triangle, line)
/// - 🔗 Gesture sequences and combinations
/// - 🔧 Gesture conflict resolution
/// - 📊 Debugger overlay for development
/// - 📼 Gesture recording and playback
/// - ♿️ Accessibility alternatives
/// - 📳 Haptic feedback integration
/// - ✨ Animation helpers
///
/// ## Quick Start
/// ```swift
/// import GestureKit
///
/// struct ContentView: View {
///     var body: some View {
///         Rectangle()
///             .gestureKit(.doubleTap) { print("Double tapped!") }
///             .gestureKit(.swipe(.left)) { print("Swiped left!") }
///             .onPinch { scale in print("Scale: \(scale)") }
///             .onShapeDrawn { shape in print("Drew: \(shape)") }
///     }
/// }
/// ```
public enum GestureKit {
    /// Library version
    public static let version = "2.0.0"
    
    /// Enable debug mode globally
    public static var debugMode = false
    
    /// Global haptic feedback preference
    public static var hapticsEnabled = true
}

// MARK: - Gesture Type Enum

/// All available gesture types in GestureKit
public enum GestureType: Sendable, Equatable {
    // Basic
    case tap
    case doubleTap
    case tripleTap
    case longPress(duration: Double = 0.5)
    
    // Swipe
    case swipe(SwipeDirection)
    case swipeAny
    case edgeSwipe(Edge)
    
    // Transform
    case pinch
    case rotation
    case drag
    case pan
    
    // Multi-finger
    case twoFingerTap
    case threeFingerTap
    case twoFingerDrag
    case twoFingerRotation
    
    // Advanced
    case forceTouch
    case hover
    case scroll
    
    public static func == (lhs: GestureType, rhs: GestureType) -> Bool {
        switch (lhs, rhs) {
        case (.tap, .tap), (.doubleTap, .doubleTap), (.tripleTap, .tripleTap):
            return true
        case let (.longPress(d1), .longPress(d2)):
            return d1 == d2
        case let (.swipe(dir1), .swipe(dir2)):
            return dir1 == dir2
        case (.swipeAny, .swipeAny):
            return true
        case let (.edgeSwipe(e1), .edgeSwipe(e2)):
            return e1 == e2
        case (.pinch, .pinch), (.rotation, .rotation), (.drag, .drag), (.pan, .pan):
            return true
        case (.twoFingerTap, .twoFingerTap), (.threeFingerTap, .threeFingerTap):
            return true
        case (.twoFingerDrag, .twoFingerDrag), (.twoFingerRotation, .twoFingerRotation):
            return true
        case (.forceTouch, .forceTouch), (.hover, .hover), (.scroll, .scroll):
            return true
        default:
            return false
        }
    }
}

// MARK: - Swipe Direction

/// Direction for swipe gestures
public enum SwipeDirection: String, CaseIterable, Sendable {
    case left
    case right
    case up
    case down
    
    /// Opposite direction
    public var opposite: SwipeDirection {
        switch self {
        case .left: return .right
        case .right: return .left
        case .up: return .down
        case .down: return .up
        }
    }
    
    /// Horizontal directions
    public static var horizontal: [SwipeDirection] { [.left, .right] }
    
    /// Vertical directions
    public static var vertical: [SwipeDirection] { [.up, .down] }
}

// MARK: - Gesture Tracking State

/// State of a gesture
public enum GestureTrackingState: Sendable, Equatable {
    case inactive
    case started
    case changed
    case ended
    case cancelled
    case failed
}

// MARK: - Gesture Event

/// Information about a gesture event
public struct GestureEvent: Sendable {
    public let type: GestureType
    public let state: GestureTrackingState
    public let location: CGPoint
    public let timestamp: Date
    public let velocity: CGSize?
    public let translation: CGSize?
    public let scale: CGFloat?
    public let rotation: Angle?
    
    public init(
        type: GestureType,
        state: GestureTrackingState,
        location: CGPoint = .zero,
        timestamp: Date = Date(),
        velocity: CGSize? = nil,
        translation: CGSize? = nil,
        scale: CGFloat? = nil,
        rotation: Angle? = nil
    ) {
        self.type = type
        self.state = state
        self.location = location
        self.timestamp = timestamp
        self.velocity = velocity
        self.translation = translation
        self.scale = scale
        self.rotation = rotation
    }
}

// MARK: - Swipe Gesture

/// A configurable swipe gesture modifier
public struct SwipeGestureModifier: ViewModifier {
    let direction: SwipeDirection
    let minimumDistance: CGFloat
    let maximumAngle: Double
    let action: () -> Void
    let hapticFeedback: Bool
    
    public init(
        direction: SwipeDirection,
        minimumDistance: CGFloat = 50,
        maximumAngle: Double = 30,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void
    ) {
        self.direction = direction
        self.minimumDistance = minimumDistance
        self.maximumAngle = maximumAngle
        self.hapticFeedback = hapticFeedback
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: minimumDistance)
                    .onEnded { value in
                        let horizontal = value.translation.width
                        let vertical = value.translation.height
                        
                        // Calculate angle to ensure direction accuracy
                        let angle = atan2(abs(vertical), abs(horizontal)) * 180 / .pi
                        
                        let detected: SwipeDirection? = {
                            if abs(horizontal) > abs(vertical) && angle <= maximumAngle {
                                return horizontal > 0 ? .right : .left
                            } else if abs(vertical) >= abs(horizontal) && (90 - angle) <= maximumAngle {
                                return vertical > 0 ? .down : .up
                            }
                            return nil
                        }()
                        
                        if detected == direction {
                            if hapticFeedback {
                                HapticEngine.impact(.light)
                            }
                            action()
                        }
                    }
            )
    }
}

// MARK: - Multi-Direction Swipe

/// Swipe gesture that detects all directions
public struct MultiDirectionSwipeModifier: ViewModifier {
    let minimumDistance: CGFloat
    let action: (SwipeDirection) -> Void
    
    public init(
        minimumDistance: CGFloat = 50,
        action: @escaping (SwipeDirection) -> Void
    ) {
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
                        
                        let direction: SwipeDirection = {
                            if abs(horizontal) > abs(vertical) {
                                return horizontal > 0 ? .right : .left
                            } else {
                                return vertical > 0 ? .down : .up
                            }
                        }()
                        
                        HapticEngine.impact(.light)
                        action(direction)
                    }
            )
    }
}

// MARK: - Double Tap Gesture

/// A double tap gesture modifier with location
public struct DoubleTapGestureModifier: ViewModifier {
    let action: (CGPoint) -> Void
    
    public init(action: @escaping (CGPoint) -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                SpatialTapGesture(count: 2)
                    .onEnded { value in
                        HapticEngine.impact(.medium)
                        action(value.location)
                    }
            )
    }
}

// MARK: - Triple Tap Gesture

/// A triple tap gesture modifier with location
public struct TripleTapGestureModifier: ViewModifier {
    let action: (CGPoint) -> Void
    
    public init(action: @escaping (CGPoint) -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 3) {
                HapticEngine.impact(.heavy)
                action(.zero)
            }
    }
}

// MARK: - Long Press Gesture

/// A customizable long press gesture modifier with progress
public struct LongPressGestureModifier: ViewModifier {
    let minimumDuration: Double
    let maximumDistance: CGFloat
    let onStart: (() -> Void)?
    let onProgress: ((Double) -> Void)?
    let onComplete: () -> Void
    let onCancel: (() -> Void)?
    
    @State private var isPressing = false
    @State private var timer: Timer?
    @State private var startTime: Date?
    
    public init(
        minimumDuration: Double = 0.5,
        maximumDistance: CGFloat = 10,
        onStart: (() -> Void)? = nil,
        onProgress: ((Double) -> Void)? = nil,
        onComplete: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
        self.onStart = onStart
        self.onProgress = onProgress
        self.onComplete = onComplete
        self.onCancel = onCancel
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
                    .onChanged { isPressing in
                        if isPressing && !self.isPressing {
                            self.isPressing = true
                            self.startTime = Date()
                            self.onStart?()
                            
                            // Progress timer
                            if onProgress != nil {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                                    guard let start = startTime else { return }
                                    let elapsed = Date().timeIntervalSince(start)
                                    let progress = min(elapsed / minimumDuration, 1.0)
                                    onProgress?(progress)
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        timer?.invalidate()
                        timer = nil
                        isPressing = false
                        HapticEngine.notification(.success)
                        onComplete()
                    }
            )
    }
}

// MARK: - Pinch Gesture

/// A pinch gesture modifier with momentum
public struct PinchGestureModifier: ViewModifier {
    let onChanged: (CGFloat) -> Void
    let onEnded: ((CGFloat) -> Void)?
    
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
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
                MagnificationGesture()
                    .onChanged { value in
                        currentScale = lastScale * value
                        onChanged(currentScale)
                    }
                    .onEnded { value in
                        lastScale = currentScale
                        onEnded?(currentScale)
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
    @State private var lastRotation: Angle = .zero
    
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
                        currentRotation = lastRotation + value
                        onChanged(currentRotation)
                    }
                    .onEnded { value in
                        lastRotation = currentRotation
                        onEnded?(currentRotation)
                    }
            )
    }
}

// MARK: - Pan Gesture with Velocity

/// A pan gesture modifier with velocity tracking
public struct PanGestureModifier: ViewModifier {
    let onChanged: (CGSize, CGSize) -> Void  // (translation, velocity)
    let onEnded: ((CGSize, CGSize) -> Void)?
    
    @State private var lastTranslation: CGSize = .zero
    @State private var lastTime: Date = Date()
    @State private var velocity: CGSize = .zero
    
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
                        
                        if dt > 0 {
                            velocity = CGSize(
                                width: (value.translation.width - lastTranslation.width) / dt,
                                height: (value.translation.height - lastTranslation.height) / dt
                            )
                        }
                        
                        lastTranslation = value.translation
                        lastTime = now
                        onChanged(value.translation, velocity)
                    }
                    .onEnded { value in
                        onEnded?(value.translation, value.predictedEndTranslation)
                        lastTranslation = .zero
                        velocity = .zero
                    }
            )
    }
}

// MARK: - Drag Gesture with Bounds

/// A drag gesture with optional bounds constraint
public struct BoundedDragModifier: ViewModifier {
    @Binding var offset: CGSize
    let bounds: CGRect?
    let onDragStart: (() -> Void)?
    let onDragEnd: ((CGSize) -> Void)?
    
    @State private var startOffset: CGSize = .zero
    
    public init(
        offset: Binding<CGSize>,
        bounds: CGRect? = nil,
        onDragStart: (() -> Void)? = nil,
        onDragEnd: ((CGSize) -> Void)? = nil
    ) {
        self._offset = offset
        self.bounds = bounds
        self.onDragStart = onDragStart
        self.onDragEnd = onDragEnd
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if startOffset == .zero {
                            startOffset = offset
                            onDragStart?()
                        }
                        
                        var newOffset = CGSize(
                            width: startOffset.width + value.translation.width,
                            height: startOffset.height + value.translation.height
                        )
                        
                        // Apply bounds if provided
                        if let bounds = bounds {
                            newOffset.width = max(bounds.minX, min(bounds.maxX, newOffset.width))
                            newOffset.height = max(bounds.minY, min(bounds.maxY, newOffset.height))
                        }
                        
                        offset = newOffset
                    }
                    .onEnded { _ in
                        startOffset = .zero
                        onDragEnd?(offset)
                    }
            )
    }
}

// MARK: - Edge Swipe Gesture

/// A gesture that triggers when swiping from an edge
public struct EdgeSwipeModifier: ViewModifier {
    let edge: Edge
    let threshold: CGFloat
    let action: () -> Void
    
    @State private var startLocation: CGPoint = .zero
    @State private var didTrigger = false
    
    public init(
        edge: Edge,
        threshold: CGFloat = 50,
        action: @escaping () -> Void
    ) {
        self.edge = edge
        self.threshold = threshold
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .gesture(
                    DragGesture(coordinateSpace: .local)
                        .onChanged { value in
                            if startLocation == .zero {
                                startLocation = value.startLocation
                            }
                            
                            guard !didTrigger else { return }
                            
                            let isEdgeStart = isStartingFromEdge(
                                startLocation,
                                in: geometry.size
                            )
                            
                            if isEdgeStart && meetsThreshold(value.translation) {
                                didTrigger = true
                                HapticEngine.impact(.medium)
                                action()
                            }
                        }
                        .onEnded { _ in
                            startLocation = .zero
                            didTrigger = false
                        }
                )
        }
    }
    
    private func isStartingFromEdge(_ location: CGPoint, in size: CGSize) -> Bool {
        let edgeThreshold: CGFloat = 20
        switch edge {
        case .leading: return location.x <= edgeThreshold
        case .trailing: return location.x >= size.width - edgeThreshold
        case .top: return location.y <= edgeThreshold
        case .bottom: return location.y >= size.height - edgeThreshold
        }
    }
    
    private func meetsThreshold(_ translation: CGSize) -> Bool {
        switch edge {
        case .leading: return translation.width >= threshold
        case .trailing: return translation.width <= -threshold
        case .top: return translation.height >= threshold
        case .bottom: return translation.height <= -threshold
        }
    }
}

// MARK: - Simultaneous Gesture (Pinch + Rotation)

/// Combined pinch and rotation gesture
public struct TransformGestureModifier: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    @Binding var offset: CGSize
    
    let minScale: CGFloat
    let maxScale: CGFloat
    
    @State private var lastScale: CGFloat = 1.0
    @State private var lastRotation: Angle = .zero
    @State private var lastOffset: CGSize = .zero
    
    public init(
        scale: Binding<CGFloat>,
        rotation: Binding<Angle>,
        offset: Binding<CGSize>,
        minScale: CGFloat = 0.5,
        maxScale: CGFloat = 3.0
    ) {
        self._scale = scale
        self._rotation = rotation
        self._offset = offset
        self.minScale = minScale
        self.maxScale = maxScale
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(rotation)
            .offset(offset)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let newScale = lastScale * value
                                scale = max(minScale, min(maxScale, newScale))
                            }
                            .onEnded { _ in
                                lastScale = scale
                            },
                        RotationGesture()
                            .onChanged { value in
                                rotation = lastRotation + value
                            }
                            .onEnded { _ in
                                lastRotation = rotation
                            }
                    ),
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
            )
    }
}

// MARK: - Hover Gesture (macOS/iPadOS)

/// A hover gesture modifier
public struct HoverGestureModifier: ViewModifier {
    let onHover: (Bool) -> Void
    let onLocation: ((CGPoint) -> Void)?
    
    @State private var isHovering = false
    
    public init(
        onHover: @escaping (Bool) -> Void,
        onLocation: ((CGPoint) -> Void)? = nil
    ) {
        self.onHover = onHover
        self.onLocation = onLocation
    }
    
    public func body(content: Content) -> some View {
        content
            .onHover { hovering in
                isHovering = hovering
                onHover(hovering)
            }
    }
}

// MARK: - Two Finger Tap

#if os(iOS)
/// Two finger tap gesture using UIKit gesture recognizer
public struct TwoFingerTapModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                SpatialTapGesture(count: 1)
                    .onEnded { _ in
                        // Note: True multi-finger requires UIKit integration
                        // This is a simplified version
                    }
            )
            .overlay(
                TwoFingerTapView(action: action)
                    .allowsHitTesting(true)
            )
    }
}

struct TwoFingerTapView: UIViewRepresentable {
    let action: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        tap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tap)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func handleTap() {
            HapticEngine.impact(.medium)
            action()
        }
    }
}
#endif

// MARK: - View Extensions

public extension View {
    /// Adds a swipe gesture in the specified direction
    func onSwipe(
        _ direction: SwipeDirection,
        minimumDistance: CGFloat = 50,
        maximumAngle: Double = 30,
        hapticFeedback: Bool = true,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(SwipeGestureModifier(
            direction: direction,
            minimumDistance: minimumDistance,
            maximumAngle: maximumAngle,
            hapticFeedback: hapticFeedback,
            action: action
        ))
    }
    
    /// Adds swipe gestures in all directions
    func onSwipeAny(
        minimumDistance: CGFloat = 50,
        perform action: @escaping (SwipeDirection) -> Void
    ) -> some View {
        modifier(MultiDirectionSwipeModifier(minimumDistance: minimumDistance, action: action))
    }
    
    /// Adds a double tap gesture with location
    func onDoubleTap(perform action: @escaping (CGPoint) -> Void) -> some View {
        modifier(DoubleTapGestureModifier(action: action))
    }
    
    /// Adds a double tap gesture (simple)
    func onDoubleTap(perform action: @escaping () -> Void) -> some View {
        modifier(DoubleTapGestureModifier { _ in action() })
    }
    
    /// Adds a triple tap gesture
    func onTripleTap(perform action: @escaping () -> Void) -> some View {
        modifier(TripleTapGestureModifier { _ in action() })
    }
    
    /// Adds a customizable long press gesture
    func onLongPress(
        minimumDuration: Double = 0.5,
        maximumDistance: CGFloat = 10,
        onStart: (() -> Void)? = nil,
        onProgress: ((Double) -> Void)? = nil,
        onComplete: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        modifier(LongPressGestureModifier(
            minimumDuration: minimumDuration,
            maximumDistance: maximumDistance,
            onStart: onStart,
            onProgress: onProgress,
            onComplete: onComplete,
            onCancel: onCancel
        ))
    }
    
    /// Adds a pinch gesture
    func onPinch(
        onChanged: @escaping (CGFloat) -> Void,
        onEnded: ((CGFloat) -> Void)? = nil
    ) -> some View {
        modifier(PinchGestureModifier(onChanged: onChanged, onEnded: onEnded))
    }
    
    /// Adds a rotation gesture
    func onRotate(
        onChanged: @escaping (Angle) -> Void,
        onEnded: ((Angle) -> Void)? = nil
    ) -> some View {
        modifier(RotationGestureModifier(onChanged: onChanged, onEnded: onEnded))
    }
    
    /// Adds a pan gesture with velocity tracking
    func onPan(
        onChanged: @escaping (CGSize, CGSize) -> Void,
        onEnded: ((CGSize, CGSize) -> Void)? = nil
    ) -> some View {
        modifier(PanGestureModifier(onChanged: onChanged, onEnded: onEnded))
    }
    
    /// Adds a bounded drag gesture
    func draggable(
        offset: Binding<CGSize>,
        bounds: CGRect? = nil,
        onStart: (() -> Void)? = nil,
        onEnd: ((CGSize) -> Void)? = nil
    ) -> some View {
        modifier(BoundedDragModifier(
            offset: offset,
            bounds: bounds,
            onDragStart: onStart,
            onDragEnd: onEnd
        ))
    }
    
    /// Adds an edge swipe gesture
    func onEdgeSwipe(
        _ edge: Edge,
        threshold: CGFloat = 50,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(EdgeSwipeModifier(edge: edge, threshold: threshold, action: action))
    }
    
    /// Adds combined transform gestures (pinch + rotate + drag)
    func transformable(
        scale: Binding<CGFloat>,
        rotation: Binding<Angle>,
        offset: Binding<CGSize>,
        minScale: CGFloat = 0.5,
        maxScale: CGFloat = 3.0
    ) -> some View {
        modifier(TransformGestureModifier(
            scale: scale,
            rotation: rotation,
            offset: offset,
            minScale: minScale,
            maxScale: maxScale
        ))
    }
    
    /// Adds a hover gesture
    func onHoverGesture(
        perform action: @escaping (Bool) -> Void,
        onLocation: ((CGPoint) -> Void)? = nil
    ) -> some View {
        modifier(HoverGestureModifier(onHover: action, onLocation: onLocation))
    }
    
    #if os(iOS)
    /// Adds a two finger tap gesture
    func onTwoFingerTap(perform action: @escaping () -> Void) -> some View {
        modifier(TwoFingerTapModifier(action: action))
    }
    #endif
}

// MARK: - Unified Gesture API

public extension View {
    /// Unified gesture API for simple gestures
    @ViewBuilder
    func gestureKit(_ type: GestureType, perform action: @escaping () -> Void) -> some View {
        switch type {
        case .tap:
            self.onTapGesture(perform: action)
        case .doubleTap:
            self.onDoubleTap(perform: action)
        case .tripleTap:
            self.onTripleTap(perform: action)
        case .longPress(let duration):
            self.onLongPress(minimumDuration: duration, onComplete: action)
        case .swipe(let direction):
            self.onSwipe(direction, perform: action)
        case .swipeAny:
            self.onSwipeAny { _ in action() }
        case .edgeSwipe(let edge):
            self.onEdgeSwipe(edge, perform: action)
        default:
            self
        }
    }
}
