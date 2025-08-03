import SwiftUI
import Foundation

/// Advanced pan gesture recognizer with momentum tracking and boundary support
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class PanGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Pan configuration
    private let panConfig: PanConfiguration
    
    /// Pan start location
    private var panStartLocation: CGPoint?
    
    /// Current pan location
    private var currentPanLocation: CGPoint?
    
    /// Pan translation
    private var panTranslation: CGPoint = .zero
    
    /// Pan velocity
    private var panVelocity: CGPoint = .zero
    
    /// Pan direction
    private var panDirection: PanDirection?
    
    /// Whether pan is within boundaries
    private var isWithinBoundaries: Bool = true
    
    // MARK: - Initialization
    
    public init(configuration: PanConfiguration = .default) {
        self.panConfig = configuration
        super.init(type: .pan)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        panStartLocation = event.location
        currentPanLocation = event.location
        panTranslation = .zero
        panVelocity = .zero
        panDirection = nil
        isWithinBoundaries = true
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        
        guard let startLocation = panStartLocation else { return }
        
        currentPanLocation = event.location
        panTranslation = CGPoint(
            x: event.location.x - startLocation.x,
            y: event.location.y - startLocation.y
        )
        
        // Calculate velocity
        let timeInterval = event.timestamp - startTime
        if timeInterval > 0 {
            panVelocity = CGPoint(
                x: panTranslation.x / CGFloat(timeInterval),
                y: panTranslation.y / CGFloat(timeInterval)
            )
        }
        
        // Determine pan direction
        panDirection = calculatePanDirection()
        
        // Check boundaries
        isWithinBoundaries = checkBoundaries()
        
        // Trigger haptic feedback if enabled
        if panConfig.enableHapticFeedback && isWithinBoundaries {
            let hapticManager = HapticFeedbackManager()
            hapticManager.triggerCustomFeedback(intensity: 0.3)
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        guard let startLocation = panStartLocation else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            return
        }
        
        // Final update
        currentPanLocation = event.location
        panTranslation = CGPoint(
            x: event.location.x - startLocation.x,
            y: event.location.y - startLocation.y
        )
        
        if isValidPanGesture() {
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        } else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
        }
    }
    
    public override func validateGesture() -> Bool {
        return isValidPanGesture()
    }
    
    public override func reset() {
        super.reset()
        panStartLocation = nil
        currentPanLocation = nil
        panTranslation = .zero
        panVelocity = .zero
        panDirection = nil
        isWithinBoundaries = true
    }
    
    // MARK: - Public Methods
    
    /// Gets the current pan translation
    public func getPanTranslation() -> CGPoint {
        return panTranslation
    }
    
    /// Gets the pan velocity
    public func getPanVelocity() -> CGPoint {
        return panVelocity
    }
    
    /// Gets the pan direction
    public func getPanDirection() -> PanDirection? {
        return panDirection
    }
    
    /// Gets the pan start location
    public func getPanStartLocation() -> CGPoint? {
        return panStartLocation
    }
    
    /// Gets the current pan location
    public func getCurrentPanLocation() -> CGPoint? {
        return currentPanLocation
    }
    
    /// Checks if pan is within boundaries
    public func isPanWithinBoundaries() -> Bool {
        return isWithinBoundaries
    }
    
    // MARK: - Private Methods
    
    private func calculatePanDirection() -> PanDirection {
        let absX = abs(panTranslation.x)
        let absY = abs(panTranslation.y)
        
        if absX > absY {
            return panTranslation.x > 0 ? .right : .left
        } else {
            return panTranslation.y > 0 ? .down : .up
        }
    }
    
    private func checkBoundaries() -> Bool {
        guard let boundaries = panConfig.boundaries else { return true }
        
        let x = panTranslation.x
        let y = panTranslation.y
        
        return x >= boundaries.minX && x <= boundaries.maxX &&
               y >= boundaries.minY && y <= boundaries.maxY
    }
    
    private func isValidPanGesture() -> Bool {
        let hasMinimumDistance = abs(panTranslation.x) >= panConfig.minimumDistance ||
                                abs(panTranslation.y) >= panConfig.minimumDistance
        
        let hasValidDirection = panDirection != nil
        let isWithinBounds = isWithinBoundaries
        
        return hasMinimumDistance && hasValidDirection && isWithinBounds
    }
}

