import SwiftUI
import Foundation

/// Advanced rotation gesture recognizer with angle tracking and haptic feedback
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class RotationGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Rotation configuration
    private let rotationConfig: RotationConfiguration
    
    /// Initial angle between touch points
    private var initialAngle: CGFloat = 0
    
    /// Current angle between touch points
    private var currentAngle: CGFloat = 0
    
    /// Rotation center point
    private var rotationCenter: CGPoint?
    
    /// Touch points for multi-touch tracking
    private var touchPoints: [CGPoint] = []
    
    /// Rotation velocity
    private var rotationVelocity: CGFloat = 0
    
    /// Total rotation angle
    private var totalRotation: CGFloat = 0
    
    // MARK: - Initialization
    
    public init(configuration: RotationConfiguration = .default) {
        self.rotationConfig = configuration
        super.init(type: .rotation)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        touchPoints.append(event.location)
        
        if touchPoints.count == 2 {
            calculateRotationCenter()
            initialAngle = calculateAngleBetweenPoints(touchPoints[0], touchPoints[1])
            currentAngle = initialAngle
            totalRotation = 0
        }
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        
        // Update touch points
        if let index = touchPoints.firstIndex(where: { calculateDistance(from: $0, to: event.location) < 50 }) {
            touchPoints[index] = event.location
        } else {
            touchPoints.append(event.location)
        }
        
        // Calculate rotation if we have two touch points
        if touchPoints.count >= 2 {
            let newAngle = calculateAngleBetweenPoints(touchPoints[0], touchPoints[1])
            let angleDifference = newAngle - currentAngle
            
            // Handle angle wrapping
            let normalizedDifference = normalizeAngle(angleDifference)
            totalRotation += normalizedDifference
            
            currentAngle = newAngle
            
            // Calculate velocity
            let timeInterval = event.timestamp - startTime
            if timeInterval > 0 {
                rotationVelocity = normalizedDifference / CGFloat(timeInterval)
            }
            
            // Trigger haptic feedback for significant rotations
            if abs(normalizedDifference) > rotationConfig.hapticThreshold {
                let hapticManager = HapticFeedbackManager()
                hapticManager.triggerCustomFeedback(intensity: 0.5)
            }
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        // Remove the ended touch point
        touchPoints.removeAll { calculateDistance(from: $0, to: event.location) < 50 }
        
        if touchPoints.count < 2 {
            // End of rotation gesture
            if isValidRotationGesture() {
                state = .recognized
                delegate?.gestureRecognizer(self, didChangeState: state)
            } else {
                state = .failed
                delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            }
        }
    }
    
    public override func validateGesture() -> Bool {
        return isValidRotationGesture()
    }
    
    public override func reset() {
        super.reset()
        initialAngle = 0
        currentAngle = 0
        rotationCenter = nil
        touchPoints.removeAll()
        rotationVelocity = 0
        totalRotation = 0
    }
    
    // MARK: - Public Methods
    
    /// Gets the current rotation angle in radians
    public func getCurrentRotation() -> CGFloat {
        return totalRotation
    }
    
    /// Gets the current rotation angle in degrees
    public func getCurrentRotationDegrees() -> CGFloat {
        return totalRotation * 180 / .pi
    }
    
    /// Gets the rotation velocity
    public func getRotationVelocity() -> CGFloat {
        return rotationVelocity
    }
    
    /// Gets the rotation center point
    public func getRotationCenter() -> CGPoint? {
        return rotationCenter
    }
    
    /// Gets the initial angle
    public func getInitialAngle() -> CGFloat {
        return initialAngle
    }
    
    // MARK: - Private Methods
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func calculateAngleBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return atan2(dy, dx)
    }
    
    private func calculateRotationCenter() {
        guard touchPoints.count >= 2 else { return }
        
        let x = (touchPoints[0].x + touchPoints[1].x) / 2
        let y = (touchPoints[0].y + touchPoints[1].y) / 2
        rotationCenter = CGPoint(x: x, y: y)
    }
    
    private func normalizeAngle(_ angle: CGFloat) -> CGFloat {
        var normalized = angle
        
        // Normalize to [-π, π]
        while normalized > .pi {
            normalized -= 2 * .pi
        }
        while normalized < -.pi {
            normalized += 2 * .pi
        }
        
        return normalized
    }
    
    private func isValidRotationGesture() -> Bool {
        let hasMinimumRotation = abs(totalRotation) >= rotationConfig.minimumRotationAngle
        let hasValidCenter = rotationCenter != nil
        let hasValidTouchPoints = touchPoints.count >= 2
        
        return hasMinimumRotation && hasValidCenter && hasValidTouchPoints
    }
}

