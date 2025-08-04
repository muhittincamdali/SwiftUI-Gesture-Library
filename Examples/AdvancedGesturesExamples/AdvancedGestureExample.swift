import SwiftUI
import SwiftUIGestureLibrary

struct AdvancedGestureExample: View {
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Advanced Gesture Examples")
                .font(.title)
                .fontWeight(.bold)
            
            Circle()
                .fill(LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 100, height: 100)
                .offset(dragOffset)
                .scaleEffect(isDragging ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isDragging)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                            isDragging = true
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                            isDragging = false
                        }
                )
            
            Text("Drag the circle")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    AdvancedGestureExample()
} 