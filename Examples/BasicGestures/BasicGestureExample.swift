import SwiftUI
import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BasicGestureExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var gestureCounts: [String: Int] = [:]
    @State private var lastGesture = "No gesture detected"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Main gesture area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .green, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    VStack(spacing: 15) {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("Basic Gestures")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Try different gestures!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .customTapGesture {
                    updateGestureCount("Tap")
                    lastGesture = "Tap detected"
                    hapticManager.triggerFeedback(for: .tap)
                }
                .customDoubleTapGesture {
                    updateGestureCount("Double Tap")
                    lastGesture = "Double tap detected"
                    hapticManager.triggerFeedback(for: .tap)
                }
                .customSwipeGesture { direction in
                    updateGestureCount("Swipe")
                    lastGesture = "Swipe detected: \(direction)"
                    hapticManager.triggerFeedback(for: .swipe)
                }
                .customLongPressGesture {
                    updateGestureCount("Long Press")
                    lastGesture = "Long press detected"
                    hapticManager.triggerFeedback(for: .longPress)
                }
                
                // Last gesture display
                VStack(alignment: .leading, spacing: 10) {
                    Text("Last Gesture")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(lastGesture)
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // Gesture counts
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gesture Counts")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(Array(gestureCounts.keys.sorted()), id: \.self) { gesture in
                            HStack {
                                Text(gesture)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(gestureCounts[gesture] ?? 0)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                        }
                    }
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // Reset button
                Button("Reset Counts") {
                    gestureCounts.removeAll()
                    lastGesture = "No gesture detected"
                    hapticManager.triggerCustomFeedback(intensity: 0.6)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Basic Gestures")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func updateGestureCount(_ gesture: String) {
        gestureCounts[gesture, default: 0] += 1
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct TapGestureExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var tapCount = 0
    @State private var doubleTapCount = 0
    @State private var tripleTapCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tap Gestures")
                .font(.title)
                .fontWeight(.bold)
            
            // Single tap area
            VStack(spacing: 15) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 100)
                    .cornerRadius(10)
                    .customTapGesture {
                        tapCount += 1
                        hapticManager.triggerFeedback(for: .tap)
                    }
                    .overlay(
                        VStack {
                            Text("Single Tap")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Count: \(tapCount)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
            }
            
            // Double tap area
            VStack(spacing: 15) {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 200, height: 100)
                    .cornerRadius(10)
                    .customDoubleTapGesture {
                        doubleTapCount += 1
                        hapticManager.triggerFeedback(for: .tap)
                    }
                    .overlay(
                        VStack {
                            Text("Double Tap")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Count: \(doubleTapCount)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
            }
            
            // Triple tap area
            VStack(spacing: 15) {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 200, height: 100)
                    .cornerRadius(10)
                    .customTapGesture(
                        configuration: TapConfiguration(
                            numberOfTaps: 3,
                            minimumTapDuration: 0.1,
                            maximumTapDuration: 0.5,
                            maxTimeBetweenTaps: 0.3,
                            maxTapDistance: 10.0,
                            requireSameLocation: false
                        )
                    ) {
                        tripleTapCount += 1
                        hapticManager.triggerFeedback(for: .tap)
                    }
                    .overlay(
                        VStack {
                            Text("Triple Tap")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Count: \(tripleTapCount)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
            }
            
            Button("Reset Counts") {
                tapCount = 0
                doubleTapCount = 0
                tripleTapCount = 0
                hapticManager.triggerCustomFeedback(intensity: 0.8)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct SwipeGestureExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var swipeDirections: [SwipeDirection] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Swipe Gestures")
                .font(.title)
                .fontWeight(.bold)
            
            // Swipe area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 200)
                    .shadow(radius: 10)
                
                VStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("Swipe in any direction")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Detected: \(swipeDirections.last?.description ?? "None")")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .customSwipeGesture { direction in
                swipeDirections.append(direction)
                hapticManager.triggerFeedback(for: .swipe)
                
                // Keep only last 10 swipes
                if swipeDirections.count > 10 {
                    swipeDirections.removeFirst()
                }
            }
            
            // Swipe history
            VStack(alignment: .leading, spacing: 10) {
                Text("Swipe History")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(Array(swipeDirections.enumerated()), id: \.offset) { index, direction in
                            HStack {
                                Text("\(index + 1).")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                
                                Text(direction.description)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Image(systemName: directionIcon(for: direction))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 120)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button("Clear History") {
                swipeDirections.removeAll()
                hapticManager.triggerCustomFeedback(intensity: 0.6)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func directionIcon(for direction: SwipeDirection) -> String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        case .upLeft: return "arrow.up.left"
        case .upRight: return "arrow.up.right"
        case .downLeft: return "arrow.down.left"
        case .downRight: return "arrow.down.right"
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct LongPressGestureExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var pressDuration: TimeInterval = 0.0
    @State private var longPressCount = 0
    @State private var isPressing = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Long Press Gestures")
                .font(.title)
                .fontWeight(.bold)
            
            // Long press area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: isPressing ? [.red, .orange] : [.blue, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 250, height: 150)
                    .shadow(radius: 10)
                    .scaleEffect(isPressing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPressing)
                
                VStack {
                    Image(systemName: isPressing ? "hand.raised.fill" : "hand.raised")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text(isPressing ? "Pressing..." : "Long Press")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    if isPressing {
                        Text("Duration: \(String(format: "%.1f", pressDuration))s")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    } else {
                        Text("Count: \(longPressCount)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .customLongPressGesture(
                configuration: LongPressConfiguration(
                    minimumPressDuration: 0.5,
                    maximumPressDuration: 3.0,
                    maximumMovementDistance: 10.0,
                    enableHapticFeedback: true,
                    numberOfTouchesRequired: 1
                )
            ) {
                longPressCount += 1
                hapticManager.triggerFeedback(for: .longPress)
            }
            .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 10) {
                // This is for visual feedback only
            } onPressingChanged: { pressing in
                isPressing = pressing
                if pressing {
                    pressDuration = 0.0
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if isPressing {
                            pressDuration += 0.1
                        } else {
                            timer.invalidate()
                        }
                    }
                }
            }
            
            // Long press statistics
            VStack(alignment: .leading, spacing: 10) {
                Text("Long Press Statistics")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Total Long Presses:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(longPressCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Current Duration:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(String(format: "%.1f", pressDuration))s")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Status:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(isPressing ? "Pressing" : "Idle")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(isPressing ? .red : .gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button("Reset Count") {
                longPressCount = 0
                hapticManager.triggerCustomFeedback(intensity: 0.8)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BasicGestureExample_Previews: PreviewProvider {
    static var previews: some View {
        BasicGestureExample()
    }
} 