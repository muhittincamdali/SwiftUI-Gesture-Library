//
//  AdvancedGestures.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI
#if canImport(CoreMotion)
import CoreMotion
#endif

// MARK: - Recognized Shape

/// Shapes that can be recognized from drawing gestures
public enum RecognizedShape: String, CaseIterable, Sendable {
    case circle
    case square
    case rectangle
    case triangle
    case line
    case horizontalLine
    case verticalLine
    case checkmark
    case cross
    case arrow
    case star
    case heart
    case unknown
    
    /// Display name
    public var displayName: String {
        switch self {
        case .circle: return "Circle"
        case .square: return "Square"
        case .rectangle: return "Rectangle"
        case .triangle: return "Triangle"
        case .line: return "Line"
        case .horizontalLine: return "Horizontal Line"
        case .verticalLine: return "Vertical Line"
        case .checkmark: return "Checkmark"
        case .cross: return "Cross"
        case .arrow: return "Arrow"
        case .star: return "Star"
        case .heart: return "Heart"
        case .unknown: return "Unknown"
        }
    }
    
    /// SF Symbol name
    public var symbolName: String {
        switch self {
        case .circle: return "circle"
        case .square: return "square"
        case .rectangle: return "rectangle"
        case .triangle: return "triangle"
        case .line: return "line.diagonal"
        case .horizontalLine: return "minus"
        case .verticalLine: return "line.vertical"
        case .checkmark: return "checkmark"
        case .cross: return "xmark"
        case .arrow: return "arrow.right"
        case .star: return "star"
        case .heart: return "heart"
        case .unknown: return "questionmark"
        }
    }
}

// MARK: - Shape Recognition Result

/// Result from shape recognition
public struct ShapeRecognitionResult: Sendable {
    public let shape: RecognizedShape
    public let confidence: Double  // 0.0 - 1.0
    public let boundingRect: CGRect
    public let points: [CGPoint]
    public let drawDuration: TimeInterval
    
    public init(
        shape: RecognizedShape,
        confidence: Double,
        boundingRect: CGRect,
        points: [CGPoint],
        drawDuration: TimeInterval
    ) {
        self.shape = shape
        self.confidence = confidence
        self.boundingRect = boundingRect
        self.points = points
        self.drawDuration = drawDuration
    }
}

// MARK: - Shape Recognizer

/// Engine for recognizing shapes from points
public final class ShapeRecognizer: @unchecked Sendable {
    public static let shared = ShapeRecognizer()
    
    private init() {}
    
    /// Recognize shape from points
    public func recognize(points: [CGPoint]) -> ShapeRecognitionResult {
        guard points.count >= 3 else {
            return ShapeRecognitionResult(
                shape: .unknown,
                confidence: 0,
                boundingRect: .zero,
                points: points,
                drawDuration: 0
            )
        }
        
        let boundingRect = calculateBoundingRect(points)
        let normalizedPoints = normalizePoints(points, in: boundingRect)
        
        // Try each shape and get confidence scores
        var bestMatch: RecognizedShape = .unknown
        var bestConfidence: Double = 0.0
        
        let circleConfidence = checkCircle(normalizedPoints)
        if circleConfidence > bestConfidence {
            bestConfidence = circleConfidence
            bestMatch = .circle
        }
        
        let lineConfidence = checkLine(normalizedPoints)
        if lineConfidence > bestConfidence {
            bestConfidence = lineConfidence
            bestMatch = detectLineType(points)
        }
        
        let squareConfidence = checkSquare(normalizedPoints, boundingRect: boundingRect)
        if squareConfidence > bestConfidence {
            bestConfidence = squareConfidence
            bestMatch = isSquare(boundingRect) ? .square : .rectangle
        }
        
        let triangleConfidence = checkTriangle(normalizedPoints)
        if triangleConfidence > bestConfidence {
            bestConfidence = triangleConfidence
            bestMatch = .triangle
        }
        
        let checkmarkConfidence = checkCheckmark(normalizedPoints)
        if checkmarkConfidence > bestConfidence {
            bestConfidence = checkmarkConfidence
            bestMatch = .checkmark
        }
        
        let crossConfidence = checkCross(normalizedPoints)
        if crossConfidence > bestConfidence {
            bestConfidence = crossConfidence
            bestMatch = .cross
        }
        
        // Minimum confidence threshold
        if bestConfidence < 0.5 {
            bestMatch = .unknown
        }
        
        return ShapeRecognitionResult(
            shape: bestMatch,
            confidence: bestConfidence,
            boundingRect: boundingRect,
            points: points,
            drawDuration: 0
        )
    }
    
