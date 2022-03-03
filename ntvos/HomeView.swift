//
//  HomeView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI



struct HomeView: View {
    @EnvironmentObject var liveData: LiveDataModel
    @EnvironmentObject var player: Player
    
    @State var openChannel: String?
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.cyan, .secondary]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                    .ignoresSafeArea()
                    .opacity(0.2)
                VStack(alignment: .center) {
                    Spacer()
                    if liveData.response == nil {
                        LoadingView()
                    } else {
                        HStack {
                            ForEach(liveData.response!.results, id: \.channelName) { result in
                                NavigationLink(destination: ChannelView(result: result), tag: result.channelName, selection: $openChannel) {
                                    ChannelCardView(result: result)
                                }
                                .buttonStyle(.card)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}
