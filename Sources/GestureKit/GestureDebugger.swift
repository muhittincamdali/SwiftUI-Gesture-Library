//
//  GestureDebugger.swift
//  GestureKit
//
//  Created by Muhittin Camdali
//  Copyright © 2026 Muhittin Camdali. All rights reserved.
//

import SwiftUI

// MARK: - Gesture Log Entry

/// A single gesture event log entry
public struct GestureLogEntry: Identifiable, Sendable {
    public let id = UUID()
    public let timestamp: Date
    public let gestureType: String
    public let state: GestureTrackingState
    public let location: CGPoint?
    public let details: String?
    
    public init(
        timestamp: Date = Date(),
        gestureType: String,
        state: GestureTrackingState,
        location: CGPoint? = nil,
        details: String? = nil
    ) {
        self.timestamp = timestamp
        self.gestureType = gestureType
        self.state = state
        self.location = location
        self.details = details
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: timestamp)
    }
}

// MARK: - Gesture Logger

/// Singleton gesture logger
@MainActor
public final class GestureLogger: ObservableObject {
    public static let shared = GestureLogger()
    
    @Published public var entries: [GestureLogEntry] = []
    @Published public var isEnabled: Bool = false
    
    public let maxEntries: Int
    
    private init(maxEntries: Int = 100) {
        self.maxEntries = maxEntries
    }
    
    public func log(
        type: String,
        state: GestureTrackingState,
        location: CGPoint? = nil,
        details: String? = nil
    ) {
        guard isEnabled else { return }
        
        let entry = GestureLogEntry(
            gestureType: type,
            state: state,
            location: location,
            details: details
        )
        
        entries.append(entry)
        
        // Trim old entries
        if entries.count > maxEntries {
            entries.removeFirst(entries.count - maxEntries)
        }
    }
    
    public func clear() {
        entries.removeAll()
    }
    
    public func export() -> String {
        entries.map { entry in
            var line = "[\(entry.formattedTime)] \(entry.gestureType) - \(entry.state.rawValue)"
            if let location = entry.location {
                line += " @ (\(Int(location.x)), \(Int(location.y)))"
            }
            if let details = entry.details {
                line += " | \(details)"
            }
            return line
        }.joined(separator: "\n")
    }
}

// MARK: - Debug State Extension

extension GestureTrackingState {
    var rawValue: String {
        switch self {
        case .inactive: return "inactive"
        case .started: return "started"
        case .changed: return "changed"
        case .ended: return "ended"
        case .cancelled: return "cancelled"
        case .failed: return "failed"
        }
    }
    
    var color: Color {
        switch self {
        case .inactive: return .gray
        case .started: return .blue
        case .changed: return .yellow
        case .ended: return .green
        case .cancelled: return .orange
        case .failed: return .red
        }
    }
}

// MARK: - Touch Visualizer

/// Shows touch points on screen
struct TouchVisualizerView: View {
    let points: [CGPoint]
    let pointSize: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                Circle()
                    .fill(color.opacity(0.5))
                    .frame(width: pointSize, height: pointSize)
                    .overlay(
                        Circle()
                            .stroke(color, lineWidth: 2)
                    )
                    .position(point)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.15), value: points.count)
    }
}

// MARK: - Gesture Debugger Overlay

/// Full debug overlay for gesture development
public struct GestureDebuggerOverlay: View {
    @ObservedObject private var logger = GestureLogger.shared
    @State private var touchPoints: [CGPoint] = []
    @State private var isMinimized = false
    @State private var dragOffset: CGSize = .zero
    
    let position: Position
    let showTouches: Bool
    let touchColor: Color
    let touchSize: CGFloat
    
    public enum Position {
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
    }
    
