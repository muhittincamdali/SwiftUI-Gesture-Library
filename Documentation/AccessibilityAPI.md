# Accessibility API Reference

Complete API reference for accessibility functionality in SwiftUI Gesture Library.

## Overview

The Accessibility API provides comprehensive tools for making gesture recognition accessible to users with disabilities. This API enables developers to create inclusive gesture recognition systems that work with assistive technologies and provide alternative input methods.

## Core Components

### AccessibilityManager

Manages accessibility features and assistive technology integration.

```swift
public class AccessibilityManager: ObservableObject {
    public init(configuration: AccessibilityConfiguration = .default)
    public func enableVoiceOver()
    public func enableSwitchControl()
    public func enableAssistiveTouch()
    public func enableAlternativeInput()
    public func getAccessibilityStatus() -> AccessibilityStatus
    public func updateAccessibilitySettings(_ settings: AccessibilitySettings)
}
```

### VoiceOverGestureRecognizer

Recognizes gestures specifically designed for VoiceOver users.

```swift
public class VoiceOverGestureRecognizer: GestureRecognizer {
    public init(configuration: VoiceOverConfiguration = .default)
    public func getVoiceOverGesture() -> VoiceOverGesture?
    public func getAccessibilityLabel() -> String?
    public func getAccessibilityHint() -> String?
    public func getAccessibilityTraits() -> AccessibilityTraits
}
```

### SwitchControlGestureRecognizer

Recognizes gestures designed for Switch Control users.

```swift
public class SwitchControlGestureRecognizer: GestureRecognizer {
    public init(configuration: SwitchControlConfiguration = .default)
    public func getSwitchControlGesture() -> SwitchControlGesture?
    public func getSwitchControlOptions() -> [SwitchControlOption]
    public func getSwitchControlTiming() -> SwitchControlTiming
}
```

### AssistiveTouchGestureRecognizer

Recognizes gestures designed for AssistiveTouch users.

```swift
public class AssistiveTouchGestureRecognizer: GestureRecognizer {
    public init(configuration: AssistiveTouchConfiguration = .default)
    public func getAssistiveTouchGesture() -> AssistiveTouchGesture?
    public func getAssistiveTouchOptions() -> [AssistiveTouchOption]
    public func getAssistiveTouchSensitivity() -> CGFloat
}
```

## Configuration Types

### AccessibilityConfiguration

```swift
public struct AccessibilityConfiguration {
    public let enableVoiceOver: Bool
    public let enableSwitchControl: Bool
    public let enableAssistiveTouch: Bool
    public let enableAlternativeInput: Bool
    public let enableGestureModification: Bool
    public let enableHapticGuidance: Bool
    public let enableAudioFeedback: Bool
    public let enableVisualIndicators: Bool
    public let enableLargeText: Bool
    public let enableHighContrast: Bool
    public let enableReduceMotion: Bool
    
    public static let `default` = AccessibilityConfiguration(
        enableVoiceOver: true,
        enableSwitchControl: true,
        enableAssistiveTouch: true,
        enableAlternativeInput: true,
        enableGestureModification: true,
        enableHapticGuidance: true,
        enableAudioFeedback: true,
        enableVisualIndicators: true,
        enableLargeText: true,
        enableHighContrast: true,
        enableReduceMotion: true
    )
}
```

### VoiceOverConfiguration

```swift
public struct VoiceOverConfiguration {
    public let enableVoiceOverGestures: Bool
    public let enableVoiceOverNavigation: Bool
    public let enableVoiceOverAnnouncements: Bool
    public let enableVoiceOverHints: Bool
    public let enableVoiceOverLabels: Bool
    public let enableVoiceOverTraits: Bool
    public let enableVoiceOverActions: Bool
    
    public static let `default` = VoiceOverConfiguration(
        enableVoiceOverGestures: true,
        enableVoiceOverNavigation: true,
        enableVoiceOverAnnouncements: true,
        enableVoiceOverHints: true,
        enableVoiceOverLabels: true,
        enableVoiceOverTraits: true,
        enableVoiceOverActions: true
    )
}
```

### SwitchControlConfiguration

