//
//  ChannelView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI

struct ChannelView: View {
    var result: Result
    @EnvironmentObject var player: Player
    @EnvironmentObject var liveData: LiveDataModel
    
    
    var body: some View {
        
        ZStack {
            
            AsyncImage(url: URL(string: result.now.embeds.details.media.backgroundLarge)) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.5)
            } placeholder: {
                Color(.black)
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(result.now.broadcastTitle.uppercased())
                                .font(Font.custom("Univers-BoldCondensed", size: 30))
                                .foregroundColor(.black)
                            Text(result.now.embeds.details.locationLong!.uppercased())
                                .font(Font.custom("Univers-Condensed", size: 30))
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                                
                            Text(result.now.embeds.details.detailsDescription.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                                .lineLimit(3)
                                .frame(minWidth: 200, idealWidth: 200, maxWidth: UIScreen.main.bounds.width / 2, alignment: .leading)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))

                            HStack {
                                if player.customerPlayerStatus == .Loading {
                                  LoadingView()
                                } else if player.customerPlayerStatus == .Playing {
                                    Button(action: {
                                        player.pause()
                                    }){
                                        HStack {
                                            Image(systemName: "pause")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 50, height: 50)
                                        .background(.white)
                                    }
                                    .buttonStyle(.card)

                                } else if player.customerPlayerStatus == .Paused {
                                    Button(action: {
                                        player.play()
                                    }){
                                        HStack {
                                            Image(systemName: "play")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)
                                        }
                                        .frame(width: 50, height: 50)
                                        .background(.white)
                                    }
                                    .buttonStyle(.card)

                                }
                                Spacer()
                            }.frame(width: 200, height: 100)
                            
                            
                        }
                        .padding(40)
                        .background {
                            Color(.white)
                        }
                        Spacer()
                    }
                }
            }
        }
        
        .onAppear {
            player.startPlay(streamUrl: liveData.streamUrlForChannel(channel: result.channelName))
        }
    }
}


struct ChannelView_Preview: PreviewProvider {
    static var previews: some View {
        ChannelView(
            result:
                Result(
                    channelName: "test",
                    now: Now(
                        broadcastTitle: "Broadcast",
                        startTimestamp: "2022-02-15T19:51:58+0000",
                        endTimestamp: "2022-02-15T19:51:58+0000",
                        embeds: NowEmbeds(details: Details(status: "", updated: "", name: "", detailsDescription: "Rose-tinted hallucinogenic sounds from Astral Vibes' Acid Memories. Illicit dealings in psychedelia of all persuasions. Sit back and enjoy…", descriptionHTML: "", externalLinks: [], moods: [], genres: [], locationShort: "", locationLong: "London", intensity: "", media: Media(backgroundLarge: "", backgroundMediumLarge: "", backgroundMedium: "", backgroundSmall: "", backgroundThumb: "", pictureLarge: "", pictureMediumLarge: "", pictureMedium: "", pictureSmall: "", pictureThumb: ""), episodeAlias: "", showAlias: "", broadcast: "", mixcloud: nil, audioSources: [], embeds: DetailsEmbeds(), links: [])),
                        links: [])
                )
        )
    }
}

