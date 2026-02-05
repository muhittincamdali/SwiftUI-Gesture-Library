//
//  GestureAccessibility.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

// MARK: - Accessibility Action

/// Represents an accessible alternative to a gesture
public struct AccessibleGestureAction: Identifiable, Sendable {
    public let id = UUID()
    public let name: String
    public let systemImage: String
    public let description: String
    public let action: @Sendable () -> Void
    
    public init(
        name: String,
        systemImage: String,
        description: String,
        action: @escaping @Sendable () -> Void
    ) {
        self.name = name
        self.systemImage = systemImage
        self.description = description
        self.action = action
    }
}

// MARK: - Gesture Accessibility Configuration

/// Configuration for gesture accessibility
public struct GestureAccessibilityConfig: Sendable {
    public let gestureType: GestureType
    public let accessibilityLabel: String
    public let accessibilityHint: String
    public let alternativeActions: [AccessibleGestureAction]
    
    public init(
        gestureType: GestureType,
        label: String,
        hint: String,
        alternatives: [AccessibleGestureAction] = []
    ) {
        self.gestureType = gestureType
        self.accessibilityLabel = label
        self.accessibilityHint = hint
        self.alternativeActions = alternatives
    }
    
    // MARK: - Preset Configurations
    
    public static func swipe(
        direction: SwipeDirection,
        label: String,
        action: @escaping @Sendable () -> Void
    ) -> GestureAccessibilityConfig {
        GestureAccessibilityConfig(
            gestureType: .swipe(direction),
            label: label,
            hint: "Swipe \(direction.rawValue) to \(label.lowercased())",
            alternatives: [
                AccessibleGestureAction(
                    name: label,
                    systemImage: direction.systemImage,
                    description: "Alternative to swiping \(direction.rawValue)",
                    action: action
                )
            ]
        )
    }
    
    public static func doubleTap(
        label: String,
        action: @escaping @Sendable () -> Void
    ) -> GestureAccessibilityConfig {
        GestureAccessibilityConfig(
            gestureType: .doubleTap,
            label: label,
            hint: "Double tap to \(label.lowercased())",
            alternatives: [
                AccessibleGestureAction(
                    name: label,
                    systemImage: "hand.tap.fill",
                    description: "Alternative to double tap",
                    action: action
                )
            ]
        )
    }
    
    public static func longPress(
        label: String,
        action: @escaping @Sendable () -> Void
    ) -> GestureAccessibilityConfig {
        GestureAccessibilityConfig(
            gestureType: .longPress(),
            label: label,
            hint: "Press and hold to \(label.lowercased())",
            alternatives: [
                AccessibleGestureAction(
                    name: label,
                    systemImage: "hand.tap.fill",
                    description: "Alternative to long press",
                    action: action
                )
            ]
        )
    }
    
    public static func pinch(
        label: String,
        zoomIn: @escaping @Sendable () -> Void,
        zoomOut: @escaping @Sendable () -> Void
    ) -> GestureAccessibilityConfig {
        GestureAccessibilityConfig(
            gestureType: .pinch,
            label: label,
            hint: "Pinch to zoom",
            alternatives: [
                AccessibleGestureAction(
                    name: "Zoom In",
                    systemImage: "plus.magnifyingglass",
                    description: "Zoom in",
                    action: zoomIn
                ),
                AccessibleGestureAction(
                    name: "Zoom Out",
                    systemImage: "minus.magnifyingglass",
                    description: "Zoom out",
                    action: zoomOut
                )
            ]
        )
    }
}

// MARK: - SwipeDirection Extension

extension SwipeDirection {
    var systemImage: String {
        switch self {
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        }
    }
}

// MARK: - Accessibility Gesture View

/// A view that shows accessibility alternatives for gestures
public struct AccessibilityGestureMenu: View {
    let actions: [AccessibleGestureAction]
    @Binding var isPresented: Bool
    
