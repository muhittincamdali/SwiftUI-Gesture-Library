//
//  BasicExample.swift
//  GestureKit Examples
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI
import GestureKit

// MARK: - Photo Gallery Example

/// Photo viewer with gestures
struct PhotoGalleryExample: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var offset: CGSize = .zero
    @State private var currentIndex = 0
    
    let photos = ["photo1", "photo2", "photo3", "photo4"]
    
    var body: some View {
        VStack {
            Text("Photo \(currentIndex + 1) of \(photos.count)")
                .font(.headline)
            
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .scaleEffect(scale)
                .rotationEffect(rotation)
                .offset(offset)
                // Swipe to navigate
                .onSwipe(.left) {
                    withAnimation { currentIndex = min(currentIndex + 1, photos.count - 1) }
                }
                .onSwipe(.right) {
                    withAnimation { currentIndex = max(currentIndex - 1, 0) }
                }
                // Double tap to reset
                .onDoubleTap {
                    withAnimation(.spring()) {
                        scale = 1.0
                        rotation = .zero
                        offset = .zero
                    }
                }
                // Pinch to zoom
                .onPinch(
                    onChanged: { scale = $0 },
                    onEnded: { _ in }
                )
                // Rotate
                .onRotate(
                    onChanged: { rotation = $0 },
                    onEnded: { _ in }
                )
            
            // Page indicators
            HStack {
                ForEach(0..<photos.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding()
        }
    }
}

// MARK: - Interactive Card Example

/// Card with interactive gestures
struct InteractiveCardExample: View {
    @State private var isPressed = false
    @State private var bounce = false
    @State private var cardOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Interactive Card")
                .font(.title2.bold())
            
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 280, height: 180)
                .overlay(
                    VStack {
                        Image(systemName: "creditcard.fill")
                            .font(.largeTitle)
                        Text("Tap, swipe, or long press")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                )
                .shadow(radius: isPressed ? 5 : 15)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .offset(cardOffset)
                .animation(.spring(), value: isPressed)
                .animation(.spring(), value: cardOffset)
                // Interactive press state
                .interactiveGesture(isActive: $isPressed)
                // Bounce on double tap
                .bounceAnimation(trigger: $bounce)
                .onDoubleTap { bounce = true }
                // Swipe to dismiss
                .onSwipeAny { direction in
                    let offset: CGSize
                    switch direction {
                    case .left: offset = CGSize(width: -300, height: 0)
                    case .right: offset = CGSize(width: 300, height: 0)
                    case .up: offset = CGSize(width: 0, height: -300)
                    case .down: offset = CGSize(width: 0, height: 300)
                    }
                    
                    withAnimation(.spring()) {
                        cardOffset = offset
                    }
                    
                    // Reset after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            cardOffset = .zero
                        }
                    }
                }
                // Long press for haptic
                .onLongPress(
                    minimumDuration: 0.5,
                    onStart: { isPressed = true },
                    onComplete: { isPressed = false }
                )
        }
    }
}

// MARK: - Shape Drawing Example

/// Draw shapes and see recognition results
struct ShapeDrawingExample: View {
    @State private var recognizedShape: RecognizedShape = .unknown
    @State private var confidence: Double = 0
    @State private var isDrawing = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Draw a Shape")
                .font(.title2.bold())
            
            Text("Try: circle, square, triangle, line")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 300)
                
                if !isDrawing && recognizedShape != .unknown {
                    VStack {
                        Image(systemName: recognizedShape.symbolName)
                            .font(.system(size: 60))
                        Text(recognizedShape.displayName)
                            .font(.headline)
                        Text("\(Int(confidence * 100))% confidence")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .onShapeDrawn(
                lineWidth: 4,
                lineColor: .blue,
                onDrawing: { _ in
                    isDrawing = true
                    recognizedShape = .unknown
                },
                onComplete: { result in
                    isDrawing = false
                    withAnimation(.spring()) {
                        recognizedShape = result.shape
                        confidence = result.confidence
                    }
                }
            )
            
            Button("Clear") {
                withAnimation {
                    recognizedShape = .unknown
                    confidence = 0
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Gesture Recording Example

/// Record and playback gestures
struct GestureRecordingExample: View {
    @StateObject private var recorder = GestureRecorder()
    @StateObject private var player = GesturePlayer()
    @State private var selectedRecording: RecordedGesture?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Gesture Recording")
                .font(.title2.bold())
            
            // Canvas
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 300)
                
                if let recording = selectedRecording {
                    Path { path in
                        guard !recording.points.isEmpty else { return }
                        path.move(to: recording.points[0].cgPoint)
                        for point in recording.points.dropFirst() {
                            path.addLine(to: point.cgPoint)
                        }
                    }
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                }
                
                if let current = player.currentPoint {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .position(current)
                }
            }
            .gestureRecording(recorder: recorder)
            
            // Controls
            HStack(spacing: 12) {
                Button(recorder.isRecording ? "Stop" : "Record") {
                    if recorder.isRecording {
                        if let recording = recorder.stopRecording(name: "Gesture \(recorder.recordings.count + 1)") {
                            selectedRecording = recording
                        }
                    } else {
                        recorder.startRecording()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(recorder.isRecording ? .red : .blue)
                
                Button("Play") {
                    guard let recording = selectedRecording else { return }
                    player.play(recording, speed: 1.0)
                }
                .buttonStyle(.bordered)
                .disabled(selectedRecording == nil || player.isPlaying)
                
                Button("Clear") {
                    recorder.clearAll()
                    selectedRecording = nil
                }
                .buttonStyle(.bordered)
            }
            
            // Recordings list
            if !recorder.recordings.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(recorder.recordings) { recording in
                            Button(recording.name) {
                                selectedRecording = recording
                            }
                            .buttonStyle(.bordered)
                            .tint(selectedRecording?.id == recording.id ? .blue : .gray)
                        }
                    }
                }
                .frame(height: 44)
            }
        }
    }
}

