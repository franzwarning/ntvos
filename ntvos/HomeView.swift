//
//  HomeView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI


struct HomeView: View {
    var response: Response?
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
                    if response == nil {
                        LoadingView()
                    } else {
                        HStack {
                            ForEach(response!.results, id: \.channelName) { result in
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

struct HomeViewManager: View {
    @EnvironmentObject var liveData: LiveDataModel
    
    
    
    
    var body: some View {
        HomeView(response: liveData.response)
    }
}



struct HomeView_Preview: PreviewProvider {
    

    static var previews: some View {
        HomeView(response: FakeResponses().mainResponse)
    }
}

