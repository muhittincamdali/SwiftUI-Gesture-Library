import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class TapGestureRecognizerTests: XCTestCase {
    
    var tapRecognizer: TapGestureRecognizer!
    
    override func setUp() {
        super.setUp()
        tapRecognizer = TapGestureRecognizer()
    }
    
    override func tearDown() {
        tapRecognizer = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testTapGestureRecognizerInitialization() {
        XCTAssertNotNil(tapRecognizer)
        XCTAssertEqual(tapRecognizer.type, .tap)
        XCTAssertEqual(tapRecognizer.state, .possible)
    }
    
    func testTapGestureRecognizerWithCustomConfiguration() {
        let configuration = TapConfiguration(
            numberOfTaps: 2,
            minimumTapDuration: 0.1,
            maximumTapDuration: 0.3,
            maxTimeBetweenTaps: 0.2,
            maxTapDistance: 30.0,
            requireSameLocation: false
        )
        
        let customRecognizer = TapGestureRecognizer(configuration: configuration)
        XCTAssertNotNil(customRecognizer)
        XCTAssertEqual(customRecognizer.type, .doubleTap)
    }
    
    // MARK: - Single Tap Tests
    
    func testSingleTapRecognition() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .recognized)
    }
    
    func testSingleTapWithMovement() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 105, y: 105), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .recognized)
    }
    
    func testSingleTapWithExcessiveMovement() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    // MARK: - Double Tap Tests
    
    func testDoubleTapRecognition() {
        let doubleTapRecognizer = TapGestureRecognizer(configuration: .doubleTap)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.15, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.2, phase: .ended)
        ]
        
        for event in events {
            doubleTapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(doubleTapRecognizer.state, .recognized)
    }
    
    func testDoubleTapWithTimeout() {
        let doubleTapRecognizer = TapGestureRecognizer(configuration: .doubleTap)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.5, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.55, phase: .ended)
        ]
        
        for event in events {
            doubleTapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(doubleTapRecognizer.state, .failed)
    }
    
    // MARK: - Triple Tap Tests
    
    func testTripleTapRecognition() {
        let tripleTapRecognizer = TapGestureRecognizer(configuration: .tripleTap)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.05, phase: .ended),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.15, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.2, phase: .ended),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.3, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.35, phase: .ended)
        ]
        
        for event in events {
            tripleTapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tripleTapRecognizer.state, .recognized)
    }
    
    // MARK: - Duration Tests
    
    func testTapWithShortDuration() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.01, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    func testTapWithLongDuration() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 1.0, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    // MARK: - Distance Tests
    
    func testTapWithAcceptableDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 120, y: 120), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .recognized)
    }
    
    func testTapWithExcessiveDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    // MARK: - Validation Tests
    
    func testGestureValidation() {
        // Valid tap
        let validEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in validEvents {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertTrue(tapRecognizer.isValidGesture())
    }
    
    func testGestureValidationFailure() {
        // Invalid tap with excessive movement
        let invalidEvents = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 300, y: 300), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in invalidEvents {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertFalse(tapRecognizer.isValidGesture())
    }
    
    // MARK: - Reset Tests
    
    func testResetFunctionality() {
        // Perform a tap
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .recognized)
        
        // Reset
        tapRecognizer.reset()
        
        XCTAssertEqual(tapRecognizer.state, .possible)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithMultipleTaps() {
        measure {
            for _ in 0..<100 {
                let events = [
                    TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
                    TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
                ]
                
                for event in events {
                    tapRecognizer.processTouchEvent(event)
                }
                
                tapRecognizer.reset()
            }
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testTapWithZeroDuration() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    func testTapWithNegativeDuration() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(tapRecognizer.state, .failed)
    }
    
    func testTapWithInvalidLocation() {
        let events = [
            TouchEvent(location: CGPoint(x: -1000, y: -1000), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: -1000, y: -1000), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            tapRecognizer.processTouchEvent(event)
        }
        
        // Should not crash and should handle gracefully
        XCTAssertTrue(true)
    }
} 