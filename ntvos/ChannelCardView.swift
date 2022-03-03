//
//  ChannelCard.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI

struct ChannelCardView: View {
    @EnvironmentObject var player: Player
    
    var result: Result
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Text("LIVE ON \(result.channelName)")
                            .font(Font.custom("Univers-Bold", size: 30))
                            .foregroundColor(.black)
                            .frame(alignment: .leading)
                        HStack {}
                        Color(.red)
                            .background(.red)
                            .cornerRadius(10)
                            .frame(width: 10, height: 10)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(.white)
                    Spacer()
                }.padding()
                Spacer()
                HStack {
                    VStack {
                        HStack {
                            Text("\(utcToLocal(dateStr: result.now.startTimestamp)!) - \(utcToLocal(dateStr: result.now.endTimestamp)!)")
                                .font(Font.custom("Univers-Condensed", size: 30))
                            Spacer()
                        }
                        .padding(EdgeInsets(
                            top: 0, leading: 0, bottom: 10, trailing: 0
                        ))
                        HStack {
                            Text(result.now.broadcastTitle)
                                .lineLimit(2)
                                .font(Font.custom("Univers-Bold", size: 30))
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.black)
                }.padding()
            }
            .background(AsyncImage(url: URL(string: result.now.embeds.details.media.pictureLarge)).scaledToFill())
            .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2)
        }

    }
}