```swift
public struct SwitchControlConfiguration {
    public let enableSwitchControlGestures: Bool
    public let enableSwitchControlScanning: Bool
    public let enableSwitchControlTiming: Bool
    public let enableSwitchControlOptions: Bool
    public let enableSwitchControlNavigation: Bool
    public let enableSwitchControlActions: Bool
    
    public static let `default` = SwitchControlConfiguration(
        enableSwitchControlGestures: true,
        enableSwitchControlScanning: true,
        enableSwitchControlTiming: true,
        enableSwitchControlOptions: true,
        enableSwitchControlNavigation: true,
        enableSwitchControlActions: true
    )
}
```

### AssistiveTouchConfiguration

```swift
public struct AssistiveTouchConfiguration {
    public let enableAssistiveTouchGestures: Bool
    public let enableAssistiveTouchMenu: Bool
    public let enableAssistiveTouchCustomization: Bool
    public let enableAssistiveTouchSensitivity: Bool
    public let enableAssistiveTouchOptions: Bool
    public let enableAssistiveTouchActions: Bool
    
    public static let `default` = AssistiveTouchConfiguration(
        enableAssistiveTouchGestures: true,
        enableAssistiveTouchMenu: true,
        enableAssistiveTouchCustomization: true,
        enableAssistiveTouchSensitivity: true,
        enableAssistiveTouchOptions: true,
        enableAssistiveTouchActions: true
    )
}
```

## Data Models

### AccessibilityStatus

```swift
public struct AccessibilityStatus {
    public let voiceOverEnabled: Bool
    public let switchControlEnabled: Bool
    public let assistiveTouchEnabled: Bool
    public let alternativeInputEnabled: Bool
    public let gestureModificationEnabled: Bool
    public let hapticGuidanceEnabled: Bool
    public let audioFeedbackEnabled: Bool
    public let visualIndicatorsEnabled: Bool
    public let largeTextEnabled: Bool
    public let highContrastEnabled: Bool
    public let reduceMotionEnabled: Bool
    public let metadata: [String: Any]
    
    public init(voiceOverEnabled: Bool, switchControlEnabled: Bool, assistiveTouchEnabled: Bool, alternativeInputEnabled: Bool, gestureModificationEnabled: Bool, hapticGuidanceEnabled: Bool, audioFeedbackEnabled: Bool, visualIndicatorsEnabled: Bool, largeTextEnabled: Bool, highContrastEnabled: Bool, reduceMotionEnabled: Bool, metadata: [String: Any] = [:])
}
```

### AccessibilitySettings

```swift
public struct AccessibilitySettings {
    public let voiceOverSettings: VoiceOverSettings
    public let switchControlSettings: SwitchControlSettings
    public let assistiveTouchSettings: AssistiveTouchSettings
    public let alternativeInputSettings: AlternativeInputSettings
    public let gestureModificationSettings: GestureModificationSettings
    public let hapticGuidanceSettings: HapticGuidanceSettings
    public let audioFeedbackSettings: AudioFeedbackSettings
    public let visualIndicatorSettings: VisualIndicatorSettings
    
    public init(voiceOverSettings: VoiceOverSettings, switchControlSettings: SwitchControlSettings, assistiveTouchSettings: AssistiveTouchSettings, alternativeInputSettings: AlternativeInputSettings, gestureModificationSettings: GestureModificationSettings, hapticGuidanceSettings: HapticGuidanceSettings, audioFeedbackSettings: AudioFeedbackSettings, visualIndicatorSettings: VisualIndicatorSettings)
}
```

### VoiceOverGesture

```swift
public struct VoiceOverGesture {
    public let type: VoiceOverGestureType
    public let label: String
    public let hint: String?
    public let traits: AccessibilityTraits
    public let actions: [AccessibilityAction]
    public let metadata: [String: Any]
    
    public init(type: VoiceOverGestureType, label: String, hint: String? = nil, traits: AccessibilityTraits = [], actions: [AccessibilityAction] = [], metadata: [String: Any] = [:])
}
```

### SwitchControlGesture

