import SwiftUI
import Foundation
import Combine

/// Protocol for gesture recognizer delegate
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol GestureRecognizerDelegate: AnyObject {
    func gestureRecognizer(_ recognizer: GestureRecognizer, didChangeState state: GestureRecognizerState)
    func gestureRecognizer(_ recognizer: GestureRecognizer, didFailWithError error: GestureError)
}

/// Base gesture recognizer class
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class GestureRecognizer: Identifiable, ObservableObject {
    
    // MARK: - Properties
    
    /// Unique identifier for the recognizer
    public let id = UUID()
    
    /// Current state of the gesture recognizer
    @Published public private(set) var state: GestureRecognizerState = .possible
    
    /// Type of gesture this recognizer handles
    public let type: GestureType
    
    /// Configuration for this specific recognizer
    public let configuration: RecognizerConfiguration
    
    /// Delegate to receive state change notifications
    public weak var delegate: GestureRecognizerDelegate?
    
    /// Touch events history
    private var touchEvents: [TouchEvent] = []
    
    /// Timer for gesture timeout
    private var timeoutTimer: Timer?
    
    /// Performance tracking
    private var startTime: TimeInterval = 0
    
    // MARK: - Initialization
    
    public init(type: GestureType, configuration: RecognizerConfiguration = .default) {
        self.type = type
        self.configuration = configuration
        setupRecognizer()
    }
    
    // MARK: - Public Methods
    
    /// Processes a touch event
    public func processTouchEvent(_ event: TouchEvent) {
        touchEvents.append(event)
        
        switch event.phase {
        case .began:
            handleTouchBegan(event)
        case .moved:
            handleTouchMoved(event)
        case .ended:
            handleTouchEnded(event)
        case .cancelled:
            handleTouchCancelled(event)
        }
        
        // Check for gesture recognition
        checkForRecognition()
        
        // Update timeout timer
        updateTimeoutTimer()
    }
    
    /// Resets the recognizer to initial state
    public func reset() {
        state = .possible
        touchEvents.removeAll()
        timeoutTimer?.invalidate()
        timeoutTimer = nil
        startTime = 0
    }
    
    /// Checks if the gesture is valid based on current touch events
    public func isValidGesture() -> Bool {
        guard touchEvents.count >= configuration.minimumTouchEvents else {
            return false
        }
        
        return validateGesture()
    }
    
    // MARK: - Protected Methods (to be overridden by subclasses)
    
    /// Override this method to handle touch began events
    open func handleTouchBegan(_ event: TouchEvent) {
        startTime = event.timestamp
        state = .began
        delegate?.gestureRecognizer(self, didChangeState: state)
    }
    
    /// Override this method to handle touch moved events
    open func handleTouchMoved(_ event: TouchEvent) {
        state = .changed
        delegate?.gestureRecognizer(self, didChangeState: state)
    }
    
    /// Override this method to handle touch ended events
    open func handleTouchEnded(_ event: TouchEvent) {
        if isValidGesture() {
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        } else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
        }
    }
    
    /// Override this method to handle touch cancelled events
    open func handleTouchCancelled(_ event: TouchEvent) {
        state = .cancelled
        delegate?.gestureRecognizer(self, didChangeState: state)
    }
    
    /// Override this method to implement custom gesture validation
    open func validateGesture() -> Bool {
        // Default implementation - subclasses should override
        return true
    }
    
    /// Override this method to implement custom gesture recognition logic
    open func checkForRecognition() {
        // Default implementation - subclasses should override
    }
    
    // MARK: - Private Methods
    
    private func setupRecognizer() {
        // Initialize recognizer-specific setup
    }
    
    private func updateTimeoutTimer() {
        timeoutTimer?.invalidate()
        
        guard configuration.timeout > 0 else { return }
        
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: configuration.timeout, repeats: false) { [weak self] _ in
            self?.handleTimeout()
        }
    }
    
    private func handleTimeout() {
        state = .failed
        delegate?.gestureRecognizer(self, didFailWithError: .timeout)
    }
}

// MARK: - Supporting Types

/// Gesture recognizer state
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GestureRecognizerState {
    case possible
    case began
    case changed
    case recognized
    case failed
    case cancelled
}

/// Gesture types
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GestureType {
    case tap
    case doubleTap
    case longPress
    case swipe
    case pan
    case pinch
    case rotation
    case custom(String)
    
    public var description: String {
        switch self {
        case .tap: return "Tap"
        case .doubleTap: return "Double Tap"
        case .longPress: return "Long Press"
        case .swipe: return "Swipe"
        case .pan: return "Pan"
        case .pinch: return "Pinch"
        case .rotation: return "Rotation"
        case .custom(let name): return name
        }
    }
}

/// Recognizer configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RecognizerConfiguration {
    public let minimumTouchEvents: Int
    public let timeout: TimeInterval
    public let enableVelocityTracking: Bool
    public let enablePressureTracking: Bool
    
    public static let `default` = RecognizerConfiguration(
        minimumTouchEvents: 2,
        timeout: 2.0,
        enableVelocityTracking: true,
        enablePressureTracking: true
    )
    
    public init(minimumTouchEvents: Int = 2,
                timeout: TimeInterval = 2.0,
                enableVelocityTracking: Bool = true,
                enablePressureTracking: Bool = true) {
        self.minimumTouchEvents = minimumTouchEvents
        self.timeout = timeout
        self.enableVelocityTracking = enableVelocityTracking
        self.enablePressureTracking = enablePressureTracking
    }
}

/// Gesture errors
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GestureError: Error, LocalizedError {
    case invalidGesture
    case timeout
    case insufficientTouchEvents
    case velocityTooLow
    case pressureTooLow
    
    public var errorDescription: String? {
        switch self {
        case .invalidGesture:
            return "The gesture does not meet the recognition criteria"
        case .timeout:
            return "Gesture recognition timed out"
        case .insufficientTouchEvents:
            return "Insufficient touch events for gesture recognition"
        case .velocityTooLow:
            return "Gesture velocity is below the minimum threshold"
        case .pressureTooLow:
            return "Touch pressure is below the minimum threshold"
        }
    }
} 