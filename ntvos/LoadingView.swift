//
//  LoadingView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @State private var opacitySwitch: Bool = false
    
    var body: some View {
        Text("LOADING")
            .font(Font.custom("Univers-BoldCondensed", size: 30))
            .foregroundColor(.gray)
            .opacity(opacitySwitch ? 0.5 : 1)
            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: opacitySwitch)
            .onAppear {
                withAnimation {
                    self.opacitySwitch.toggle()
                }
            }
    }
}
