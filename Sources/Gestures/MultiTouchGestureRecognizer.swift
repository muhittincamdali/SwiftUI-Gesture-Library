import SwiftUI
import Foundation

/// Advanced multi-touch gesture recognizer with complex gesture support
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class MultiTouchGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Multi-touch configuration
    private let multiTouchConfig: MultiTouchConfiguration
    
    /// Active touch points
    private var activeTouchPoints: [CGPoint] = []
    
    /// Touch point history
    private var touchHistory: [[CGPoint]] = []
    
    /// Gesture pattern
    private var gesturePattern: MultiTouchPattern?
    
    /// Recognition state
    private var recognitionState: MultiTouchRecognitionState = .waiting
    
    // MARK: - Initialization
    
    public init(configuration: MultiTouchConfiguration = .default) {
        self.multiTouchConfig = configuration
        super.init(type: .custom("MultiTouch"))
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        activeTouchPoints.append(event.location)
        updateTouchHistory()
        
        if activeTouchPoints.count >= multiTouchConfig.minimumTouchPoints {
            recognitionState = .recognizing
        }
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        
        // Update touch point if it exists
        if let index = findTouchPointIndex(for: event.location) {
            activeTouchPoints[index] = event.location
        } else {
            activeTouchPoints.append(event.location)
        }
        
        updateTouchHistory()
        analyzeGesturePattern()
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        // Remove the ended touch point
        if let index = findTouchPointIndex(for: event.location) {
            activeTouchPoints.remove(at: index)
        }
        
        if activeTouchPoints.count < multiTouchConfig.minimumTouchPoints {
            // End of multi-touch gesture
            if isValidMultiTouchGesture() {
                state = .recognized
                delegate?.gestureRecognizer(self, didChangeState: state)
            } else {
                state = .failed
                delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            }
        }
    }
    
    public override func validateGesture() -> Bool {
        return isValidMultiTouchGesture()
    }
    
    public override func reset() {
        super.reset()
        activeTouchPoints.removeAll()
        touchHistory.removeAll()
        gesturePattern = nil
        recognitionState = .waiting
    }
    
    // MARK: - Public Methods
    
    /// Gets the current active touch points
    public func getActiveTouchPoints() -> [CGPoint] {
        return activeTouchPoints
    }
    
    /// Gets the touch point count
    public func getTouchPointCount() -> Int {
        return activeTouchPoints.count
    }
    
    /// Gets the recognized gesture pattern
    public func getGesturePattern() -> MultiTouchPattern? {
        return gesturePattern
    }
    
    /// Gets the recognition state
    public func getRecognitionState() -> MultiTouchRecognitionState {
        return recognitionState
    }
    
    // MARK: - Private Methods
    
    private func findTouchPointIndex(for location: CGPoint) -> Int? {
        return activeTouchPoints.firstIndex { point in
            let distance = calculateDistance(from: point, to: location)
            return distance < 50.0
        }
    }
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func updateTouchHistory() {
        touchHistory.append(activeTouchPoints)
        
        // Keep only recent history
        if touchHistory.count > multiTouchConfig.maxHistorySize {
            touchHistory.removeFirst()
        }
    }
    
    private func analyzeGesturePattern() {
        guard activeTouchPoints.count >= multiTouchConfig.minimumTouchPoints else { return }
        
        // Analyze touch point movement patterns
        let pattern = analyzeTouchPattern()
        
        if let recognizedPattern = pattern {
            gesturePattern = recognizedPattern
            recognitionState = .patternRecognized
        }
    }
    
    private func analyzeTouchPattern() -> MultiTouchPattern? {
        guard touchHistory.count >= 3 else { return nil }
        
        let recentHistory = Array(touchHistory.suffix(3))
        
        // Analyze for pinch pattern
        if isPinchPattern(recentHistory) {
            return .pinch
        }
        
        // Analyze for rotation pattern
        if isRotationPattern(recentHistory) {
            return .rotation
        }
        
        // Analyze for spread pattern
        if isSpreadPattern(recentHistory) {
            return .spread
        }
        
        // Analyze for custom pattern
        if isCustomPattern(recentHistory) {
            return .custom
        }
        
        return nil
    }
    
    private func isPinchPattern(_ history: [[CGPoint]]) -> Bool {
        guard history.count >= 2 else { return false }
        
        let firstPoints = history[0]
        let lastPoints = history[history.count - 1]
        
        guard firstPoints.count >= 2, lastPoints.count >= 2 else { return false }
        
        let initialDistance = calculateDistance(from: firstPoints[0], to: firstPoints[1])
        let finalDistance = calculateDistance(from: lastPoints[0], to: lastPoints[1])
        
        let scaleChange = abs(finalDistance - initialDistance) / initialDistance
        return scaleChange > 0.1
    }
    
    private func isRotationPattern(_ history: [[CGPoint]]) -> Bool {
        guard history.count >= 2 else { return false }
        
        let firstPoints = history[0]
        let lastPoints = history[history.count - 1]
        
        guard firstPoints.count >= 2, lastPoints.count >= 2 else { return false }
        
        let initialAngle = calculateAngle(from: firstPoints[0], to: firstPoints[1])
        let finalAngle = calculateAngle(from: lastPoints[0], to: lastPoints[1])
        
        let angleChange = abs(finalAngle - initialAngle)
        return angleChange > 0.1
    }
    
    private func isSpreadPattern(_ history: [[CGPoint]]) -> Bool {
        guard history.count >= 2 else { return false }
        
        let firstPoints = history[0]
        let lastPoints = history[history.count - 1]
        
        guard firstPoints.count >= 2, lastPoints.count >= 2 else { return false }
        
        let initialDistance = calculateDistance(from: firstPoints[0], to: firstPoints[1])
        let finalDistance = calculateDistance(from: lastPoints[0], to: lastPoints[1])
        
        return finalDistance > initialDistance * 1.2
    }
    
    private func isCustomPattern(_ history: [[CGPoint]]) -> Bool {
        // Custom pattern recognition logic
        return history.count >= multiTouchConfig.minimumHistorySize
    }
    
    private func calculateAngle(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return atan2(dy, dx)
    }
    
    private func isValidMultiTouchGesture() -> Bool {
        let hasMinimumTouchPoints = activeTouchPoints.count >= multiTouchConfig.minimumTouchPoints
        let hasMaximumTouchPoints = activeTouchPoints.count <= multiTouchConfig.maximumTouchPoints
        let hasValidPattern = gesturePattern != nil
        let hasMinimumHistory = touchHistory.count >= multiTouchConfig.minimumHistorySize
        
        return hasMinimumTouchPoints && hasMaximumTouchPoints && hasValidPattern && hasMinimumHistory
    }
}

