import Foundation

/// Main entry point for the SwiftUI Gesture Library toolkit.
public enum GestureKit {
    public static let version = "2.0.0"
}

/// A standard result for gesture state.
public enum GestureState: Sendable {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    case completed
}
