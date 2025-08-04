import SwiftUI
import SwiftUIGestureLibrary

struct CustomGestureExample: View {
    @State private var gesturePath: [CGPoint] = []
    @State private var isDrawing = false
    @State private var gestureResult = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Gesture Examples")
                .font(.title)
                .fontWeight(.bold)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .frame(width: 250, height: 200)
                .overlay(
                    Path { path in
                        guard let firstPoint = gesturePath.first else { return }
                        path.move(to: firstPoint)
                        for point in gesturePath.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 3)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isDrawing {
                                gesturePath = [value.location]
                                isDrawing = true
                            } else {
                                gesturePath.append(value.location)
                            }
                        }
                        .onEnded { _ in
                            isDrawing = false
                            analyzeGesture()
                        }
                )
            
            Text(gestureResult.isEmpty ? "Draw a gesture" : gestureResult)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func analyzeGesture() {
        // Simple gesture analysis
        let pointCount = gesturePath.count
        if pointCount < 10 {
            gestureResult = "Gesture too short"
        } else if pointCount > 50 {
            gestureResult = "Complex gesture detected"
        } else {
            gestureResult = "Gesture recorded: \(pointCount) points"
        }
        
        // Clear path after analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            gesturePath = []
            gestureResult = ""
        }
    }
}

#Preview {
    CustomGestureExample()
} 