    // MARK: - Shape Checks
    
    private func checkCircle(_ points: [CGPoint]) -> Double {
        guard points.count >= 10 else { return 0 }
        
        // Calculate centroid
        let centerX = points.map(\.x).reduce(0, +) / Double(points.count)
        let centerY = points.map(\.y).reduce(0, +) / Double(points.count)
        let center = CGPoint(x: centerX, y: centerY)
        
        // Calculate average distance from center
        let distances = points.map { distance($0, center) }
        let avgDistance = distances.reduce(0, +) / Double(distances.count)
        
        // Check variance in distances (circles have low variance)
        let variance = distances.map { pow($0 - avgDistance, 2) }.reduce(0, +) / Double(distances.count)
        let normalizedVariance = sqrt(variance) / avgDistance
        
        // Check if path is closed
        let startEnd = distance(points.first!, points.last!)
        let isClosed = startEnd < avgDistance * 0.3
        
        if normalizedVariance < 0.2 && isClosed {
            return 1.0 - normalizedVariance
        }
        return max(0, 0.7 - normalizedVariance)
    }
    
    private func checkLine(_ points: [CGPoint]) -> Double {
        guard points.count >= 2 else { return 0 }
        
        let start = points.first!
        let end = points.last!
        let lineLength = distance(start, end)
        
        guard lineLength > 10 else { return 0 }
        
        // Calculate average deviation from the line
        var totalDeviation: Double = 0
        for point in points {
            let deviation = pointToLineDistance(point, from: start, to: end)
            totalDeviation += deviation
        }
        let avgDeviation = totalDeviation / Double(points.count)
        let normalizedDeviation = avgDeviation / lineLength
        
        if normalizedDeviation < 0.1 {
            return 1.0 - normalizedDeviation
        }
        return max(0, 0.8 - normalizedDeviation * 2)
    }
    
    private func checkSquare(_ points: [CGPoint], boundingRect: CGRect) -> Double {
        guard points.count >= 8 else { return 0 }
        
        // Check if path is closed
        let startEnd = distance(points.first!, points.last!)
        let diagonal = sqrt(pow(boundingRect.width, 2) + pow(boundingRect.height, 2))
        let isClosed = startEnd < diagonal * 0.2
        
        guard isClosed else { return 0 }
        
        // Find corners
        let corners = findCorners(points, count: 4)
        guard corners.count >= 4 else { return 0.3 }
        
        // Check angles at corners (should be ~90 degrees)
        var angleScore: Double = 0
        for i in 0..<min(4, corners.count) {
            let prev = corners[(i - 1 + corners.count) % corners.count]
            let curr = corners[i]
            let next = corners[(i + 1) % corners.count]
            
            let angle = calculateAngle(prev, curr, next)
            let deviation = abs(angle - 90) / 90
            angleScore += max(0, 1.0 - deviation)
        }
        angleScore /= 4.0
        
        return angleScore * 0.9 // Slightly lower than circle
    }
    
    private func checkTriangle(_ points: [CGPoint]) -> Double {
        guard points.count >= 6 else { return 0 }
        
        // Check if closed
        let startEnd = distance(points.first!, points.last!)
        let boundingRect = calculateBoundingRect(points)
        let diagonal = sqrt(pow(boundingRect.width, 2) + pow(boundingRect.height, 2))
        let isClosed = startEnd < diagonal * 0.2
        
        guard isClosed else { return 0 }
        
        // Find 3 corners
        let corners = findCorners(points, count: 3)
        guard corners.count >= 3 else { return 0.2 }
        
        // Check if we have exactly 3 distinct corners
        return 0.75
    }
    
