//
//  AdvancedGestures.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

// MARK: - Draggable Modifier

/// Makes a view draggable with optional bounds and snap-back
public struct DraggableModifier: ViewModifier {
    @Binding var position: CGPoint
    let bounds: CGRect?
    let snapBack: Bool
    let onDragStart: (() -> Void)?
    let onDragEnd: ((CGPoint) -> Void)?
    
    @State private var startPosition: CGPoint = .zero
    
    public init(
        position: Binding<CGPoint>,
        bounds: CGRect? = nil,
        snapBack: Bool = false,
        onDragStart: (() -> Void)? = nil,
        onDragEnd: ((CGPoint) -> Void)? = nil
    ) {
        self._position = position
        self.bounds = bounds
        self.snapBack = snapBack
        self.onDragStart = onDragStart
        self.onDragEnd = onDragEnd
    }
    
    public func body(content: Content) -> some View {
        content
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if startPosition == .zero {
                            startPosition = position
                            onDragStart?()
                        }
                        
                        var newPosition = CGPoint(
                            x: startPosition.x + value.translation.width,
                            y: startPosition.y + value.translation.height
                        )
                        
                        if let bounds = bounds {
                            newPosition.x = max(bounds.minX, min(bounds.maxX, newPosition.x))
                            newPosition.y = max(bounds.minY, min(bounds.maxY, newPosition.y))
                        }
                        
                        position = newPosition
                    }
                    .onEnded { value in
                        onDragEnd?(position)
                        
                        if snapBack {
                            withAnimation(.spring()) {
                                position = startPosition
                            }
                        }
                        startPosition = .zero
                    }
            )
    }
}

// MARK: - Zoomable Modifier

/// Makes a view zoomable with pinch gesture
public struct ZoomableModifier: ViewModifier {
    @Binding var scale: CGFloat
    let minScale: CGFloat
    let maxScale: CGFloat
    let doubleTapScale: CGFloat?
    
    @State private var lastScale: CGFloat = 1.0
    
    public init(
        scale: Binding<CGFloat>,
        minScale: CGFloat = 0.5,
        maxScale: CGFloat = 4.0,
        doubleTapScale: CGFloat? = 2.0
    ) {
        self._scale = scale
        self.minScale = minScale
        self.maxScale = maxScale
        self.doubleTapScale = doubleTapScale
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        let newScale = lastScale * value.magnification
                        scale = max(minScale, min(maxScale, newScale))
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
            .onTapGesture(count: 2) {
                if let doubleTapScale = doubleTapScale {
                    withAnimation(.spring()) {
                        if scale > 1.0 {
                            scale = 1.0
                            lastScale = 1.0
                        } else {
                            scale = doubleTapScale
                            lastScale = doubleTapScale
                        }
                    }
                }
            }
    }
}

// MARK: - Rotatable Modifier

/// Makes a view rotatable with gesture
public struct RotatableModifier: ViewModifier {
    @Binding var rotation: Angle
    let snapAngles: [Angle]?
    
    @State private var lastRotation: Angle = .zero
    
    public init(
        rotation: Binding<Angle>,
        snapAngles: [Angle]? = nil
    ) {
        self._rotation = rotation
        self.snapAngles = snapAngles
    }
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(rotation)
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        rotation = lastRotation + value
                    }
                    .onEnded { _ in
                        if let snapAngles = snapAngles {
                            let closestAngle = snapAngles.min { a, b in
                                abs(a.degrees - rotation.degrees) < abs(b.degrees - rotation.degrees)
                            }
                            if let closest = closestAngle {
                                withAnimation(.spring()) {
                                    rotation = closest
                                    lastRotation = closest
                                }
                                return
                            }
                        }
                        lastRotation = rotation
                    }
            )
    }
}

// MARK: - Combined Transform Modifier

/// A modifier that combines pinch-to-zoom and rotation
public struct TransformableModifier: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    @Binding var offset: CGSize
    
    @State private var lastScale: CGFloat = 1.0
    @State private var lastRotation: Angle = .zero
    
    public init(
        scale: Binding<CGFloat>,
        rotation: Binding<Angle>,
        offset: Binding<CGSize>
    ) {
        self._scale = scale
        self._rotation = rotation
        self._offset = offset
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(rotation)
            .offset(offset)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        MagnifyGesture()
                            .onChanged { value in
                                scale = lastScale * value.magnification
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
                            offset = value.translation
                        }
                        .onEnded { value in
                            offset = value.translation
                        }
                )
            )
    }
}

// MARK: - Hover Effect (macOS/visionOS)

#if os(macOS) || os(visionOS)
/// Adds hover effects to a view
public struct HoverEffectModifier: ViewModifier {
    let scaleEffect: CGFloat
    let onHover: ((Bool) -> Void)?
    
    @State private var isHovering = false
    
    public init(
        scaleEffect: CGFloat = 1.05,
        onHover: ((Bool) -> Void)? = nil
    ) {
        self.scaleEffect = scaleEffect
        self.onHover = onHover
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isHovering ? scaleEffect : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
                onHover?(hovering)
            }
    }
}
#endif

// MARK: - Shake Gesture (iOS)

#if os(iOS)
/// Detects shake gesture
public struct ShakeGestureModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
#endif

// MARK: - View Extensions

public extension View {
    /// Makes the view draggable
    func draggable(
        position: Binding<CGPoint>,
        bounds: CGRect? = nil,
        snapBack: Bool = false,
        onDragStart: (() -> Void)? = nil,
        onDragEnd: ((CGPoint) -> Void)? = nil
    ) -> some View {
        modifier(DraggableModifier(
            position: position,
            bounds: bounds,
            snapBack: snapBack,
            onDragStart: onDragStart,
            onDragEnd: onDragEnd
        ))
    }
    
    /// Makes the view zoomable
    func zoomable(
        scale: Binding<CGFloat>,
        minScale: CGFloat = 0.5,
        maxScale: CGFloat = 4.0,
        doubleTapScale: CGFloat? = 2.0
    ) -> some View {
        modifier(ZoomableModifier(
            scale: scale,
            minScale: minScale,
            maxScale: maxScale,
            doubleTapScale: doubleTapScale
        ))
    }
    
    /// Makes the view rotatable
    func rotatable(
        rotation: Binding<Angle>,
        snapAngles: [Angle]? = nil
    ) -> some View {
        modifier(RotatableModifier(rotation: rotation, snapAngles: snapAngles))
    }
    
    /// Makes the view fully transformable (scale, rotate, drag)
    func transformable(
        scale: Binding<CGFloat>,
        rotation: Binding<Angle>,
        offset: Binding<CGSize>
    ) -> some View {
        modifier(TransformableModifier(scale: scale, rotation: rotation, offset: offset))
    }
    
    #if os(macOS) || os(visionOS)
    /// Adds hover effects
    func hoverEffect(
        scale: CGFloat = 1.05,
        onHover: ((Bool) -> Void)? = nil
    ) -> some View {
        modifier(HoverEffectModifier(scaleEffect: scale, onHover: onHover))
    }
    #endif
    
    #if os(iOS)
    /// Detects device shake
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(ShakeGestureModifier(action: action))
    }
    #endif
}
