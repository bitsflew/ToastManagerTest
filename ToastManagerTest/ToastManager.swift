//
//  ToastManager.swift
//  ToaToastManagerTest
//
//  Created by Henk on 23/05/2025.
//
import SwiftUI

struct ToastItem: Equatable,Identifiable {
    let id: UUID
    let view:  AnyView
    
    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
            return lhs.id == rhs.id
        }
}

@MainActor
final class ToastManager: ObservableObject {
    private let visibleSecs: TimeInterval = 2
    
    @Published
    var stack: [ToastItem] = []
    func show<Content: View>(@ViewBuilder _ content: () -> Content) {
        let toastItem = ToastItem(id: UUID(), view: AnyView(content()) )
        self.stack.append(toastItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + self.visibleSecs) { [weak self] in
            guard let self else { return }
            
            if let index = self.stack.firstIndex(where: { $0.id == toastItem.id }) {
                self.stack.remove(at: index)
            }
        }
    }
    
    func show<Content: View>(id: UUID, visible: Bool, @ViewBuilder _ content: () -> Content) {
        let toastItem = ToastItem(id:id, view: AnyView(content()) )
        if let index = self.stack.firstIndex(where: { $0.id == toastItem.id }) {
            if visible {
                self.stack.append(toastItem)
            } else {
                self.stack.remove(at: index)
            }
        } else {
            if visible {
                self.stack.append(toastItem)
            }
        }
    }
}

struct ToastStackView: View {
    
    @ObservedObject
    var toastManager: ToastManager
    
    @State
    private var stack: [ToastItem] = []
    
    init(toastManager: ToastManager) {
        self.toastManager = toastManager
    }
    
    var body: some View {
        ZStack {
            ForEach(self.stack, id: \.id) { item in
                item.view
                    .background(Color(UIColor.systemBackground))
                    .id(item.id)
            }
        }
        .onChange(of: self.toastManager.stack) { stack in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.stack = stack
            }
        }
    }
}