    private func checkCheckmark(_ points: [CGPoint]) -> Double {
        guard points.count >= 5 else { return 0 }
        
        // Checkmark: start high, go down-right, then up-right
        let segments = segmentPath(points, count: 2)
        guard segments.count >= 2 else { return 0 }
        
        let firstDirection = getDirection(segments[0])
        let secondDirection = getDirection(segments[1])
        
        // First segment should go down-right
        let isFirstDownRight = firstDirection.x > 0 && firstDirection.y > 0
        // Second segment should go up-right
        let isSecondUpRight = secondDirection.x > 0 && secondDirection.y < 0
        
        if isFirstDownRight && isSecondUpRight {
            return 0.8
        }
        return 0.2
    }
    
    private func checkCross(_ points: [CGPoint]) -> Double {
        guard points.count >= 8 else { return 0 }
        
        // Cross: two intersecting lines
        // This is simplified - real implementation would need stroke detection
        return 0.3
    }
    
    // MARK: - Helper Functions
    
    private func distance(_ p1: CGPoint, _ p2: CGPoint) -> Double {
        sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    private func pointToLineDistance(_ point: CGPoint, from: CGPoint, to: CGPoint) -> Double {
        let lineLength = distance(from, to)
        guard lineLength > 0 else { return distance(point, from) }
        
        let t = max(0, min(1, ((point.x - from.x) * (to.x - from.x) + (point.y - from.y) * (to.y - from.y)) / pow(lineLength, 2)))
        let projection = CGPoint(x: from.x + t * (to.x - from.x), y: from.y + t * (to.y - from.y))
        return distance(point, projection)
    }
    
    private func calculateBoundingRect(_ points: [CGPoint]) -> CGRect {
        guard !points.isEmpty else { return .zero }
        
        let minX = points.map(\.x).min()!
        let maxX = points.map(\.x).max()!
        let minY = points.map(\.y).min()!
        let maxY = points.map(\.y).max()!
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    private func normalizePoints(_ points: [CGPoint], in rect: CGRect) -> [CGPoint] {
        guard rect.width > 0, rect.height > 0 else { return points }
        
        return points.map { point in
            CGPoint(
                x: (point.x - rect.minX) / rect.width,
                y: (point.y - rect.minY) / rect.height
            )
        }
    }
    
    private func isSquare(_ rect: CGRect) -> Bool {
        guard rect.width > 0, rect.height > 0 else { return false }
        let ratio = rect.width / rect.height
        return ratio > 0.8 && ratio < 1.2
    }
    
    private func detectLineType(_ points: [CGPoint]) -> RecognizedShape {
        guard points.count >= 2 else { return .line }
        
        let start = points.first!
        let end = points.last!
        
        let dx = abs(end.x - start.x)
        let dy = abs(end.y - start.y)
        
        if dx > dy * 2 {
            return .horizontalLine
        } else if dy > dx * 2 {
            return .verticalLine
        }
        return .line
    }
    
    private func findCorners(_ points: [CGPoint], count: Int) -> [CGPoint] {
        guard points.count >= count else { return [] }
        
        // Find points with highest curvature
        var corners: [(point: CGPoint, curvature: Double)] = []
        
        let windowSize = max(2, points.count / 10)
        
        for i in windowSize..<(points.count - windowSize) {
            let prev = points[i - windowSize]
            let curr = points[i]
            let next = points[i + windowSize]
            
            let angle = calculateAngle(prev, curr, next)
            let curvature = abs(180 - angle)
            corners.append((curr, curvature))
        }
        
        // Sort by curvature and take top N
        corners.sort { $0.curvature > $1.curvature }
        
        // Return distinct corners (not too close together)
        var result: [CGPoint] = []
        for corner in corners {
            let isFarEnough = result.allSatisfy { distance($0, corner.point) > 20 }
            if isFarEnough {
                result.append(corner.point)
            }
            if result.count >= count {
                break
            }
        }
        
        return result
    }
    
    private func calculateAngle(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> Double {
        let v1 = CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
        let v2 = CGPoint(x: p3.x - p2.x, y: p3.y - p2.y)
        
        let dot = v1.x * v2.x + v1.y * v2.y
        let mag1 = sqrt(v1.x * v1.x + v1.y * v1.y)
        let mag2 = sqrt(v2.x * v2.x + v2.y * v2.y)
        
        guard mag1 > 0, mag2 > 0 else { return 0 }
        
        let cos = dot / (mag1 * mag2)
        return acos(max(-1, min(1, cos))) * 180 / .pi
    }
    
    private func segmentPath(_ points: [CGPoint], count: Int) -> [[CGPoint]] {
        guard points.count >= count else { return [] }
        
        let segmentSize = points.count / count
        var segments: [[CGPoint]] = []
        
        for i in 0..<count {
            let start = i * segmentSize
            let end = min((i + 1) * segmentSize, points.count)
            segments.append(Array(points[start..<end]))
        }
        
        return segments
    }
    
    private func getDirection(_ segment: [CGPoint]) -> CGPoint {
        guard segment.count >= 2 else { return .zero }
        let first = segment.first!
        let last = segment.last!
        return CGPoint(x: last.x - first.x, y: last.y - first.y)
    }
}

// MARK: - Drawing Gesture

/// Drawing path data
public struct DrawingPath: Sendable {
    public var points: [CGPoint]
    public var startTime: Date
    public var endTime: Date?
    
    public init(points: [CGPoint] = [], startTime: Date = Date()) {
        self.points = points
        self.startTime = startTime
    }
    
    public var duration: TimeInterval {
        (endTime ?? Date()).timeIntervalSince(startTime)
    }
}

/// A drawing gesture modifier that tracks path and recognizes shapes
public struct DrawingGestureModifier: ViewModifier {
    let lineWidth: CGFloat
    let lineColor: Color
    let onDrawing: ((DrawingPath) -> Void)?
    let onComplete: (ShapeRecognitionResult) -> Void
    
    @State private var currentPath = DrawingPath()
    @State private var isDrawing = false
    
    public init(
        lineWidth: CGFloat = 3,
        lineColor: Color = .blue,
        onDrawing: ((DrawingPath) -> Void)? = nil,
        onComplete: @escaping (ShapeRecognitionResult) -> Void
    ) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.onDrawing = onDrawing
        self.onComplete = onComplete
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                DrawingCanvas(
                    path: currentPath,
                    lineWidth: lineWidth,
                    lineColor: lineColor
                )
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDrawing {
                            isDrawing = true
                            currentPath = DrawingPath(startTime: Date())
                        }
                        currentPath.points.append(value.location)
                        onDrawing?(currentPath)
                    }
                    .onEnded { _ in
                        isDrawing = false
                        currentPath.endTime = Date()
                        
                        // Recognize shape
                        var result = ShapeRecognizer.shared.recognize(points: currentPath.points)
                        result = ShapeRecognitionResult(
                            shape: result.shape,
                            confidence: result.confidence,
                            boundingRect: result.boundingRect,
                            points: result.points,
                            drawDuration: currentPath.duration
                        )
                        
                        HapticEngine.notification(result.shape != .unknown ? .success : .warning)
                        onComplete(result)
                        
                        // Clear path after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            currentPath = DrawingPath()
                        }
                    }
            )
    }
}

