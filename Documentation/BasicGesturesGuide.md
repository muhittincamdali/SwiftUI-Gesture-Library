# 👆 Basic Gestures Guide

<!-- TOC START -->
## Table of Contents
- [👆 Basic Gestures Guide](#-basic-gestures-guide)
- [Overview](#overview)
- [Tap Gestures](#tap-gestures)
  - [Single Tap](#single-tap)
  - [Double Tap](#double-tap)
- [Long Press Gestures](#long-press-gestures)
  - [Basic Long Press](#basic-long-press)
  - [Variable Long Press](#variable-long-press)
- [Touch Gestures](#touch-gestures)
  - [Touch Down/Up Events](#touch-downup-events)
- [Hover Gestures (macOS)](#hover-gestures-macos)
  - [Mouse Hover](#mouse-hover)
- [Best Practices](#best-practices)
  - [1. Provide Visual Feedback](#1-provide-visual-feedback)
  - [2. Use Appropriate Durations](#2-use-appropriate-durations)
  - [3. Consider Accessibility](#3-consider-accessibility)
  - [4. Combine Gestures](#4-combine-gestures)
- [Common Patterns](#common-patterns)
  - [1. Toggle Pattern](#1-toggle-pattern)
  - [2. Counter Pattern](#2-counter-pattern)
  - [3. State Pattern](#3-state-pattern)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Tips](#debug-tips)
- [Next Steps](#next-steps)
<!-- TOC END -->


## Overview

Basic gestures are the foundation of touch interaction in SwiftUI applications. This guide covers the essential gesture types that every iOS developer should know.

## Tap Gestures

### Single Tap

```swift
struct SingleTapExample: View {
    @State private var tapCount = 0
    
    var body: some View {
        VStack {
            Text("Tap Count: \(tapCount)")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue)
                .frame(width: 150, height: 100)
                .onTapGesture {
                    tapCount += 1
                }
        }
    }
}
```

### Double Tap

```swift
struct DoubleTapExample: View {
    @State private var isDoubleTapped = false
    
    var body: some View {
        VStack {
            Text(isDoubleTapped ? "Double Tapped!" : "Double tap me")
                .font(.title)
            
            Circle()
                .fill(isDoubleTapped ? .green : .red)
                .frame(width: 100, height: 100)
                .onTapGesture(count: 2) {
                    isDoubleTapped.toggle()
                }
        }
    }
}
```

## Long Press Gestures

### Basic Long Press

```swift
struct LongPressExample: View {
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Text(isPressed ? "Long Pressed!" : "Long press me")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(isPressed ? .orange : .purple)
                .frame(width: 150, height: 100)
                .scaleEffect(isPressed ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
                .onLongPressGesture(minimumDuration: 0.5) {
                    isPressed.toggle()
                }
        }
    }
}
```

### Variable Long Press

```swift
struct VariableLongPressExample: View {
    @State private var pressDuration: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text("Press Duration: \(String(format: "%.1f", pressDuration))s")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.cyan)
                .frame(width: 150, height: 100)
                .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 50) {
                    // Long press completed
                } onPressingChanged: { isPressing in
                    if isPressing {
                        // Started pressing
                    } else {
                        // Stopped pressing
                        pressDuration = 0
                    }
                }
        }
    }
}
```

## Touch Gestures

### Touch Down/Up Events

```swift
struct TouchExample: View {
    @State private var isTouching = false
    
    var body: some View {
        VStack {
            Text(isTouching ? "Touching!" : "Touch me")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(isTouching ? .yellow : .gray)
                .frame(width: 150, height: 100)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            isTouching = true
                        }
                        .onEnded { _ in
                            isTouching = false
                        }
                )
        }
    }
}
```

## Hover Gestures (macOS)

### Mouse Hover

```swift
struct HoverExample: View {
    @State private var isHovering = false
    
    var body: some View {
        VStack {
            Text(isHovering ? "Hovering!" : "Hover over me")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(isHovering ? .mint : .indigo)
                .frame(width: 150, height: 100)
                .onHover { hovering in
                    isHovering = hovering
                }
        }
    }
}
```

## Best Practices

### 1. Provide Visual Feedback

Always give users visual feedback when gestures are recognized:

```swift
.onTapGesture {
    // Provide haptic feedback
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
    
    // Update UI
    withAnimation(.easeInOut(duration: 0.1)) {
        // Visual changes
    }
}
```

### 2. Use Appropriate Durations

- **Single Tap**: 0.1-0.3 seconds
- **Double Tap**: 0.3-0.5 seconds between taps
- **Long Press**: 0.5-1.0 seconds minimum

### 3. Consider Accessibility

```swift
.accessibilityAction(named: "Double tap") {
    // Handle double tap for accessibility
}
```

### 4. Combine Gestures

```swift
.gesture(
    SimultaneousGesture(
        TapGesture()
            .onEnded { _ in
                // Handle tap
            },
        LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                // Handle long press
            }
    )
)
```

## Common Patterns

### 1. Toggle Pattern

```swift
@State private var isActive = false

.onTapGesture {
    isActive.toggle()
}
```

### 2. Counter Pattern

```swift
@State private var count = 0

.onTapGesture {
    count += 1
}
```

### 3. State Pattern

```swift
@State private var gestureState: GestureState = .idle

enum GestureState {
    case idle, pressing, completed
}
```

## Troubleshooting

### Common Issues

1. **Gesture not responding**: Check if the view is interactive
2. **Conflicting gestures**: Use `SimultaneousGesture` or `ExclusiveGesture`
3. **Performance issues**: Avoid complex computations in gesture handlers
4. **Accessibility problems**: Provide alternative interaction methods

### Debug Tips

```swift
.onTapGesture {
    print("Tap detected at: \(Date())")
}
```

## Next Steps

- Explore [Advanced Gestures Guide](AdvancedGesturesGuide.md) for complex gesture implementations
- Learn about [Custom Gestures Guide](CustomGesturesGuide.md) for custom gesture recognition
- Review [Gesture Best Practices Guide](GestureBestPracticesGuide.md) for optimization tips
