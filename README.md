```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║    ██████╗ ███████╗███████╗████████╗██╗   ██╗██████╗ ███████╗██╗  ██╗██╗████████╗║
║   ██╔════╝ ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗██╔════╝██║ ██╔╝██║╚══██╔══╝║
║   ██║  ███╗█████╗  ███████╗   ██║   ██║   ██║██████╔╝█████╗  █████╔╝ ██║   ██║   ║
║   ██║   ██║██╔══╝  ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  ██╔═██╗ ██║   ██║   ║
║   ╚██████╔╝███████╗███████║   ██║   ╚██████╔╝██║  ██║███████╗██║  ██╗██║   ██║   ║
║    ╚═════╝ ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝   ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

<div align="center">

**Advanced gesture library for SwiftUI. Touch, pinch, rotate, swipe — all declarative.**

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![visionOS](https://img.shields.io/badge/visionOS-1.0+-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/visionos/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![CI](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions)

[Features](#-features) • [Quick Start](#-quick-start) • [Installation](#-installation) • [Gestures](#-gesture-catalog) • [API](#-api-reference) • [Docs](Documentation/)

</div>

---

## ✨ Features

- 👆 **Tap Gestures** — Single, double, triple tap with custom counts
- 👋 **Swipe Gestures** — All four directions with customizable distance
- 🤏 **Pinch & Zoom** — Scale views with momentum and bounds
- 🔄 **Rotation** — Rotate views with snap angles
- ✋ **Pan & Drag** — Velocity tracking and bounds support
- ⏱️ **Long Press** — Customizable duration with callbacks
- 🎯 **Combined Gestures** — Compose multiple gestures together
- 📱 **Shake Detection** — Device shake gesture (iOS)
- 🖱️ **Hover Effects** — Mouse hover support (macOS/visionOS)
- 🎭 **Fully Transformable** — Scale + Rotate + Drag in one modifier

---

## 🚀 Quick Start

```swift
import GestureKit

struct ContentView: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 200, height: 200)
            .onSwipe(.left) { print("Swiped left!") }
            .onDoubleTap { print("Double tapped!") }
            .onPinch { scale in print("Scale: \(scale)") }
    }
}
```

---

## 📦 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Packages** → Enter the repository URL.

### Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 15.0+           |
| macOS    | 13.0+           |
| tvOS     | 15.0+           |
| watchOS  | 8.0+            |
| visionOS | 1.0+            |
| Swift    | 5.9+            |

---

## 👆 Gesture Catalog

### Swipe Gestures

```swift
// Single direction
Rectangle()
    .onSwipe(.left) { print("Left!") }
    .onSwipe(.right) { print("Right!") }
    .onSwipe(.up) { print("Up!") }
    .onSwipe(.down) { print("Down!") }

// Custom minimum distance
Rectangle()
    .onSwipe(.left, minimumDistance: 100) { 
        print("Long swipe left!") 
    }

// All directions
Rectangle()
    .onSwipeAny { direction in
        print("Swiped \(direction)")
    }
```

### Tap Gestures

```swift
// Double tap
Rectangle()
    .onDoubleTap { print("Double tap!") }

// Triple tap
Rectangle()
    .onTripleTap { print("Triple tap!") }
```

### Long Press

```swift
Rectangle()
    .onLongPress(
        minimumDuration: 0.5,
        onStart: { print("Press started") },
        onEnd: { print("Press ended") }
    )
```

### Pinch & Zoom

```swift
// Basic pinch
Rectangle()
    .onPinch(
        onChanged: { scale in print("Scale: \(scale)") },
        onEnded: { finalScale in print("Final: \(finalScale)") }
    )

// Zoomable view with bounds
@State private var scale: CGFloat = 1.0

Image("photo")
    .zoomable(
        scale: $scale,
        minScale: 0.5,
        maxScale: 4.0,
        doubleTapScale: 2.0  // Double tap toggles zoom
    )
```

### Rotation

```swift
// Basic rotation
Rectangle()
    .onRotate(
        onChanged: { angle in print("Angle: \(angle.degrees)°") },
        onEnded: { finalAngle in print("Final: \(finalAngle.degrees)°") }
    )

// Rotatable with snap angles
@State private var rotation: Angle = .zero

Rectangle()
    .rotatable(
        rotation: $rotation,
        snapAngles: [.zero, .degrees(90), .degrees(180), .degrees(270)]
    )
