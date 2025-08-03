import Foundation
import UIKit

/// Advanced haptic feedback manager for gesture interactions
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class HapticFeedbackManager: ObservableObject {
    
    // MARK: - Properties
    
    /// Current haptic intensity
    @Published public private(set) var currentIntensity: Float = 1.0
    
    /// Whether haptic feedback is enabled
    @Published public var isEnabled: Bool = true
    
    /// Haptic configuration
    private let configuration: HapticConfiguration
    
    // MARK: - Initialization
    
    public init(configuration: HapticConfiguration = .default) {
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    
    /// Triggers haptic feedback for a specific gesture type
    public func triggerFeedback(for gestureType: GestureType) {
        guard isEnabled else { return }
        
        switch gestureType {
        case .tap:
            triggerTapFeedback()
        case .doubleTap:
            triggerDoubleTapFeedback()
        case .longPress:
            triggerLongPressFeedback()
        case .swipe:
            triggerSwipeFeedback()
        case .pan:
            triggerPanFeedback()
        case .pinch:
            triggerPinchFeedback()
        case .rotation:
            triggerRotationFeedback()
        case .custom(_):
            triggerCustomFeedback()
        }
    }
    
    /// Triggers custom haptic feedback with intensity
    public func triggerCustomFeedback(intensity: Float = 1.0) {
        guard isEnabled else { return }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred(intensity: CGFloat(intensity))
    }
    
    /// Sets the haptic intensity
    public func setIntensity(_ intensity: Float) {
        currentIntensity = max(0.0, min(1.0, intensity))
    }
    
    /// Enables or disables haptic feedback
    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    // MARK: - Private Methods
    
    private func triggerTapFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerDoubleTapFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            feedback.impactOccurred(intensity: CGFloat(self.currentIntensity))
        }
    }
    
    private func triggerLongPressFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .heavy)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerSwipeFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .rigid)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerPanFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .soft)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerPinchFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerRotationFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .rigid)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
    
    private func triggerCustomFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred(intensity: CGFloat(currentIntensity))
    }
}

// MARK: - Supporting Types

/// Haptic feedback configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct HapticConfiguration {
    public let defaultIntensity: Float
    public let enableAdvancedHaptics: Bool
    public let enableCustomPatterns: Bool
    public let autoResetEngine: Bool
    
    public static let `default` = HapticConfiguration(
        defaultIntensity: 1.0,
        enableAdvancedHaptics: true,
        enableCustomPatterns: true,
        autoResetEngine: true
    )
    
    public init(defaultIntensity: Float = 1.0,
                enableAdvancedHaptics: Bool = true,
                enableCustomPatterns: Bool = true,
                autoResetEngine: Bool = true) {
        self.defaultIntensity = defaultIntensity
        self.enableAdvancedHaptics = enableAdvancedHaptics
        self.enableCustomPatterns = enableCustomPatterns
        self.autoResetEngine = autoResetEngine
    }
} 