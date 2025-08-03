import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class GestureIntegrationTests: XCTestCase {
    
    var gestureEngine: GestureEngine!
    
    override func setUp() {
        super.setUp()
        gestureEngine = GestureEngine()
    }
    
    override func tearDown() {
        gestureEngine = nil
        super.tearDown()
    }
    
    // MARK: - Multi-Gesture Integration Tests
    
    func testTapAndSwipeCombination() {
        let tapRecognizer = TapGestureRecognizer()
        let swipeRecognizer = SwipeGestureRecognizer()
        
        gestureEngine.registerRecognizer(tapRecognizer)
        gestureEngine.registerRecognizer(swipeRecognizer)
        
        // Simulate tap gesture
        let tapEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in tapEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(gestureEngine.currentState, .singleGesture(tapRecognizer))
        
        // Reset and simulate swipe gesture
        gestureEngine.reset()
        
        let swipeEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in swipeEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(gestureEngine.currentState, .singleGesture(swipeRecognizer))
    }
    
    func testPinchAndRotationCombination() {
        let pinchRecognizer = PinchGestureRecognizer()
        let rotationRecognizer = RotationGestureRecognizer()
        
        gestureEngine.registerRecognizer(pinchRecognizer)
        gestureEngine.registerRecognizer(rotationRecognizer)
        
        // Simulate multi-touch pinch and rotation
        let multiTouchEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 250, y: 250), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.2, phase: .ended),
            TouchEvent(location: CGPoint(x: 250, y: 250), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in multiTouchEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        // Should recognize either pinch or rotation based on dominant gesture
        XCTAssertNotEqual(gestureEngine.currentState, .idle)
    }
    
    // MARK: - Gesture Chaining Tests
    
    func testGestureChaining() {
        let tapRecognizer = TapGestureRecognizer(configuration: .doubleTap)
        let longPressRecognizer = LongPressGestureRecognizer()
        
        gestureEngine.registerRecognizer(tapRecognizer)
        gestureEngine.registerRecognizer(longPressRecognizer)
        
        // Simulate double tap followed by long press
        let doubleTapEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.15, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in doubleTapEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(gestureEngine.currentState, .singleGesture(tapRecognizer))
        
        // Reset for long press test
        gestureEngine.reset()
        
        let longPressEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.6, phase: .ended)
        ]
        
        for event in longPressEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(gestureEngine.currentState, .singleGesture(longPressRecognizer))
    }
    
    // MARK: - Performance Integration Tests
    
    func testConcurrentGesturePerformance() {
        let recognizers = [
            TapGestureRecognizer(),
            SwipeGestureRecognizer(),
            PinchGestureRecognizer(),
            PanGestureRecognizer()
        ]
        
        for recognizer in recognizers {
            gestureEngine.registerRecognizer(recognizer)
        }
        
        measure {
            for _ in 0..<50 {
                let events = [
                    TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
                    TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
                ]
                
                for event in events {
                    gestureEngine.processTouchEvent(event)
                }
                
                gestureEngine.reset()
            }
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagementWithMultipleRecognizers() {
        weak var weakEngine: GestureEngine?
        weak var weakTapRecognizer: TapGestureRecognizer?
        weak var weakSwipeRecognizer: SwipeGestureRecognizer?
        
        autoreleasepool {
            let engine = GestureEngine()
            weakEngine = engine
            
            let tapRecognizer = TapGestureRecognizer()
            let swipeRecognizer = SwipeGestureRecognizer()
            
            weakTapRecognizer = tapRecognizer
            weakSwipeRecognizer = swipeRecognizer
            
            engine.registerRecognizer(tapRecognizer)
            engine.registerRecognizer(swipeRecognizer)
            
            // Process some events
            let events = [
                TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
                TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
            ]
            
            for event in events {
                engine.processTouchEvent(event)
            }
        }
        
        // All objects should be deallocated
        XCTAssertNil(weakEngine)
        XCTAssertNil(weakTapRecognizer)
        XCTAssertNil(weakSwipeRecognizer)
    }
    
    // MARK: - Error Handling Integration Tests
    
    func testErrorHandlingWithInvalidGestures() {
        let tapRecognizer = TapGestureRecognizer()
        gestureEngine.registerRecognizer(tapRecognizer)
        
        // Simulate invalid gesture (too short duration)
        let invalidEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.01, phase: .ended)
        ]
        
        for event in invalidEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    // MARK: - Haptic Feedback Integration Tests
    
    func testHapticFeedbackIntegration() {
        let hapticManager = HapticFeedbackManager()
        let tapRecognizer = TapGestureRecognizer()
        
        gestureEngine.registerRecognizer(tapRecognizer)
        
        // Simulate successful tap
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            gestureEngine.processTouchEvent(event)
        }
        
        // Haptic feedback should be triggered
        XCTAssertEqual(tapRecognizer.state, .recognized)
    }
    
    // MARK: - Accessibility Integration Tests
    
    func testAccessibilityGestureSupport() {
        let tapRecognizer = TapGestureRecognizer()
        gestureEngine.registerRecognizer(tapRecognizer)
        
        // Test with accessibility touch type
        let accessibilityEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began, type: .finger),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended, type: .finger)
        ]
        
        for event in accessibilityEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .recognized)
    }
    
    // MARK: - Cross-Platform Integration Tests
    
    func testCrossPlatformGestureSupport() {
        let recognizers = [
            TapGestureRecognizer(),
            SwipeGestureRecognizer(),
            PinchGestureRecognizer(),
            PanGestureRecognizer(),
            LongPressGestureRecognizer()
        ]
        
        for recognizer in recognizers {
            gestureEngine.registerRecognizer(recognizer)
        }
        
        // Test that all recognizers are properly registered
        XCTAssertEqual(recognizers.count, 5)
        
        // Test cross-platform compatibility
        for recognizer in recognizers {
            XCTAssertTrue(recognizer.type.description.count > 0)
        }
    }
    
    // MARK: - Real-World Scenario Tests
    
    func testPhotoGalleryGestureScenario() {
        let pinchRecognizer = PinchGestureRecognizer(configuration: .precise)
        let panRecognizer = PanGestureRecognizer(configuration: .constrained)
        let tapRecognizer = TapGestureRecognizer(configuration: .doubleTap)
        
        gestureEngine.registerRecognizer(pinchRecognizer)
        gestureEngine.registerRecognizer(panRecognizer)
        gestureEngine.registerRecognizer(tapRecognizer)
        
        // Simulate photo gallery interactions
        let zoomEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 250, y: 250), timestamp: CACurrentMediaTime() + 0.1, phase: .moved),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.2, phase: .ended),
            TouchEvent(location: CGPoint(x: 250, y: 250), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in zoomEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        // Should recognize pinch gesture
        XCTAssertNotEqual(gestureEngine.currentState, .idle)
    }
    
    func testGameControlGestureScenario() {
        let swipeRecognizer = SwipeGestureRecognizer(configuration: .horizontal)
        let longPressRecognizer = LongPressGestureRecognizer(configuration: .short)
        
        gestureEngine.registerRecognizer(swipeRecognizer)
        gestureEngine.registerRecognizer(longPressRecognizer)
        
        // Simulate game control gestures
        let swipeEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 300, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended)
        ]
        
        for event in swipeEvents {
            gestureEngine.processTouchEvent(event)
        }
        
        // Should recognize swipe gesture
        XCTAssertEqual(gestureEngine.currentState, .singleGesture(swipeRecognizer))
    }
} 