```

### Pan & Drag

```swift
// Pan with velocity tracking
Rectangle()
    .onPan(
        onChanged: { translation, velocity in
            print("Position: \(translation)")
            print("Velocity: \(velocity)")
        },
        onEnded: { translation, velocity in
            print("Ended with velocity: \(velocity)")
        }
    )

// Draggable view
@State private var position: CGPoint = CGPoint(x: 100, y: 100)

Circle()
    .draggable(
        position: $position,
        bounds: CGRect(x: 0, y: 0, width: 300, height: 300),
        snapBack: false,
        onDragStart: { print("Started") },
        onDragEnd: { finalPos in print("Ended at \(finalPos)") }
    )
```

### Combined Transform (Scale + Rotate + Drag)

```swift
@State private var scale: CGFloat = 1.0
@State private var rotation: Angle = .zero
@State private var offset: CGSize = .zero

Image("photo")
    .transformable(
        scale: $scale,
        rotation: $rotation,
        offset: $offset
    )
```

### Shake Detection (iOS)

```swift
#if os(iOS)
Rectangle()
    .onShake {
        print("Device shaken!")
    }
#endif
```

### Hover Effects (macOS/visionOS)

```swift
#if os(macOS) || os(visionOS)
Rectangle()
    .hoverEffect(
        scale: 1.05,
        onHover: { isHovering in
            print(isHovering ? "Entered" : "Exited")
        }
    )
#endif
```

---

## 🎯 Common Patterns

### Image Viewer

```swift
struct ImageViewer: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        Image("photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(scale)
            .offset(offset)
            .zoomable(scale: $scale, minScale: 1.0, maxScale: 5.0)
            .onPan(onChanged: { translation, _ in
                offset = translation
            })
    }
}
```

### Dismissable Card

```swift
struct DismissableCard: View {
    @State private var offset: CGFloat = 0
    @Binding var isPresented: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .offset(y: offset)
            .onSwipe(.down) {
                withAnimation {
                    isPresented = false
                }
            }
    }
}
```

### Rotatable Dial

```swift
struct RotatableDial: View {
    @State private var rotation: Angle = .zero
    
    var body: some View {
        Circle()
            .fill(.gray)
            .overlay(
                Rectangle()
                    .fill(.white)
                    .frame(width: 4, height: 40)
                    .offset(y: -30)
            )
            .rotatable(
                rotation: $rotation,
                snapAngles: stride(from: 0, through: 360, by: 30).map { .degrees($0) }
            )
    }
}
```

---

## 📊 API Reference

### Swipe

| Modifier | Description |
|----------|-------------|
| `.onSwipe(_:minimumDistance:perform:)` | Detect swipe in direction |
| `.onSwipeAny(perform:)` | Detect swipe in any direction |

### Tap

| Modifier | Description |
|----------|-------------|
| `.onDoubleTap(perform:)` | Detect double tap |
| `.onTripleTap(perform:)` | Detect triple tap |

### Press

| Modifier | Description |
|----------|-------------|
| `.onLongPress(minimumDuration:onStart:onEnd:)` | Detect long press |

### Scale

| Modifier | Description |
|----------|-------------|
| `.onPinch(onChanged:onEnded:)` | Detect pinch gesture |
| `.zoomable(scale:minScale:maxScale:doubleTapScale:)` | Make view zoomable |

### Rotation

| Modifier | Description |
|----------|-------------|
| `.onRotate(onChanged:onEnded:)` | Detect rotation |
| `.rotatable(rotation:snapAngles:)` | Make view rotatable |

### Drag

| Modifier | Description |
|----------|-------------|
| `.onPan(onChanged:onEnded:)` | Detect pan with velocity |
| `.draggable(position:bounds:snapBack:)` | Make view draggable |

### Combined

| Modifier | Description |
|----------|-------------|
| `.transformable(scale:rotation:offset:)` | Full transform support |

---

## 🧪 Testing

```bash
swift test
```

---

## 📁 Project Structure

```
SwiftUI-Gesture-Library/
├── Sources/
│   └── GestureKit/
│       ├── GestureKit.swift         # Core gestures
│       └── AdvancedGestures.swift   # Advanced modifiers
├── Tests/
│   └── GestureKitTests/
├── Documentation/
├── Examples/
└── Package.swift
```

---

## 🤝 Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

<div align="center">

**[⬆ Back to Top](#-features)**

Made with ❤️ by [Muhittin Camdali](https://github.com/muhittincamdali)

</div>

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/SwiftUI-Gesture-Library&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Gesture-Library&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Gesture-Library&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Gesture-Library&type=Date" />
 </picture>
</a>
