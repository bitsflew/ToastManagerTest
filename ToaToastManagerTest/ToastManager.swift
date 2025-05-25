//
//  ToastManager.swift
//  ToaToastManagerTest
//
//  Created by Henk on 23/05/2025.
//
import SwiftUI

struct ToastItem: Equatable, Identifiable {
    let id = UUID()
    let message: String
}

@MainActor
final class ToastManager: ObservableObject {
    private let visibleSecs: TimeInterval = 2
    
    @Published
    var stack: [ToastItem] = []

    func show(message: String) {
        let toastItem = ToastItem(message: message)
        stack.append(toastItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + visibleSecs) { [weak self] in
            guard let self else { return }
            
            if let index = self.stack.firstIndex(where: { $0.id == toastItem.id}) {
                self.stack.remove(at: index)
            }
        }
    }
}

struct ToastView<Content: View>: View {
    private let content: (ToastItem) -> Content
    
    @ObservedObject
    var toastManager: ToastManager
    
    @State
    private var stack: [ToastItem] = []
    
    init(toastManager: ToastManager, @ViewBuilder content: @escaping (ToastItem) -> Content) {
        self.toastManager = toastManager
        self.content = content
    }
    
    var body: some View {
        ZStack {
            ForEach(stack, id: \.id) { item in
                content(item)
                    .id(item.id)
            }
        }
        .onChange(of: toastManager.stack) { stack in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.stack = stack
            }
        }
    }
}