// MARK: - Supporting Types

/// Pan direction enumeration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum PanDirection {
    case up
    case down
    case left
    case right
    case upLeft
    case upRight
    case downLeft
    case downRight
    
    public var description: String {
        switch self {
        case .up: return "Up"
        case .down: return "Down"
        case .left: return "Left"
        case .right: return "Right"
        case .upLeft: return "Up Left"
        case .upRight: return "Up Right"
        case .downLeft: return "Down Left"
        case .downRight: return "Down Right"
        }
    }
}

/// Pan boundaries
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PanBoundaries {
    public let minX: CGFloat
    public let maxX: CGFloat
    public let minY: CGFloat
    public let maxY: CGFloat
    
    public init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }
    
    public static let unlimited = PanBoundaries(minX: -CGFloat.infinity, maxX: CGFloat.infinity, minY: -CGFloat.infinity, maxY: CGFloat.infinity)
}

/// Configuration for pan gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PanConfiguration {
    /// Minimum distance required for pan recognition
    public let minimumDistance: CGFloat
    
    /// Pan boundaries (optional)
    public let boundaries: PanBoundaries?
    
    /// Whether to enable haptic feedback
    public let enableHapticFeedback: Bool
    
    /// Whether to enable momentum tracking
    public let enableMomentum: Bool
    
    /// Maximum velocity for momentum calculation
    public let maximumVelocity: CGFloat
    
    public static let `default` = PanConfiguration(
        minimumDistance: 10.0,
        boundaries: nil,
        enableHapticFeedback: true,
        enableMomentum: true,
        maximumVelocity: 1000.0
    )
    
    public static let constrained = PanConfiguration(
        minimumDistance: 5.0,
        boundaries: PanBoundaries(minX: -200, maxX: 200, minY: -200, maxY: 200),
        enableHapticFeedback: true,
        enableMomentum: false,
        maximumVelocity: 500.0
    )
    
    public static let freeform = PanConfiguration(
        minimumDistance: 20.0,
        boundaries: .unlimited,
        enableHapticFeedback: false,
        enableMomentum: true,
        maximumVelocity: 2000.0
    )
    
    public init(minimumDistance: CGFloat = 10.0,
                boundaries: PanBoundaries? = nil,
                enableHapticFeedback: Bool = true,
                enableMomentum: Bool = true,
                maximumVelocity: CGFloat = 1000.0) {
        self.minimumDistance = minimumDistance
        self.boundaries = boundaries
        self.enableHapticFeedback = enableHapticFeedback
        self.enableMomentum = enableMomentum
        self.maximumVelocity = maximumVelocity
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PanGestureViewModifier: ViewModifier {
    private let configuration: PanConfiguration
    private let onPanChanged: (CGPoint) -> Void
    private let onPanEnded: (CGPoint, CGPoint) -> Void
    
    public init(configuration: PanConfiguration = .default,
                onPanChanged: @escaping (CGPoint) -> Void,
                onPanEnded: @escaping (CGPoint, CGPoint) -> Void) {
        self.configuration = configuration
        self.onPanChanged = onPanChanged
        self.onPanEnded = onPanEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: configuration.minimumDistance)
                    .onChanged { value in
                        self.onPanChanged(value.translation)
                    }
                    .onEnded { value in
                        self.onPanEnded(value.translation, value.predictedEndTranslation)
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customPanGesture(configuration: PanConfiguration = .default,
                         onPanChanged: @escaping (CGPoint) -> Void,
                         onPanEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View {
        modifier(PanGestureViewModifier(configuration: configuration, onPanChanged: onPanChanged, onPanEnded: onPanEnded))
    }
} 