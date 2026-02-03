//
//  BasicExample.swift
//  GestureKit Examples
//
//  Created by Muhittin Camdali
//

import SwiftUI
import GestureKit

// MARK: - Swipe Card Demo

/// A card that can be swiped away
struct SwipeCardDemo: View {
    @State private var offset: CGSize = .zero
    @State private var isRemoved = false
    
    var body: some View {
        if !isRemoved {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 300, height: 400)
                .offset(offset)
                .onSwipe(.left) {
                    withAnimation(.easeOut) {
                        offset = CGSize(width: -500, height: 0)
                        isRemoved = true
                    }
                }
                .onSwipe(.right) {
                    withAnimation(.easeOut) {
                        offset = CGSize(width: 500, height: 0)
                        isRemoved = true
                    }
                }
        }
    }
}

// MARK: - Zoomable Image Demo

/// An image that can be zoomed with pinch or double tap
struct ZoomableImageDemo: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
            .zoomable(
                scale: $scale,
                minScale: 0.5,
                maxScale: 4.0,
                doubleTapScale: 2.0
            )
            .overlay(
                Text("Scale: \(String(format: "%.2f", scale))x")
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8),
                alignment: .bottom
            )
    }
}

// MARK: - Rotatable Dial Demo

/// A dial that can be rotated with snap positions
struct RotatableDialDemo: View {
    @State private var rotation: Angle = .zero
    
    let snapAngles: [Angle] = stride(from: 0, through: 330, by: 30)
        .map { Angle.degrees(Double($0)) }
    
    var body: some View {
        ZStack {
            // Dial background
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: 200, height: 200)
            
            // Tick marks
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(.gray)
                    .frame(width: 2, height: i % 3 == 0 ? 20 : 10)
                    .offset(y: -90)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            
            // Pointer
            RoundedRectangle(cornerRadius: 2)
                .fill(.red)
                .frame(width: 4, height: 80)
                .offset(y: -40)
                .rotationEffect(rotation)
        }
        .rotatable(rotation: $rotation, snapAngles: snapAngles)
    }
}

// MARK: - Draggable Item Demo

/// A draggable item within bounds
struct DraggableItemDemo: View {
    @State private var position: CGPoint = CGPoint(x: 150, y: 150)
    
    var body: some View {
        ZStack {
            // Bounds indicator
            Rectangle()
                .stroke(.gray, style: StrokeStyle(lineWidth: 2, dash: [5]))
                .frame(width: 300, height: 300)
            
            // Draggable circle
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .draggable(
                    position: $position,
                    bounds: CGRect(x: 25, y: 25, width: 250, height: 250),
                    onDragStart: { print("Started dragging") },
                    onDragEnd: { pos in print("Ended at \(pos)") }
                )
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - Combined Gestures Demo

/// A view with multiple combined gestures
struct CombinedGesturesDemo: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var offset: CGSize = .zero
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 200, height: 200)
            .transformable(
                scale: $scale,
                rotation: $rotation,
                offset: $offset
            )
            .onDoubleTap {
                withAnimation(.spring()) {
                    scale = 1.0
                    rotation = .zero
                    offset = .zero
                }
            }
    }
}

// MARK: - Preview

struct GestureExamples_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            SwipeCardDemo()
            ZoomableImageDemo()
            RotatableDialDemo()
            DraggableItemDemo()
            CombinedGesturesDemo()
        }
    }
}
