import SwiftUI
import SwiftUIGestureLibrary

/// Basic gesture examples demonstrating core functionality
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct BasicGestureExample: View {
    
    @State private var tapCount = 0
    @State private var swipeDirection = "None"
    @State private var scale: CGFloat = 1.0
    @State private var rotation: CGFloat = 0.0
    @State private var panOffset = CGSize.zero
    @State private var longPressTriggered = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Tap Gesture Example
                    tapGestureExample
                    
                    // Swipe Gesture Example
                    swipeGestureExample
                    
                    // Pinch Gesture Example
                    pinchGestureExample
                    
                    // Rotation Gesture Example
                    rotationGestureExample
                    
                    // Pan Gesture Example
                    panGestureExample
                    
                    // Long Press Gesture Example
                    longPressGestureExample
                }
                .padding()
            }
            .navigationTitle("Basic Gesture Examples")
        }
    }
    
    // MARK: - Tap Gesture Example
    
    private var tapGestureExample: some View {
        VStack {
            Text("Tap Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: 150, height: 100)
                .customTapGesture {
                    tapCount += 1
                }
                .overlay(
                    Text("Taps: \(tapCount)")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    // MARK: - Swipe Gesture Example
    
    private var swipeGestureExample: some View {
        VStack {
            Text("Swipe Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(Color.green)
                .frame(width: 150, height: 100)
                .customSwipeGesture { direction in
                    swipeDirection = direction.description
                }
                .overlay(
                    Text("Swipe: \(swipeDirection)")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    // MARK: - Pinch Gesture Example
    
    private var pinchGestureExample: some View {
        VStack {
            Text("Pinch Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(Color.orange)
                .frame(width: 150 * scale, height: 100 * scale)
                .customPinchGesture { newScale in
                    scale = newScale
                }
                .overlay(
                    Text("Scale: \(String(format: "%.2f", scale))")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    // MARK: - Rotation Gesture Example
    
    private var rotationGestureExample: some View {
        VStack {
            Text("Rotation Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(Color.purple)
                .frame(width: 150, height: 100)
                .rotationEffect(.radians(rotation))
                .customRotationGesture(
                    onRotationChanged: { angle in
                        rotation = angle
                    },
                    onRotationEnded: { finalAngle in
                        rotation = finalAngle
                    }
                )
                .overlay(
                    Text("Rotation: \(String(format: "%.1f°", rotation * 180 / .pi))")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    // MARK: - Pan Gesture Example
    
    private var panGestureExample: some View {
        VStack {
            Text("Pan Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 150, height: 100)
                .offset(panOffset)
                .customPanGesture(
                    onPanChanged: { translation in
                        panOffset = CGSize(width: translation.x, height: translation.y)
                    },
                    onPanEnded: { translation, predictedEnd in
                        panOffset = CGSize(width: translation.x, height: translation.y)
                    }
                )
                .overlay(
                    Text("Offset: (\(Int(panOffset.width)), \(Int(panOffset.height)))")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    // MARK: - Long Press Gesture Example
    
    private var longPressGestureExample: some View {
        VStack {
            Text("Long Press Gesture")
                .font(.headline)
            
            Rectangle()
                .fill(longPressTriggered ? Color.yellow : Color.pink)
                .frame(width: 150, height: 100)
                .customLongPressGesture {
                    longPressTriggered.toggle()
                }
                .overlay(
                    Text(longPressTriggered ? "Triggered!" : "Long Press Me")
                        .foregroundColor(.white)
                        .font(.caption)
                )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BasicGestureExample_Previews: PreviewProvider {
    static var previews: some View {
        BasicGestureExample()
    }
} 