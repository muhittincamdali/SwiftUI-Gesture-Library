import SwiftUI
import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AdvancedGestureExample: View {
    @StateObject private var gestureEngine = GestureEngine(
        configuration: GestureConfiguration(
            enableHapticFeedback: true,
            enablePerformanceMonitoring: true,
            maxConcurrentGestures: 3,
            recognitionTimeout: 2.0
        )
    )
    
    @StateObject private var hapticManager = HapticFeedbackManager()
    
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    @State private var isZoomed = false
    @State private var gestureHistory: [String] = []
    @State private var performanceMetrics: PerformanceMetrics?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Main interactive area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .scaleEffect(scale)
                        .rotationEffect(.radians(rotation))
                        .offset(offset)
                        .shadow(radius: 10)
                    
                    VStack {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("Advanced Gestures")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Try different gestures!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .customPinchGesture { newScale in
                    scale = newScale
                    isZoomed = newScale > 1.0
                    addToHistory("Pinch: \(String(format: "%.2f", newScale))")
                    hapticManager.triggerFeedback(for: .pinch)
                }
                .customRotationGesture(
                    onRotationChanged: { angle in
                        rotation = angle
                        addToHistory("Rotation: \(String(format: "%.1f", angle * 180 / .pi))°")
                    },
                    onRotationEnded: { finalAngle in
                        rotation = finalAngle
                        addToHistory("Rotation ended: \(String(format: "%.1f", finalAngle * 180 / .pi))°")
                        hapticManager.triggerFeedback(for: .rotation)
                    }
                )
                .customPanGesture(
                    onPanChanged: { translation in
                        if isZoomed {
                            offset = translation
                            addToHistory("Pan: \(String(format: "%.1f", translation.width)), \(String(format: "%.1f", translation.height))")
                        }
                    },
                    onPanEnded: { translation, velocity in
                        if isZoomed {
                            offset = translation
                            addToHistory("Pan ended with velocity: \(String(format: "%.1f", velocity.magnitude))")
                        }
                    }
                )
                .customDoubleTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if isZoomed {
                            scale = 1.0
                            offset = .zero
                            isZoomed = false
                            addToHistory("Reset to original size")
                        } else {
                            scale = 2.0
                            isZoomed = true
                            addToHistory("Zoomed to 2x")
                        }
                    }
                    hapticManager.triggerFeedback(for: .tap)
                }
                .customLongPressGesture(
                    configuration: LongPressConfiguration(
                        minimumPressDuration: 1.0,
                        maximumPressDuration: 3.0,
                        maximumMovementDistance: 10.0,
                        enableHapticFeedback: true,
                        numberOfTouchesRequired: 1
                    )
                ) {
                    withAnimation(.spring()) {
                        rotation = 0.0
                        addToHistory("Reset rotation")
                    }
                    hapticManager.triggerFeedback(for: .longPress)
                }
                
                // Gesture history
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gesture History")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 5) {
                            ForEach(gestureHistory.suffix(10), id: \.self) { gesture in
                                Text(gesture)
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(height: 100)
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // Performance metrics
                if let metrics = performanceMetrics {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Performance Metrics")
                            .font(.headline)
                        
                        Text("Avg Processing: \(String(format: "%.3f", metrics.averageProcessingTime))s")
                            .font(.caption)
                        
                        Text("Total Events: \(metrics.totalEventsProcessed)")
                            .font(.caption)
                        
                        Text("Accuracy: \(String(format: "%.1f", metrics.recognitionAccuracy * 100))%")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Control buttons
                HStack(spacing: 20) {
                    Button("Reset All") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scale = 1.0
                            rotation = 0.0
                            offset = .zero
                            isZoomed = false
                            gestureHistory.removeAll()
                            performanceMetrics = gestureEngine.getPerformanceMetrics()
                        }
                        hapticManager.triggerCustomFeedback(intensity: 0.8)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Performance") {
                        performanceMetrics = gestureEngine.getPerformanceMetrics()
                        hapticManager.triggerCustomFeedback(intensity: 0.6)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Advanced Gestures")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func addToHistory(_ gesture: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        gestureHistory.append("[\(timestamp)] \(gesture)")
        
        // Keep only last 50 entries
        if gestureHistory.count > 50 {
            gestureHistory.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct MultiTouchAdvancedExample: View {
    @State private var detectedPattern: String = "None"
    @State private var touchPoints: [CGPoint] = []
    @State private var patternHistory: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Multi-Touch Advanced")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.green, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                
                VStack {
                    Image(systemName: "hand.raised")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("Multi-Touch Area")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Use multiple fingers")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Touch point indicators
                ForEach(Array(touchPoints.enumerated()), id: \.offset) { index, point in
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 20, height: 20)
                        .position(point)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        )
                }
            }
            .customMultiTouchGesture(
                configuration: MultiTouchConfiguration(
                    minimumTouchPoints: 2,
                    maximumTouchPoints: 5,
                    minimumHistorySize: 3,
                    maxHistorySize: 10,
                    enablePatternRecognition: true
                )
            ) { pattern, points in
                touchPoints = points
                detectedPattern = pattern.description
                addToPatternHistory(pattern.description)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Detected Pattern: \(detectedPattern)")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text("Touch Points: \(touchPoints.count)")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(patternHistory.suffix(10), id: \.self) { pattern in
                            Text(pattern)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 80)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button("Clear History") {
                patternHistory.removeAll()
                touchPoints.removeAll()
                detectedPattern = "None"
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func addToPatternHistory(_ pattern: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        patternHistory.append("[\(timestamp)] \(pattern)")
        
        // Keep only last 20 entries
        if patternHistory.count > 20 {
            patternHistory.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct HapticAdvancedExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var hapticIntensity: Float = 0.5
    @State private var hapticHistory: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Advanced Haptic Feedback")
                .font(.title)
                .fontWeight(.bold)
            
            // Haptic intensity slider
            VStack(alignment: .leading, spacing: 10) {
                Text("Haptic Intensity: \(String(format: "%.2f", hapticIntensity))")
                    .font(.headline)
                
                Slider(value: $hapticIntensity, in: 0.0...1.0, step: 0.1)
                    .accentColor(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            // Haptic test buttons
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                HapticTestButton(
                    title: "Light Tap",
                    color: .green
                ) {
                    hapticManager.triggerCustomFeedback(intensity: hapticIntensity * 0.3)
                    addToHapticHistory("Light tap - \(String(format: "%.1f", hapticIntensity * 0.3))")
                }
                
                HapticTestButton(
                    title: "Medium Tap",
                    color: .blue
                ) {
                    hapticManager.triggerCustomFeedback(intensity: hapticIntensity * 0.6)
                    addToHapticHistory("Medium tap - \(String(format: "%.1f", hapticIntensity * 0.6))")
                }
                
                HapticTestButton(
                    title: "Heavy Tap",
                    color: .orange
                ) {
                    hapticManager.triggerCustomFeedback(intensity: hapticIntensity * 0.9)
                    addToHapticHistory("Heavy tap - \(String(format: "%.1f", hapticIntensity * 0.9))")
                }
                
                HapticTestButton(
                    title: "Full Intensity",
                    color: .red
                ) {
                    hapticManager.triggerCustomFeedback(intensity: hapticIntensity)
                    addToHapticHistory("Full intensity - \(String(format: "%.1f", hapticIntensity))")
                }
            }
            
            // Gesture-specific haptic feedback
            VStack(spacing: 15) {
                Text("Gesture-Specific Haptics")
                    .font(.headline)
                
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: 200, height: 100)
                    .cornerRadius(10)
                    .customTapGesture {
                        hapticManager.triggerFeedback(for: .tap)
                        addToHapticHistory("Tap gesture haptic")
                    }
                    .customLongPressGesture {
                        hapticManager.triggerFeedback(for: .longPress)
                        addToHapticHistory("Long press haptic")
                    }
                    .customSwipeGesture { direction in
                        hapticManager.triggerFeedback(for: .swipe)
                        addToHapticHistory("Swipe haptic - \(direction)")
                    }
                    .overlay(
                        Text("Tap, Long Press, or Swipe")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
            }
            
            // Haptic history
            VStack(alignment: .leading, spacing: 10) {
                Text("Haptic History")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(hapticHistory.suffix(10), id: \.self) { haptic in
                            Text(haptic)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 100)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button("Clear History") {
                hapticHistory.removeAll()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private func addToHapticHistory(_ haptic: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        hapticHistory.append("[\(timestamp)] \(haptic)")
        
        // Keep only last 30 entries
        if hapticHistory.count > 30 {
            hapticHistory.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct HapticTestButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(color)
                .cornerRadius(10)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AdvancedGestureExample_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedGestureExample()
    }
} 