```swift
public struct SwitchControlGesture {
    public let type: SwitchControlGestureType
    public let options: [SwitchControlOption]
    public let timing: SwitchControlTiming
    public let navigation: SwitchControlNavigation
    public let actions: [AccessibilityAction]
    public let metadata: [String: Any]
    
    public init(type: SwitchControlGestureType, options: [SwitchControlOption], timing: SwitchControlTiming, navigation: SwitchControlNavigation, actions: [AccessibilityAction] = [], metadata: [String: Any] = [:])
}
```

### AssistiveTouchGesture

```swift
public struct AssistiveTouchGesture {
    public let type: AssistiveTouchGestureType
    public let options: [AssistiveTouchOption]
    public let sensitivity: CGFloat
    public let menu: AssistiveTouchMenu
    public let actions: [AccessibilityAction]
    public let metadata: [String: Any]
    
    public init(type: AssistiveTouchGestureType, options: [AssistiveTouchOption], sensitivity: CGFloat, menu: AssistiveTouchMenu, actions: [AccessibilityAction] = [], metadata: [String: Any] = [:])
}
```

## Enums and Types

### VoiceOverGestureType

```swift
public enum VoiceOverGestureType {
    case singleTap
    case doubleTap
    case tripleTap
    case longPress
    case swipeLeft
    case swipeRight
    case swipeUp
    case swipeDown
    case custom(String)
}
```

### SwitchControlGestureType

```swift
public enum SwitchControlGestureType {
    case singleSwitch
    case dualSwitch
    case headSwitch
    case eyeSwitch
    case custom(String)
}
```

### AssistiveTouchGestureType

```swift
public enum AssistiveTouchGestureType {
    case singleTap
    case doubleTap
    case longPress
    case swipe
    case pinch
    case rotation
    case custom(String)
}
```

### AccessibilityTraits

```swift
public struct AccessibilityTraits: OptionSet {
    public let rawValue: UInt64
    
    public static let button = AccessibilityTraits(rawValue: 1 << 0)
    public static let link = AccessibilityTraits(rawValue: 1 << 1)
    public static let image = AccessibilityTraits(rawValue: 1 << 2)
    public static let text = AccessibilityTraits(rawValue: 1 << 3)
    public static let searchField = AccessibilityTraits(rawValue: 1 << 4)
    public static let keyboardKey = AccessibilityTraits(rawValue: 1 << 5)
    public static let staticText = AccessibilityTraits(rawValue: 1 << 6)
    public static let header = AccessibilityTraits(rawValue: 1 << 7)
    public static let tabBar = AccessibilityTraits(rawValue: 1 << 8)
    public static let selected = AccessibilityTraits(rawValue: 1 << 9)
    public static let notEnabled = AccessibilityTraits(rawValue: 1 << 10)
    public static let updatesFrequently = AccessibilityTraits(rawValue: 1 << 11)
    public static let startsMediaSession = AccessibilityTraits(rawValue: 1 << 12)
    public static let adjustable = AccessibilityTraits(rawValue: 1 << 13)
    public static let allowsDirectInteraction = AccessibilityTraits(rawValue: 1 << 14)
    public static let causesPageTurn = AccessibilityTraits(rawValue: 1 << 15)
}
```

### AccessibilityAction

```swift
public struct AccessibilityAction {
    public let name: String
    public let handler: () -> Void
    public let isDefault: Bool
    public let isDestructive: Bool
    
    public init(name: String, handler: @escaping () -> Void, isDefault: Bool = false, isDestructive: Bool = false)
}
```

## Usage Examples

### Basic Accessibility Setup

```swift
// Create accessibility manager
let accessibilityManager = AccessibilityManager(
    configuration: AccessibilityConfiguration(
        enableVoiceOver: true,
        enableSwitchControl: true,
        enableAssistiveTouch: true,
        enableAlternativeInput: true,
        enableGestureModification: true,
        enableHapticGuidance: true,
        enableAudioFeedback: true,
        enableVisualIndicators: true,
        enableLargeText: true,
        enableHighContrast: true,
        enableReduceMotion: true
    )
)

// Enable accessibility features
accessibilityManager.enableVoiceOver()
accessibilityManager.enableSwitchControl()
accessibilityManager.enableAssistiveTouch()
accessibilityManager.enableAlternativeInput()

// Get accessibility status
let status = accessibilityManager.getAccessibilityStatus()
print("VoiceOver enabled: \(status.voiceOverEnabled)")
print("Switch Control enabled: \(status.switchControlEnabled)")
print("AssistiveTouch enabled: \(status.assistiveTouchEnabled)")
```