    public init(
        position: Position = .bottomTrailing,
        showTouches: Bool = true,
        touchColor: Color = .blue,
        touchSize: CGFloat = 44
    ) {
        self.position = position
        self.showTouches = showTouches
        self.touchColor = touchColor
        self.touchSize = touchSize
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Touch visualization
                if showTouches && logger.isEnabled {
                    TouchVisualizerView(
                        points: touchPoints,
                        pointSize: touchSize,
                        color: touchColor
                    )
                }
                
                // Debug panel
                if logger.isEnabled {
                    debugPanel
                        .position(panelPosition(in: geometry.size))
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { _ in
                                    // Keep new position
                                }
                        )
                }
            }
        }
    }
    
    private var debugPanel: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "hand.tap.fill")
                Text("Gesture Debug")
                    .font(.caption.bold())
                Spacer()
                
                Button {
                    withAnimation { isMinimized.toggle() }
                } label: {
                    Image(systemName: isMinimized ? "chevron.down" : "chevron.up")
                }
                
                Button {
                    logger.isEnabled = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.blue)
            .foregroundColor(.white)
            
            if !isMinimized {
                // Log entries
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(logger.entries.suffix(20)) { entry in
                                logEntryView(entry)
                                    .id(entry.id)
                            }
                        }
                        .padding(8)
                    }
                    .frame(height: 200)
                    .onChange(of: logger.entries.count) { _ in
                        if let lastId = logger.entries.last?.id {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                
                // Controls
                HStack {
                    Button("Clear") {
                        logger.clear()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Text("\(logger.entries.count) events")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(8)
            }
        }
        .frame(width: 280)
        #if os(iOS)
        .background(Color(UIColor.systemBackground))
        #else
        .background(Color(NSColor.windowBackgroundColor))
        #endif
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    private func logEntryView(_ entry: GestureLogEntry) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(entry.state.color)
                .frame(width: 8, height: 8)
            
            Text(entry.formattedTime)
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(.secondary)
            
            Text(entry.gestureType)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
            
            Text(entry.state.rawValue)
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(entry.state.color)
            
            if let details = entry.details {
                Text(details)
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
    
    private func panelPosition(in size: CGSize) -> CGPoint {
        let padding: CGFloat = 20
        let width: CGFloat = 280
        let height: CGFloat = isMinimized ? 40 : 280
        
        switch position {
        case .topLeading:
            return CGPoint(x: padding + width / 2, y: padding + height / 2)
        case .topTrailing:
            return CGPoint(x: size.width - padding - width / 2, y: padding + height / 2)
        case .bottomLeading:
            return CGPoint(x: padding + width / 2, y: size.height - padding - height / 2)
        case .bottomTrailing:
            return CGPoint(x: size.width - padding - width / 2, y: size.height - padding - height / 2)
        }
    }
}

// MARK: - Debug Gesture Modifier

/// Modifier that logs all gesture events
public struct GestureDebugModifier: ViewModifier {
    let name: String
    @ObservedObject private var logger = GestureLogger.shared
    
    public init(name: String) {
        self.name = name
    }
    
    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        logger.log(
                            type: name.isEmpty ? "drag" : name,
                            state: .changed,
                            location: value.location,
                            details: "Δ(\(Int(value.translation.width)),\(Int(value.translation.height)))"
                        )
                    }
                    .onEnded { value in
                        logger.log(
                            type: name.isEmpty ? "drag" : name,
                            state: .ended,
                            location: value.location
                        )
                    }
            )
    }
}

// MARK: - View Extensions

public extension View {
    /// Enables gesture debugging for this view
    func gestureDebug(name: String = "") -> some View {
        modifier(GestureDebugModifier(name: name))
    }
    
    /// Adds gesture debugger overlay
    func gestureDebuggerOverlay(
        position: GestureDebuggerOverlay.Position = .bottomTrailing,
        showTouches: Bool = true,
        touchColor: Color = .blue,
        touchSize: CGFloat = 44
    ) -> some View {
        overlay(
            GestureDebuggerOverlay(
                position: position,
                showTouches: showTouches,
                touchColor: touchColor,
                touchSize: touchSize
            )
        )
    }
    
    /// Enables debug mode
    func enableGestureDebug(_ enabled: Bool = true) -> some View {
        onAppear {
            GestureLogger.shared.isEnabled = enabled
            GestureKit.debugMode = enabled
        }
    }
}
