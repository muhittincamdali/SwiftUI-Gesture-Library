# SwiftUI Gesture Library

<p align="center">
  <img src="Assets/banner.png" alt="SwiftUI Gesture Library" width="800">
</p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white" alt="Swift"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-15.0+-000000?style=flat&logo=apple&logoColor=white" alt="iOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
  <a href="https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions"><img src="https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <b>Custom gestures and interactions for SwiftUI applications.</b>
</p>

---

## Preview

<p align="center">
  <img src="Assets/gestures-demo.gif" alt="Gestures Demo" width="300">
</p>

## Gestures

| Gesture | Description |
|---------|-------------|
| **Long Press** | Press and hold with duration |
| **Drag** | Pan and drag with velocity |
| **Pinch** | Scale with two fingers |
| **Rotation** | Rotate with two fingers |
| **Double Tap** | Quick double tap detection |
| **Swipe** | Directional swipe gestures |
| **Force Touch** | 3D Touch pressure (where available) |
| **Custom** | Build your own gesture recognizers |

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "1.0.0")
]
```

## Quick Start

### Drag Gesture

```swift
import SwiftUIGestureLibrary

struct DraggableCard: View {
    @State private var offset: CGSize = .zero
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .frame(width: 200, height: 150)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
    }
}
```

### Pinch to Zoom

```swift
struct ZoomableImage: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                    }
                    .onEnded { _ in
                        withAnimation {
                            scale = max(1, min(scale, 4))
                        }
                    }
            )
    }
}
```

### Rotation Gesture

```swift
struct RotatableView: View {
    @State private var angle: Angle = .zero
    
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 100))
            .rotationEffect(angle)
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        angle = value
                    }
            )
    }
}
```

### Combined Gestures

```swift
struct TransformableView: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var angle: Angle = .zero
    
    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .offset(offset)
            .scaleEffect(scale)
            .rotationEffect(angle)
            .gesture(
                SimultaneousGesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                            },
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value
                            }
                    ),
                    RotationGesture()
                        .onChanged { value in
                            angle = value
                        }
                )
            )
    }
}
```

### Swipe Gesture

```swift
struct SwipeableCard: View {
    @State private var offset: CGFloat = 0
    @State private var isRemoved = false
    
    var body: some View {
        CardView()
            .offset(x: offset)
            .opacity(2 - Double(abs(offset / 100)))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation.width
                    }
                    .onEnded { value in
                        if abs(value.translation.width) > 150 {
                            withAnimation {
                                offset = value.translation.width > 0 ? 500 : -500
                                isRemoved = true
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = 0
                            }
                        }
                    }
            )
    }
}
```

### Long Press with Haptic

```swift
struct LongPressButton: View {
    @State private var isPressed = false
    
    var body: some View {
        Circle()
            .fill(isPressed ? .green : .blue)
            .frame(width: 100, height: 100)
            .scaleEffect(isPressed ? 1.2 : 1.0)
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onChanged { _ in
                        withAnimation {
                            isPressed = true
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    .onEnded { _ in
                        withAnimation {
                            isPressed = false
                        }
                    }
            )
    }
}
```

## Custom Gesture Modifier

```swift
extension View {
    func onSwipe(
        direction: SwipeDirection,
        action: @escaping () -> Void
    ) -> some View {
        self.gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    let horizontal = value.translation.width
                    let vertical = value.translation.height
                    
                    switch direction {
                    case .left where horizontal < 0 && abs(horizontal) > abs(vertical):
                        action()
                    case .right where horizontal > 0 && abs(horizontal) > abs(vertical):
                        action()
                    case .up where vertical < 0 && abs(vertical) > abs(horizontal):
                        action()
                    case .down where vertical > 0 && abs(vertical) > abs(horizontal):
                        action()
                    default:
                        break
                    }
                }
        )
    }
}

enum SwipeDirection {
    case left, right, up, down
}

// Usage
Text("Swipe me")
    .onSwipe(direction: .left) {
        print("Swiped left!")
    }
```

## Project Structure

```
SwiftUI-Gesture-Library/
├── Sources/
│   ├── Gestures/
│   │   ├── DragGestureHandler.swift
│   │   ├── PinchGestureHandler.swift
│   │   ├── RotationGestureHandler.swift
│   │   └── SwipeGestureHandler.swift
│   ├── Modifiers/
│   │   └── GestureModifiers.swift
│   └── Extensions/
│       └── View+Gestures.swift
├── Examples/
└── Tests/
```

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Documentation

- [Gesture Types](Documentation/GestureTypes.md)
- [Combining Gestures](Documentation/CombiningGestures.md)
- [Custom Gestures](Documentation/CustomGestures.md)
- [Haptic Feedback](Documentation/HapticFeedback.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License. See [LICENSE](LICENSE).

## Author

**Muhittin Camdali** — [@muhittincamdali](https://github.com/muhittincamdali)

---

<p align="center">
  <sub>Touch interactions made easy ❤️</sub>
</p>