### VoiceOver Gesture Recognition

```swift
// Create VoiceOver gesture recognizer
let voiceOverRecognizer = VoiceOverGestureRecognizer(
    configuration: VoiceOverConfiguration(
        enableVoiceOverGestures: true,
        enableVoiceOverNavigation: true,
        enableVoiceOverAnnouncements: true,
        enableVoiceOverHints: true,
        enableVoiceOverLabels: true,
        enableVoiceOverTraits: true,
        enableVoiceOverActions: true
    )
)

voiceOverRecognizer.delegate = self
gestureEngine.registerRecognizer(voiceOverRecognizer)

// Handle VoiceOver gesture events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let voiceOverResult = gesture as? VoiceOverGestureResult {
        print("VoiceOver gesture detected")
        print("Type: \(voiceOverResult.gesture?.type)")
        print("Label: \(voiceOverResult.gesture?.label)")
        print("Hint: \(voiceOverResult.gesture?.hint)")
        
        // Announce gesture to VoiceOver
        UIAccessibility.post(notification: .announcement, argument: voiceOverResult.gesture?.label)
    }
}
```

### Switch Control Gesture Recognition

```swift
// Create Switch Control gesture recognizer
let switchControlRecognizer = SwitchControlGestureRecognizer(
    configuration: SwitchControlConfiguration(
        enableSwitchControlGestures: true,
        enableSwitchControlScanning: true,
        enableSwitchControlTiming: true,
        enableSwitchControlOptions: true,
        enableSwitchControlNavigation: true,
        enableSwitchControlActions: true
    )
)

switchControlRecognizer.delegate = self
gestureEngine.registerRecognizer(switchControlRecognizer)

// Handle Switch Control gesture events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let switchControlResult = gesture as? SwitchControlGestureResult {
        print("Switch Control gesture detected")
        print("Type: \(switchControlResult.gesture?.type)")
        print("Options: \(switchControlResult.gesture?.options.count ?? 0)")
        print("Timing: \(switchControlResult.gesture?.timing)")
        
        // Handle Switch Control navigation
        handleSwitchControlNavigation(switchControlResult.gesture)
    }
}
```

### AssistiveTouch Gesture Recognition

```swift
// Create AssistiveTouch gesture recognizer
let assistiveTouchRecognizer = AssistiveTouchGestureRecognizer(
    configuration: AssistiveTouchConfiguration(
        enableAssistiveTouchGestures: true,
        enableAssistiveTouchMenu: true,
        enableAssistiveTouchCustomization: true,
        enableAssistiveTouchSensitivity: true,
        enableAssistiveTouchOptions: true,
        enableAssistiveTouchActions: true
    )
)

assistiveTouchRecognizer.delegate = self
gestureEngine.registerRecognizer(assistiveTouchRecognizer)

// Handle AssistiveTouch gesture events
func gestureRecognizer(_ recognizer: GestureRecognizer, didRecognize gesture: GestureResult) {
    if let assistiveTouchResult = gesture as? AssistiveTouchGestureResult {
        print("AssistiveTouch gesture detected")
        print("Type: \(assistiveTouchResult.gesture?.type)")
        print("Sensitivity: \(assistiveTouchResult.gesture?.sensitivity)")
        print("Options: \(assistiveTouchResult.gesture?.options.count ?? 0)")
        
        // Handle AssistiveTouch menu
        handleAssistiveTouchMenu(assistiveTouchResult.gesture)
    }
}
```

### Accessibility Settings Management

