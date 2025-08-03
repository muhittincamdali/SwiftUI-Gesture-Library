import SwiftUI
import Foundation

/// Advanced long press gesture recognizer with configurable timing parameters
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class LongPressGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Long press configuration
    private let longPressConfig: LongPressConfiguration
    
    /// Press start time
    private var pressStartTime: TimeInterval = 0
    
    /// Press start location
    private var pressStartLocation: CGPoint?
    
    /// Current press duration
    private var currentPressDuration: TimeInterval = 0
    
    /// Timer for long press detection
    private var longPressTimer: Timer?
    
    /// Whether the press has moved significantly
    private var hasMovedSignificantly: Bool = false
    
    // MARK: - Initialization
    
    public init(configuration: LongPressConfiguration = .default) {
        self.longPressConfig = configuration
        super.init(type: .longPress)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        pressStartTime = event.timestamp
        pressStartLocation = event.location
        currentPressDuration = 0
        hasMovedSignificantly = false
        
        // Start timer for long press detection
        startLongPressTimer()
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        
        guard let startLocation = pressStartLocation else { return }
        
        // Check if the press has moved significantly
        let distance = calculateDistance(from: startLocation, to: event.location)
        if distance > longPressConfig.maximumMovementDistance {
            hasMovedSignificantly = true
            cancelLongPress()
        }
        
        // Update current press duration
        currentPressDuration = event.timestamp - pressStartTime
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        currentPressDuration = event.timestamp - pressStartTime
        
        if isValidLongPress() {
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        } else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
        }
        
        cleanup()
    }
    
    public override func handleTouchCancelled(_ event: TouchEvent) {
        super.handleTouchCancelled(event)
        cancelLongPress()
        cleanup()
    }
    
    public override func validateGesture() -> Bool {
        return isValidLongPress()
    }
    
    public override func reset() {
        super.reset()
        pressStartTime = 0
        pressStartLocation = nil
        currentPressDuration = 0
        hasMovedSignificantly = false
        cleanup()
    }
    
    // MARK: - Public Methods
    
    /// Gets the current press duration
    public func getPressDuration() -> TimeInterval {
        return currentPressDuration
    }
    
    /// Gets the press start location
    public func getPressStartLocation() -> CGPoint? {
        return pressStartLocation
    }
    
    /// Checks if the press has moved significantly
    public func hasMoved() -> Bool {
        return hasMovedSignificantly
    }
    
    // MARK: - Private Methods
    
    private func startLongPressTimer() {
        longPressTimer?.invalidate()
        longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressConfig.minimumPressDuration, repeats: false) { [weak self] _ in
            self?.handleLongPressDetected()
        }
    }
    
    private func handleLongPressDetected() {
        if !hasMovedSignificantly {
            // Trigger haptic feedback
            if longPressConfig.enableHapticFeedback {
                let hapticManager = HapticFeedbackManager()
                hapticManager.triggerFeedback(for: .longPress)
            }
            
            // Notify delegate of long press detection
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        }
    }
    
    private func cancelLongPress() {
        longPressTimer?.invalidate()
        longPressTimer = nil
    }
    
    private func cleanup() {
        cancelLongPress()
    }
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func isValidLongPress() -> Bool {
        let hasMinimumDuration = currentPressDuration >= longPressConfig.minimumPressDuration
        let hasMaximumDuration = currentPressDuration <= longPressConfig.maximumPressDuration
        let hasNotMovedSignificantly = !hasMovedSignificantly
        
        return hasMinimumDuration && hasMaximumDuration && hasNotMovedSignificantly
    }
}

// MARK: - Supporting Types

/// Configuration for long press gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct LongPressConfiguration {
    /// Minimum press duration required for recognition
    public let minimumPressDuration: TimeInterval
    
    /// Maximum press duration allowed
    public let maximumPressDuration: TimeInterval
    
    /// Maximum distance the press can move
    public let maximumMovementDistance: CGFloat
    
    /// Whether to enable haptic feedback
    public let enableHapticFeedback: Bool
    
    /// Number of touches required
    public let numberOfTouchesRequired: Int
    
    public static let `default` = LongPressConfiguration(
        minimumPressDuration: 0.5,
        maximumPressDuration: 10.0,
        maximumMovementDistance: 10.0,
        enableHapticFeedback: true,
        numberOfTouchesRequired: 1
    )
    
    public static let short = LongPressConfiguration(
        minimumPressDuration: 0.3,
        maximumPressDuration: 5.0,
        maximumMovementDistance: 5.0,
        enableHapticFeedback: true,
        numberOfTouchesRequired: 1
    )
    
    public static let long = LongPressConfiguration(
        minimumPressDuration: 1.0,
        maximumPressDuration: 15.0,
        maximumMovementDistance: 15.0,
        enableHapticFeedback: true,
        numberOfTouchesRequired: 1
    )
    
    public static let precise = LongPressConfiguration(
        minimumPressDuration: 0.5,
        maximumPressDuration: 10.0,
        maximumMovementDistance: 2.0,
        enableHapticFeedback: true,
        numberOfTouchesRequired: 1
    )
    
    public init(minimumPressDuration: TimeInterval = 0.5,
                maximumPressDuration: TimeInterval = 10.0,
                maximumMovementDistance: CGFloat = 10.0,
                enableHapticFeedback: Bool = true,
                numberOfTouchesRequired: Int = 1) {
        self.minimumPressDuration = minimumPressDuration
        self.maximumPressDuration = maximumPressDuration
        self.maximumMovementDistance = maximumMovementDistance
        self.enableHapticFeedback = enableHapticFeedback
        self.numberOfTouchesRequired = numberOfTouchesRequired
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct LongPressGestureViewModifier: ViewModifier {
    private let configuration: LongPressConfiguration
    private let onLongPress: () -> Void
    
    public init(configuration: LongPressConfiguration = .default, onLongPress: @escaping () -> Void) {
        self.configuration = configuration
        self.onLongPress = onLongPress
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: configuration.minimumPressDuration, maximumDistance: configuration.maximumMovementDistance)
                    .onEnded { _ in
                        self.onLongPress()
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customLongPressGesture(configuration: LongPressConfiguration = .default, onLongPress: @escaping () -> Void) -> some View {
        modifier(LongPressGestureViewModifier(configuration: configuration, onLongPress: onLongPress))
    }
} 