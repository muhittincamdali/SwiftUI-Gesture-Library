import SwiftUI
import SwiftUIGestureLibrary

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AccessibilityGestureExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var accessibilityMode = AccessibilityMode.voiceOver
    @State private var gestureHistory: [String] = []
    @State private var currentAction = "No action"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Accessibility mode selector
                Picker("Accessibility Mode", selection: $accessibilityMode) {
                    Text("VoiceOver").tag(AccessibilityMode.voiceOver)
                    Text("Switch Control").tag(AccessibilityMode.switchControl)
                    Text("AssistiveTouch").tag(AccessibilityMode.assistiveTouch)
                    Text("General").tag(AccessibilityMode.general)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Main accessibility gesture area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: accessibilityMode.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    VStack(spacing: 15) {
                        Image(systemName: accessibilityMode.icon)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text(accessibilityMode.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(accessibilityMode.description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .customAccessibleGesture(accessibilityMode.voiceOverHint)
                .customVoiceOverGesture(accessibilityMode.switchControlHint)
                .customTapGesture {
                    performAccessibilityAction()
                }
                .customLongPressGesture(
                    configuration: LongPressConfiguration(
                        minimumPressDuration: accessibilityMode.longPressDuration,
                        maximumPressDuration: 5.0,
                        maximumMovementDistance: 20.0,
                        enableHapticFeedback: true,
                        numberOfTouchesRequired: 1
                    )
                ) {
                    performAccessibilityAction()
                }
                .accessibilityLabel(accessibilityMode.accessibilityLabel)
                .accessibilityHint(accessibilityMode.accessibilityHint)
                .accessibilityAddTraits(accessibilityMode.accessibilityTraits)
                
                // Current action display
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Action")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(currentAction)
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // Gesture history
                VStack(alignment: .leading, spacing: 10) {
                    Text("Accessibility Gesture History")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 5) {
                            ForEach(gestureHistory.suffix(10), id: \.self) { gesture in
                                Text(gesture)
                                    .font(.caption)
                                    .padding(.horizontal)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(height: 100)
                }
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                // Accessibility controls
                HStack(spacing: 20) {
                    Button("Clear History") {
                        gestureHistory.removeAll()
                        currentAction = "No action"
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Test Haptic") {
                        hapticManager.triggerCustomFeedback(intensity: 0.8)
                        addToHistory("Haptic feedback test")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("Accessibility Gestures")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func performAccessibilityAction() {
        let action = accessibilityMode.randomAction
        currentAction = action
        addToHistory("\(accessibilityMode.title): \(action)")
        hapticManager.triggerFeedback(for: .tap)
    }
    
    private func addToHistory(_ gesture: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        gestureHistory.append("[\(timestamp)] \(gesture)")
        
        // Keep only last 30 entries
        if gestureHistory.count > 30 {
            gestureHistory.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AccessibilityMode: CaseIterable {
    case voiceOver
    case switchControl
    case assistiveTouch
    case general
    
    var title: String {
        switch self {
        case .voiceOver: return "VoiceOver"
        case .switchControl: return "Switch Control"
        case .assistiveTouch: return "AssistiveTouch"
        case .general: return "General"
        }
    }
    
    var description: String {
        switch self {
        case .voiceOver:
            return "Double tap to activate. Use VoiceOver gestures for navigation."
        case .switchControl:
            return "Long press to activate. Use switch control for selection."
        case .assistiveTouch:
            return "Tap to activate. Use AssistiveTouch for custom gestures."
        case .general:
            return "Standard accessibility gestures for all users."
        }
    }
    
    var icon: String {
        switch self {
        case .voiceOver: return "speaker.wave.2"
        case .switchControl: return "switch.2"
        case .assistiveTouch: return "hand.tap"
        case .general: return "accessibility"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .voiceOver: return [.blue, .purple]
        case .switchControl: return [.green, .blue]
        case .assistiveTouch: return [.orange, .red]
        case .general: return [.gray, .blue]
        }
    }
    
    var voiceOverHint: String {
        switch self {
        case .voiceOver: return "Double tap to activate VoiceOver gesture"
        case .switchControl: return "Long press to activate switch control gesture"
        case .assistiveTouch: return "Tap to activate AssistiveTouch gesture"
        case .general: return "Tap to activate general accessibility gesture"
        }
    }
    
    var switchControlHint: String {
        switch self {
        case .voiceOver: return "Use switch control to activate VoiceOver features"
        case .switchControl: return "Use switch control to navigate and select"
        case .assistiveTouch: return "Use switch control with AssistiveTouch"
        case .general: return "Use switch control for general navigation"
        }
    }
    
    var longPressDuration: TimeInterval {
        switch self {
        case .voiceOver: return 0.5
        case .switchControl: return 1.0
        case .assistiveTouch: return 0.8
        case .general: return 0.6
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .voiceOver: return "VoiceOver gesture area"
        case .switchControl: return "Switch control gesture area"
        case .assistiveTouch: return "AssistiveTouch gesture area"
        case .general: return "General accessibility gesture area"
        }
    }
    
    var accessibilityHint: String {
        switch self {
        case .voiceOver: return "Double tap to perform VoiceOver action"
        case .switchControl: return "Long press to perform switch control action"
        case .assistiveTouch: return "Tap to perform AssistiveTouch action"
        case .general: return "Tap to perform general accessibility action"
        }
    }
    
    var accessibilityTraits: AccessibilityTraits {
        switch self {
        case .voiceOver: return [.button, .allowsDirectInteraction]
        case .switchControl: return [.button, .allowsDirectInteraction]
        case .assistiveTouch: return [.button, .allowsDirectInteraction]
        case .general: return [.button, .allowsDirectInteraction]
        }
    }
    
    var randomAction: String {
        let actions = [
            "Activate feature",
            "Navigate to next item",
            "Select current item",
            "Perform action",
            "Execute command",
            "Trigger function",
            "Open menu",
            "Close dialog",
            "Confirm selection",
            "Cancel operation"
        ]
        return actions.randomElement() ?? "Perform action"
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct VoiceOverSpecificExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var voiceOverActions: [String] = []
    @State private var currentVoiceOverAction = "No VoiceOver action"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("VoiceOver Specific Gestures")
                .font(.title)
                .fontWeight(.bold)
            
            // VoiceOver gesture area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .shadow(radius: 10)
                
                VStack(spacing: 15) {
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text("VoiceOver Gestures")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Use VoiceOver gestures to interact")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .customAccessibleGesture("Double tap to activate VoiceOver feature")
            .customTapGesture(
                configuration: TapConfiguration(
                    numberOfTaps: 2,
                    minimumTapDuration: 0.1,
                    maximumTapDuration: 0.5,
                    maxTimeBetweenTaps: 0.3,
                    maxTapDistance: 10.0,
                    requireSameLocation: false
                )
            ) {
                performVoiceOverAction()
            }
            .accessibilityLabel("VoiceOver gesture area")
            .accessibilityHint("Double tap to activate VoiceOver features")
            .accessibilityAddTraits([.button, .allowsDirectInteraction])
            
            // VoiceOver action display
            VStack(alignment: .leading, spacing: 10) {
                Text("Current VoiceOver Action")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text(currentVoiceOverAction)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // VoiceOver action history
            VStack(alignment: .leading, spacing: 10) {
                Text("VoiceOver Action History")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(voiceOverActions.suffix(10), id: \.self) { action in
                            Text(action)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 100)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button("Clear History") {
                voiceOverActions.removeAll()
                currentVoiceOverAction = "No VoiceOver action"
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func performVoiceOverAction() {
        let actions = [
            "Read current element",
            "Navigate to next element",
            "Navigate to previous element",
            "Activate current element",
            "Open rotor menu",
            "Perform custom action",
            "Read screen content",
            "Navigate by heading",
            "Navigate by link",
            "Navigate by button"
        ]
        
        let action = actions.randomElement() ?? "Perform VoiceOver action"
        currentVoiceOverAction = action
        addToVoiceOverHistory(action)
        hapticManager.triggerFeedback(for: .tap)
    }
    
    private func addToVoiceOverHistory(_ action: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        voiceOverActions.append("[\(timestamp)] \(action)")
        
        // Keep only last 20 entries
        if voiceOverActions.count > 20 {
            voiceOverActions.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct SwitchControlExample: View {
    @StateObject private var hapticManager = HapticFeedbackManager()
    @State private var switchControlActions: [String] = []
    @State private var currentSwitchAction = "No switch control action"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Switch Control Gestures")
                .font(.title)
                .fontWeight(.bold)
            
            // Switch control gesture area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .shadow(radius: 10)
                
                VStack(spacing: 15) {
                    Image(systemName: "switch.2")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text("Switch Control")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Use switch control for navigation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .customVoiceOverGesture("Use switch control to navigate and select items")
            .customLongPressGesture(
                configuration: LongPressConfiguration(
                    minimumPressDuration: 1.0,
                    maximumPressDuration: 3.0,
                    maximumMovementDistance: 20.0,
                    enableHapticFeedback: true,
                    numberOfTouchesRequired: 1
                )
            ) {
                performSwitchControlAction()
            }
            .accessibilityLabel("Switch control gesture area")
            .accessibilityHint("Long press to perform switch control action")
            .accessibilityAddTraits([.button, .allowsDirectInteraction])
            
            // Switch control action display
            VStack(alignment: .leading, spacing: 10) {
                Text("Current Switch Control Action")
                    .font(.headline)
                    .padding(.horizontal)
                
                Text(currentSwitchAction)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Switch control action history
            VStack(alignment: .leading, spacing: 10) {
                Text("Switch Control Action History")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(switchControlActions.suffix(10), id: \.self) { action in
                            Text(action)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 100)
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button("Clear History") {
                switchControlActions.removeAll()
                currentSwitchAction = "No switch control action"
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func performSwitchControlAction() {
        let actions = [
            "Select current item",
            "Move to next item",
            "Move to previous item",
            "Activate current item",
            "Open context menu",
            "Perform custom action",
            "Navigate by group",
            "Navigate by type",
            "Perform gesture",
            "Execute command"
        ]
        
        let action = actions.randomElement() ?? "Perform switch control action"
        currentSwitchAction = action
        addToSwitchControlHistory(action)
        hapticManager.triggerFeedback(for: .longPress)
    }
    
    private func addToSwitchControlHistory(_ action: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        switchControlActions.append("[\(timestamp)] \(action)")
        
        // Keep only last 20 entries
        if switchControlActions.count > 20 {
            switchControlActions.removeFirst()
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AccessibilityGestureExample_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityGestureExample()
    }
} 