//
//  GestureKitTests.swift
//  GestureKitTests
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
        XCTAssertEqual(GestureKit.version, "1.0.0")
    }
    
    // MARK: - SwipeDirection Tests
    
    func testSwipeDirectionCases() {
        let directions = SwipeDirection.allCases
        XCTAssertEqual(directions.count, 4)
        XCTAssertTrue(directions.contains(.left))
        XCTAssertTrue(directions.contains(.right))
        XCTAssertTrue(directions.contains(.up))
        XCTAssertTrue(directions.contains(.down))
    }
    
    func testSwipeDirectionAngleRanges() {
        // Right: -45° to 45°
        XCTAssertTrue(SwipeDirection.right.angleRange.contains(0))
        
        // Down: 45° to 135°
        XCTAssertTrue(SwipeDirection.down.angleRange.contains(Double.pi / 2))
        
        // Up: -135° to -45°
        XCTAssertTrue(SwipeDirection.up.angleRange.contains(-Double.pi / 2))
    }
    
    // MARK: - Gesture Modifier Tests
    
    func testSwipeGestureCreation() {
        let gesture = SwipeGesture(direction: .left, minimumDistance: 50) {}
        XCTAssertNotNil(gesture)
    }
    
    func testDoubleTapGestureCreation() {
        let gesture = DoubleTapGesture {}
        XCTAssertNotNil(gesture)
    }
    
    func testTripleTapGestureCreation() {
        let gesture = TripleTapGesture {}
        XCTAssertNotNil(gesture)
    }
    
    func testCustomLongPressGestureCreation() {
        let gesture = CustomLongPressGesture(minimumDuration: 0.5, onStart: {}, onEnd: {})
        XCTAssertNotNil(gesture)
    }
    
    func testPinchGestureCreation() {
        let gesture = PinchGesture(onChanged: { _ in }, onEnded: nil)
        XCTAssertNotNil(gesture)
    }
    
    func testRotationGestureCreation() {
        let gesture = RotationGestureModifier(onChanged: { _ in }, onEnded: nil)
        XCTAssertNotNil(gesture)
    }
    
    func testPanGestureCreation() {
        let gesture = PanGesture(onChanged: { _, _ in }, onEnded: nil)
        XCTAssertNotNil(gesture)
    }
    
    // MARK: - Advanced Gesture Tests
    
    func testDraggableModifierCreation() {
        @State var position: CGPoint = .zero
        let modifier = DraggableModifier(position: $position)
        XCTAssertNotNil(modifier)
    }
    
    func testZoomableModifierCreation() {
        @State var scale: CGFloat = 1.0
        let modifier = ZoomableModifier(scale: $scale)
        XCTAssertNotNil(modifier)
    }
    
    func testZoomableModifierBounds() {
        @State var scale: CGFloat = 1.0
        let modifier = ZoomableModifier(scale: $scale, minScale: 0.5, maxScale: 4.0)
        XCTAssertNotNil(modifier)
    }
    
    func testRotatableModifierCreation() {
        @State var rotation: Angle = .zero
        let modifier = RotatableModifier(rotation: $rotation)
        XCTAssertNotNil(modifier)
    }
    
    func testRotatableModifierWithSnapAngles() {
        @State var rotation: Angle = .zero
        let snapAngles: [Angle] = [.zero, .degrees(90), .degrees(180), .degrees(270)]
        let modifier = RotatableModifier(rotation: $rotation, snapAngles: snapAngles)
        XCTAssertNotNil(modifier)
    }
    
    func testTransformableModifierCreation() {
        @State var scale: CGFloat = 1.0
        @State var rotation: Angle = .zero
        @State var offset: CGSize = .zero
        let modifier = TransformableModifier(scale: $scale, rotation: $rotation, offset: $offset)
        XCTAssertNotNil(modifier)
    }
    
    // MARK: - View Extension Tests
    
    func testViewSwipeExtension() {
        let view = Rectangle()
            .onSwipe(.left) {}
        XCTAssertNotNil(view)
    }
    
    func testViewSwipeAnyExtension() {
        let view = Rectangle()
            .onSwipeAny { _ in }
        XCTAssertNotNil(view)
    }
    
    func testViewDoubleTapExtension() {
        let view = Rectangle()
            .onDoubleTap {}
        XCTAssertNotNil(view)
    }
    
    func testViewTripleTapExtension() {
        let view = Rectangle()
            .onTripleTap {}
        XCTAssertNotNil(view)
    }
    
    func testViewLongPressExtension() {
        let view = Rectangle()
            .onLongPress(minimumDuration: 1.0, onStart: {}, onEnd: {})
        XCTAssertNotNil(view)
    }
    
    func testViewPinchExtension() {
        let view = Rectangle()
            .onPinch(onChanged: { _ in })
        XCTAssertNotNil(view)
    }
    
    func testViewRotateExtension() {
        let view = Rectangle()
            .onRotate(onChanged: { _ in })
        XCTAssertNotNil(view)
    }
    
    func testViewPanExtension() {
        let view = Rectangle()
            .onPan(onChanged: { _, _ in })
        XCTAssertNotNil(view)
    }
    
    func testViewDraggableExtension() {
        @State var position: CGPoint = .zero
        let view = Rectangle()
            .draggable(position: $position)
        XCTAssertNotNil(view)
    }
    
    func testViewZoomableExtension() {
        @State var scale: CGFloat = 1.0
        let view = Rectangle()
            .zoomable(scale: $scale)
        XCTAssertNotNil(view)
    }
    
    func testViewRotatableExtension() {
        @State var rotation: Angle = .zero
        let view = Rectangle()
            .rotatable(rotation: $rotation)
        XCTAssertNotNil(view)
    }
    
    func testViewTransformableExtension() {
        @State var scale: CGFloat = 1.0
        @State var rotation: Angle = .zero
        @State var offset: CGSize = .zero
        let view = Rectangle()
            .transformable(scale: $scale, rotation: $rotation, offset: $offset)
        XCTAssertNotNil(view)
    }
    
    // MARK: - Combined Gestures Test
    
    func testCombinedGestures() {
        let view = Rectangle()
            .onSwipe(.left) {}
            .onSwipe(.right) {}
            .onDoubleTap {}
            .onPinch(onChanged: { _ in })
        XCTAssertNotNil(view)
    }
}
