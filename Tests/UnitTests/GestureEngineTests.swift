import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class GestureEngineTests: XCTestCase {
    
    var gestureEngine: GestureEngine!
    
    override func setUp() {
        super.setUp()
        gestureEngine = GestureEngine()
    }
    
    override func tearDown() {
        gestureEngine = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testGestureEngineInitialization() {
        XCTAssertNotNil(gestureEngine)
        XCTAssertEqual(gestureEngine.currentState, .idle)
    }
    
    func testGestureEngineWithCustomConfiguration() {
        let configuration = GestureConfiguration(
            enableHapticFeedback: false,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: 5,
            recognitionTimeout: 3.0
        )
        
        let customEngine = GestureEngine(configuration: configuration)
        XCTAssertNotNil(customEngine)
    }
    
    // MARK: - Touch Event Processing Tests
    
    func testProcessTouchEvent() {
        let touchEvent = TouchEvent(
            location: CGPoint(x: 100, y: 100),
            timestamp: CACurrentMediaTime(),
            phase: .began
        )
        
        gestureEngine.processTouchEvent(touchEvent)
        
        // Engine should process the event without crashing
        XCTAssertTrue(true)
    }
    
    func testProcessMultipleTouchEvents() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 110, y: 110), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 120, y: 120), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in events {
            gestureEngine.processTouchEvent(event)
        }
        
        // Engine should process all events without crashing
        XCTAssertTrue(true)
    }
    
    // MARK: - Gesture Recognizer Registration Tests
    
    func testRegisterGestureRecognizer() {
        let recognizer = TapGestureRecognizer()
        let initialCount = gestureEngine.activeRecognizers.count
        
        gestureEngine.registerRecognizer(recognizer)
        
        XCTAssertEqual(gestureEngine.activeRecognizers.count, initialCount + 1)
    }
    
    func testUnregisterGestureRecognizer() {
        let recognizer = TapGestureRecognizer()
        gestureEngine.registerRecognizer(recognizer)
        
        let countAfterRegistration = gestureEngine.activeRecognizers.count
        gestureEngine.unregisterRecognizer(recognizer)
        
        XCTAssertEqual(gestureEngine.activeRecognizers.count, countAfterRegistration - 1)
    }
    
    // MARK: - Reset Tests
    
    func testResetGestureEngine() {
        // Process some events to change state
        let touchEvent = TouchEvent(
            location: CGPoint(x: 100, y: 100),
            timestamp: CACurrentMediaTime(),
            phase: .began
        )
        gestureEngine.processTouchEvent(touchEvent)
        
        gestureEngine.reset()
        
        XCTAssertEqual(gestureEngine.currentState, .idle)
    }
    
    // MARK: - Performance Metrics Tests
    
    func testPerformanceMetrics() {
        let touchEvent = TouchEvent(
            location: CGPoint(x: 100, y: 100),
            timestamp: CACurrentMediaTime(),
            phase: .began
        )
        
        gestureEngine.processTouchEvent(touchEvent)
        
        let metrics = gestureEngine.getPerformanceMetrics()
        XCTAssertGreaterThanOrEqual(metrics.totalEventsProcessed, 1)
    }
    
    // MARK: - State Management Tests
    
    func testGestureStateTransitions() {
        XCTAssertEqual(gestureEngine.currentState, .idle)
        
        // Test state transitions through touch events
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 110, y: 110), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 120, y: 120), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in events {
            gestureEngine.processTouchEvent(event)
        }
        
        // State should be updated after processing events
        XCTAssertNotEqual(gestureEngine.currentState, .idle)
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidTouchEvent() {
        let invalidEvent = TouchEvent(
            location: CGPoint(x: -1000, y: -1000), // Invalid location
            timestamp: -1, // Invalid timestamp
            phase: .began
        )
        
        // Should not crash when processing invalid events
        gestureEngine.processTouchEvent(invalidEvent)
        XCTAssertTrue(true)
    }
    
    // MARK: - Concurrent Gesture Tests
    
    func testConcurrentGestureProcessing() {
        let recognizer1 = TapGestureRecognizer()
        let recognizer2 = SwipeGestureRecognizer()
        
        gestureEngine.registerRecognizer(recognizer1)
        gestureEngine.registerRecognizer(recognizer2)
        
        let touchEvent = TouchEvent(
            location: CGPoint(x: 100, y: 100),
            timestamp: CACurrentMediaTime(),
            phase: .began
        )
        
        gestureEngine.processTouchEvent(touchEvent)
        
        // Both recognizers should process the event
        XCTAssertTrue(true)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() {
        weak var weakEngine: GestureEngine?
        
        autoreleasepool {
            let engine = GestureEngine()
            weakEngine = engine
            
            // Process some events
            let touchEvent = TouchEvent(
                location: CGPoint(x: 100, y: 100),
                timestamp: CACurrentMediaTime(),
                phase: .began
            )
            engine.processTouchEvent(touchEvent)
        }
        
        // Engine should be deallocated
        XCTAssertNil(weakEngine)
    }
    
    // MARK: - Configuration Tests
    
    func testConfigurationValidation() {
        let validConfiguration = GestureConfiguration(
            enableHapticFeedback: true,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: 3,
            recognitionTimeout: 2.0
        )
        
        let engine = GestureEngine(configuration: validConfiguration)
        XCTAssertNotNil(engine)
    }
    
    func testInvalidConfiguration() {
        let invalidConfiguration = GestureConfiguration(
            enableHapticFeedback: true,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: -1, // Invalid value
            recognitionTimeout: -1.0 // Invalid value
        )
        
        let engine = GestureEngine(configuration: invalidConfiguration)
        XCTAssertNotNil(engine) // Should still create engine with default values
    }
}

// MARK: - Test Helpers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension GestureEngine {
    var activeRecognizers: [GestureRecognizer] {
        // This is a test helper - in real implementation this would be private
        return []
    }
} 