// MARK: - Motion Gestures Example (iOS)

#if os(iOS)
/// Shake and tilt detection
struct MotionGesturesExample: View {
    @State private var shakeCount = 0
    @State private var currentTilt: TiltDirection = .flat
    @State private var showShakeAnimation = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Motion Gestures")
                .font(.title2.bold())
            
            // Shake detector
            VStack {
                Text("Shake Count: \(shakeCount)")
                    .font(.headline)
                
                Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .shakeAnimation(trigger: $showShakeAnimation, intensity: 15)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .onShake {
                shakeCount += 1
                showShakeAnimation = true
            }
            
            // Tilt detector
            VStack {
                Text("Tilt: \(currentTilt.rawValue)")
                    .font(.headline)
                
                Image(systemName: tiltIcon)
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .rotationEffect(tiltRotation)
                    .animation(.spring(), value: currentTilt)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .onTilt { direction in
                currentTilt = direction
            }
        }
    }
    
    private var tiltIcon: String {
        switch currentTilt {
        case .left, .right: return "iphone.gen3.landscape"
        case .forward, .backward: return "iphone.gen3"
        case .flat: return "iphone.gen3"
        }
    }
    
    private var tiltRotation: Angle {
        switch currentTilt {
        case .left: return .degrees(-30)
        case .right: return .degrees(30)
        default: return .zero
        }
    }
}
#endif

// MARK: - Animation Showcase

/// All gesture animations
struct AnimationShowcaseExample: View {
    @State private var triggers: [GestureAnimationPreset: Bool] = [:]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Animation Showcase")
                .font(.title2.bold())
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(GestureAnimationPreset.allCases, id: \.self) { preset in
                    AnimationButton(preset: preset, trigger: binding(for: preset))
                }
            }
            .padding()
        }
    }
    
    private func binding(for preset: GestureAnimationPreset) -> Binding<Bool> {
        Binding(
            get: { triggers[preset] ?? false },
            set: { triggers[preset] = $0 }
        )
    }
}

struct AnimationButton: View {
    let preset: GestureAnimationPreset
    @Binding var trigger: Bool
    
    var body: some View {
        Button {
            trigger = true
        } label: {
            VStack {
                Image(systemName: iconName)
                    .font(.title2)
                Text(preset.rawValue)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .gestureAnimation(preset, trigger: $trigger)
    }
    
    private var iconName: String {
        switch preset {
        case .bounce: return "arrow.up.arrow.down"
        case .scale: return "arrow.up.left.and.arrow.down.right"
        case .shake: return "arrow.left.arrow.right"
        case .pulse: return "heart.fill"
        case .rotate: return "arrow.clockwise"
        case .slide: return "arrow.right"
        case .fade: return "circle.dotted"
        case .glow: return "sun.max.fill"
        case .wiggle: return "waveform"
        case .rubber: return "rectangle.compress.vertical"
        case .flip: return "arrow.triangle.2.circlepath"
        case .swing: return "metronome"
        }
    }
}

// MARK: - Accessible Gestures Example

/// Gestures with accessibility support
struct AccessibleGesturesExample: View {
    @State private var message = "Try the gestures"
    @State private var showAnimation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Accessible Gestures")
                .font(.title2.bold())
            
            Text(message)
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .bounceAnimation(trigger: $showAnimation)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 280, height: 180)
                .overlay(
                    VStack {
                        Image(systemName: "hand.tap.fill")
                            .font(.largeTitle)
                        Text("Accessible gesture area")
                            .font(.caption)
                    }
                )
                .accessibleSwipe(.left, label: "Go back") {
                    message = "Swiped left (Go back)"
                    showAnimation = true
                }
                .accessibleSwipe(.right, label: "Go forward") {
                    message = "Swiped right (Go forward)"
                    showAnimation = true
                }
                .accessibleDoubleTap(label: "Activate") {
                    message = "Double tapped (Activated)"
                    showAnimation = true
                }
                .accessibleLongPress(label: "Show options") {
                    message = "Long pressed (Options)"
                    showAnimation = true
                }
            
            Text("• VoiceOver users can use the rotor menu\n• Context menu available on long press")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Debug Example

/// Debugger overlay demonstration
struct DebugExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Gesture Debugger")
                .font(.title2.bold())
            
            Text("Touch anywhere to see debug info")
                .font(.caption)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: 400)
                .gestureDebug(name: "TestArea")
                .onSwipe(.left) { }
                .onSwipe(.right) { }
                .onDoubleTap { }
        }
        .enableGestureDebug(true)
        .gestureDebuggerOverlay(
            position: .bottomTrailing,
            showTouches: true
        )
    }
}

// MARK: - Preview Provider

#Preview("Photo Gallery") {
    PhotoGalleryExample()
}

#Preview("Interactive Card") {
    InteractiveCardExample()
}

#Preview("Shape Drawing") {
    ShapeDrawingExample()
}

#Preview("Gesture Recording") {
    GestureRecordingExample()
}

#Preview("Animation Showcase") {
    AnimationShowcaseExample()
}

#Preview("Accessible Gestures") {
    AccessibleGesturesExample()
}

#Preview("Debug") {
    DebugExample()
}
