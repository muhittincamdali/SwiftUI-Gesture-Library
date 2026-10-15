<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-light.svg" alt="SwiftUI Components: Ready-made SwiftUI views for iOS and macOS: buttons, cards, charts, forms and more."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="#türkçe">Türkçe</a></p>

# SwiftUI-Gesture-Library has moved

This project now lives in [SwiftUI-Components](https://github.com/muhittincamdali/SwiftUI-Components).
This repository is archived and will not receive updates.

The gesture code was folded into the `Gestures` module of SwiftUI Components:
[Sources/SwiftUIComponents/Gestures](https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Sources/SwiftUIComponents/Gestures).
It contains swipe and edge-swipe gestures, swipe sequences, a bounded drag, a combined
pinch-rotate-drag transform and shape recognition for drawn strokes.

The code was reworked while it was merged, so type names and initializers differ from this
repository's `GestureKit` target. Read the module and its
[documentation](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
before you migrate.

## Install the new package

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "2.1.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

Requires iOS 17+ or macOS 14+ and Swift 6.2+.

## Türkçe

**Bu proje artık [SwiftUI-Components](https://github.com/muhittincamdali/SwiftUI-Components) içinde.**
Bu depo arşivlendi ve güncellenmeyecek.

Jest kodu, SwiftUI Components paketinin `Gestures` modülüne taşındı:
[Sources/SwiftUIComponents/Gestures](https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Sources/SwiftUIComponents/Gestures).
Kaydırma ve kenar kaydırma, kaydırma dizileri, sınırlı sürükleme, tek jestte
yakınlaştırma-döndürme-sürükleme ve çizilen şekilleri tanıma burada.

Kod taşınırken yeniden düzenlendi; tür adları ve başlatıcılar bu depodaki `GestureKit`
hedefinden farklıdır. Geçiş yapmadan önce modülü ve
[belgeleri](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/) okuyun.

Kurulum için yukarıdaki Swift Package Manager satırlarını kullanın. iOS 17+ veya macOS 14+ ve
Swift 6.2+ gerekir.
