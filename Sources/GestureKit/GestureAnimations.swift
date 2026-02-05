//
//  GestureAnimations.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

// MARK: - Animation Preset

/// Preset animations for gesture feedback
public enum GestureAnimationPreset: String, CaseIterable, Sendable {
    case bounce
    case scale
    case shake
    case pulse
    case rotate
    case slide
    case fade
    case glow
    case wiggle
    case rubber
    case flip
    case swing
}

// MARK: - Animation Configuration

/// Configuration for gesture-triggered animations
public struct GestureAnimationConfig {
    public let duration: Double
    public let delay: Double
    public let repeatCount: Int
    public let autoreverses: Bool
    
    public init(
        duration: Double = 0.3,
        delay: Double = 0,
        repeatCount: Int = 1,
        autoreverses: Bool = true
    ) {
        self.duration = duration
        self.delay = delay
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
    }
    
    public static let quick = GestureAnimationConfig(duration: 0.15)
    public static let standard = GestureAnimationConfig(duration: 0.3)
    public static let slow = GestureAnimationConfig(duration: 0.5)
    public static let bouncy = GestureAnimationConfig(duration: 0.4, autoreverses: true)
}

// MARK: - Bounce Animation

/// Bounce animation modifier
public struct BounceAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let scale: CGFloat
    let config: GestureAnimationConfig
    
    @State private var animationScale: CGFloat = 1.0
    
    public init(trigger: Binding<Bool>, scale: CGFloat = 0.9, config: GestureAnimationConfig = .standard) {
        self._trigger = trigger
        self.scale = scale
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(animationScale)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.spring(response: config.duration, dampingFraction: 0.5)) {
                        animationScale = scale
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration * 0.5) {
                        withAnimation(.spring(response: config.duration, dampingFraction: 0.5)) {
                            animationScale = 1.0
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Shake Animation

/// Shake animation modifier
public struct ShakeAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let intensity: CGFloat
    let config: GestureAnimationConfig
    
    @State private var shakeOffset: CGFloat = 0
    
    public init(trigger: Binding<Bool>, intensity: CGFloat = 10, config: GestureAnimationConfig = .quick) {
        self._trigger = trigger
        self.intensity = intensity
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(x: shakeOffset)
            .onChange(of: trigger) { newValue in
                if newValue {
                    let totalDuration = config.duration
                    let shakeCount = 4
                    let singleShakeDuration = totalDuration / Double(shakeCount)
                    
                    for i in 0..<shakeCount {
                        let delay = Double(i) * singleShakeDuration
                        let offset = (i % 2 == 0) ? intensity : -intensity
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation(.linear(duration: singleShakeDuration / 2)) {
                                shakeOffset = offset
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                        withAnimation(.linear(duration: singleShakeDuration / 2)) {
                            shakeOffset = 0
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Pulse Animation

/// Pulse animation modifier
public struct PulseAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let scale: CGFloat
    let opacity: Double
    let config: GestureAnimationConfig
    
    @State private var isPulsing = false
    
    public init(
        trigger: Binding<Bool>,
        scale: CGFloat = 1.1,
        opacity: Double = 0.7,
        config: GestureAnimationConfig = .standard
    ) {
        self._trigger = trigger
        self.scale = scale
        self.opacity = opacity
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? scale : 1.0)
            .opacity(isPulsing ? opacity : 1.0)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: config.duration)) {
                        isPulsing = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                        withAnimation(.easeInOut(duration: config.duration)) {
                            isPulsing = false
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Wiggle Animation

/// Wiggle animation modifier
public struct WiggleAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let angle: Double
    let config: GestureAnimationConfig
    
    @State private var rotation: Double = 0
    
    public init(trigger: Binding<Bool>, angle: Double = 5, config: GestureAnimationConfig = .quick) {
        self._trigger = trigger
        self.angle = angle
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onChange(of: trigger) { newValue in
                if newValue {
                    let totalDuration = config.duration
                    let wiggleCount = 6
                    let singleWiggleDuration = totalDuration / Double(wiggleCount)
                    
                    for i in 0..<wiggleCount {
                        let delay = Double(i) * singleWiggleDuration
                        let rotationAngle = (i % 2 == 0) ? angle : -angle
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation(.linear(duration: singleWiggleDuration)) {
                                rotation = rotationAngle
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                        withAnimation(.linear(duration: singleWiggleDuration / 2)) {
                            rotation = 0
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Rubber Band Animation

/// Rubber band stretch animation
public struct RubberBandModifier: ViewModifier {
    @Binding var trigger: Bool
    let axis: Axis
    let intensity: CGFloat
    let config: GestureAnimationConfig
    
    @State private var scaleX: CGFloat = 1.0
    @State private var scaleY: CGFloat = 1.0
    
    public init(
        trigger: Binding<Bool>,
        axis: Axis = .horizontal,
        intensity: CGFloat = 1.2,
        config: GestureAnimationConfig = .bouncy
    ) {
        self._trigger = trigger
        self.axis = axis
        self.intensity = intensity
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(x: scaleX, y: scaleY)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.spring(response: config.duration / 2, dampingFraction: 0.3)) {
                        if axis == .horizontal {
                            scaleX = intensity
                            scaleY = 2 - intensity
                        } else {
                            scaleX = 2 - intensity
                            scaleY = intensity
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration / 2) {
                        withAnimation(.spring(response: config.duration / 2, dampingFraction: 0.5)) {
                            scaleX = 1.0
                            scaleY = 1.0
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Flip Animation

/// Flip animation modifier
public struct FlipAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let config: GestureAnimationConfig
    
    @State private var rotation: Double = 0
    
    public init(
        trigger: Binding<Bool>,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0),
        config: GestureAnimationConfig = .standard
    ) {
        self._trigger = trigger
        self.axis = axis
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(rotation), axis: axis)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: config.duration)) {
                        rotation = 180
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                        withAnimation(.easeInOut(duration: config.duration)) {
                            rotation = 360
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration * 2) {
                        rotation = 0
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Glow Animation

/// Glow effect animation
public struct GlowAnimationModifier: ViewModifier {
    @Binding var trigger: Bool
    let color: Color
    let radius: CGFloat
    let config: GestureAnimationConfig
    
    @State private var glowRadius: CGFloat = 0
    @State private var glowOpacity: Double = 0
    
    public init(
        trigger: Binding<Bool>,
        color: Color = .blue,
        radius: CGFloat = 20,
        config: GestureAnimationConfig = .standard
    ) {
        self._trigger = trigger
        self.color = color
        self.radius = radius
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(glowOpacity), radius: glowRadius)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.easeOut(duration: config.duration)) {
                        glowRadius = radius
                        glowOpacity = 0.8
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                        withAnimation(.easeIn(duration: config.duration)) {
                            glowRadius = 0
                            glowOpacity = 0
                        }
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - Interactive Gesture Animation

/// Applies animation based on gesture state
public struct InteractiveGestureModifier: ViewModifier {
    @Binding var isActive: Bool
    let pressedScale: CGFloat
    let pressedOpacity: Double
    
    public init(
        isActive: Binding<Bool>,
        pressedScale: CGFloat = 0.95,
        pressedOpacity: Double = 0.8
    ) {
        self._isActive = isActive
        self.pressedScale = pressedScale
        self.pressedOpacity = pressedOpacity
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? pressedScale : 1.0)
            .opacity(isActive ? pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isActive)
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds bounce animation triggered by binding
    func bounceAnimation(
        trigger: Binding<Bool>,
        scale: CGFloat = 0.9,
        config: GestureAnimationConfig = .standard
    ) -> some View {
        modifier(BounceAnimationModifier(trigger: trigger, scale: scale, config: config))
    }
    
    /// Adds shake animation triggered by binding
    func shakeAnimation(
        trigger: Binding<Bool>,
        intensity: CGFloat = 10,
        config: GestureAnimationConfig = .quick
    ) -> some View {
        modifier(ShakeAnimationModifier(trigger: trigger, intensity: intensity, config: config))
    }
    
    /// Adds pulse animation triggered by binding
    func pulseAnimation(
        trigger: Binding<Bool>,
        scale: CGFloat = 1.1,
        opacity: Double = 0.7,
        config: GestureAnimationConfig = .standard
    ) -> some View {
        modifier(PulseAnimationModifier(trigger: trigger, scale: scale, opacity: opacity, config: config))
    }
    
    /// Adds wiggle animation triggered by binding
    func wiggleAnimation(
        trigger: Binding<Bool>,
        angle: Double = 5,
        config: GestureAnimationConfig = .quick
    ) -> some View {
        modifier(WiggleAnimationModifier(trigger: trigger, angle: angle, config: config))
    }
    
    /// Adds rubber band animation triggered by binding
    func rubberBandAnimation(
        trigger: Binding<Bool>,
        axis: Axis = .horizontal,
        intensity: CGFloat = 1.2,
        config: GestureAnimationConfig = .bouncy
    ) -> some View {
        modifier(RubberBandModifier(trigger: trigger, axis: axis, intensity: intensity, config: config))
    }
    
    /// Adds flip animation triggered by binding
    func flipAnimation(
        trigger: Binding<Bool>,
        axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0),
        config: GestureAnimationConfig = .standard
    ) -> some View {
        modifier(FlipAnimationModifier(trigger: trigger, axis: axis, config: config))
    }
    
    /// Adds glow animation triggered by binding
    func glowAnimation(
        trigger: Binding<Bool>,
        color: Color = .blue,
        radius: CGFloat = 20,
        config: GestureAnimationConfig = .standard
    ) -> some View {
        modifier(GlowAnimationModifier(trigger: trigger, color: color, radius: radius, config: config))
    }
    
    /// Adds interactive gesture state animation
    func interactiveGesture(
        isActive: Binding<Bool>,
        pressedScale: CGFloat = 0.95,
        pressedOpacity: Double = 0.8
    ) -> some View {
        modifier(InteractiveGestureModifier(isActive: isActive, pressedScale: pressedScale, pressedOpacity: pressedOpacity))
    }
    
    /// Adds preset animation
    @ViewBuilder
    func gestureAnimation(
        _ preset: GestureAnimationPreset,
        trigger: Binding<Bool>,
        config: GestureAnimationConfig = .standard
    ) -> some View {
        switch preset {
        case .bounce:
            self.bounceAnimation(trigger: trigger, config: config)
        case .scale:
            self.bounceAnimation(trigger: trigger, scale: 1.1, config: config)
        case .shake:
            self.shakeAnimation(trigger: trigger, config: config)
        case .pulse:
            self.pulseAnimation(trigger: trigger, config: config)
        case .rotate:
            self.flipAnimation(trigger: trigger, axis: (0, 0, 1), config: config)
        case .slide:
            self.shakeAnimation(trigger: trigger, intensity: 20, config: config)
        case .fade:
            self.pulseAnimation(trigger: trigger, scale: 1.0, opacity: 0.3, config: config)
        case .glow:
            self.glowAnimation(trigger: trigger, config: config)
        case .wiggle:
            self.wiggleAnimation(trigger: trigger, config: config)
        case .rubber:
            self.rubberBandAnimation(trigger: trigger, config: config)
        case .flip:
            self.flipAnimation(trigger: trigger, config: config)
        case .swing:
            self.wiggleAnimation(trigger: trigger, angle: 15, config: config)
        }
    }
}
