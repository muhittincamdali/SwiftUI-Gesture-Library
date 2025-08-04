import SwiftUI
import SwiftUIGestureLibrary

struct AdvancedGestureExample: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Advanced Gesture Examples")
                .font(.title)
                .fontWeight(.bold)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    scale = 1.0
                                }
                            },
                        RotationGesture()
                            .onChanged { angle in
                                rotation = angle.degrees
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    rotation = 0.0
                                }
                            }
                    )
                )
            
            Text("Pinch to zoom and rotate")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    AdvancedGestureExample()
} 