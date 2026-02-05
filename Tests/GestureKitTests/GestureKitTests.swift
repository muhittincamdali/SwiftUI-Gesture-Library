//
//  GestureKitTests.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import XCTest
import SwiftUI
@testable import GestureKit

final class GestureKitTests: XCTestCase {
    
    // MARK: - Version Tests
    
    func testVersion() {
        XCTAssertEqual(GestureKit.version, "2.0.0")
    }
    
    // MARK: - Swipe Direction Tests
    
    func testSwipeDirectionOpposite() {
        XCTAssertEqual(SwipeDirection.left.opposite, .right)
        XCTAssertEqual(SwipeDirection.right.opposite, .left)
        XCTAssertEqual(SwipeDirection.up.opposite, .down)
        XCTAssertEqual(SwipeDirection.down.opposite, .up)
    }
    
    func testSwipeDirectionHorizontal() {
        XCTAssertEqual(SwipeDirection.horizontal, [.left, .right])
    }
    
    func testSwipeDirectionVertical() {
        XCTAssertEqual(SwipeDirection.vertical, [.up, .down])
    }
    
    // MARK: - Gesture Type Tests
    
    func testGestureTypeEquality() {
        XCTAssertEqual(GestureType.tap, GestureType.tap)
        XCTAssertEqual(GestureType.doubleTap, GestureType.doubleTap)
        XCTAssertEqual(GestureType.swipe(.left), GestureType.swipe(.left))
        XCTAssertNotEqual(GestureType.swipe(.left), GestureType.swipe(.right))
        XCTAssertEqual(GestureType.longPress(duration: 0.5), GestureType.longPress(duration: 0.5))
        XCTAssertNotEqual(GestureType.longPress(duration: 0.5), GestureType.longPress(duration: 1.0))
    }
    
    // MARK: - Gesture Event Tests
    
    func testGestureEventCreation() {
        let event = GestureEvent(
            type: .tap,
            state: .ended,
            location: CGPoint(x: 100, y: 200)
        )
        
        XCTAssertEqual(event.type, .tap)
        XCTAssertEqual(event.state, .ended)
        XCTAssertEqual(event.location.x, 100)
        XCTAssertEqual(event.location.y, 200)
    }
    
    // MARK: - Shape Recognition Tests
    
    func testShapeRecognizerWithCircle() {
        let recognizer = ShapeRecognizer.shared
        
        // Generate circle points
        let center = CGPoint(x: 100, y: 100)
        let radius: CGFloat = 50
        var points: [CGPoint] = []
        
        for i in 0..<36 {
            let angle = Double(i) * 10 * .pi / 180
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            points.append(CGPoint(x: x, y: y))
        }
        // Close the circle
        points.append(points[0])
        
        let result = recognizer.recognize(points: points)
        XCTAssertEqual(result.shape, .circle)
        XCTAssertGreaterThan(result.confidence, 0.7)
    }
    
    func testShapeRecognizerWithLine() {
        let recognizer = ShapeRecognizer.shared
        
        // Generate line points (horizontal for more reliable detection)
        var points: [CGPoint] = []
        for i in 0..<20 {
            points.append(CGPoint(x: Double(i) * 10, y: 50))
        }
        
        let result = recognizer.recognize(points: points)
        XCTAssertTrue(result.shape == .line || result.shape == .horizontalLine)
        XCTAssertGreaterThan(result.confidence, 0.5)
    }
    
    func testShapeRecognizerWithHorizontalLine() {
        let recognizer = ShapeRecognizer.shared
        
        // Generate horizontal line
        var points: [CGPoint] = []
        for i in 0..<20 {
            points.append(CGPoint(x: Double(i) * 10, y: 50))
        }
        
        let result = recognizer.recognize(points: points)
        XCTAssertEqual(result.shape, .horizontalLine)
    }
    
    func testShapeRecognizerWithVerticalLine() {
        let recognizer = ShapeRecognizer.shared
        
        // Generate vertical line
        var points: [CGPoint] = []
        for i in 0..<20 {
            points.append(CGPoint(x: 50, y: Double(i) * 10))
        }
        
        let result = recognizer.recognize(points: points)
        XCTAssertEqual(result.shape, .verticalLine)
    }
    
