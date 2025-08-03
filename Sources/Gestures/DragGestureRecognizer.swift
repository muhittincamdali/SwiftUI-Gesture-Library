import SwiftUI
import Foundation

/// Advanced drag gesture recognizer with momentum and velocity tracking
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class DragGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Drag configuration
    private let dragConfig: DragConfiguration
    
    /// Drag start location
    private var dragStartLocation: CGPoint?
    
    /// Current drag location
    private var currentDragLocation: CGPoint?
    
    /// Drag translation
    private var dragTranslation: CGPoint = .zero
    
    /// Drag velocity
    private var dragVelocity: CGPoint = .zero
    
    /// Drag momentum
    private var dragMomentum: CGPoint = .zero
    
    /// Whether drag is active
    private var isDragging: Bool = false
    
    // MARK: - Initialization
    
    public init(configuration: DragConfiguration = .default) {
        self.dragConfig = configuration
        super.init(type: .custom("Drag"))
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        dragStartLocation = event.location
        currentDragLocation = event.location
        dragTranslation = .zero
        dragVelocity = .zero
        dragMomentum = .zero
        isDragging = false
    }
    
    public override func handleTouchMoved(_ event: TouchEvent) {
        super.handleTouchMoved(event)
        
        guard let startLocation = dragStartLocation else { return }
        
        currentDragLocation = event.location
        dragTranslation = CGPoint(
            x: event.location.x - startLocation.x,
            y: event.location.y - startLocation.y
        )
        
        // Calculate velocity
        let timeInterval = event.timestamp - startTime
        if timeInterval > 0 {
            dragVelocity = CGPoint(
                x: dragTranslation.x / CGFloat(timeInterval),
                y: dragTranslation.y / CGFloat(timeInterval)
            )
        }
        
        // Calculate momentum
        dragMomentum = CGPoint(
            x: dragVelocity.x * dragConfig.momentumMultiplier,
            y: dragVelocity.y * dragConfig.momentumMultiplier
        )
        
        isDragging = true
        
        // Trigger haptic feedback if enabled
        if dragConfig.enableHapticFeedback && isDragging {
            let hapticManager = HapticFeedbackManager()
            hapticManager.triggerCustomFeedback(intensity: 0.2)
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        guard let startLocation = dragStartLocation else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            return
        }
        
        // Final update
        currentDragLocation = event.location
        dragTranslation = CGPoint(
            x: event.location.x - startLocation.x,
            y: event.location.y - startLocation.y
        )
        
        if isValidDragGesture() {
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        } else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
        }
        
        isDragging = false
    }
    
    public override func validateGesture() -> Bool {
        return isValidDragGesture()
    }
    
    public override func reset() {
        super.reset()
        dragStartLocation = nil
        currentDragLocation = nil
        dragTranslation = .zero
        dragVelocity = .zero
        dragMomentum = .zero
        isDragging = false
    }
    
    // MARK: - Public Methods
    
    /// Gets the current drag translation
    public func getDragTranslation() -> CGPoint {
        return dragTranslation
    }
    
    /// Gets the drag velocity
    public func getDragVelocity() -> CGPoint {
        return dragVelocity
    }
    
    /// Gets the drag momentum
    public func getDragMomentum() -> CGPoint {
        return dragMomentum
    }
    
    /// Gets the drag start location
    public func getDragStartLocation() -> CGPoint? {
        return dragStartLocation
    }
    
    /// Gets the current drag location
    public func getCurrentDragLocation() -> CGPoint? {
        return currentDragLocation
    }
    
    /// Checks if drag is active
    public func isDragActive() -> Bool {
        return isDragging
    }
    
    // MARK: - Private Methods
    
    private func isValidDragGesture() -> Bool {
        let hasMinimumDistance = abs(dragTranslation.x) >= dragConfig.minimumDistance ||
                                abs(dragTranslation.y) >= dragConfig.minimumDistance
        
        let hasValidVelocity = abs(dragVelocity.x) >= dragConfig.minimumVelocity ||
                              abs(dragVelocity.y) >= dragConfig.minimumVelocity
        
        let isWithinBounds = checkDragBoundaries()
        
        return hasMinimumDistance && hasValidVelocity && isWithinBounds
    }
    
    private func checkDragBoundaries() -> Bool {
        guard let boundaries = dragConfig.boundaries else { return true }
        
        let x = dragTranslation.x
        let y = dragTranslation.y
        
        return x >= boundaries.minX && x <= boundaries.maxX &&
               y >= boundaries.minY && y <= boundaries.maxY
    }
}

