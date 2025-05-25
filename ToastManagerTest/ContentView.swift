//
//  ContentView.swift
//  ToaToastManagerTest
//
//  Created by Henk on 25/05/2025.
//

import SwiftUI

var counter1 = 0
var counter2 = 0

struct ContentView: View {
    let toastManager = ToastManager()
    

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Show Toast1") {
                toastManager.show(message: "counter1 \(counter1)")
                counter1 += 1
            }
            Button("Show Toast2") {
                toastManager.show(message: "counter2 \(counter2)")
                counter2 += 1
            }
            ToastView(toastManager: toastManager) { toastItem in
                Text("count: \(toastItem.message)" )
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