    func testShapeRecognizerBoundingRect() {
        let recognizer = ShapeRecognizer.shared
        
        let points = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 100, y: 0),
            CGPoint(x: 100, y: 100),
            CGPoint(x: 0, y: 100),
            CGPoint(x: 0, y: 0)
        ]
        
        let result = recognizer.recognize(points: points)
        XCTAssertEqual(result.boundingRect.width, 100)
        XCTAssertEqual(result.boundingRect.height, 100)
    }
    
    // MARK: - Recognized Shape Tests
    
    func testRecognizedShapeDisplayName() {
        XCTAssertEqual(RecognizedShape.circle.displayName, "Circle")
        XCTAssertEqual(RecognizedShape.square.displayName, "Square")
        XCTAssertEqual(RecognizedShape.triangle.displayName, "Triangle")
    }
    
    func testRecognizedShapeSymbolName() {
        XCTAssertEqual(RecognizedShape.circle.symbolName, "circle")
        XCTAssertEqual(RecognizedShape.square.symbolName, "square")
        XCTAssertEqual(RecognizedShape.checkmark.symbolName, "checkmark")
    }
    
    // MARK: - Drawing Path Tests
    
    func testDrawingPathDuration() {
        var path = DrawingPath(startTime: Date())
        path.points = [CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 100)]
        
        // Since endTime is not set, duration should be calculated from now
        XCTAssertGreaterThanOrEqual(path.duration, 0)
    }
    
    // MARK: - Recorded Gesture Tests
    
    func testRecordedGestureCreation() {
        let points = [
            RecordedPoint(point: CGPoint(x: 0, y: 0), timestamp: 0),
            RecordedPoint(point: CGPoint(x: 100, y: 100), timestamp: 0.5)
        ]
        
        let recording = RecordedGesture(name: "Test", points: points)
        
        XCTAssertEqual(recording.name, "Test")
        XCTAssertEqual(recording.points.count, 2)
        XCTAssertEqual(recording.duration, 0.5)
    }
    
    func testRecordedGestureBoundingRect() {
        let points = [
            RecordedPoint(point: CGPoint(x: 10, y: 20), timestamp: 0),
            RecordedPoint(point: CGPoint(x: 110, y: 120), timestamp: 0.5)
        ]
        
        let recording = RecordedGesture(name: "Test", points: points)
        let bounds = recording.boundingRect
        
        XCTAssertEqual(bounds.minX, 10)
        XCTAssertEqual(bounds.minY, 20)
        XCTAssertEqual(bounds.width, 100)
        XCTAssertEqual(bounds.height, 100)
    }
    
    func testRecordedGestureNormalization() {
        let points = [
            RecordedPoint(point: CGPoint(x: 0, y: 0), timestamp: 0),
            RecordedPoint(point: CGPoint(x: 100, y: 100), timestamp: 0.5)
        ]
        
        let recording = RecordedGesture(name: "Test", points: points)
        let normalized = recording.normalized(to: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        XCTAssertEqual(normalized.points.count, 2)
    }
    
    // MARK: - Haptic Tests
    
    func testHapticTypes() {
        XCTAssertEqual(HapticType.allCases.count, 9)
        XCTAssertTrue(HapticType.allCases.contains(.light))
        XCTAssertTrue(HapticType.allCases.contains(.medium))
        XCTAssertTrue(HapticType.allCases.contains(.heavy))
    }
    
    func testHapticPatternPresets() {
        XCTAssertFalse(HapticPattern.doubleTap.events.isEmpty)
        XCTAssertFalse(HapticPattern.heartbeat.events.isEmpty)
        XCTAssertFalse(HapticPattern.celebration.events.isEmpty)
    }
    
    // MARK: - Gesture Sequence Tests
    
    func testGestureSequencePresets() {
        XCTAssertEqual(GestureSequence.doubleTapHold.gestures.count, 2)
        XCTAssertEqual(GestureSequence.swipeAndTap.gestures.count, 2)
    }
    
    // MARK: - Gesture State Tests
    
    func testGestureStateColor() {
        XCTAssertEqual(GestureTrackingState.inactive.color, .gray)
        XCTAssertEqual(GestureTrackingState.started.color, .blue)
        XCTAssertEqual(GestureTrackingState.ended.color, .green)
        XCTAssertEqual(GestureTrackingState.failed.color, .red)
    }
    
    // MARK: - Animation Config Tests
    
    func testAnimationConfigPresets() {
        XCTAssertEqual(GestureAnimationConfig.quick.duration, 0.15)
        XCTAssertEqual(GestureAnimationConfig.standard.duration, 0.3)
        XCTAssertEqual(GestureAnimationConfig.slow.duration, 0.5)
    }
    
    // MARK: - Accessibility Tests
    
    func testReducedMotionEnvironment() {
        // Just ensure it doesn't crash - actual value depends on system settings
        _ = ReducedMotionEnvironment.isEnabled
    }
    
    func testAccessibleAnimationRespectsReducedMotion() {
        // Just ensure the function works
        let animation = AccessibleAnimation.standard()
        // Animation should be nil if reduced motion is enabled, otherwise non-nil
        if ReducedMotionEnvironment.isEnabled {
            XCTAssertNil(animation)
        }
    }
    
    // MARK: - Gesture Logger Tests
    
    @MainActor
    func testGestureLoggerSingleton() {
        let logger1 = GestureLogger.shared
        let logger2 = GestureLogger.shared
        XCTAssertTrue(logger1 === logger2)
    }
    
    @MainActor
    func testGestureLoggerLogging() {
        let logger = GestureLogger.shared
        logger.isEnabled = true
        logger.clear()
        
        logger.log(type: "tap", state: .ended, location: CGPoint(x: 50, y: 50))
        
        XCTAssertEqual(logger.entries.count, 1)
        XCTAssertEqual(logger.entries.first?.gestureType, "tap")
        
        logger.isEnabled = false
        logger.clear()
    }
    
    @MainActor
    func testGestureLoggerMaxEntries() {
        let logger = GestureLogger.shared
        logger.isEnabled = true
        logger.clear()
        
        // Log more than max entries
        for i in 0..<150 {
            logger.log(type: "tap\(i)", state: .ended)
        }
        
        XCTAssertLessThanOrEqual(logger.entries.count, logger.maxEntries)
        
        logger.isEnabled = false
        logger.clear()
    }
    
    @MainActor
    func testGestureLoggerExport() {
        let logger = GestureLogger.shared
        logger.isEnabled = true
        logger.clear()
        
        logger.log(type: "tap", state: .ended, details: "test")
        
        let exported = logger.export()
        XCTAssertTrue(exported.contains("tap"))
        XCTAssertTrue(exported.contains("ended"))
        
        logger.isEnabled = false
        logger.clear()
    }
    
    // MARK: - Integration Tests
    
    func testGestureKitDebugMode() {
        GestureKit.debugMode = true
        XCTAssertTrue(GestureKit.debugMode)
        
        GestureKit.debugMode = false
        XCTAssertFalse(GestureKit.debugMode)
    }
    
    func testGestureKitHapticsEnabled() {
        let original = GestureKit.hapticsEnabled
        
        GestureKit.hapticsEnabled = false
        XCTAssertFalse(GestureKit.hapticsEnabled)
        
        GestureKit.hapticsEnabled = true
        XCTAssertTrue(GestureKit.hapticsEnabled)
        
        GestureKit.hapticsEnabled = original
    }
}

// MARK: - Performance Tests

extension GestureKitTests {
    func testShapeRecognitionPerformance() {
        let recognizer = ShapeRecognizer.shared
        
        // Generate a complex path
        var points: [CGPoint] = []
        for i in 0..<100 {
            let angle = Double(i) * 3.6 * .pi / 180
            points.append(CGPoint(x: 100 + 50 * cos(angle), y: 100 + 50 * sin(angle)))
        }
        
        measure {
            _ = recognizer.recognize(points: points)
        }
    }
    
    func testRecordingNormalizationPerformance() {
        var points: [RecordedPoint] = []
        for i in 0..<1000 {
            points.append(RecordedPoint(
                point: CGPoint(x: Double(i), y: Double(i)),
                timestamp: Double(i) / 1000.0
            ))
        }
        
        let recording = RecordedGesture(name: "Performance Test", points: points)
        
        measure {
            _ = recording.normalized(to: CGRect(x: 0, y: 0, width: 500, height: 500))
        }
    }
}
