//
//  HapticEngine.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(CoreHaptics)
import CoreHaptics
#endif

// MARK: - Haptic Feedback Type

/// Types of haptic feedback
public enum HapticType: String, CaseIterable, Sendable {
    case light
    case medium
    case heavy
    case soft
    case rigid
    case selection
    case success
    case warning
    case error
}

// MARK: - Haptic Engine

/// Cross-platform haptic feedback engine
public enum HapticEngine {
    
    // MARK: - Impact Feedback
    
    /// Triggers impact haptic feedback
    public static func impact(_ style: HapticType) {
        guard GestureKit.hapticsEnabled else { return }
        
        #if os(iOS)
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        #endif
    }
    
    // MARK: - Notification Feedback
    
    /// Triggers notification haptic feedback
    public static func notification(_ type: NotificationType) {
        guard GestureKit.hapticsEnabled else { return }
        
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .warning:
            generator.notificationOccurred(.warning)
        case .error:
            generator.notificationOccurred(.error)
        }
        #endif
    }
    
    /// Notification feedback types
    public enum NotificationType: String, CaseIterable, Sendable {
        case success
        case warning
        case error
    }
    
    // MARK: - Selection Feedback
    
    /// Triggers selection feedback
    public static func selection() {
        guard GestureKit.hapticsEnabled else { return }
        
        #if os(iOS)
        UISelectionFeedbackGenerator().selectionChanged()
        #endif
    }
    
    // MARK: - Custom Patterns
    
    #if os(iOS) && canImport(CoreHaptics)
    /// Plays a custom haptic pattern
    @MainActor
    public static func playPattern(_ pattern: HapticPattern) {
        guard GestureKit.hapticsEnabled else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            let engine = try CHHapticEngine()
            try engine.start()
            
            let events = pattern.events.map { event -> CHHapticEvent in
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(event.intensity)),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(event.sharpness))
                    ],
                    relativeTime: event.time
                )
            }
            
            let chPattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: chPattern)
            try player.start(atTime: 0)
            
            // Stop engine after pattern completes
            let duration = pattern.events.map(\.time).max() ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
                engine.stop()
            }
        } catch {
            // Fallback to simple haptic
            impact(.medium)
        }
    }
    #endif
}

// MARK: - Haptic Pattern

/// Custom haptic pattern definition
public struct HapticPattern: Sendable {
    public let name: String
    public let events: [HapticEvent]
    
    public init(name: String, events: [HapticEvent]) {
        self.name = name
        self.events = events
    }
    
    /// Single haptic event
    public struct HapticEvent: Sendable {
        public let time: TimeInterval
        public let intensity: Double
        public let sharpness: Double
        
        public init(time: TimeInterval, intensity: Double = 1.0, sharpness: Double = 0.5) {
            self.time = time
            self.intensity = intensity
            self.sharpness = sharpness
        }
    }
    
    // MARK: - Preset Patterns
    
    /// Quick double tap pattern
    public static let doubleTap = HapticPattern(
        name: "Double Tap",
        events: [
            HapticEvent(time: 0, intensity: 0.8, sharpness: 0.5),
            HapticEvent(time: 0.1, intensity: 0.8, sharpness: 0.5)
        ]
    )
    
    /// Ascending intensity
    public static let ascending = HapticPattern(
        name: "Ascending",
        events: [
            HapticEvent(time: 0, intensity: 0.3, sharpness: 0.3),
            HapticEvent(time: 0.1, intensity: 0.5, sharpness: 0.5),
            HapticEvent(time: 0.2, intensity: 0.8, sharpness: 0.7),
            HapticEvent(time: 0.3, intensity: 1.0, sharpness: 1.0)
        ]
    )
    
    /// Descending intensity
    public static let descending = HapticPattern(
        name: "Descending",
        events: [
            HapticEvent(time: 0, intensity: 1.0, sharpness: 1.0),
            HapticEvent(time: 0.1, intensity: 0.8, sharpness: 0.7),
            HapticEvent(time: 0.2, intensity: 0.5, sharpness: 0.5),
            HapticEvent(time: 0.3, intensity: 0.3, sharpness: 0.3)
        ]
    )
    
    /// Heartbeat pattern
    public static let heartbeat = HapticPattern(
        name: "Heartbeat",
        events: [
            HapticEvent(time: 0, intensity: 1.0, sharpness: 0.3),
            HapticEvent(time: 0.15, intensity: 0.6, sharpness: 0.3),
            HapticEvent(time: 0.8, intensity: 1.0, sharpness: 0.3),
            HapticEvent(time: 0.95, intensity: 0.6, sharpness: 0.3)
        ]
    )
    
    /// Celebration pattern
    public static let celebration = HapticPattern(
        name: "Celebration",
        events: [
            HapticEvent(time: 0, intensity: 0.5, sharpness: 0.8),
            HapticEvent(time: 0.08, intensity: 0.7, sharpness: 0.9),
            HapticEvent(time: 0.16, intensity: 0.9, sharpness: 1.0),
            HapticEvent(time: 0.24, intensity: 1.0, sharpness: 1.0),
            HapticEvent(time: 0.4, intensity: 0.6, sharpness: 0.6),
            HapticEvent(time: 0.5, intensity: 0.4, sharpness: 0.4)
        ]
    )
    
    /// Warning pattern
    public static let warning = HapticPattern(
        name: "Warning",
        events: [
            HapticEvent(time: 0, intensity: 0.8, sharpness: 1.0),
            HapticEvent(time: 0.2, intensity: 0.8, sharpness: 1.0),
            HapticEvent(time: 0.4, intensity: 0.8, sharpness: 1.0)
        ]
    )
    
    /// Subtle tick
    public static let tick = HapticPattern(
        name: "Tick",
        events: [
            HapticEvent(time: 0, intensity: 0.4, sharpness: 0.8)
        ]
    )
}

// MARK: - Haptic View Modifier

/// View modifier for gesture-based haptics
public struct HapticModifier: ViewModifier {
    let trigger: HapticTrigger
    let type: HapticType
    
    public init(trigger: HapticTrigger, type: HapticType = .medium) {
        self.trigger = trigger
        self.type = type
    }
    
    public func body(content: Content) -> some View {
        switch trigger {
        case .tap:
            content.onTapGesture {
                HapticEngine.impact(type)
            }
        case .longPress:
            content.onLongPressGesture {
                HapticEngine.impact(type)
            }
        case .appear:
            content.onAppear {
                HapticEngine.impact(type)
            }
        }
    }
    
    public enum HapticTrigger {
        case tap
        case longPress
        case appear
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds haptic feedback on tap
    func hapticOnTap(_ type: HapticType = .medium) -> some View {
        modifier(HapticModifier(trigger: .tap, type: type))
    }
    
    /// Adds haptic feedback on long press
    func hapticOnLongPress(_ type: HapticType = .heavy) -> some View {
        modifier(HapticModifier(trigger: .longPress, type: type))
    }
    
    /// Adds haptic feedback on appear
    func hapticOnAppear(_ type: HapticType = .light) -> some View {
        modifier(HapticModifier(trigger: .appear, type: type))
    }
    
    /// Triggers haptic manually
    func triggerHaptic(_ type: HapticType) {
        HapticEngine.impact(type)
    }
}