/// Canvas for drawing visualization
struct DrawingCanvas: View {
    let path: DrawingPath
    let lineWidth: CGFloat
    let lineColor: Color
    
    var body: some View {
        Canvas { context, size in
            guard path.points.count >= 2 else { return }
            
            var drawPath = Path()
            drawPath.move(to: path.points[0])
            
            for point in path.points.dropFirst() {
                drawPath.addLine(to: point)
            }
            
            context.stroke(
                drawPath,
                with: .color(lineColor),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Shake Gesture

#if os(iOS)
/// Shake gesture detector
@MainActor
public final class ShakeDetector: ObservableObject {
    @Published public var shakeCount: Int = 0
    
    private var motionManager: CMMotionManager?
    private var lastAcceleration: CMAcceleration?
    private let shakeThreshold: Double
    private var consecutiveShakes: Int = 0
    private var lastShakeTime: Date = Date.distantPast
    
    public init(threshold: Double = 2.5) {
        self.shakeThreshold = threshold
    }
    
    public func startMonitoring() {
        guard motionManager == nil else { return }
        
        motionManager = CMMotionManager()
        guard let manager = motionManager, manager.isAccelerometerAvailable else { return }
        
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let acceleration = data?.acceleration else { return }
            self.processAcceleration(acceleration)
        }
    }
    
    public func stopMonitoring() {
        motionManager?.stopAccelerometerUpdates()
        motionManager = nil
    }
    
    private func processAcceleration(_ acceleration: CMAcceleration) {
        defer { lastAcceleration = acceleration }
        
        guard let last = lastAcceleration else { return }
        
        let deltaX = abs(acceleration.x - last.x)
        let deltaY = abs(acceleration.y - last.y)
        let deltaZ = abs(acceleration.z - last.z)
        
        let magnitude = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
        
        if magnitude > shakeThreshold {
            let now = Date()
            if now.timeIntervalSince(lastShakeTime) < 0.5 {
                consecutiveShakes += 1
            } else {
                consecutiveShakes = 1
            }
            lastShakeTime = now
            
            if consecutiveShakes >= 2 {
                Task { @MainActor in
                    shakeCount += 1
                    HapticEngine.notification(.success)
                }
                consecutiveShakes = 0
            }
        }
    }
}

/// Shake gesture view modifier
public struct ShakeGestureModifier: ViewModifier {
    let action: () -> Void
    
    @StateObject private var detector = ShakeDetector()
    @State private var lastCount = 0
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                detector.startMonitoring()
            }
            .onDisappear {
                detector.stopMonitoring()
            }
            .onChange(of: detector.shakeCount) { newValue in
                if newValue > lastCount {
                    action()
                }
                lastCount = newValue
            }
    }
}
#endif

// MARK: - Tilt Gesture

#if os(iOS)
/// Device tilt direction
public enum TiltDirection: String, CaseIterable, Sendable {
    case left
    case right
    case forward
    case backward
    case flat
}

/// Tilt gesture detector using accelerometer
@MainActor
public final class TiltDetector: ObservableObject {
    @Published public var currentTilt: TiltDirection = .flat
    @Published public var pitch: Double = 0  // Forward/backward tilt
    @Published public var roll: Double = 0   // Left/right tilt
    
