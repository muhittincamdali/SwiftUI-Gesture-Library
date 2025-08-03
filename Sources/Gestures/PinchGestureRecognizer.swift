import SwiftUI
import Foundation

/// Advanced pinch gesture recognizer with configurable scaling parameters
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class PinchGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Pinch configuration
    private let pinchConfig: PinchConfiguration
    
    /// Current scale factor
    private var currentScale: CGFloat = 1.0
    
    /// Initial distance between touch points
    private var initialDistance: CGFloat = 0
    
    /// Current distance between touch points
    private var currentDistance: CGFloat = 0
    
    /// Touch points for multi-touch tracking
    private var touchPoints: [CGPoint] = []
    
    /// Minimum scale factor
    private let minScale: CGFloat = 0.1
    
    /// Maximum scale factor
    private let maxScale: CGFloat = 10.0
    
    // MARK: - Initialization
    
    public init(configuration: PinchConfiguration = .default) {
        self.pinchConfig = configuration
        super.init(type: .pinch)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        touchPoints.append(event.location)
        
        if touchPoints.count == 2 {
            initialDistance = calculateDistanceBetweenPoints(touchPoints[0], touchPoints[1])
            currentDistance = initialDistance
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
        
        // Calculate scale if we have two touch points
        if touchPoints.count >= 2 {
            currentDistance = calculateDistanceBetweenPoints(touchPoints[0], touchPoints[1])
            updateScale()
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        // Remove the ended touch point
        touchPoints.removeAll { calculateDistance(from: $0, to: event.location) < 50 }
        
        if touchPoints.count < 2 {
            // End of pinch gesture
            if isValidPinchGesture() {
                state = .recognized
                delegate?.gestureRecognizer(self, didChangeState: state)
            } else {
                state = .failed
                delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            }
        }
    }
    
    public override func validateGesture() -> Bool {
        guard initialDistance > 0, currentDistance > 0 else { return false }
        
        let scale = currentDistance / initialDistance
        let isValidScale = scale >= minScale && scale <= maxScale
        let hasMinimumMovement = abs(scale - 1.0) >= pinchConfig.minimumScaleChange
        
        return isValidScale && hasMinimumMovement
    }
    
    public override func reset() {
        super.reset()
        currentScale = 1.0
        initialDistance = 0
        currentDistance = 0
        touchPoints.removeAll()
    }
    
    // MARK: - Public Methods
    
    /// Gets the current scale factor
    public func getCurrentScale() -> CGFloat {
        return currentScale
    }
    
    /// Gets the scale change from initial to current
    public func getScaleChange() -> CGFloat {
        guard initialDistance > 0 else { return 1.0 }
        return currentDistance / initialDistance
    }
    
    /// Gets the center point of the pinch gesture
    public func getPinchCenter() -> CGPoint? {
        guard touchPoints.count >= 2 else { return nil }
        
        let x = (touchPoints[0].x + touchPoints[1].x) / 2
        let y = (touchPoints[0].y + touchPoints[1].y) / 2
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Private Methods
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func calculateDistanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return calculateDistance(from: point1, to: point2)
    }
    
    private func updateScale() {
        guard initialDistance > 0 else { return }
        
        let newScale = currentDistance / initialDistance
        currentScale = max(minScale, min(maxScale, newScale))
    }
    
    private func isValidPinchGesture() -> Bool {
        guard touchPoints.count >= 2 else { return false }
        
        let scale = currentDistance / initialDistance
        let isValidScale = scale >= minScale && scale <= maxScale
        let hasMinimumMovement = abs(scale - 1.0) >= pinchConfig.minimumScaleChange
        
        return isValidScale && hasMinimumMovement
    }
}

// MARK: - Supporting Types

/// Configuration for pinch gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PinchConfiguration {
    /// Minimum scale change required for recognition
    public let minimumScaleChange: CGFloat
    
    /// Minimum scale factor allowed
    public let minimumScale: CGFloat
    
    /// Maximum scale factor allowed
    public let maximumScale: CGFloat
    
    /// Whether to enable haptic feedback during scaling
    public let enableHapticFeedback: Bool
    
    /// Whether to snap to certain scale values
    public let enableScaleSnapping: Bool
    
    /// Scale values to snap to (if enabled)
    public let snapScales: [CGFloat]
    
    public static let `default` = PinchConfiguration(
        minimumScaleChange: 0.1,
        minimumScale: 0.1,
        maximumScale: 10.0,
        enableHapticFeedback: true,
        enableScaleSnapping: false,
        snapScales: [0.25, 0.5, 1.0, 1.5, 2.0, 3.0]
    )
    
    public static let precise = PinchConfiguration(
        minimumScaleChange: 0.05,
        minimumScale: 0.1,
        maximumScale: 5.0,
        enableHapticFeedback: true,
        enableScaleSnapping: true,
        snapScales: [0.25, 0.5, 1.0, 1.5, 2.0]
    )
    
    public static let freeform = PinchConfiguration(
        minimumScaleChange: 0.2,
        minimumScale: 0.1,
        maximumScale: 10.0,
        enableHapticFeedback: false,
        enableScaleSnapping: false,
        snapScales: []
    )
    
    public init(minimumScaleChange: CGFloat = 0.1,
                minimumScale: CGFloat = 0.1,
                maximumScale: CGFloat = 10.0,
                enableHapticFeedback: Bool = true,
                enableScaleSnapping: Bool = false,
                snapScales: [CGFloat] = [0.25, 0.5, 1.0, 1.5, 2.0, 3.0]) {
        self.minimumScaleChange = minimumScaleChange
        self.minimumScale = minimumScale
        self.maximumScale = maximumScale
        self.enableHapticFeedback = enableHapticFeedback
        self.enableScaleSnapping = enableScaleSnapping
        self.snapScales = snapScales
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PinchGestureViewModifier: ViewModifier {
    private let configuration: PinchConfiguration
    private let onPinch: (CGFloat) -> Void
    
    public init(configuration: PinchConfiguration = .default, onPinch: @escaping (CGFloat) -> Void) {
        self.configuration = configuration
        self.onPinch = onPinch
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                MagnificationGesture(minimumScaleDelta: configuration.minimumScaleChange)
                    .onChanged { scale in
                        let clampedScale = max(configuration.minimumScale, min(configuration.maximumScale, scale))
                        self.onPinch(clampedScale)
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customPinchGesture(configuration: PinchConfiguration = .default, onPinch: @escaping (CGFloat) -> Void) -> some View {
        modifier(PinchGestureViewModifier(configuration: configuration, onPinch: onPinch))
    }
} 