// MARK: - Supporting Types

/// Drag boundaries
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DragBoundaries {
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
    
    public static let unlimited = DragBoundaries(minX: -CGFloat.infinity, maxX: CGFloat.infinity, minY: -CGFloat.infinity, maxY: CGFloat.infinity)
}

/// Configuration for drag gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DragConfiguration {
    /// Minimum distance required for drag recognition
    public let minimumDistance: CGFloat
    
    /// Minimum velocity required for drag recognition
    public let minimumVelocity: CGFloat
    
    /// Drag boundaries (optional)
    public let boundaries: DragBoundaries?
    
    /// Whether to enable haptic feedback
    public let enableHapticFeedback: Bool
    
    /// Whether to enable momentum tracking
    public let enableMomentum: Bool
    
    /// Momentum multiplier
    public let momentumMultiplier: CGFloat
    
    public static let `default` = DragConfiguration(
        minimumDistance: 5.0,
        minimumVelocity: 50.0,
        boundaries: nil,
        enableHapticFeedback: true,
        enableMomentum: true,
        momentumMultiplier: 0.8
    )
    
    public static let precise = DragConfiguration(
        minimumDistance: 2.0,
        minimumVelocity: 20.0,
        boundaries: DragBoundaries(minX: -100, maxX: 100, minY: -100, maxY: 100),
        enableHapticFeedback: true,
        enableMomentum: false,
        momentumMultiplier: 0.5
    )
    
    public static let freeform = DragConfiguration(
        minimumDistance: 10.0,
        minimumVelocity: 100.0,
        boundaries: .unlimited,
        enableHapticFeedback: false,
        enableMomentum: true,
        momentumMultiplier: 1.0
    )
    
    public init(minimumDistance: CGFloat = 5.0,
                minimumVelocity: CGFloat = 50.0,
                boundaries: DragBoundaries? = nil,
                enableHapticFeedback: Bool = true,
                enableMomentum: Bool = true,
                momentumMultiplier: CGFloat = 0.8) {
        self.minimumDistance = minimumDistance
        self.minimumVelocity = minimumVelocity
        self.boundaries = boundaries
        self.enableHapticFeedback = enableHapticFeedback
        self.enableMomentum = enableMomentum
        self.momentumMultiplier = momentumMultiplier
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DragGestureViewModifier: ViewModifier {
    private let configuration: DragConfiguration
    private let onDragChanged: (CGPoint) -> Void
    private let onDragEnded: (CGPoint, CGPoint) -> Void
    
    public init(configuration: DragConfiguration = .default,
                onDragChanged: @escaping (CGPoint) -> Void,
                onDragEnded: @escaping (CGPoint, CGPoint) -> Void) {
        self.configuration = configuration
        self.onDragChanged = onDragChanged
        self.onDragEnded = onDragEnded
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: configuration.minimumDistance)
                    .onChanged { value in
                        self.onDragChanged(value.translation)
                    }
                    .onEnded { value in
                        self.onDragEnded(value.translation, value.predictedEndTranslation)
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customDragGesture(configuration: DragConfiguration = .default,
                          onDragChanged: @escaping (CGPoint) -> Void,
                          onDragEnded: @escaping (CGPoint, CGPoint) -> Void) -> some View {
        modifier(DragGestureViewModifier(configuration: configuration, onDragChanged: onDragChanged, onDragEnded: onDragEnded))
    }
} 