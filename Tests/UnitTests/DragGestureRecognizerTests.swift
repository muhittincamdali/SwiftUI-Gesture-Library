import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class DragGestureRecognizerTests: XCTestCase {
    
    var dragRecognizer: DragGestureRecognizer!
    
    override func setUp() {
        super.setUp()
        dragRecognizer = DragGestureRecognizer()
    }
    
    override func tearDown() {
        dragRecognizer = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDragGestureRecognizerInitialization() {
        XCTAssertNotNil(dragRecognizer)
        XCTAssertEqual(dragRecognizer.type, .custom("Drag"))
        XCTAssertEqual(dragRecognizer.state, .possible)
    }
    
    func testDragGestureRecognizerWithCustomConfiguration() {
        let configuration = DragConfiguration(
            minimumDistance: 10.0,
            minimumVelocity: 100.0,
            boundaries: DragBoundaries(minX: -50, maxX: 50, minY: -50, maxY: 50),
            enableHapticFeedback: true,
            enableMomentum: true,
            momentumMultiplier: 0.9
        )
        
        let customRecognizer = DragGestureRecognizer(configuration: configuration)
        XCTAssertNotNil(customRecognizer)
        XCTAssertEqual(customRecognizer.type, .custom("Drag"))
    }
    
    // MARK: - Drag Recognition Tests
    
    func testValidDragGesture() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(dragRecognizer.state, .recognized)
    }
    
    func testInvalidDragGestureWithInsufficientDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 102, y: 102), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(dragRecognizer.state, .failed)
    }
    
    func testDragGestureWithHighVelocity() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 300, y: 300), timestamp: CACurrentMediaTime() + 0.05, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(dragRecognizer.state, .recognized)
        XCTAssertGreaterThan(dragRecognizer.getDragVelocity().x, 100.0)
    }
    
    // MARK: - Configuration Tests
    
    func testPreciseDragConfiguration() {
        let preciseRecognizer = DragGestureRecognizer(configuration: .precise)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 105, y: 105), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            preciseRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(preciseRecognizer.state, .recognized)
    }
    
    func testFreeformDragConfiguration() {
        let freeformRecognizer = DragGestureRecognizer(configuration: .freeform)
        
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 200, y: 200), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            freeformRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(freeformRecognizer.state, .recognized)
    }
    
    // MARK: - Validation Tests
    
    func testGestureValidation() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertTrue(dragRecognizer.isValidGesture())
    }
    
    func testGestureValidationFailure() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 101, y: 101), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertFalse(dragRecognizer.isValidGesture())
    }
    
    // MARK: - Reset Tests
    
    func testResetFunctionality() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(dragRecognizer.state, .recognized)
        
        dragRecognizer.reset()
        
        XCTAssertEqual(dragRecognizer.state, .possible)
        XCTAssertEqual(dragRecognizer.getDragTranslation(), CGPoint.zero)
        XCTAssertEqual(dragRecognizer.getDragVelocity(), CGPoint.zero)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithMultipleDrags() {
        measure {
            for _ in 0..<100 {
                let events = [
                    TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
                    TouchEvent(location: CGPoint(x: 150, y: 150), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
                ]
                
                for event in events {
                    dragRecognizer.processTouchEvent(event)
                }
                
                dragRecognizer.reset()
            }
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testDragWithZeroDistance() {
        let events = [
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 100, y: 100), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        XCTAssertEqual(dragRecognizer.state, .failed)
    }
    
    func testDragWithInvalidLocation() {
        let events = [
            TouchEvent(location: CGPoint(x: -1000, y: -1000), timestamp: CACurrentMediaTime(), phase: .began),
            TouchEvent(location: CGPoint(x: 1000, y: 1000), timestamp: CACurrentMediaTime() + 0.1, phase: .ended)
        ]
        
        for event in events {
            dragRecognizer.processTouchEvent(event)
        }
        
        // Should not crash and should handle gracefully
        XCTAssertTrue(true)
    }
} 