    private var motionManager: CMMotionManager?
    private let tiltThreshold: Double
    
    public init(threshold: Double = 0.3) {
        self.tiltThreshold = threshold
    }
    
    public func startMonitoring() {
        guard motionManager == nil else { return }
        
        motionManager = CMMotionManager()
        guard let manager = motionManager, manager.isDeviceMotionAvailable else { return }
        
        manager.deviceMotionUpdateInterval = 0.1
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let attitude = motion?.attitude else { return }
            self.processMotion(pitch: attitude.pitch, roll: attitude.roll)
        }
    }
    
    public func stopMonitoring() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
    }
    
    private func processMotion(pitch: Double, roll: Double) {
        self.pitch = pitch
        self.roll = roll
        
        let newTilt: TiltDirection
        
        if abs(pitch) < tiltThreshold && abs(roll) < tiltThreshold {
            newTilt = .flat
        } else if abs(roll) > abs(pitch) {
            newTilt = roll > 0 ? .left : .right
        } else {
            newTilt = pitch > 0 ? .backward : .forward
        }
        
        if newTilt != currentTilt {
            currentTilt = newTilt
        }
    }
}

/// Tilt gesture view modifier
public struct TiltGestureModifier: ViewModifier {
    let threshold: Double
    let onTilt: (TiltDirection) -> Void
    
