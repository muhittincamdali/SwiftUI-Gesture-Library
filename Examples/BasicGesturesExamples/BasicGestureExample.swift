import SwiftUI
import SwiftUIGestureLibrary

struct BasicGestureExample: View {
    @State private var tapCount = 0
    @State private var isLongPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic Gesture Examples")
                .font(.title)
                .fontWeight(.bold)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(isLongPressed ? .red : .green)
                .frame(width: 150, height: 100)
                .scaleEffect(isLongPressed ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isLongPressed)
                .onTapGesture {
                    tapCount += 1
                }
                .onLongPressGesture(minimumDuration: 0.5) {
                    isLongPressed.toggle()
                }
            
            Text("Tap count: \(tapCount)")
                .font(.headline)
            
            Text("Long press to change color")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    BasicGestureExample()
} 