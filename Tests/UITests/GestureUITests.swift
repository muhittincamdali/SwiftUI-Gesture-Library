import XCTest
import SwiftUI
@testable import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class GestureUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Tap Gesture Tests
    
    func testSingleTapGesture() throws {
        let tapArea = app.otherElements["tapArea"]
        XCTAssertTrue(tapArea.exists)
        
        tapArea.tap()
        
        let resultLabel = app.staticTexts["tapResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertEqual(resultLabel.label, "Single tap detected")
    }
    
    func testDoubleTapGesture() throws {
        let doubleTapArea = app.otherElements["doubleTapArea"]
        XCTAssertTrue(doubleTapArea.exists)
        
        doubleTapArea.doubleTap()
        
        let resultLabel = app.staticTexts["doubleTapResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertEqual(resultLabel.label, "Double tap detected")
    }
    
    func testTripleTapGesture() throws {
        let tripleTapArea = app.otherElements["tripleTapArea"]
        XCTAssertTrue(tripleTapArea.exists)
        
        // Perform triple tap
        tripleTapArea.tap()
        tripleTapArea.tap()
        tripleTapArea.tap()
        
        let resultLabel = app.staticTexts["tripleTapResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertEqual(resultLabel.label, "Triple tap detected")
    }
    
    // MARK: - Swipe Gesture Tests
    
    func testHorizontalSwipeGesture() throws {
        let swipeArea = app.otherElements["swipeArea"]
        XCTAssertTrue(swipeArea.exists)
        
        // Swipe left
        swipeArea.swipeLeft()
        
        let resultLabel = app.staticTexts["swipeResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Left swipe"))
        
        // Swipe right
        swipeArea.swipeRight()
        XCTAssertTrue(resultLabel.label.contains("Right swipe"))
    }
    
    func testVerticalSwipeGesture() throws {
        let swipeArea = app.otherElements["swipeArea"]
        XCTAssertTrue(swipeArea.exists)
        
        // Swipe up
        swipeArea.swipeUp()
        
        let resultLabel = app.staticTexts["swipeResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Up swipe"))
        
        // Swipe down
        swipeArea.swipeDown()
        XCTAssertTrue(resultLabel.label.contains("Down swipe"))
    }
    
    // MARK: - Pinch Gesture Tests
    
    func testPinchGesture() throws {
        let pinchArea = app.otherElements["pinchArea"]
        XCTAssertTrue(pinchArea.exists)
        
        // Perform pinch gesture
        let startPoint = pinchArea.coordinate(withNormalizedOffset: CGVector(dx: 0.3, dy: 0.5))
        let endPoint = pinchArea.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.5))
        
        startPoint.press(forDuration: 0.1, thenDragTo: endPoint)
        
        let resultLabel = app.staticTexts["pinchResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Pinch detected"))
    }
    
    func testZoomInGesture() throws {
        let zoomArea = app.otherElements["zoomArea"]
        XCTAssertTrue(zoomArea.exists)
        
        // Perform zoom in gesture
        let centerPoint = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let outerPoint1 = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.2))
        let outerPoint2 = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.8))
        
        centerPoint.press(forDuration: 0.1, thenDragTo: outerPoint1)
        centerPoint.press(forDuration: 0.1, thenDragTo: outerPoint2)
        
        let resultLabel = app.staticTexts["zoomResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Zoom in"))
    }
    
    func testZoomOutGesture() throws {
        let zoomArea = app.otherElements["zoomArea"]
        XCTAssertTrue(zoomArea.exists)
        
        // Perform zoom out gesture
        let outerPoint1 = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.2))
        let outerPoint2 = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.8))
        let centerPoint = zoomArea.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        
        outerPoint1.press(forDuration: 0.1, thenDragTo: centerPoint)
        outerPoint2.press(forDuration: 0.1, thenDragTo: centerPoint)
        
        let resultLabel = app.staticTexts["zoomResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Zoom out"))
    }
    
    // MARK: - Rotation Gesture Tests
    
    func testRotationGesture() throws {
        let rotationArea = app.otherElements["rotationArea"]
        XCTAssertTrue(rotationArea.exists)
        
        // Perform rotation gesture
        let centerPoint = rotationArea.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let startPoint = rotationArea.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.5))
        let endPoint = rotationArea.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        
        centerPoint.press(forDuration: 0.1, thenDragTo: startPoint)
        startPoint.press(forDuration: 0.1, thenDragTo: endPoint)
        
        let resultLabel = app.staticTexts["rotationResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Rotation detected"))
    }
    
    // MARK: - Pan Gesture Tests
    
    func testPanGesture() throws {
        let panArea = app.otherElements["panArea"]
        XCTAssertTrue(panArea.exists)
        
        // Perform pan gesture
        let startPoint = panArea.coordinate(withNormalizedOffset: CGVector(dx: 0.3, dy: 0.5))
        let endPoint = panArea.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.5))
        
        startPoint.press(forDuration: 0.1, thenDragTo: endPoint)
        
        let resultLabel = app.staticTexts["panResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Pan detected"))
    }
    
    // MARK: - Long Press Gesture Tests
    
    func testLongPressGesture() throws {
        let longPressArea = app.otherElements["longPressArea"]
        XCTAssertTrue(longPressArea.exists)
        
        // Perform long press gesture
        longPressArea.press(forDuration: 1.0)
        
        let resultLabel = app.staticTexts["longPressResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertEqual(resultLabel.label, "Long press detected")
    }
    
    // MARK: - Multi-Touch Gesture Tests
    
    func testMultiTouchGesture() throws {
        let multiTouchArea = app.otherElements["multiTouchArea"]
        XCTAssertTrue(multiTouchArea.exists)
        
        // Perform multi-touch gesture (simulated)
        let point1 = multiTouchArea.coordinate(withNormalizedOffset: CGVector(dx: 0.3, dy: 0.3))
        let point2 = multiTouchArea.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.7))
        
        // Simulate multi-touch by pressing both points
        point1.press(forDuration: 0.5)
        point2.press(forDuration: 0.5)
        
        let resultLabel = app.staticTexts["multiTouchResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Multi-touch detected"))
    }
    
    // MARK: - Combined Gesture Tests
    
    func testCombinedGestures() throws {
        let combinedArea = app.otherElements["combinedArea"]
        XCTAssertTrue(combinedArea.exists)
        
        // Test tap and swipe combination
        combinedArea.tap()
        combinedArea.swipeLeft()
        
        let resultLabel = app.staticTexts["combinedResult"]
        XCTAssertTrue(resultLabel.exists)
        XCTAssertTrue(resultLabel.label.contains("Combined gesture"))
    }
    
    // MARK: - Performance Tests
    
    func testGesturePerformance() throws {
        let performanceArea = app.otherElements["performanceArea"]
        XCTAssertTrue(performanceArea.exists)
        
        // Measure gesture recognition performance
        let startTime = Date()
        
        for _ in 0..<10 {
            performanceArea.tap()
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Performance should be under 2 seconds for 10 taps
        XCTAssertLessThan(duration, 2.0)
        
        let performanceLabel = app.staticTexts["performanceResult"]
        XCTAssertTrue(performanceLabel.exists)
        XCTAssertTrue(performanceLabel.label.contains("Performance test passed"))
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityGestures() throws {
        let accessibleArea = app.otherElements["accessibleArea"]
        XCTAssertTrue(accessibleArea.exists)
        
        // Test accessibility gesture
        accessibleArea.tap()
        
        let accessibilityLabel = app.staticTexts["accessibilityResult"]
        XCTAssertTrue(accessibilityLabel.exists)
        XCTAssertEqual(accessibilityLabel.label, "Accessible gesture detected")
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidGestureHandling() throws {
        let invalidArea = app.otherElements["invalidArea"]
        XCTAssertTrue(invalidArea.exists)
        
        // Perform invalid gesture
        invalidArea.press(forDuration: 0.05) // Too short for long press
        
        let errorLabel = app.staticTexts["errorResult"]
        XCTAssertTrue(errorLabel.exists)
        XCTAssertEqual(errorLabel.label, "Invalid gesture handled")
    }
    
    // MARK: - Haptic Feedback Tests
    
    func testHapticFeedback() throws {
        let hapticArea = app.otherElements["hapticArea"]
        XCTAssertTrue(hapticArea.exists)
        
        // Test haptic feedback
        hapticArea.tap()
        
        let hapticLabel = app.staticTexts["hapticResult"]
        XCTAssertTrue(hapticLabel.exists)
        XCTAssertEqual(hapticLabel.label, "Haptic feedback triggered")
    }
    
    // MARK: - Configuration Tests
    
    func testCustomConfiguration() throws {
        let configArea = app.otherElements["configArea"]
        XCTAssertTrue(configArea.exists)
        
        // Test custom configuration
        configArea.tap()
        
        let configLabel = app.staticTexts["configResult"]
        XCTAssertTrue(configLabel.exists)
        XCTAssertEqual(configLabel.label, "Custom configuration applied")
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() throws {
        let memoryArea = app.otherElements["memoryArea"]
        XCTAssertTrue(memoryArea.exists)
        
        // Perform multiple gestures to test memory management
        for _ in 0..<20 {
            memoryArea.tap()
        }
        
        let memoryLabel = app.staticTexts["memoryResult"]
        XCTAssertTrue(memoryLabel.exists)
        XCTAssertEqual(memoryLabel.label, "Memory management successful")
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseGestures() throws {
        let edgeArea = app.otherElements["edgeArea"]
        XCTAssertTrue(edgeArea.exists)
        
        // Test edge case gestures
        edgeArea.press(forDuration: 5.0) // Very long press
        
        let edgeLabel = app.staticTexts["edgeResult"]
        XCTAssertTrue(edgeLabel.exists)
        XCTAssertEqual(edgeLabel.label, "Edge case handled")
    }
    
    // MARK: - Integration Tests
    
    func testGestureIntegration() throws {
        let integrationArea = app.otherElements["integrationArea"]
        XCTAssertTrue(integrationArea.exists)
        
        // Test integration with other UI elements
        integrationArea.tap()
        
        let integrationLabel = app.staticTexts["integrationResult"]
        XCTAssertTrue(integrationLabel.exists)
        XCTAssertEqual(integrationLabel.label, "Integration test passed")
    }
} 