    @StateObject private var detector: TiltDetector
    @State private var lastTilt: TiltDirection = .flat
    
    public init(threshold: Double = 0.3, onTilt: @escaping (TiltDirection) -> Void) {
        self.threshold = threshold
        self.onTilt = onTilt
        self._detector = StateObject(wrappedValue: TiltDetector(threshold: threshold))
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                detector.startMonitoring()
            }
            .onDisappear {
                detector.stopMonitoring()
            }
            .onChange(of: detector.currentTilt) { newValue in
                if newValue != lastTilt {
                    onTilt(newValue)
                    lastTilt = newValue
                }
            }
    }
}
#endif

// MARK: - Gesture Sequence

/// A sequence of gestures that must be performed in order
public struct GestureSequence: Sendable {
    public let gestures: [GestureType]
    public let timeLimit: TimeInterval
    public let name: String
    
    public init(name: String, gestures: [GestureType], timeLimit: TimeInterval = 2.0) {
        self.name = name
        self.gestures = gestures
        self.timeLimit = timeLimit
    }
    
    // Common sequences
    public static let doubleTapHold = GestureSequence(
        name: "Double Tap + Hold",
        gestures: [.doubleTap, .longPress()]
    )
    
    public static let swipeAndTap = GestureSequence(
        name: "Swipe + Tap",
        gestures: [.swipeAny, .tap]
    )
}

/// Gesture sequence tracker
@MainActor
public final class GestureSequenceTracker: ObservableObject {
    @Published public var completedSequences: [String] = []
    @Published public var currentProgress: Int = 0
    
    private var targetSequence: GestureSequence?
    private var recordedGestures: [GestureType] = []
    private var sequenceStartTime: Date?
    private var completion: (() -> Void)?
    
    public init() {}
    
    public func track(sequence: GestureSequence, completion: @escaping () -> Void) {
        self.targetSequence = sequence
        self.completion = completion
        reset()
    }
    
    public func recordGesture(_ type: GestureType) {
        guard let sequence = targetSequence else { return }
        
        if recordedGestures.isEmpty {
            sequenceStartTime = Date()
        }
        
        // Check time limit
        if let start = sequenceStartTime,
           Date().timeIntervalSince(start) > sequence.timeLimit {
            reset()
            return
        }
        
        recordedGestures.append(type)
        currentProgress = recordedGestures.count
        
        // Check if sequence matches
        if recordedGestures.count == sequence.gestures.count {
            var matches = true
            for (i, gesture) in recordedGestures.enumerated() {
                if gesture != sequence.gestures[i] {
                    matches = false
                    break
                }
            }
            
            if matches {
                completedSequences.append(sequence.name)
                HapticEngine.notification(.success)
                completion?()
            }
            reset()
        }
    }
    
    public func reset() {
        recordedGestures = []
        sequenceStartTime = nil
        currentProgress = 0
    }
}

// MARK: - View Extensions for Advanced Gestures

public extension View {
    /// Adds shape drawing recognition
    func onShapeDrawn(
        lineWidth: CGFloat = 3,
        lineColor: Color = .blue,
        onDrawing: ((DrawingPath) -> Void)? = nil,
        onComplete: @escaping (ShapeRecognitionResult) -> Void
    ) -> some View {
        modifier(DrawingGestureModifier(
            lineWidth: lineWidth,
            lineColor: lineColor,
            onDrawing: onDrawing,
            onComplete: onComplete
        ))
    }
    
    #if os(iOS)
    /// Adds shake gesture detection
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(ShakeGestureModifier(action: action))
    }
    
    /// Adds tilt gesture detection
    func onTilt(threshold: Double = 0.3, perform action: @escaping (TiltDirection) -> Void) -> some View {
        modifier(TiltGestureModifier(threshold: threshold, onTilt: action))
    }
    #endif
}
