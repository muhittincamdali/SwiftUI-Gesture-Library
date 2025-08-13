# 👆 SwiftUI Gesture Library
[![CI](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/actions/workflows/ci.yml)



<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=ios&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Interface-4CAF50?style=for-the-badge)
![Gestures](https://img.shields.io/badge/Gestures-Interactive-2196F3?style=for-the-badge)
![Touch](https://img.shields.io/badge/Touch-Recognition-FF9800?style=for-the-badge)
![Drag](https://img.shields.io/badge/Drag-Drop-9C27B0?style=for-the-badge)
![Pinch](https://img.shields.io/badge/Pinch-Zoom-00BCD4?style=for-the-badge)
![Rotation](https://img.shields.io/badge/Rotation-Transform-607D8B?style=for-the-badge)
![Custom](https://img.shields.io/badge/Custom-Gestures-795548?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Clean-FF5722?style=for-the-badge)
![Swift Package Manager](https://img.shields.io/badge/SPM-Dependencies-FF6B35?style=for-the-badge)

**🏆 Professional SwiftUI Gesture Library**

**👆 Advanced Gesture Recognition & Handling**

**🎯 Interactive & Responsive User Experience**

</div>

---

## 📋 Table of Contents

- [🚀 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [👆 Basic Gestures](#-basic-gestures)
- [🔄 Advanced Gestures](#-advanced-gestures)
- [🎯 Custom Gestures](#-custom-gestures)
- [🚀 Quick Start](#-quick-start)
- [📱 Usage Examples](#-usage-examples)
- [🔧 Configuration](#-configuration)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)
- [📊 Project Statistics](#-project-statistics)
- [🌟 Stargazers](#-stargazers)

---

## 🚀 Overview

**SwiftUI Gesture Library** is the most comprehensive, professional, and feature-rich gesture recognition library for SwiftUI applications. Built with enterprise-grade standards and modern gesture handling practices, this library provides essential tools for creating interactive, responsive, and intuitive user experiences.

### 🎯 What Makes This Library Special?

- **👆 Basic Gestures**: Tap, long press, and simple touch gestures
- **🔄 Advanced Gestures**: Drag, pinch, rotation, and complex gestures
- **🎯 Custom Gestures**: Custom gesture recognition and handling
- **⚡ Performance**: Optimized for smooth gesture recognition
- **🎨 Customization**: Highly customizable gesture parameters
- **📱 Cross-Platform**: iOS, iPadOS, macOS, and watchOS support
- **♿ Accessibility**: Gesture accessibility and alternative input
- **📚 Learning**: Comprehensive gesture tutorials and examples

---

## ✨ Key Features

### 👆 Basic Gestures

* **Tap Gestures**: Single tap, double tap, and multi-tap recognition
* **Long Press Gestures**: Long press with duration and pressure control
* **Touch Gestures**: Touch down, touch up, and touch move events
* **Hover Gestures**: Mouse hover and cursor interaction
* **Keyboard Gestures**: Keyboard input and shortcut recognition
* **Voice Gestures**: Voice command and speech recognition
* **Eye Tracking**: Eye movement and gaze tracking
* **Head Tracking**: Head movement and orientation tracking

### 🔄 Advanced Gestures

* **Drag Gestures**: Drag and drop with velocity and direction
* **Pinch Gestures**: Pinch to zoom with scale and rotation
* **Rotation Gestures**: Rotation with angle and center point
* **Swipe Gestures**: Swipe with direction and distance
* **Pan Gestures**: Pan with translation and velocity
* **Scale Gestures**: Scale with factor and center point
* **Multi-Touch**: Multi-finger gesture recognition
* **Gesture Sequences**: Complex gesture sequences and combinations

### 🎯 Custom Gestures

* **Custom Recognition**: Custom gesture pattern recognition
* **Machine Learning**: ML-based gesture recognition
* **Pattern Matching**: Gesture pattern matching and validation
* **Gesture Training**: User-defined gesture training
* **Gesture Classification**: Gesture classification and categorization
* **Gesture Analytics**: Gesture usage analytics and insights
* **Gesture Optimization**: Gesture performance optimization
* **Gesture Accessibility**: Gesture accessibility features

---

## 👆 Basic Gestures

### Tap Gesture Manager

```swift
// Tap gesture manager
let tapGestureManager = TapGestureManager()

// Configure tap gestures
let tapConfig = TapGestureConfiguration()
tapConfig.enableSingleTap = true
tapConfig.enableDoubleTap = true
tapConfig.enableTripleTap = true
tapConfig.enableMultiTap = true

// Setup tap gesture manager
tapGestureManager.configure(tapConfig)

// Create single tap gesture
let singleTapGesture = SingleTapGesture(
    count: 1,
    minimumDuration: 0.1,
    maximumDuration: 0.5
)

// Add single tap gesture
tapGestureManager.addSingleTapGesture(
    to: customView,
    gesture: singleTapGesture
) { result in
    switch result {
    case .success(let tap):
        print("✅ Single tap detected")
        print("Location: \(tap.location)")
        print("Timestamp: \(tap.timestamp)")
    case .failure(let error):
        print("❌ Single tap gesture failed: \(error)")
    }
}

// Create double tap gesture
let doubleTapGesture = DoubleTapGesture(
    count: 2,
    minimumDuration: 0.1,
    maximumDuration: 0.5,
    maximumDistance: 50.0
)

// Add double tap gesture
tapGestureManager.addDoubleTapGesture(
    to: customView,
    gesture: doubleTapGesture
) { result in
    switch result {
    case .success(let tap):
        print("✅ Double tap detected")
        print("Location: \(tap.location)")
        print("Interval: \(tap.interval)s")
    case .failure(let error):
        print("❌ Double tap gesture failed: \(error)")
    }
}
```

### Long Press Gesture Manager

```swift
// Long press gesture manager
let longPressGestureManager = LongPressGestureManager()

// Configure long press gestures
let longPressConfig = LongPressGestureConfiguration()
longPressConfig.enableMinimumDuration = true
longPressConfig.enableMaximumDistance = true
longPressConfig.enablePressureSensitivity = true
longPressConfig.enableHapticFeedback = true

// Setup long press gesture manager
longPressGestureManager.configure(longPressConfig)

// Create long press gesture
let longPressGesture = LongPressGesture(
    minimumDuration: 0.5,
    maximumDistance: 10.0,
    pressureSensitivity: 0.5
)

// Add long press gesture
longPressGestureManager.addLongPressGesture(
    to: customView,
    gesture: longPressGesture
) { result in
    switch result {
    case .success(let press):
        print("✅ Long press detected")
        print("Location: \(press.location)")
        print("Duration: \(press.duration)s")
        print("Pressure: \(press.pressure)")
    case .failure(let error):
        print("❌ Long press gesture failed: \(error)")
    }
}

// Create variable long press gesture
let variableLongPressGesture = VariableLongPressGesture(
    minimumDuration: 0.3,
    maximumDuration: 2.0,
    pressureSensitivity: 0.3
)

// Add variable long press gesture
longPressGestureManager.addVariableLongPressGesture(
    to: customView,
    gesture: variableLongPressGesture
) { result in
    switch result {
    case .success(let press):
        print("✅ Variable long press detected")
        print("Duration: \(press.duration)s")
        print("Intensity: \(press.intensity)")
    case .failure(let error):
        print("❌ Variable long press gesture failed: \(error)")
    }
}
```

---

## 🔄 Advanced Gestures

### Drag Gesture Manager

```swift
// Drag gesture manager
let dragGestureManager = DragGestureManager()

// Configure drag gestures
let dragConfig = DragGestureConfiguration()
dragConfig.enableTranslation = true
dragConfig.enableVelocity = true
dragConfig.enableDirection = true
dragConfig.enableDistance = true

// Setup drag gesture manager
dragGestureManager.configure(dragConfig)

// Create drag gesture
let dragGesture = DragGesture(
    minimumDistance: 10.0,
    coordinateSpace: .local
)

// Add drag gesture
dragGestureManager.addDragGesture(
    to: customView,
    gesture: dragGesture
) { result in
    switch result {
    case .success(let drag):
        print("✅ Drag gesture detected")
        print("Translation: \(drag.translation)")
        print("Velocity: \(drag.velocity)")
        print("Direction: \(drag.direction)")
        print("Distance: \(drag.distance)")
    case .failure(let error):
        print("❌ Drag gesture failed: \(error)")
    }
}

// Create constrained drag gesture
let constrainedDragGesture = ConstrainedDragGesture(
    minimumDistance: 10.0,
    maximumDistance: 200.0,
    allowedDirections: [.horizontal, .vertical]
)

// Add constrained drag gesture
dragGestureManager.addConstrainedDragGesture(
    to: customView,
    gesture: constrainedDragGesture
) { result in
    switch result {
    case .success(let drag):
        print("✅ Constrained drag detected")
        print("Translation: \(drag.translation)")
        print("Direction: \(drag.direction)")
        print("IsConstrained: \(drag.isConstrained)")
    case .failure(let error):
        print("❌ Constrained drag gesture failed: \(error)")
    }
}
```

### Pinch Gesture Manager

```swift
// Pinch gesture manager
let pinchGestureManager = PinchGestureManager()

// Configure pinch gestures
let pinchConfig = PinchGestureConfiguration()
pinchConfig.enableScale = true
pinchConfig.enableRotation = true
pinchConfig.enableCenter = true
pinchConfig.enableVelocity = true

// Setup pinch gesture manager
pinchGestureManager.configure(pinchConfig)

// Create pinch gesture
let pinchGesture = PinchGesture(
    minimumScale: 0.5,
    maximumScale: 3.0,
    coordinateSpace: .local
)

// Add pinch gesture
pinchGestureManager.addPinchGesture(
    to: customView,
    gesture: pinchGesture
) { result in
    switch result {
    case .success(let pinch):
        print("✅ Pinch gesture detected")
        print("Scale: \(pinch.scale)")
        print("Rotation: \(pinch.rotation)°")
        print("Center: \(pinch.center)")
        print("Velocity: \(pinch.velocity)")
    case .failure(let error):
        print("❌ Pinch gesture failed: \(error)")
    }
}

// Create zoom pinch gesture
let zoomPinchGesture = ZoomPinchGesture(
    minimumScale: 0.1,
    maximumScale: 10.0,
    zoomFactor: 1.5
)

// Add zoom pinch gesture
pinchGestureManager.addZoomPinchGesture(
    to: customView,
    gesture: zoomPinchGesture
) { result in
    switch result {
    case .success(let pinch):
        print("✅ Zoom pinch detected")
        print("Scale: \(pinch.scale)")
        print("Zoom Level: \(pinch.zoomLevel)")
        print("Is Zooming: \(pinch.isZooming)")
    case .failure(let error):
        print("❌ Zoom pinch gesture failed: \(error)")
    }
}
```

### Rotation Gesture Manager

```swift
// Rotation gesture manager
let rotationGestureManager = RotationGestureManager()

// Configure rotation gestures
let rotationConfig = RotationGestureConfiguration()
rotationConfig.enableAngle = true
rotationConfig.enableCenter = true
rotationConfig.enableVelocity = true
rotationConfig.enableDirection = true

// Setup rotation gesture manager
rotationGestureManager.configure(rotationConfig)

// Create rotation gesture
let rotationGesture = RotationGesture(
    minimumAngle: 5.0,
    maximumAngle: 360.0,
    coordinateSpace: .local
)

// Add rotation gesture
rotationGestureManager.addRotationGesture(
    to: customView,
    gesture: rotationGesture
) { result in
    switch result {
    case .success(let rotation):
        print("✅ Rotation gesture detected")
        print("Angle: \(rotation.angle)°")
        print("Center: \(rotation.center)")
        print("Velocity: \(rotation.velocity)")
        print("Direction: \(rotation.direction)")
    case .failure(let error):
        print("❌ Rotation gesture failed: \(error)")
    }
}

// Create constrained rotation gesture
let constrainedRotationGesture = ConstrainedRotationGesture(
    minimumAngle: 10.0,
    maximumAngle: 180.0,
    snapToAngles: [0, 45, 90, 135, 180]
)

// Add constrained rotation gesture
rotationGestureManager.addConstrainedRotationGesture(
    to: customView,
    gesture: constrainedRotationGesture
) { result in
    switch result {
    case .success(let rotation):
        print("✅ Constrained rotation detected")
        print("Angle: \(rotation.angle)°")
        print("Snapped Angle: \(rotation.snappedAngle)°")
        print("Is Snapped: \(rotation.isSnapped)")
    case .failure(let error):
        print("❌ Constrained rotation gesture failed: \(error)")
    }
}
```

---

## 🎯 Custom Gestures

### Custom Gesture Manager

```swift
// Custom gesture manager
let customGestureManager = CustomGestureManager()

// Configure custom gestures
let customConfig = CustomGestureConfiguration()
customConfig.enablePatternRecognition = true
customConfig.enableMachineLearning = true
customConfig.enableGestureTraining = true
customConfig.enableGestureClassification = true

// Setup custom gesture manager
customGestureManager.configure(customConfig)

// Create custom gesture pattern
let customGesturePattern = CustomGesturePattern(
    name: "Circle Gesture",
    points: circlePoints,
    tolerance: 0.1
)

// Add custom gesture
customGestureManager.addCustomGesture(
    to: customView,
    pattern: customGesturePattern
) { result in
    switch result {
    case .success(let gesture):
        print("✅ Custom gesture detected")
        print("Pattern: \(gesture.pattern)")
        print("Confidence: \(gesture.confidence)%")
        print("Duration: \(gesture.duration)s")
    case .failure(let error):
        print("❌ Custom gesture failed: \(error)")
    }
}

// Create ML-based gesture
let mlGesture = MLGesture(
    model: "gesture_classifier",
    confidence: 0.8,
    categories: ["swipe", "circle", "square", "triangle"]
)

// Add ML gesture
customGestureManager.addMLGesture(
    to: customView,
    gesture: mlGesture
) { result in
    switch result {
    case .success(let gesture):
        print("✅ ML gesture detected")
        print("Category: \(gesture.category)")
        print("Confidence: \(gesture.confidence)%")
        print("All predictions: \(gesture.allPredictions)")
    case .failure(let error):
        print("❌ ML gesture failed: \(error)")
    }
}
```

### Gesture Training Manager

```swift
// Gesture training manager
let gestureTrainingManager = GestureTrainingManager()

// Configure gesture training
let trainingConfig = GestureTrainingConfiguration()
trainingConfig.enableUserTraining = true
trainingConfig.enableGestureValidation = true
trainingConfig.enableGestureOptimization = true
trainingConfig.enableGestureAnalytics = true

// Setup gesture training manager
gestureTrainingManager.configure(trainingConfig)

// Train custom gesture
gestureTrainingManager.trainGesture(
    name: "My Custom Gesture",
    samples: gestureSamples,
    category: "navigation"
) { result in
    switch result {
    case .success(let training):
        print("✅ Gesture training completed")
        print("Accuracy: \(training.accuracy)%")
        print("Samples: \(training.samples)")
        print("Duration: \(training.duration)s")
    case .failure(let error):
        print("❌ Gesture training failed: \(error)")
    }
}

// Validate gesture
gestureTrainingManager.validateGesture(
    name: "My Custom Gesture",
    testSamples: testSamples
) { result in
    switch result {
    case .success(let validation):
        print("✅ Gesture validation completed")
        print("Precision: \(validation.precision)")
        print("Recall: \(validation.recall)")
        print("F1 Score: \(validation.f1Score)")
    case .failure(let error):
        print("❌ Gesture validation failed: \(error)")
    }
}
```

---

## 🚀 Quick Start

### Prerequisites

* **iOS 15.0+** with iOS 15.0+ SDK
* **Swift 5.9+** programming language
* **Xcode 15.0+** development environment
* **Git** version control system
* **Swift Package Manager** for dependency management

### Installation

```bash
# Clone the repository
git clone https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git

# Navigate to project directory
cd SwiftUI-Gesture-Library

# Install dependencies
swift package resolve

# Open in Xcode
open Package.swift
```

### Swift Package Manager

Add the framework to your project:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Gesture-Library.git", from: "1.0.0")
]
```

### Basic Setup

```swift
import SwiftUIGestureLibrary

// Initialize gesture library manager
let gestureLibraryManager = GestureLibraryManager()

// Configure gesture library
let gestureConfig = GestureLibraryConfiguration()
gestureConfig.enableBasicGestures = true
gestureConfig.enableAdvancedGestures = true
gestureConfig.enableCustomGestures = true
gestureConfig.enableAccessibility = true

// Start gesture library manager
gestureLibraryManager.start(with: gestureConfig)

// Configure gesture performance
gestureLibraryManager.configurePerformance { config in
    config.enableSmoothRecognition = true
    config.enableReducedLatency = true
    config.enableAccessibility = true
}
```

---

## 📱 Usage Examples

### Simple Tap Gesture

```swift
// Simple tap gesture
let simpleTap = SimpleTapGesture()

// Create tap gesture
simpleTap.createTapGesture(
    count: 1,
    duration: 0.5
) { result in
    switch result {
    case .success(let tap):
        print("✅ Tap detected")
        print("Location: \(tap.location)")
    case .failure(let error):
        print("❌ Tap gesture failed: \(error)")
    }
}
```

### Simple Drag Gesture

```swift
// Simple drag gesture
let simpleDrag = SimpleDragGesture()

// Create drag gesture
simpleDrag.createDragGesture(
    minimumDistance: 10.0
) { result in
    switch result {
    case .success(let drag):
        print("✅ Drag detected")
        print("Translation: \(drag.translation)")
    case .failure(let error):
        print("❌ Drag gesture failed: \(error)")
    }
}
```

---

## 🔧 Configuration

### Gesture Library Configuration

```swift
// Configure gesture library settings
let gestureConfig = GestureLibraryConfiguration()

// Enable gesture types
gestureConfig.enableBasicGestures = true
gestureConfig.enableAdvancedGestures = true
gestureConfig.enableCustomGestures = true
gestureConfig.enableAccessibility = true

// Set basic gesture settings
gestureConfig.enableSingleTap = true
gestureConfig.enableDoubleTap = true
gestureConfig.enableLongPress = true
gestureConfig.enableTouchEvents = true

// Set advanced gesture settings
gestureConfig.enableDrag = true
gestureConfig.enablePinch = true
gestureConfig.enableRotation = true
gestureConfig.enableSwipe = true

// Set custom gesture settings
gestureConfig.enablePatternRecognition = true
gestureConfig.enableMachineLearning = true
gestureConfig.enableGestureTraining = true
gestureConfig.enableGestureClassification = true

// Apply configuration
gestureLibraryManager.configure(gestureConfig)
```

---

## 📚 Documentation

### API Documentation

Comprehensive API documentation is available for all public interfaces:

* [Gesture Library Manager API](Documentation/GestureLibraryManagerAPI.md) - Core gesture functionality
* [Basic Gestures API](Documentation/BasicGesturesAPI.md) - Basic gesture features
* [Advanced Gestures API](Documentation/AdvancedGesturesAPI.md) - Advanced gesture capabilities
* [Custom Gestures API](Documentation/CustomGesturesAPI.md) - Custom gesture features
* [Gesture Training API](Documentation/GestureTrainingAPI.md) - Gesture training capabilities
* [Performance API](Documentation/PerformanceAPI.md) - Performance optimization
* [Configuration API](Documentation/ConfigurationAPI.md) - Configuration options
* [Accessibility API](Documentation/AccessibilityAPI.md) - Accessibility features

### Integration Guides

* [Getting Started Guide](Documentation/GettingStarted.md) - Quick start tutorial
* [Basic Gestures Guide](Documentation/BasicGesturesGuide.md) - Basic gesture setup
* [Advanced Gestures Guide](Documentation/AdvancedGesturesGuide.md) - Advanced gesture setup
* [Custom Gestures Guide](Documentation/CustomGesturesGuide.md) - Custom gesture setup
* [Gesture Training Guide](Documentation/GestureTrainingGuide.md) - Gesture training setup
* [Performance Guide](Documentation/PerformanceGuide.md) - Performance optimization
* [Accessibility Guide](Documentation/AccessibilityGuide.md) - Accessibility features
* [Gesture Best Practices Guide](Documentation/GestureBestPracticesGuide.md) - Gesture best practices

### Examples

* [Basic Examples](Examples/BasicExamples/) - Simple gesture implementations
* [Advanced Examples](Examples/AdvancedExamples/) - Complex gesture scenarios
* [Basic Gestures Examples](Examples/BasicGesturesExamples/) - Basic gesture examples
* [Advanced Gestures Examples](Examples/AdvancedGesturesExamples/) - Advanced gesture examples
* [Custom Gestures Examples](Examples/CustomGesturesExamples/) - Custom gesture examples
* [Training Examples](Examples/TrainingExamples/) - Gesture training examples

---

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Development Setup

1. **Fork** the repository
2. **Create feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open Pull Request**

### Code Standards

* Follow Swift API Design Guidelines
* Maintain 100% test coverage
* Use meaningful commit messages
* Update documentation as needed
* Follow gesture best practices
* Implement proper error handling
* Add comprehensive examples

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

* **Apple** for the excellent iOS development platform
* **The Swift Community** for inspiration and feedback
* **All Contributors** who help improve this framework
* **Gesture Recognition Community** for best practices and standards
* **Open Source Community** for continuous innovation
* **iOS Developer Community** for gesture insights
* **UX/UI Community** for interaction expertise

---

**⭐ Star this repository if it helped you!**

---

## 📊 Project Statistics

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/network)
[![GitHub issues](https://img.shields.io/github/issues/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/pulls)
[![GitHub contributors](https://img.shields.io/github/contributors/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/graphs/contributors)
[![GitHub last commit](https://img.shields.io/github/last-commit/muhittincamdali/SwiftUI-Gesture-Library?style=flat-square&logo=github)](https://github.com/muhittincamdali/SwiftUI-Gesture-Library/commits/master)

</div>

## 🌟 Stargazers

<div align="center">

[![GitHub stats](https://github-readme-stats.vercel.app/api?username=muhittincamdali&show_icons=true&theme=radical)](https://github.com/muhittincamdali)
[![Top Languages](https://github-readme-stats.vercel.app/api/top-langs/?username=muhittincamdali&layout=compact&theme=radical)](https://github.com/muhittincamdali)
[![Profile Views](https://komarev.com/ghpvc/?username=muhittincamdali&color=brightgreen)](https://github.com/muhittincamdali)
[![GitHub Streak](https://streak-stats.demolab.com/?user=muhittincamdali&theme=radical)](https://github.com/muhittincamdali)

</div>