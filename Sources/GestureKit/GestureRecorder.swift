//
//  GestureRecorder.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

// MARK: - Recorded Gesture Point

/// A single point in a recorded gesture
public struct RecordedPoint: Codable, Sendable {
    public let x: Double
    public let y: Double
    public let timestamp: TimeInterval
    
    public init(point: CGPoint, timestamp: TimeInterval) {
        self.x = point.x
        self.y = point.y
        self.timestamp = timestamp
    }
    
    public var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

// MARK: - Recorded Gesture

/// A complete recorded gesture
public struct RecordedGesture: Codable, Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let points: [RecordedPoint]
    public let recordedAt: Date
    public let duration: TimeInterval
    public let gestureType: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        points: [RecordedPoint],
        recordedAt: Date = Date(),
        gestureType: String = "custom"
    ) {
        self.id = id
        self.name = name
        self.points = points
        self.recordedAt = recordedAt
        self.duration = points.last?.timestamp ?? 0
        self.gestureType = gestureType
    }
    
    /// Bounding rectangle of the gesture
    public var boundingRect: CGRect {
        guard !points.isEmpty else { return .zero }
        
        let xs = points.map(\.x)
        let ys = points.map(\.y)
        
        let minX = xs.min()!
        let maxX = xs.max()!
        let minY = ys.min()!
        let maxY = ys.max()!
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    /// Normalize to fit within given bounds
    public func normalized(to bounds: CGRect) -> RecordedGesture {
        let original = boundingRect
        guard original.width > 0, original.height > 0 else { return self }
        
        let scaleX = bounds.width / original.width
        let scaleY = bounds.height / original.height
        let scale = min(scaleX, scaleY)
        
        let offsetX = bounds.minX + (bounds.width - original.width * scale) / 2
        let offsetY = bounds.minY + (bounds.height - original.height * scale) / 2
        
        let normalizedPoints = points.map { point in
            RecordedPoint(
                point: CGPoint(
                    x: (point.x - original.minX) * scale + offsetX,
                    y: (point.y - original.minY) * scale + offsetY
                ),
                timestamp: point.timestamp
            )
        }
        
        return RecordedGesture(
            id: id,
            name: name,
            points: normalizedPoints,
            recordedAt: recordedAt,
            gestureType: gestureType
        )
    }
}

// MARK: - Gesture Recorder

/// Records gesture input for later playback
@MainActor
public final class GestureRecorder: ObservableObject {
    @Published public private(set) var isRecording = false
    @Published public private(set) var recordings: [RecordedGesture] = []
    @Published public private(set) var currentPoints: [RecordedPoint] = []
    
    private var recordingStartTime: Date?
    private let storageKey = "GestureKit.Recordings"
    
    public init() {
        loadRecordings()
    }
    
    // MARK: - Recording
    
    public func startRecording() {
        guard !isRecording else { return }
        
        isRecording = true
        currentPoints = []
        recordingStartTime = Date()
        
        HapticEngine.impact(.light)
    }
    
    public func recordPoint(_ point: CGPoint) {
        guard isRecording, let startTime = recordingStartTime else { return }
        
        let timestamp = Date().timeIntervalSince(startTime)
        let recordedPoint = RecordedPoint(point: point, timestamp: timestamp)
        currentPoints.append(recordedPoint)
    }
    
    public func stopRecording(name: String) -> RecordedGesture? {
        guard isRecording else { return nil }
        
        isRecording = false
        
        guard currentPoints.count >= 2 else {
            currentPoints = []
            return nil
        }
        
        let recording = RecordedGesture(
            name: name,
            points: currentPoints,
            gestureType: "recorded"
        )
        
        recordings.append(recording)
        saveRecordings()
        
        HapticEngine.notification(.success)
        
        currentPoints = []
        recordingStartTime = nil
        
        return recording
    }
    
    public func cancelRecording() {
        isRecording = false
        currentPoints = []
        recordingStartTime = nil
    }
    
    // MARK: - Management
    
    public func deleteRecording(_ recording: RecordedGesture) {
        recordings.removeAll { $0.id == recording.id }
        saveRecordings()
    }
    
    public func deleteRecording(at index: Int) {
        guard recordings.indices.contains(index) else { return }
        recordings.remove(at: index)
        saveRecordings()
    }
    
    public func clearAll() {
        recordings.removeAll()
        saveRecordings()
    }
    
    // MARK: - Persistence
    
    private func saveRecordings() {
        guard let data = try? JSONEncoder().encode(recordings) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
    
    private func loadRecordings() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([RecordedGesture].self, from: data) else {
            return
        }
        recordings = saved
    }
    
    // MARK: - Export/Import
    
    public func exportRecording(_ recording: RecordedGesture) -> Data? {
        try? JSONEncoder().encode(recording)
    }
    
    public func importRecording(from data: Data) -> RecordedGesture? {
        guard let recording = try? JSONDecoder().decode(RecordedGesture.self, from: data) else {
            return nil
        }
        recordings.append(recording)
        saveRecordings()
        return recording
    }
}

