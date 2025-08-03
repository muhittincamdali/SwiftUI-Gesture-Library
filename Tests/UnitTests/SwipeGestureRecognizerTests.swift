import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class SwipeGestureRecognizerTests: XCTestCase {
    
    var swipeRecognizer: SwipeGestureRecognizer!
    
    override func setUp() {
        super.setUp()
        swipeRecognizer = SwipeGestureRecognizer()
    }
    
    override func tearDown() {
        swipeRecognizer = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testSwipeGestureRecognizerInitialization() {
        XCTAssertNotNil(swipeRecognizer)
        XCTAssertEqual(swipeRecognizer.type, .swipe)
        XCTAssertEqual(swipeRecognizer.state, .possible)
    }
    
    func testSwipeGestureRecognizerWithCustomConfiguration() {
        let configuration = SwipeConfiguration(
            minimumVelocity: 150.0,
            allowedDirections: .horizontal,
            minimumDistance: 30.0,
            maximumDuration: 0.8
        )
        
        let customRecognizer = SwipeGestureRecognizer(configuration: configuration)
        XCTAssertNotNil(customRecognizer)
        XCTAssertEqual(customRecognizer.type, .swipe)
    }
    
    // MARK: - Swipe Direction Tests
    
    func testRightSwipeRecognition() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertEqual(swipeRecognizer.getSwipeDirection(), .right)
    }
    
    func testLeftSwipeRecognition() {
        let events = [
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertEqual(swipeRecognizer.getSwipeDirection(), .left)
    }
    
    func testUpSwipeRecognition() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 200), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertEqual(swipeRecognizer.getSwipeDirection(), .up)
    }
    
    func testDownSwipeRecognition() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertEqual(swipeRecognizer.getSwipeDirection(), .down)
    }
    
    // MARK: - Velocity Tests
    
    func testSwipeWithHighVelocity() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 300, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertGreaterThan(swipeRecognizer.getSwipeVelocity().x, 100.0)
    }
    
    func testSwipeWithLowVelocity() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 110, y: 100), timestamp: CACurrentMediaTime() + 1.0, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .failed)
    }
    
    // MARK: - Distance Tests
    
    func testSwipeWithMinimumDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
    }
    
    func testSwipeWithInsufficientDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 105, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .failed)
    }
    
    // MARK: - Configuration Tests
    
    func testHorizontalSwipeConfiguration() {
        let horizontalRecognizer = SwipeGestureRecognizer(configuration: .horizontal)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            horizontalRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(horizontalRecognizer.state, .recognized)
    }
    
    func testVerticalSwipeConfiguration() {
        let verticalRecognizer = SwipeGestureRecognizer(configuration: .vertical)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            verticalRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(verticalRecognizer.state, .recognized)
    }
    
    func testCustomDirectionConfiguration() {
        let customDirections = SwipeDirectionSet.custom([.right, .down])
        let configuration = SwipeConfiguration(allowedDirections: customDirections)
        let customRecognizer = SwipeGestureRecognizer(configuration: configuration)
        
        // Test right swipe (allowed)
        let rightEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in rightEvents {
            customRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(customRecognizer.state, .recognized)
        
        // Reset for next test
        customRecognizer.reset()
        
        // Test left swipe (not allowed)
        let leftEvents = [
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in leftEvents {
            customRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(customRecognizer.state, .failed)
    }
    
    // MARK: - Validation Tests
    
    func testGestureValidation() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertTrue(swipeRecognizer.isValidGesture())
    }
    
    func testGestureValidationFailure() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 105, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertFalse(swipeRecognizer.isValidGesture())
    }
    
    // MARK: - Reset Tests
    
    func testResetFunctionality() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        
        swipeRecognizer.reset()
        
        XCTAssertEqual(swipeRecognizer.state, .possible)
        XCTAssertNil(swipeRecognizer.getSwipeDirection())
        XCTAssertEqual(swipeRecognizer.getSwipeVelocity(), CGPoint.zero)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithMultipleSwipes() {
        measure {
            for _ in 0..<100 {
                let events = [
                    TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
                    TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
                ]
                
                for event in events {
                    swipeRecognizer.processTouchEvent(event)
                }
                
                swipeRecognizer.reset()
            }
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testSwipeWithZeroDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .failed)
    }
    
    func testSwipeWithNegativeDuration() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime(), phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .failed)
    }
    
    func testSwipeWithInvalidLocation() {
        let events = [
            TouchEvent(location: CGPoint(x: -1000, y: -1000), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 1000, y: 1000), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        // Should not crash and should handle gracefully
        XCTAssertTrue(true)
    }
    
    // MARK: - Complex Swipe Tests
    
    func testDiagonalSwipe() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        // Should recognize as either right or down based on dominant direction
        XCTAssertEqual(swipeRecognizer.state, .recognized)
    }
    
    func testSwipeWithMultipleTouchEvents() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .moved),
            TouchEvent(location: CGPoint(x: 200, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            swipeRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(swipeRecognizer.state, .recognized)
        XCTAssertEqual(swipeRecognizer.getSwipeDirection(), .right)
    }
} 