```swift
// Create accessibility settings
let settings = AccessibilitySettings(
    voiceOverSettings: VoiceOverSettings(
        enableGestures: true,
        enableNavigation: true,
        enableAnnouncements: true,
        enableHints: true,
        enableLabels: true,
        enableTraits: true,
        enableActions: true
    ),
    switchControlSettings: SwitchControlSettings(
        enableGestures: true,
        enableScanning: true,
        enableTiming: true,
        enableOptions: true,
        enableNavigation: true,
        enableActions: true
    ),
    assistiveTouchSettings: AssistiveTouchSettings(
        enableGestures: true,
        enableMenu: true,
        enableCustomization: true,
        enableSensitivity: true,
        enableOptions: true,
        enableActions: true
    ),
    alternativeInputSettings: AlternativeInputSettings(
        enableKeyboard: true,
        enableMouse: true,
        enableTrackpad: true,
        enableVoice: true,
        enableEyeTracking: true,
        enableHeadTracking: true
    ),
    gestureModificationSettings: GestureModificationSettings(
        enableModification: true,
        enableCustomization: true,
        enableAdaptation: true,
        enableLearning: true
    ),
    hapticGuidanceSettings: HapticGuidanceSettings(
        enableGuidance: true,
        enableFeedback: true,
        enablePatterns: true,
        enableIntensity: true
    ),
    audioFeedbackSettings: AudioFeedbackSettings(
        enableAudio: true,
        enableSpeech: true,
        enableSounds: true,
        enableVolume: true
    ),
    visualIndicatorSettings: VisualIndicatorSettings(
        enableIndicators: true,
        enableHighlights: true,
        enableContrast: true,
        enableLargeText: true
    )
)

// Update accessibility settings
accessibilityManager.updateAccessibilitySettings(settings)
```

### Accessibility Action Handling

```swift
// Create accessibility actions
let tapAction = AccessibilityAction(
    name: "Tap",
    handler: {
        print("Accessibility tap action performed")
        // Handle tap action
    },
    isDefault: true,
    isDestructive: false
)

let longPressAction = AccessibilityAction(
    name: "Long Press",
    handler: {
        print("Accessibility long press action performed")
        // Handle long press action
    },
    isDefault: false,
    isDestructive: false
)

let swipeAction = AccessibilityAction(
    name: "Swipe",
    handler: {
        print("Accessibility swipe action performed")
        // Handle swipe action
    },
    isDefault: false,
    isDestructive: false
)

// Add actions to gesture recognizer
let gestureRecognizer = CustomGestureRecognizer()
gestureRecognizer.addAccessibilityAction(tapAction)
gestureRecognizer.addAccessibilityAction(longPressAction)
gestureRecognizer.addAccessibilityAction(swipeAction)
```

### Accessibility Trait Management

```swift
// Create gesture with accessibility traits
let buttonGesture = VoiceOverGesture(
    type: .singleTap,
    label: "Submit Button",
    hint: "Double tap to submit the form",
    traits: [.button, .allowsDirectInteraction],
    actions: [
        AccessibilityAction(name: "Submit", handler: { submitForm() }, isDefault: true),
        AccessibilityAction(name: "Cancel", handler: { cancelForm() }, isDestructive: true)
    ]
)

// Create gesture with different traits
let linkGesture = VoiceOverGesture(
    type: .singleTap,
    label: "Learn More",
    hint: "Opens detailed information",
    traits: [.link, .allowsDirectInteraction],
    actions: [
        AccessibilityAction(name: "Open", handler: { openLink() }, isDefault: true)
    ]
)

let imageGesture = VoiceOverGesture(
    type: .singleTap,
    label: "Product Image",
    hint: "Shows product details",
    traits: [.image, .allowsDirectInteraction],
    actions: [
        AccessibilityAction(name: "View", handler: { viewImage() }, isDefault: true),
        AccessibilityAction(name: "Share", handler: { shareImage() })
    ]
)
```

### Accessibility Announcements

