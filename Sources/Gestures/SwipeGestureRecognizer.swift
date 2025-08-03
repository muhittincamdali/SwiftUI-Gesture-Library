import SwiftUI
import Foundation

/// Advanced swipe gesture recognizer with configurable parameters
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class SwipeGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Swipe configuration
    private let swipeConfig: SwipeConfiguration
    
    /// Swipe direction
    private var swipeDirection: SwipeDirection?
    
    /// Swipe velocity
    private var swipeVelocity: CGFloat = 0
    
    /// Start and end points
    private var startPoint: CGPoint?
    private var endPoint: CGPoint?
    
    /// Minimum distance for swipe recognition
    private let minSwipeDistance: CGFloat = 50.0
    
    // MARK: - Initialization
    
    public init(configuration: SwipeConfiguration = .default) {
        self.swipeConfig = configuration
        super.init(type: .swipe)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        startPoint = event.location
        endPoint = nil
        swipeDirection = nil
        swipeVelocity = 0
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        endPoint = event.location
        
        // Calculate velocity
        if let start = startPoint, let end = endPoint {
            let distance = calculateDistance(from: start, to: end)
            let timeInterval = event.timestamp - startTime
            swipeVelocity = distance / CGFloat(timeInterval)
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        endPoint = event.location
        
        guard let start = startPoint, let end = endPoint else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            return
        }
        
        // Calculate swipe properties
        let distance = calculateDistance(from: start, to: end)
        let direction = calculateSwipeDirection(from: start, to: end)
        
        // Validate swipe
        guard distance >= minSwipeDistance,
              swipeVelocity >= swipeConfig.minimumVelocity,
              isValidSwipeDirection(direction) else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            return
        }
        
        swipeDirection = direction
        
        state = .recognized
        delegate?.gestureRecognizer(self, didChangeState: state)
    }
    
    public override func validateGesture() -> Bool {
        guard let direction = swipeDirection else { return false }
        
        // Check if swipe meets all criteria
        let distance = calculateDistance(from: startPoint!, to: endPoint!)
        let isValidDistance = distance >= minSwipeDistance
        let isValidVelocity = swipeVelocity >= swipeConfig.minimumVelocity
        let isValidDirection = isValidSwipeDirection(direction)
        
        return isValidDistance && isValidVelocity && isValidDirection
    }
    
    public override func reset() {
        super.reset()
        startPoint = nil
        endPoint = nil
        swipeDirection = nil
        swipeVelocity = 0
    }
    
    // MARK: - Public Methods
    
    /// Gets the recognized swipe direction
    public func getSwipeDirection() -> SwipeDirection? {
        return swipeDirection
    }
    
    /// Gets the swipe velocity
    public func getSwipeVelocity() -> CGFloat {
        return swipeVelocity
    }
    
    /// Gets the swipe distance
    public func getSwipeDistance() -> CGFloat {
        guard let start = startPoint, let end = endPoint else { return 0 }
        return calculateDistance(from: start, to: end)
    }
    
    // MARK: - Private Methods
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func calculateSwipeDirection(from start: CGPoint, to end: CGPoint) -> SwipeDirection {
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        let absDx = abs(dx)
        let absDy = abs(dy)
        
        if absDx > absDy {
            return dx > 0 ? .right : .left
        } else {
            return dy > 0 ? .down : .up
        }
    }
    
    private func isValidSwipeDirection(_ direction: SwipeDirection) -> Bool {
        switch swipeConfig.allowedDirections {
        case .all:
            return true
        case .horizontal:
            return direction == .left || direction == .right
        case .vertical:
            return direction == .up || direction == .down
        case .custom(let directions):
            return directions.contains(direction)
        }
    }
}

// MARK: - Supporting Types

/// Swipe direction enumeration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum SwipeDirection {
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

/// Allowed swipe directions
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum SwipeDirectionSet {
    case all
    case horizontal
    case vertical
    case custom([SwipeDirection])
}

/// Configuration for swipe gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SwipeConfiguration {
    /// Minimum velocity required for swipe recognition
    public let minimumVelocity: CGFloat
    
    /// Allowed swipe directions
    public let allowedDirections: SwipeDirectionSet
    
    /// Minimum distance for swipe recognition
    public let minimumDistance: CGFloat
    
    /// Maximum time for swipe completion
    public let maximumDuration: TimeInterval
    
    public static let `default` = SwipeConfiguration(
        minimumVelocity: 100.0,
        allowedDirections: .all,
        minimumDistance: 50.0,
        maximumDuration: 1.0
    )
    
    public static let horizontal = SwipeConfiguration(
        minimumVelocity: 100.0,
        allowedDirections: .horizontal,
        minimumDistance: 50.0,
        maximumDuration: 1.0
    )
    
    public static let vertical = SwipeConfiguration(
        minimumVelocity: 100.0,
        allowedDirections: .vertical,
        minimumDistance: 50.0,
        maximumDuration: 1.0
    )
    
    public init(minimumVelocity: CGFloat = 100.0,
                allowedDirections: SwipeDirectionSet = .all,
                minimumDistance: CGFloat = 50.0,
                maximumDuration: TimeInterval = 1.0) {
        self.minimumVelocity = minimumVelocity
        self.allowedDirections = allowedDirections
        self.minimumDistance = minimumDistance
        self.maximumDuration = maximumDuration
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SwipeGestureViewModifier: ViewModifier {
    private let configuration: SwipeConfiguration
    private let onSwipe: (SwipeDirection) -> Void
    
    public init(configuration: SwipeConfiguration = .default, onSwipe: @escaping (SwipeDirection) -> Void) {
        self.configuration = configuration
        self.onSwipe = onSwipe
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: configuration.minimumDistance)
                    .onEnded { value in
                        let direction = self.calculateDirection(from: value)
                        self.onSwipe(direction)
                    }
            )
    }
    
    private func calculateDirection(from value: DragGesture.Value) -> SwipeDirection {
        let dx = value.translation.x
        let dy = value.translation.y
        
        let absDx = abs(dx)
        let absDy = abs(dy)
        
        if absDx > absDy {
            return dx > 0 ? .right : .left
        } else {
            return dy > 0 ? .down : .up
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customSwipeGesture(configuration: SwipeConfiguration = .default, onSwipe: @escaping (SwipeDirection) -> Void) -> some View {
        modifier(SwipeGestureViewModifier(configuration: configuration, onSwipe: onSwipe))
    }
} 