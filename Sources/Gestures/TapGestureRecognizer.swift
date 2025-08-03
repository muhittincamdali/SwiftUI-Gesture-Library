import SwiftUI
import Foundation

/// Advanced tap gesture recognizer with configurable parameters
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class TapGestureRecognizer: GestureRecognizer {
    
    // MARK: - Properties
    
    /// Tap configuration
    private let tapConfig: TapConfiguration
    
    /// Tap count tracking
    private var tapCount: Int = 0
    
    /// Last tap timestamp
    private var lastTapTime: TimeInterval = 0
    
    /// Tap locations for multi-tap detection
    private var tapLocations: [CGPoint] = []
    
    /// Maximum distance between taps for multi-tap recognition
    private let maxTapDistance: CGFloat = 50.0
    
    // MARK: - Initialization
    
    public init(configuration: TapConfiguration = .default) {
        self.tapConfig = configuration
        super.init(type: configuration.numberOfTaps == 1 ? .tap : .doubleTap)
    }
    
    // MARK: - Override Methods
    
    public override func handleTouchBegan(_ event: TouchEvent) {
        super.handleTouchBegan(event)
        
        // Reset tap tracking for new gesture
        if event.timestamp - lastTapTime > tapConfig.maxTimeBetweenTaps {
            resetTapTracking()
        }
    }
    
    public override func handleTouchEnded(_ event: TouchEvent) {
        // Calculate tap duration
        let tapDuration = event.timestamp - startTime
        
        // Check if tap duration is within valid range
        guard tapDuration >= tapConfig.minimumTapDuration && 
              tapDuration <= tapConfig.maximumTapDuration else {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
            return
        }
        
        // Check if tap location is within acceptable distance from previous taps
        if !tapLocations.isEmpty {
            let distance = calculateDistance(from: event.location, to: tapLocations.last!)
            guard distance <= maxTapDistance else {
                state = .failed
                delegate?.gestureRecognizer(self, didFailWithError: .invalidGesture)
                return
            }
        }
        
        // Update tap tracking
        tapCount += 1
        lastTapTime = event.timestamp
        tapLocations.append(event.location)
        
        // Check if we have the required number of taps
        if tapCount >= tapConfig.numberOfTaps {
            state = .recognized
            delegate?.gestureRecognizer(self, didChangeState: state)
        } else {
            // Start timer for next tap
            startMultiTapTimer()
        }
    }
    
    public override func validateGesture() -> Bool {
        // Check if we have the correct number of taps
        guard tapCount == tapConfig.numberOfTaps else {
            return false
        }
        
        // Check if all taps are within the time window
        guard lastTapTime - startTime <= tapConfig.maxTimeBetweenTaps else {
            return false
        }
        
        // Check if tap locations are within acceptable distance
        for i in 1..<tapLocations.count {
            let distance = calculateDistance(from: tapLocations[i], to: tapLocations[i-1])
            guard distance <= maxTapDistance else {
                return false
            }
        }
        
        return true
    }
    
    public override func reset() {
        super.reset()
        resetTapTracking()
    }
    
    // MARK: - Private Methods
    
    private func resetTapTracking() {
        tapCount = 0
        lastTapTime = 0
        tapLocations.removeAll()
    }
    
    private func startMultiTapTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: tapConfig.maxTimeBetweenTaps, repeats: false) { [weak self] _ in
            self?.handleMultiTapTimeout()
        }
    }
    
    private func handleMultiTapTimeout() {
        if tapCount < tapConfig.numberOfTaps {
            state = .failed
            delegate?.gestureRecognizer(self, didFailWithError: .timeout)
        }
    }
    
    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
}

// MARK: - Supporting Types

/// Configuration for tap gesture recognition
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct TapConfiguration {
    /// Number of taps required for recognition
    public let numberOfTaps: Int
    
    /// Minimum duration for a tap to be recognized
    public let minimumTapDuration: TimeInterval
    
    /// Maximum duration for a tap to be recognized
    public let maximumTapDuration: TimeInterval
    
    /// Maximum time between taps for multi-tap gestures
    public let maxTimeBetweenTaps: TimeInterval
    
    /// Maximum distance between tap locations
    public let maxTapDistance: CGFloat
    
    /// Whether to require taps to be in the same location
    public let requireSameLocation: Bool
    
    public static let `default` = TapConfiguration(
        numberOfTaps: 1,
        minimumTapDuration: 0.05,
        maximumTapDuration: 0.5,
        maxTimeBetweenTaps: 0.3,
        maxTapDistance: 50.0,
        requireSameLocation: false
    )
    
    public static let doubleTap = TapConfiguration(
        numberOfTaps: 2,
        minimumTapDuration: 0.05,
        maximumTapDuration: 0.5,
        maxTimeBetweenTaps: 0.3,
        maxTapDistance: 50.0,
        requireSameLocation: false
    )
    
    public static let tripleTap = TapConfiguration(
        numberOfTaps: 3,
        minimumTapDuration: 0.05,
        maximumTapDuration: 0.5,
        maxTimeBetweenTaps: 0.3,
        maxTapDistance: 50.0,
        requireSameLocation: false
    )
    
    public init(numberOfTaps: Int = 1,
                minimumTapDuration: TimeInterval = 0.05,
                maximumTapDuration: TimeInterval = 0.5,
                maxTimeBetweenTaps: TimeInterval = 0.3,
                maxTapDistance: CGFloat = 50.0,
                requireSameLocation: Bool = false) {
        self.numberOfTaps = numberOfTaps
        self.minimumTapDuration = minimumTapDuration
        self.maximumTapDuration = maximumTapDuration
        self.maxTimeBetweenTaps = maxTimeBetweenTaps
        self.maxTapDistance = maxTapDistance
        self.requireSameLocation = requireSameLocation
    }
}

// MARK: - SwiftUI Integration

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct TapGestureViewModifier: ViewModifier {
    private let configuration: TapConfiguration
    private let onTap: () -> Void
    
    public init(configuration: TapConfiguration = .default, onTap: @escaping () -> Void) {
        self.configuration = configuration
        self.onTap = onTap
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                TapGesture(count: configuration.numberOfTaps)
                    .onEnded { _ in
                        onTap()
                    }
            )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    func customTapGesture(configuration: TapConfiguration = .default, onTap: @escaping () -> Void) -> some View {
        modifier(TapGestureViewModifier(configuration: configuration, onTap: onTap))
    }
} 