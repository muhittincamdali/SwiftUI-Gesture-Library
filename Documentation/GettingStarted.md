# Getting Started with GestureKit

This guide will help you get started with GestureKit in your SwiftUI project.

## Installation

Add GestureKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "1.0.0")
]
```

## Basic Setup

### 1. Import the Framework

```swift
import GestureKit
```

### 2. Add Gestures to Views

```swift
struct ContentView: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 200, height: 200)
            .onSwipe(.left) {
                print("Swiped left!")
            }
            .onDoubleTap {
                print("Double tapped!")
            }
    }
}
```

### 3. Use Advanced Gestures

```swift
@State private var scale: CGFloat = 1.0

Image("photo")
    .zoomable(scale: $scale, minScale: 0.5, maxScale: 4.0)
```

## Next Steps

- Read the [API Reference](API.md)
- Explore [Examples](../Examples/)
- Learn about [Combining Gestures](CombiningGestures.md)