    public init(actions: [AccessibleGestureAction], isPresented: Binding<Bool>) {
        self.actions = actions
        self._isPresented = isPresented
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            Text("Gesture Alternatives")
                .font(.headline)
                .padding(.bottom, 8)
            
            ForEach(actions) { action in
                Button {
                    action.action()
                    isPresented = false
                } label: {
                    HStack {
                        Image(systemName: action.systemImage)
                            .font(.title2)
                            .frame(width: 44)
                        
                        VStack(alignment: .leading) {
                            Text(action.name)
                                .font(.body.bold())
                            Text(action.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    #if os(iOS)
                    .background(Color(UIColor.secondarySystemBackground))
                    #else
                    .background(Color(NSColor.controlBackgroundColor))
                    #endif
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            
            Button("Cancel") {
                isPresented = false
            }
            .padding(.top, 8)
        }
        .padding()
        #if os(iOS)
        .background(Color(UIColor.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

// MARK: - Accessible Gesture Modifier

/// View modifier that adds accessibility support to gestures
public struct AccessibleGestureModifier: ViewModifier {
    let config: GestureAccessibilityConfig
    @State private var showingAlternatives = false
    
    public init(config: GestureAccessibilityConfig) {
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .accessibilityLabel(config.accessibilityLabel)
            .accessibilityHint(config.accessibilityHint)
            .accessibilityAddTraits(.isButton)
            #if os(iOS) || os(tvOS) || os(watchOS)
            .accessibilityAction(.magicTap) {
                // Perform primary action on magic tap
                config.alternativeActions.first?.action()
            }
            #endif
            .accessibilityActions {
                ForEach(config.alternativeActions) { action in
                    Button(action.name) {
                        action.action()
                    }
                }
            }
            .overlay(
                Group {
                    if showingAlternatives && !config.alternativeActions.isEmpty {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showingAlternatives = false
                            }
                        
                        AccessibilityGestureMenu(
                            actions: config.alternativeActions,
                            isPresented: $showingAlternatives
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(), value: showingAlternatives)
            )
            .contextMenu {
                ForEach(config.alternativeActions) { action in
                    Button {
                        action.action()
                    } label: {
                        Label(action.name, systemImage: action.systemImage)
                    }
                }
            }
    }
}

// MARK: - Reduced Motion Support

/// Checks if reduced motion is enabled
public struct ReducedMotionEnvironment: Sendable {
    public static var isEnabled: Bool {
        #if os(iOS)
        UIAccessibility.isReduceMotionEnabled
        #elseif os(macOS)
        NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        #else
        false
        #endif
    }
}

/// Animation configuration respecting reduced motion
public struct AccessibleAnimation {
    /// Returns appropriate animation based on accessibility settings
    public static func standard(_ animation: Animation = .default) -> Animation? {
        ReducedMotionEnvironment.isEnabled ? nil : animation
    }
    
    /// Returns spring animation or none if reduced motion
    public static func spring(
        response: Double = 0.3,
        dampingFraction: Double = 0.7,
        blendDuration: Double = 0
    ) -> Animation? {
        guard !ReducedMotionEnvironment.isEnabled else { return nil }
        return .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
    }
    
    /// Returns easeInOut or none if reduced motion
    public static func easeInOut(duration: Double = 0.25) -> Animation? {
        guard !ReducedMotionEnvironment.isEnabled else { return nil }
        return .easeInOut(duration: duration)
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds accessibility support for a gesture
    func accessibleGesture(_ config: GestureAccessibilityConfig) -> some View {
        modifier(AccessibleGestureModifier(config: config))
    }
    
    /// Adds swipe gesture with accessibility
    func accessibleSwipe(
        _ direction: SwipeDirection,
        label: String,
        perform action: @escaping () -> Void
    ) -> some View {
        self
            .onSwipe(direction, perform: action)
            .accessibleGesture(.swipe(direction: direction, label: label, action: action))
    }
    
    /// Adds double tap with accessibility
    func accessibleDoubleTap(
        label: String,
        perform action: @escaping () -> Void
    ) -> some View {
        self
            .onDoubleTap(perform: action)
            .accessibleGesture(.doubleTap(label: label, action: action))
    }
    
    /// Adds long press with accessibility
    func accessibleLongPress(
        label: String,
        perform action: @escaping () -> Void
    ) -> some View {
        self
            .onLongPress(onComplete: action)
            .accessibleGesture(.longPress(label: label, action: action))
    }
    
    /// Applies animation respecting reduced motion
    func accessibleAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        self.animation(
            ReducedMotionEnvironment.isEnabled ? nil : animation,
            value: value
        )
    }
    
    /// Conditional animation based on reduced motion
    @ViewBuilder
    func withAccessibleAnimation(_ animation: Animation = .default) -> some View {
        if ReducedMotionEnvironment.isEnabled {
            self
        } else {
            self.animation(animation, value: UUID())
        }
    }
}

// MARK: - VoiceOver Announcement

/// Helper for VoiceOver announcements
public enum VoiceOverAnnouncement {
    /// Announces a message via VoiceOver
    public static func announce(_ message: String, delay: TimeInterval = 0.1) {
        #if os(iOS)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
    }
    
    /// Announces gesture completion
    public static func gestureCompleted(_ gestureName: String) {
        announce("\(gestureName) gesture completed")
    }
    
    /// Announces shape recognition
    public static func shapeRecognized(_ shape: RecognizedShape) {
        announce("Recognized shape: \(shape.displayName)")
    }
}
