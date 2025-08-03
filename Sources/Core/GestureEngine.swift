import SwiftUI
import Combine
import Foundation

/// Core gesture engine that manages gesture recognition and processing
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class GestureEngine: ObservableObject {
    
    // MARK: - Properties
    
    /// Current gesture state
    @Published public private(set) var currentState: GestureState = .idle
    
    /// Active gesture recognizers
    private var activeRecognizers: [GestureRecognizer] = []
    
    /// Gesture configuration
    private let configuration: GestureConfiguration
    
    /// Performance metrics
    private var performanceMetrics = PerformanceMetrics()
    
    /// Haptic feedback manager
    private let hapticManager: HapticFeedbackManager
    
    // MARK: - Initialization
    
    public init(configuration: GestureConfiguration = .default) {
        self.configuration = configuration
        self.hapticManager = HapticFeedbackManager()
        setupGestureEngine()
    }
    
    // MARK: - Public Methods
    
    /// Registers a new gesture recognizer
    public func registerRecognizer(_ recognizer: GestureRecognizer) {
        activeRecognizers.append(recognizer)
        recognizer.delegate = self
    }
    
    /// Unregisters a gesture recognizer
    public func unregisterRecognizer(_ recognizer: GestureRecognizer) {
        activeRecognizers.removeAll { $0.id == recognizer.id }
    }
    
    /// Processes touch events and updates gesture state
    public func processTouchEvent(_ event: TouchEvent) {
        performanceMetrics.startProcessing()
        
        // Update all active recognizers
        for recognizer in activeRecognizers {
            recognizer.processTouchEvent(event)
        }
        
        // Update gesture state based on recognizer states
        updateGestureState()
        
        performanceMetrics.endProcessing()
    }
    
    /// Resets the gesture engine to idle state
    public func reset() {
        currentState = .idle
        activeRecognizers.forEach { $0.reset() }
        performanceMetrics.reset()
    }
    
    /// Gets performance metrics
    public func getPerformanceMetrics() -> PerformanceMetrics {
        return performanceMetrics
    }
    
    // MARK: - Private Methods
    
    private func setupGestureEngine() {
        // Initialize default gesture recognizers
        let defaultRecognizers: [GestureRecognizer] = [
            TapGestureRecognizer(),
            SwipeGestureRecognizer(),
            PinchGestureRecognizer(),
            RotationGestureRecognizer(),
            LongPressGestureRecognizer(),
            PanGestureRecognizer()
        ]
        
        defaultRecognizers.forEach { registerRecognizer($0) }
    }
    
    private func updateGestureState() {
        let recognizedGestures = activeRecognizers.filter { $0.state == .recognized }
        
        if recognizedGestures.isEmpty {
            currentState = .idle
        } else if recognizedGestures.count == 1 {
            currentState = .singleGesture(recognizedGestures.first!)
        } else {
            currentState = .multiGesture(recognizedGestures)
        }
        
        // Trigger haptic feedback if needed
        if case .singleGesture(let recognizer) = currentState {
            hapticManager.triggerFeedback(for: recognizer.type)
        }
    }
}

// MARK: - GestureRecognizerDelegate

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension GestureEngine: GestureRecognizerDelegate {
    
    public func gestureRecognizer(_ recognizer: GestureRecognizer, didChangeState state: GestureRecognizerState) {
        // Handle state changes from recognizers
        DispatchQueue.main.async {
            self.updateGestureState()
        }
    }
    
    public func gestureRecognizer(_ recognizer: GestureRecognizer, didFailWithError error: GestureError) {
        // Handle gesture recognition errors
        print("Gesture recognition failed: \(error.localizedDescription)")
    }
}

// MARK: - Supporting Types

/// Gesture state enumeration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GestureState {
    case idle
    case singleGesture(GestureRecognizer)
    case multiGesture([GestureRecognizer])
}

/// Touch event structure
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct TouchEvent {
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let phase: TouchPhase
    public let pressure: Float
    public let type: TouchType
    
    public init(location: CGPoint, timestamp: TimeInterval, phase: TouchPhase, pressure: Float = 1.0, type: TouchType = .finger) {
        self.location = location
        self.timestamp = timestamp
        self.phase = phase
        self.pressure = pressure
        self.type = type
    }
}

/// Touch phase enumeration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum TouchPhase {
    case began
    case moved
    case ended
    case cancelled
}

/// Touch type enumeration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum TouchType {
    case finger
    case pencil
    case stylus
}

/// Performance metrics for gesture processing
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PerformanceMetrics {
    public private(set) var averageProcessingTime: TimeInterval = 0
    public private(set) var totalEventsProcessed: Int = 0
    public private(set) var recognitionAccuracy: Double = 0
    
    private var processingTimes: [TimeInterval] = []
    private var startTime: TimeInterval = 0
    
    mutating func startProcessing() {
        startTime = CACurrentMediaTime()
    }
    
    mutating func endProcessing() {
        let processingTime = CACurrentMediaTime() - startTime
        processingTimes.append(processingTime)
        totalEventsProcessed += 1
        
        // Keep only last 100 measurements for average
        if processingTimes.count > 100 {
            processingTimes.removeFirst()
        }
        
        averageProcessingTime = processingTimes.reduce(0, +) / Double(processingTimes.count)
    }
    
    mutating func reset() {
        processingTimes.removeAll()
        totalEventsProcessed = 0
        averageProcessingTime = 0
        recognitionAccuracy = 0
    }
}

/// Gesture configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct GestureConfiguration {
    public let enableHapticFeedback: Bool
    public let enablePerformanceMonitoring: Bool
    public let maxConcurrentGestures: Int
    public let recognitionTimeout: TimeInterval
    
    public static let `default` = GestureConfiguration(
        enableHapticFeedback: true,
        enablePerformanceMonitoring: true,
        maxConcurrentGestures: 3,
        recognitionTimeout: 2.0
    )
    
    public init(enableHapticFeedback: Bool = true,
                enablePerformanceMonitoring: Bool = true,
                maxConcurrentGestures: Int = 3,
                recognitionTimeout: TimeInterval = 2.0) {
        self.enableHapticFeedback = enableHapticFeedback
        self.enablePerformanceMonitoring = enablePerformanceMonitoring
        self.maxConcurrentGestures = maxConcurrentGestures
        self.recognitionTimeout = recognitionTimeout
    }
} 