// MARK: - Supporting Types

/// Configuration for rotation gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RotationConfiguration {
    /// Minimum rotation angle required for recognition (in radians)
    public let minimumRotationAngle: CGFloat
    
    /// Maximum rotation angle allowed (in radians)
    public let maximumRotationAngle: CGFloat
    
    /// Threshold for haptic feedback (in radians)
    public let hapticThreshold: CGFloat
    
    /// Whether to enable haptic feedback
    public let enableHapticFeedback: Bool
    
    /// Whether to snap to certain angles
    public let enableAngleSnapping: Bool
    
    /// Angles to snap to (in degrees)
    public let snapAngles: [CGFloat]
    
    public static let `default` = RotationConfiguration(
        minimumRotationAngle: 0.1, // ~5.7 degrees
        maximumRotationAngle: 2 * .pi, // 360 degrees
        hapticThreshold: 0.1,
        enableHapticFeedback: true,
        enableAngleSnapping: false,
        snapAngles: [0, 45, 90, 135, 180, 225, 270, 315]
    )
    
    public static let precise = RotationConfiguration(
        minimumRotationAngle: 0.05, // ~2.9 degrees
        maximumRotationAngle: .pi, // 180 degrees
        hapticThreshold: 0.05,
        enableHapticFeedback: true,
        enableAngleSnapping: true,
        snapAngles: [0, 30, 60, 90, 120, 150, 180]
    )
    
    public static let freeform = RotationConfiguration(
        minimumRotationAngle: 0.2, // ~11.5 degrees
        maximumRotationAngle: 4 * .pi, // 720 degrees
        hapticThreshold: 0.2,
        enableHapticFeedback: false,
        enableAngleSnapping: false,
        snapAngles: []
    )
    
    public init(minimumRotationAngle: CGFloat = 0.1,
                maximumRotationAngle: CGFloat = 2 * .pi,
                hapticThreshold: CGFloat = 0.1,
                enableHapticFeedback: Bool = true,
                enableAngleSnapping: Bool = false,
                snapAngles: [CGFloat] = [0, 45, 90, 135, 180, 225, 270, 315]) {
        self.minimumRotationAngle = minimumRotationAngle
        self.maximumRotationAngle = maximumRotationAngle
        self.hapticThreshold = hapticThreshold
        self.enableHapticFeedback = enableHapticFeedback
        self.enableAngleSnapping = enableAngleSnapping
        self.snapAngles = snapAngles
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RotationGestureViewModifier: ViewModifier {
    private let configuration: RotationConfiguration
    private let onRotationChanged: (CGFloat) -> Void
    private let onRotationEnded: (CGFloat) -> Void
    
    public init(configuration: RotationConfiguration = .default,
                onRotationChanged: @escaping (CGFloat) -> Void,
                onRotationEnded: @escaping (CGFloat) -> Void) {
        self.configuration = configuration
        self.onRotationChanged = onRotationChanged
        self.onRotationEnded = onRotationEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                RotationGesture(minimumAngleDelta: Angle(radians: configuration.minimumRotationAngle))
                    .onChanged { angle in
                        let clampedAngle = max(configuration.minimumRotationAngle, min(configuration.maximumRotationAngle, angle.radians))
                        self.onRotationChanged(clampedAngle)
                    }
                    .onEnded { angle in
                        self.onRotationEnded(angle.radians)
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customRotationGesture(configuration: RotationConfiguration = .default,
                              onRotationChanged: @escaping (CGFloat) -> Void,
                              onRotationEnded: @escaping (CGFloat) -> Void) -> some View {
        modifier(RotationGestureViewModifier(configuration: configuration, onRotationChanged: onRotationChanged, onRotationEnded: onRotationEnded))
    }
} 