//
//  LoadingView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI

//extension Animation {
//    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
//        if expression {
//            return self.repeatForever(autoreverses: autoreverses)
//        } else {
//            return self
//        }
//    }
//}

struct LoadingView: View {
    @State private var opacity = 1.0
    
    var body: some View {
        
            Text("LOADING")
                .font(Font.custom("Univers-BoldCondensed", size: 30))
                .foregroundColor(.gray)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut.repeatForever()) {
                        opacity = 0.5
                    }
                }
        
    }
}
