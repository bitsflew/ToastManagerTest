//
//  ContentView.swift
//  ToaToastManagerTest
//
//  Created by Henk on 25/05/2025.
//

import SwiftUI

var counter1 = 0
var counter2 = 0

let stateId = UUID()
struct ContentView: View {
    let toastManager = ToastManager()
    @State
    var  state = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Show Toast1") {
                toastManager.show {
                    Text("counter1 \(counter1)")
                }
                counter1 += 1
            }
            Button("Show Toast2") {
                toastManager.show {
                    Text("counter2 \(counter2))")
                }
                counter2 += 1
            }
            
            Button("Toggle state") {
                state.toggle()
                toastManager.show(id: stateId,  visible: state) {
                    Text( "state \(state)")
                }
            }
            
            ToastStackView(toastManager: toastManager)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