// MARK: - Gesture Player

/// Plays back recorded gestures
@MainActor
public final class GesturePlayer: ObservableObject {
    @Published public private(set) var isPlaying = false
    @Published public private(set) var currentPointIndex = 0
    @Published public private(set) var currentPoint: CGPoint?
    
    private var playbackTask: Task<Void, Never>?
    private var currentRecording: RecordedGesture?
    private var speedMultiplier: Double = 1.0
    
    public init() {}
    
    // MARK: - Playback
    
    public func play(
        _ recording: RecordedGesture,
        speed: Double = 1.0,
        onPoint: ((CGPoint, Int) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        guard !isPlaying else { return }
        guard !recording.points.isEmpty else { return }
        
        isPlaying = true
        currentRecording = recording
        currentPointIndex = 0
        speedMultiplier = max(0.1, speed)
        
        HapticEngine.impact(.light)
        
        playbackTask = Task { @MainActor in
            var lastTimestamp: TimeInterval = 0
            
            for (index, point) in recording.points.enumerated() {
                guard !Task.isCancelled else { break }
                
                // Calculate delay
                let delay = (point.timestamp - lastTimestamp) / speedMultiplier
                if delay > 0 {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
                
                guard !Task.isCancelled else { break }
                
                currentPointIndex = index
                currentPoint = point.cgPoint
                onPoint?(point.cgPoint, index)
                
                lastTimestamp = point.timestamp
            }
            
            isPlaying = false
            currentPoint = nil
            completion?()
        }
    }
    
    public func stop() {
        playbackTask?.cancel()
        playbackTask = nil
        isPlaying = false
        currentPoint = nil
        currentPointIndex = 0
    }
    
    public func pause() {
        // Simplified pause - just stops
        stop()
    }
    
    // MARK: - Properties
    
    public var progress: Double {
        guard let recording = currentRecording, !recording.points.isEmpty else { return 0 }
        return Double(currentPointIndex) / Double(recording.points.count - 1)
    }
}

// MARK: - Recording View Modifier

/// View modifier for recording gestures
public struct GestureRecordingModifier: ViewModifier {
    @ObservedObject var recorder: GestureRecorder
    let showIndicator: Bool
    
    public init(recorder: GestureRecorder, showIndicator: Bool = true) {
        self.recorder = recorder
        self.showIndicator = showIndicator
    }
    
    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if recorder.isRecording {
                            recorder.recordPoint(value.location)
                        }
                    }
            )
            .overlay(
                Group {
                    if showIndicator && recorder.isRecording {
                        recordingIndicator
                    }
                }
            )
    }
    
    private var recordingIndicator: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.red.opacity(0.5), lineWidth: 4)
                            .scaleEffect(1.5)
                            .opacity(0.5)
                    )
                
                Text("Recording...")
                    .font(.caption.bold())
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .shadow(radius: 4)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Playback View Modifier

/// View modifier for gesture playback visualization
public struct GesturePlaybackModifier: ViewModifier {
    @ObservedObject var player: GesturePlayer
    let recording: RecordedGesture
    let pointColor: Color
    let pathColor: Color
    let pointSize: CGFloat
    
    @State private var playedPoints: [CGPoint] = []
    
    public init(
        player: GesturePlayer,
        recording: RecordedGesture,
        pointColor: Color = .blue,
        pathColor: Color = .blue.opacity(0.5),
        pointSize: CGFloat = 20
    ) {
        self.player = player
        self.recording = recording
        self.pointColor = pointColor
        self.pathColor = pathColor
        self.pointSize = pointSize
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    // Path trail
                    if !playedPoints.isEmpty {
                        Path { path in
                            path.move(to: playedPoints[0])
                            for point in playedPoints.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(pathColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    }
                    
                    // Current point
                    if let point = player.currentPoint {
                        Circle()
                            .fill(pointColor)
                            .frame(width: pointSize, height: pointSize)
                            .position(point)
                            .transition(.scale)
                    }
                }
            )
            .onChange(of: player.currentPoint) { newPoint in
                if let point = newPoint {
                    playedPoints.append(point)
                }
            }
            .onChange(of: player.isPlaying) { isPlaying in
                if !isPlaying {
                    // Clear after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        playedPoints = []
                    }
                }
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Enables gesture recording on this view
    func gestureRecording(
        recorder: GestureRecorder,
        showIndicator: Bool = true
    ) -> some View {
        modifier(GestureRecordingModifier(recorder: recorder, showIndicator: showIndicator))
    }
    
    /// Shows gesture playback visualization
    func gesturePlayback(
        player: GesturePlayer,
        recording: RecordedGesture,
        pointColor: Color = .blue,
        pathColor: Color = .blue.opacity(0.5),
        pointSize: CGFloat = 20
    ) -> some View {
        modifier(GesturePlaybackModifier(
            player: player,
            recording: recording,
            pointColor: pointColor,
            pathColor: pathColor,
            pointSize: pointSize
        ))
    }
}
