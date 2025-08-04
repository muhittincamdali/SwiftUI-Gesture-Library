import SwiftUI
import SwiftUIGestureLibrary

struct GestureTrainingExample: View {
    @State private var trainingMode = false
    @State private var gestureName = ""
    @State private var trainingSamples: [[CGPoint]] = []
    @State private var currentSample: [CGPoint] = []
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Gesture Training Examples")
                .font(.title)
                .fontWeight(.bold)
            
            if trainingMode {
                VStack(spacing: 15) {
                    TextField("Gesture Name", text: $gestureName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)
                        .frame(width: 250, height: 200)
                        .overlay(
                            Path { path in
                                guard let firstPoint = currentSample.first else { return }
                                path.move(to: firstPoint)
                                for point in currentSample.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                            .stroke(Color.green, lineWidth: 3)
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if !isRecording {
                                        currentSample = [value.location]
                                        isRecording = true
                                    } else {
                                        currentSample.append(value.location)
                                    }
                                }
                                .onEnded { _ in
                                    isRecording = false
                                    if !currentSample.isEmpty {
                                        trainingSamples.append(currentSample)
                                        currentSample = []
                                    }
                                }
                        )
                    
                    Text("Samples: \(trainingSamples.count)")
                        .font(.caption)
                    
                    Button("Save Gesture") {
                        saveGesture()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(gestureName.isEmpty || trainingSamples.isEmpty)
                }
            } else {
                VStack(spacing: 15) {
                    Text("Train custom gestures")
                        .font(.headline)
                    
                    Button("Start Training") {
                        trainingMode = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
    }
    
    private func saveGesture() {
        // Save gesture training data
        print("Saving gesture: \(gestureName)")
        print("Samples: \(trainingSamples.count)")
        
        // Reset training mode
        trainingMode = false
        gestureName = ""
        trainingSamples = []
        currentSample = []
    }
}

#Preview {
    GestureTrainingExample()
} 