# 🎯 Custom Gestures Guide

## Overview

Custom gestures allow you to create unique interaction patterns that go beyond standard iOS gestures. This guide covers pattern recognition, machine learning, and custom gesture implementation.

## Pattern Recognition

### Basic Pattern Gesture

```swift
struct PatternGestureExample: View {
    @State private var gesturePath: [CGPoint] = []
    @State private var isDrawing = false
    
    var body: some View {
        VStack {
            Text("Draw a pattern")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .frame(width: 250, height: 200)
                .overlay(
                    Path { path in
                        guard let firstPoint = gesturePath.first else { return }
                        path.move(to: firstPoint)
                        for point in gesturePath.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 3)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isDrawing {
                                gesturePath = [value.location]
                                isDrawing = true
                            } else {
                                gesturePath.append(value.location)
                            }
                        }
                        .onEnded { _ in
                            isDrawing = false
                            analyzePattern()
                        }
                )
        }
    }
    
    private func analyzePattern() {
        // Analyze the drawn pattern
        let pointCount = gesturePath.count
        print("Pattern points: \(pointCount)")
        
        // Clear path after analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            gesturePath = []
        }
    }
}
```

## Machine Learning Gestures

### ML Gesture Recognition

```swift
struct MLGestureExample: View {
    @State private var gestureResult = ""
    @State private var confidence: Float = 0.0
    
    var body: some View {
        VStack {
            Text("ML Gesture Recognition")
                .font(.title)
            
            Text(gestureResult)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Confidence: \(String(format: "%.1f%%", confidence * 100))")
                .font(.caption)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.mint)
                .frame(width: 200, height: 200)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            // Collect gesture data
                        }
                        .onEnded { _ in
                            recognizeGesture()
                        }
                )
        }
    }
    
    private func recognizeGesture() {
        // Simulate ML gesture recognition
        let gestures = ["swipe", "circle", "square", "triangle"]
        let randomGesture = gestures.randomElement() ?? "unknown"
        confidence = Float.random(in: 0.7...1.0)
        
        gestureResult = "Detected: \(randomGesture)"
    }
}
```

## Gesture Training

### Custom Gesture Training

```swift
struct GestureTrainingExample: View {
    @State private var trainingMode = false
    @State private var gestureName = ""
    @State private var trainingSamples: [[CGPoint]] = []
    @State private var currentSample: [CGPoint] = []
    
    var body: some View {
        VStack {
            Text("Gesture Training")
                .font(.title)
            
            if trainingMode {
                VStack {
                    TextField("Gesture Name", text: $gestureName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Samples: \(trainingSamples.count)")
                        .font(.caption)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)
                        .frame(width: 250, height: 200)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    currentSample.append(value.location)
                                }
                                .onEnded { _ in
                                    if !currentSample.isEmpty {
                                        trainingSamples.append(currentSample)
                                        currentSample = []
                                    }
                                }
                        )
                    
                    Button("Save Gesture") {
                        saveTrainedGesture()
                    }
                    .disabled(gestureName.isEmpty || trainingSamples.isEmpty)
                }
            } else {
                Button("Start Training") {
                    trainingMode = true
                }
            }
        }
    }
    
    private func saveTrainedGesture() {
        print("Saving gesture: \(gestureName)")
        print("Samples: \(trainingSamples.count)")
        
        // Reset training mode
        trainingMode = false
        gestureName = ""
        trainingSamples = []
    }
}
```

## Gesture Classification

### Gesture Categories

```swift
enum GestureCategory: String, CaseIterable {
    case navigation = "navigation"
    case selection = "selection"
    case manipulation = "manipulation"
    case custom = "custom"
}

struct GestureClassificationExample: View {
    @State private var selectedCategory: GestureCategory = .navigation
    @State private var gestureData: [CGPoint] = []
    
    var body: some View {
        VStack {
            Text("Gesture Classification")
                .font(.title)
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(GestureCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                        .tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.indigo)
                .frame(width: 200, height: 200)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            gestureData.append(value.location)
                        }
                        .onEnded { _ in
                            classifyGesture()
                        }
                )
        }
    }
    
    private func classifyGesture() {
        print("Classifying gesture for category: \(selectedCategory.rawValue)")
        print("Data points: \(gestureData.count)")
        
        gestureData = []
    }
}
```

## Performance Optimization

### 1. Efficient Pattern Matching

```swift
private func matchPattern(_ points: [CGPoint], against template: [CGPoint]) -> Float {
    // Implement efficient pattern matching algorithm
    // Consider using dynamic time warping (DTW) or similar
    return 0.8 // Placeholder confidence score
}
```

### 2. Gesture Data Compression

```swift
private func compressGestureData(_ points: [CGPoint]) -> [CGPoint] {
    // Reduce number of points while preserving shape
    let compressionRatio = 0.1
    let targetCount = max(10, Int(Double(points.count) * compressionRatio))
    
    var compressed: [CGPoint] = []
    let step = points.count / targetCount
    
    for i in stride(from: 0, to: points.count, by: step) {
        compressed.append(points[i])
    }
    
    return compressed
}
```

### 3. Caching Recognized Patterns

```swift
private var gestureCache: [String: [CGPoint]] = [:]

private func cacheGesture(_ name: String, points: [CGPoint]) {
    gestureCache[name] = points
}
```

## Best Practices

### 1. Provide Clear Feedback

```swift
private func provideFeedback(for gesture: String, confidence: Float) {
    if confidence > 0.8 {
        // High confidence - provide positive feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    } else {
        // Low confidence - provide subtle feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}
```

### 2. Handle Edge Cases

```swift
private func validateGesture(_ points: [CGPoint]) -> Bool {
    // Check minimum points
    guard points.count >= 5 else { return false }
    
    // Check gesture duration
    // Check gesture size
    // Check gesture complexity
    
    return true
}
```

### 3. Consider Accessibility

```swift
.accessibilityAction(named: "Custom gesture") {
    // Provide alternative for accessibility
}
```

## Troubleshooting

### Common Issues

1. **Low recognition accuracy**: Increase training samples
2. **Performance issues**: Optimize pattern matching algorithms
3. **Memory usage**: Implement gesture data compression
4. **False positives**: Adjust confidence thresholds

### Debug Tips

```swift
private func debugGesture(_ points: [CGPoint]) {
    print("Gesture debug info:")
    print("- Point count: \(points.count)")
    print("- Bounds: \(calculateBounds(points))")
    print("- Duration: \(calculateDuration(points))")
}
```

## Next Steps

- Review [Gesture Best Practices Guide](GestureBestPracticesGuide.md) for optimization tips
- Check out [Performance Guide](PerformanceGuide.md) for advanced optimization
- Explore [Gesture Training Guide](GestureTrainingGuide.md) for training techniques