// MARK: - Supporting Types

/// Multi-touch recognition state
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum MultiTouchRecognitionState {
    case waiting
    case recognizing
    case patternRecognized
    case failed
}

/// Multi-touch gesture patterns
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum MultiTouchPattern {
    case pinch
    case rotation
    case spread
    case custom
    
    public var description: String {
        switch self {
        case .pinch: return "Pinch"
        case .rotation: return "Rotation"
        case .spread: return "Spread"
        case .custom: return "Custom"
        }
    }
}

/// Configuration for multi-touch gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct MultiTouchConfiguration {
    /// Minimum number of touch points required
    public let minimumTouchPoints: Int
    
    /// Maximum number of touch points allowed
    public let maximumTouchPoints: Int
    
    /// Minimum history size for pattern recognition
    public let minimumHistorySize: Int
    
    /// Maximum history size to keep in memory
    public let maxHistorySize: Int
    
    /// Whether to enable pattern recognition
    public let enablePatternRecognition: Bool
    
    public static let `default` = MultiTouchConfiguration(
        minimumTouchPoints: 2,
        maximumTouchPoints: 5,
        minimumHistorySize: 3,
        maxHistorySize: 10,
        enablePatternRecognition: true
    )
    
    public static let precise = MultiTouchConfiguration(
        minimumTouchPoints: 2,
        maximumTouchPoints: 3,
        minimumHistorySize: 5,
        maxHistorySize: 15,
        enablePatternRecognition: true
    )
    
    public static let freeform = MultiTouchConfiguration(
        minimumTouchPoints: 1,
        maximumTouchPoints: 10,
        minimumHistorySize: 2,
        maxHistorySize: 5,
        enablePatternRecognition: false
    )
    
    public init(minimumTouchPoints: Int = 2,
                maximumTouchPoints: Int = 5,
                minimumHistorySize: Int = 3,
                maxHistorySize: Int = 10,
                enablePatternRecognition: Bool = true) {
        self.minimumTouchPoints = minimumTouchPoints
        self.maximumTouchPoints = maximumTouchPoints
        self.minimumHistorySize = minimumHistorySize
        self.maxHistorySize = maxHistorySize
        self.enablePatternRecognition = enablePatternRecognition
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct MultiTouchGestureViewModifier: ViewModifier {
    private let configuration: MultiTouchConfiguration
    private let onMultiTouch: (MultiTouchPattern, [CGPoint]) -> Void
    
    public init(configuration: MultiTouchConfiguration = .default,
                onMultiTouch: @escaping (MultiTouchPattern, [CGPoint]) -> Void) {
        self.configuration = configuration
        self.onMultiTouch = onMultiTouch
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Multi-touch gesture handling
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customMultiTouchGesture(configuration: MultiTouchConfiguration = .default,
                                onMultiTouch: @escaping (MultiTouchPattern, [CGPoint]) -> Void) -> some View {
        modifier(MultiTouchGestureViewModifier(configuration: configuration, onMultiTouch: onMultiTouch))
    }
} 