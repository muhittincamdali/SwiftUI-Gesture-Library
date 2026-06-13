<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0"/>
  <img src="https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20visionOS-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="Platform"/>
  <img src="https://img.shields.io/badge/Standard-Unified%20Core-5856D6?style=for-the-badge" alt="Standard"/>
</p>

---

> **🛡️ PART OF THE 2026 UNIFIED CORE**
> This repository is a verified component of 'The Endless March' initiative. Purified for Swift 6, zero-dependency, and engineered for maximum hardware saturation.
> 
> *Flagship Engines:* [SwiftNetwork](https://github.com/muhittincamdali/SwiftNetwork) | [SwiftAI](https://github.com/muhittincamdali/SwiftAI) | [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit)

---

<p align="center">
  <img src="https://raw.githubusercontent.com/nicklockwood/SwiftFormat/main/EditorExtension/Assets.xcassets/AppIcon.appiconset/icon1024.png" width="120" height="120" alt="GestureKit Icon">
</p>

<h1 align="center">GestureKit</h1>

<p align="center">
  <strong>The most comprehensive gesture library for SwiftUI</strong><br>
  25+ gesture types • Shape recognition • Recording & playback • Full accessibility
</p>

<p align="center">
  <a href="https://github.com/muhamm3t-cap/SwiftUI-Gesture-Library/actions">
    <img src="https://img.shields.io/badge/build-passing-brightgreen?style=flat-square" alt="Build Status">
  </a>
  <a href="https://swift.org">
    <img src="https://img.shields.io/badge/Swift-5.9+-orange?style=flat-square&logo=swift" alt="Swift 5.9+">
  </a>
  <a href="https://developer.apple.com/ios/">
    <img src="https://img.shields.io/badge/iOS-15.0+-blue?style=flat-square&logo=apple" alt="iOS 15.0+">
  </a>
  <a href="https://developer.apple.com/macos/">
    <img src="https://img.shields.io/badge/macOS-13.0+-blue?style=flat-square&logo=apple" alt="macOS 13.0+">
  </a>
  <a href="https://developer.apple.com/visionos/">
    <img src="https://img.shields.io/badge/visionOS-1.0+-purple?style=flat-square&logo=apple" alt="visionOS 1.0+">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="MIT License">
  </a>
</p>

---

## ✨ Features

| Category | Gestures |
|----------|----------|
| **Basic** | Tap, Double Tap, Triple Tap, Long Press (with progress) |
| **Swipe** | All directions, Multi-direction, Edge Swipe |
| **Transform** | Pinch, Rotation, Pan with velocity, Bounded Drag |
| **Multi-finger** | Two-finger tap, Three-finger tap, Two-finger drag |
| **Advanced** | Shape Recognition, Gesture Sequences, Force Touch, Hover |
| **Motion** | Shake Detection, Tilt (accelerometer-based) |
| **Tools** | Debugger Overlay, Recording/Playback, Haptic Integration |

### 🎯 Shape Recognition

Draw shapes and GestureKit recognizes them automatically:

```swift
Rectangle()
    .onShapeDrawn { result in
        print("Shape: \(result.shape)")        // .circle, .square, .triangle...
        print("Confidence: \(result.confidence)") // 0.0 - 1.0
    }
```

**Supported Shapes:** Circle, Square, Rectangle, Triangle, Line, Checkmark, Cross, Arrow, Star, Heart

### 📼 Gesture Recording & Playback

Record user gestures and replay them for tutorials, demos, or testing:

```swift
@StateObject var recorder = GestureRecorder()
@StateObject var player = GesturePlayer()

// Record
Rectangle()
    .gestureRecording(recorder: recorder)

// Playback
player.play(recording) { point, index in
    // Animate based on playback
}
```

---

## 📦 Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhamm3t-cap/SwiftUI-Gesture-Library.git", from: "2.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → Enter the URL above.

---

## 🚀 Quick Start

```swift
import GestureKit

struct ContentView: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    
    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            // Swipe gestures
            .onSwipe(.left) { print("Previous") }
            .onSwipe(.right) { print("Next") }
            // Double tap to reset
            .onDoubleTap { 
                scale = 1.0
                rotation = .zero 
            }
            // Pinch to zoom
            .onPinch { newScale in
                scale = newScale
            }
            // Rotation
            .onRotate { angle in
                rotation = angle
            }
            .scaleEffect(scale)
            .rotationEffect(rotation)
    }
}
```

---

## 📖 Gesture Reference

### Basic Gestures

```swift
// Tap variations
view.gestureKit(.tap) { /* action */ }
view.onDoubleTap { /* action */ }
view.onTripleTap { /* action */ }

// Long press with progress
view.onLongPress(
    minimumDuration: 1.0,
    onStart: { /* started pressing */ },
    onProgress: { progress in /* 0.0 to 1.0 */ },
    onComplete: { /* completed! */ }
)
```

### Swipe Gestures

```swift
// Single direction
view.onSwipe(.left, minimumDistance: 50) { print("Swiped left") }
view.onSwipe(.right) { print("Swiped right") }
view.onSwipe(.up) { print("Swiped up") }
view.onSwipe(.down) { print("Swiped down") }

// All directions
view.onSwipeAny { direction in
    print("Swiped \(direction.rawValue)")
}

// Edge swipe (like iOS back gesture)
view.onEdgeSwipe(.leading, threshold: 50) {
    print("Swiped from leading edge")
}
```

### Transform Gestures

```swift
// Pinch to zoom
view.onPinch(
    onChanged: { scale in /* during pinch */ },
    onEnded: { finalScale in /* pinch ended */ }
)

// Rotation
view.onRotate(
    onChanged: { angle in /* during rotation */ },
    onEnded: { finalAngle in /* rotation ended */ }
)

// Pan with velocity
view.onPan(
    onChanged: { translation, velocity in /* during pan */ },
    onEnded: { translation, predictedEnd in /* pan ended */ }
)

// Bounded drag
@State var offset: CGSize = .zero
view.draggable(
    offset: $offset,
    bounds: CGRect(x: -100, y: -100, width: 200, height: 200)
)

// Combined transforms (pinch + rotate + drag)
@State var scale: CGFloat = 1.0
@State var rotation: Angle = .zero
@State var offset: CGSize = .zero

view.transformable(
    scale: $scale,
    rotation: $rotation,
    offset: $offset,
    minScale: 0.5,
    maxScale: 3.0
)
```

### Multi-Finger Gestures

```swift
// Two-finger tap (iOS only)
view.onTwoFingerTap {
    print("Two fingers tapped")
}
```

### Motion Gestures (iOS)

```swift
// Shake detection
view.onShake {
    print("Device shaken!")
}

// Tilt detection
view.onTilt { direction in
    switch direction {
    case .left: print("Tilted left")
    case .right: print("Tilted right")
    case .forward: print("Tilted forward")
    case .backward: print("Tilted backward")
    case .flat: print("Flat")
    }
}
```

### Shape Drawing

```swift
view.onShapeDrawn(
    lineWidth: 3,
    lineColor: .blue,
    onDrawing: { path in
        // Track drawing in progress
        print("Points: \(path.points.count)")
    },
    onComplete: { result in
        print("Shape: \(result.shape)")
        print("Confidence: \(result.confidence)")
        print("Duration: \(result.drawDuration)s")
    }
)
```

---

## 🎨 Animation Integration

GestureKit includes 12 animation presets for gesture feedback:

```swift
@State private var animateBounce = false

Button("Tap Me") {
    animateBounce = true
}
.bounceAnimation(trigger: $animateBounce)
```

### Available Animations

| Preset | Description |
|--------|-------------|
| `.bounce` | Scale down and spring back |
| `.shake` | Horizontal shake |
| `.pulse` | Scale up with opacity |
| `.wiggle` | Rotational wiggle |
| `.rubber` | Rubber band stretch |
| `.flip` | 3D flip |
| `.glow` | Shadow glow effect |
| `.slide` | Horizontal slide |
| `.fade` | Opacity pulse |
| `.rotate` | Z-axis rotation |
| `.swing` | Pendulum swing |
| `.scale` | Scale up |

```swift
// Using presets
view.gestureAnimation(.bounce, trigger: $trigger)
view.gestureAnimation(.shake, trigger: $trigger)
view.gestureAnimation(.wiggle, trigger: $trigger)

// With configuration
view.bounceAnimation(
    trigger: $trigger,
    scale: 0.85,
    config: .init(duration: 0.4, autoreverses: true)
)
```

---

## 📳 Haptic Feedback

Built-in haptic feedback for all gestures:

```swift
// Enable/disable globally
GestureKit.hapticsEnabled = true

// Manual haptics
HapticEngine.impact(.light)
HapticEngine.impact(.medium)
HapticEngine.impact(.heavy)
HapticEngine.notification(.success)
HapticEngine.notification(.warning)
HapticEngine.notification(.error)
HapticEngine.selection()

// Custom patterns
HapticEngine.playPattern(.heartbeat)
HapticEngine.playPattern(.celebration)
HapticEngine.playPattern(.doubleTap)

// View modifiers
view.hapticOnTap(.medium)
view.hapticOnLongPress(.heavy)
```

---

## 🔧 Debugger Overlay

Visual debugging for gesture development:

```swift
ContentView()
    .enableGestureDebug(true)
    .gestureDebuggerOverlay(
        position: .bottomTrailing,
        showTouches: true,
        touchColor: .blue
    )
```

Features:
- Real-time gesture event log
- Touch point visualization
- Gesture state tracking
- Export logs for analysis

---

## ♿️ Accessibility

GestureKit provides full accessibility support:

```swift
// Accessible gestures with alternatives
view.accessibleSwipe(.left, label: "Go back") {
    navigateBack()
}

view.accessibleDoubleTap(label: "Zoom in") {
    zoomIn()
}

view.accessibleLongPress(label: "Show options") {
    showOptions()
}

// Respects reduced motion
view.accessibleAnimation(.spring(), value: isActive)

// VoiceOver announcements
VoiceOverAnnouncement.gestureCompleted("Swipe")
VoiceOverAnnouncement.shapeRecognized(.circle)
```

---

## 📼 Recording & Playback

Record gestures for tutorials, demos, or automated testing:

```swift
@StateObject var recorder = GestureRecorder()
@StateObject var player = GesturePlayer()

var body: some View {
    VStack {
        Canvas()
            .gestureRecording(recorder: recorder, showIndicator: true)
            .gesturePlayback(
                player: player,
                recording: selectedRecording,
                pointColor: .blue
            )
        
        HStack {
            Button("Record") {
                recorder.startRecording()
            }
            
            Button("Stop") {
                if let recording = recorder.stopRecording(name: "My Gesture") {
                    // Recording saved
                }
            }
            
            Button("Play") {
                player.play(selectedRecording, speed: 1.0) { point, index in
                    // Handle each point
                } completion: {
                    // Playback complete
                }
            }
        }
    }
}
```

Features:
- Automatic persistence (UserDefaults)
- Export/import recordings
- Playback speed control
- Progress tracking
- Visual playback overlay

---

## 🔗 Gesture Sequences

Detect sequences of gestures:

```swift
@StateObject var tracker = GestureSequenceTracker()

view.onAppear {
    tracker.track(
        sequence: GestureSequence(
            name: "Secret Code",
            gestures: [.swipe(.up), .swipe(.down), .doubleTap],
            timeLimit: 3.0
        )
    ) {
        print("Secret code entered!")
    }
}
```

Built-in sequences:
- `GestureSequence.doubleTapHold`
- `GestureSequence.swipeAndTap`

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        GestureKit                           │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Core      │  │  Advanced   │  │      Tools          │  │
│  │  Gestures   │  │  Gestures   │  │                     │  │
│  ├─────────────┤  ├─────────────┤  ├─────────────────────┤  │
│  │ • Tap       │  │ • Shape     │  │ • Debugger Overlay  │  │
│  │ • Swipe     │  │   Recognition│ │ • Recorder/Player   │  │
│  │ • Pinch     │  │ • Sequences │  │ • Accessibility     │  │
│  │ • Rotation  │  │ • Shake     │  │ • Haptic Engine     │  │
│  │ • Pan       │  │ • Tilt      │  │ • Animations        │  │
│  │ • Long Press│  │ • Multi-    │  │                     │  │
│  │ • Edge Swipe│  │   finger    │  │                     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                    View Extensions                          │
│   .onSwipe() .onPinch() .onRotate() .onShapeDrawn() ...    │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS | 15.0+ |
| macOS | 13.0+ |
| tvOS | 15.0+ |
| watchOS | 8.0+ |
| visionOS | 1.0+ |

- Swift 5.9+
- Xcode 15.0+

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

GestureKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

<p align="center">
  Made with ❤️ for the SwiftUI community
</p>