```swift
// Announce gesture recognition
func announceGesture(_ gesture: VoiceOverGesture) {
    let announcement = "\(gesture.label). \(gesture.hint ?? "")"
    UIAccessibility.post(notification: .announcement, argument: announcement)
}

// Announce gesture completion
func announceGestureCompletion(_ gesture: VoiceOverGesture) {
    let announcement = "\(gesture.label) completed"
    UIAccessibility.post(notification: .announcement, argument: announcement)
}

// Announce gesture failure
func announceGestureFailure(_ gesture: VoiceOverGesture) {
    let announcement = "\(gesture.label) failed. Please try again"
    UIAccessibility.post(notification: .announcement, argument: announcement)
}

// Announce accessibility status
func announceAccessibilityStatus(_ status: AccessibilityStatus) {
    var announcements: [String] = []
    
    if status.voiceOverEnabled {
        announcements.append("VoiceOver enabled")
    }
    
    if status.switchControlEnabled {
        announcements.append("Switch Control enabled")
    }
    
    if status.assistiveTouchEnabled {
        announcements.append("AssistiveTouch enabled")
    }
    
    let announcement = announcements.joined(separator: ". ")
    UIAccessibility.post(notification: .announcement, argument: announcement)
}
```

## Accessibility Best Practices

### VoiceOver Best Practices

- Provide clear, descriptive labels
- Include helpful hints for complex gestures
- Use appropriate accessibility traits
- Announce important state changes
- Support VoiceOver navigation

### Switch Control Best Practices

- Provide multiple input options
- Use appropriate timing settings
- Support scanning navigation
- Include clear action descriptions
- Test with different switch types

### AssistiveTouch Best Practices

- Provide customizable gestures
- Support menu navigation
- Use appropriate sensitivity settings
- Include clear visual feedback
- Support custom actions

### General Accessibility Best Practices

- Test with assistive technologies
- Provide alternative input methods
- Use appropriate contrast ratios
- Support large text sizes
- Respect reduce motion preferences

## Error Handling

### Common Accessibility Errors

```swift
public enum AccessibilityError: Error {
    case voiceOverNotAvailable
    case switchControlNotAvailable
    case assistiveTouchNotAvailable
    case alternativeInputNotAvailable
    case gestureModificationFailed
    case hapticGuidanceFailed
    case audioFeedbackFailed
    case visualIndicatorFailed
    case unsupportedPlatform
}
```

### Error Handling Example

```swift
func handleAccessibilityError(_ error: AccessibilityError) {
    switch error {
    case .voiceOverNotAvailable:
        print("VoiceOver not available on this platform")
        print("Please use alternative accessibility features")
        
    case .switchControlNotAvailable:
        print("Switch Control not available on this platform")
        print("Please use alternative input methods")
        
    case .assistiveTouchNotAvailable:
        print("AssistiveTouch not available on this platform")
        print("Please use alternative touch features")
        
    case .alternativeInputNotAvailable:
        print("Alternative input not available on this platform")
        print("Please use standard input methods")
        
    case .gestureModificationFailed:
        print("Gesture modification failed")
        print("Please check gesture configuration")
        
    case .hapticGuidanceFailed:
        print("Haptic guidance failed")
        print("Please check haptic feedback settings")
        
    case .audioFeedbackFailed:
        print("Audio feedback failed")
        print("Please check audio settings")
        
    case .visualIndicatorFailed:
        print("Visual indicator failed")
        print("Please check visual settings")
        
    case .unsupportedPlatform:
        print("Accessibility features not supported on this platform")
        print("Please use supported platform")
    }
}
```

## Platform Support

- **iOS 15.0+**: Full support for all accessibility features
- **macOS 12.0+**: Limited support (no VoiceOver, limited Switch Control)
- **tvOS 15.0+**: Limited support (focus-based accessibility)
- **watchOS 8.0+**: Limited support (crown-based accessibility)

## Accessibility Testing

### VoiceOver Testing

- Test with VoiceOver enabled
- Verify all gestures are accessible
- Check labels and hints are clear
- Test navigation flow
- Verify announcements work

### Switch Control Testing

- Test with Switch Control enabled
- Verify all options are accessible
- Check timing settings work
- Test navigation flow
- Verify actions work

### AssistiveTouch Testing

- Test with AssistiveTouch enabled
- Verify gestures are customizable
- Check menu navigation works
- Test sensitivity settings
- Verify custom actions work

### General Accessibility Testing

- Test with different accessibility settings
- Verify alternative input methods work
- Check visual indicators are clear
- Test with different text sizes
- Verify motion reduction works
