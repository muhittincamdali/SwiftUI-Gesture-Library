# 🔄 Advanced Gestures Guide

<!-- TOC START -->
## Table of Contents
- [🔄 Advanced Gestures Guide](#-advanced-gestures-guide)
- [Overview](#overview)
- [Drag Gestures](#drag-gestures)
  - [Basic Drag](#basic-drag)
  - [Constrained Drag](#constrained-drag)
- [Pinch Gestures](#pinch-gestures)
  - [Basic Pinch](#basic-pinch)
  - [Constrained Pinch](#constrained-pinch)
- [Rotation Gestures](#rotation-gestures)
  - [Basic Rotation](#basic-rotation)
  - [Snapping Rotation](#snapping-rotation)
- [Combined Gestures](#combined-gestures)
  - [Simultaneous Gestures](#simultaneous-gestures)
  - [Exclusive Gestures](#exclusive-gestures)
- [Performance Optimization](#performance-optimization)
  - [1. Use Appropriate Update Frequency](#1-use-appropriate-update-frequency)
  - [2. Debounce Gesture Events](#2-debounce-gesture-events)
  - [3. Use Gesture State](#3-use-gesture-state)
- [Best Practices](#best-practices)
  - [1. Provide Visual Feedback](#1-provide-visual-feedback)
  - [2. Handle Edge Cases](#2-handle-edge-cases)
  - [3. Consider Accessibility](#3-consider-accessibility)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Tips](#debug-tips)
- [Next Steps](#next-steps)
<!-- TOC END -->


## Overview

Advanced gestures provide complex interaction patterns that enhance user experience. This guide covers drag, pinch, rotation, and other sophisticated gesture implementations.

## Drag Gestures

### Basic Drag

```swift
struct BasicDragExample: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            Text("Drag the circle")
                .font(.title)
            
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                )
        }
    }
}
```

### Constrained Drag

```swift
struct ConstrainedDragExample: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            Text("Horizontal drag only")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.green)
                .frame(width: 150, height: 100)
                .offset(x: offset.width, y: 0) // Only horizontal
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset.width = value.translation.width
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                )
        }
    }
}
```

## Pinch Gestures

### Basic Pinch

```swift
struct BasicPinchExample: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Text("Pinch to zoom")
                .font(.title)
            
            Image(systemName: "photo")
                .font(.system(size: 100))
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                scale = 1.0
                            }
                        }
                )
        }
    }
}
```

### Constrained Pinch

```swift
struct ConstrainedPinchExample: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Text("Constrained zoom")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.orange)
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = min(max(value, 0.5), 3.0) // Constrain between 0.5x and 3x
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                scale = 1.0
                            }
                        }
                )
        }
    }
}
```

## Rotation Gestures

### Basic Rotation

```swift
struct BasicRotationExample: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            Text("Rotate the square")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.purple)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            rotation = angle.degrees
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                rotation = 0
                            }
                        }
                )
        }
    }
}
```

### Snapping Rotation

```swift
struct SnappingRotationExample: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            Text("Snap rotation")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.cyan)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            rotation = angle.degrees
                        }
                        .onEnded { _ in
                            // Snap to nearest 90 degrees
                            let snappedRotation = round(rotation / 90) * 90
                            withAnimation(.spring()) {
                                rotation = snappedRotation
                            }
                        }
                )
        }
    }
}
```

## Combined Gestures

### Simultaneous Gestures

```swift
struct SimultaneousGesturesExample: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            Text("Multi-touch gestures")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.red)
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    scale = 1.0
                                }
                            },
                        RotationGesture()
                            .onChanged { angle in
                                rotation = angle.degrees
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    rotation = 0
                                }
                            }
                    )
                )
        }
    }
}
```

### Exclusive Gestures

```swift
struct ExclusiveGesturesExample: View {
    @State private var isDragging = false
    @State private var isScaling = false
    
    var body: some View {
        VStack {
            Text("Exclusive gestures")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(isDragging ? .blue : isScaling ? .green : .gray)
                .frame(width: 150, height: 150)
                .gesture(
                    ExclusiveGesture(
                        DragGesture()
                            .onChanged { _ in
                                isDragging = true
                                isScaling = false
                            }
                            .onEnded { _ in
                                isDragging = false
                            },
                        MagnificationGesture()
                            .onChanged { _ in
                                isScaling = true
                                isDragging = false
                            }
                            .onEnded { _ in
                                isScaling = false
                            }
                    )
                )
        }
    }
}
```

## Performance Optimization

### 1. Use Appropriate Update Frequency

```swift
.gesture(
    DragGesture()
        .onChanged { value in
            // Update at 60fps for smooth interaction
            DispatchQueue.main.async {
                offset = value.translation
            }
        }
)
```

### 2. Debounce Gesture Events

```swift
@State private var debounceTimer: Timer?

.gesture(
    DragGesture()
        .onChanged { value in
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                // Handle gesture after debounce
            }
        }
)
```

### 3. Use Gesture State

```swift
@GestureState private var isPressed = false

.gesture(
    LongPressGesture(minimumDuration: 0.5)
        .updating($isPressed) { currentState, gestureState, _ in
            gestureState = currentState
        }
)
```

## Best Practices

### 1. Provide Visual Feedback

```swift
.gesture(
    DragGesture()
        .onChanged { value in
            // Visual feedback
            withAnimation(.easeInOut(duration: 0.1)) {
                offset = value.translation
            }
        }
)
```

### 2. Handle Edge Cases

```swift
.gesture(
    MagnificationGesture()
        .onChanged { value in
            // Prevent extreme scaling
            scale = min(max(value, 0.1), 5.0)
        }
)
```

### 3. Consider Accessibility

```swift
.accessibilityAction(named: "Zoom in") {
    scale *= 1.2
}
.accessibilityAction(named: "Zoom out") {
    scale /= 1.2
}
```

## Troubleshooting

### Common Issues

1. **Gesture conflicts**: Use `ExclusiveGesture` or `SimultaneousGesture`
2. **Performance issues**: Debounce or throttle gesture events
3. **Memory leaks**: Properly clean up timers and observers
4. **Accessibility**: Provide alternative interaction methods

### Debug Tips

```swift
.gesture(
    DragGesture()
        .onChanged { value in
            print("Drag translation: \(value.translation)")
            print("Drag velocity: \(value.velocity)")
        }
)
```

## Next Steps

- Explore [Custom Gestures Guide](CustomGesturesGuide.md) for custom gesture recognition
- Review [Gesture Best Practices Guide](GestureBestPracticesGuide.md) for optimization tips
- Check out [Performance Guide](PerformanceGuide.md) for advanced optimization techniques
