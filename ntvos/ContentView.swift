//
//  ContentView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 2/28/22.
//

import SwiftUI
import AVKit


func utcToLocal(dateStr: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
    
        return dateFormatter.string(from: date)
    }
    return nil
}

struct ChannelCard: View {
    @EnvironmentObject var player: Player
    
    var channelName: String
    var streamUrl: String
    var imageUrl: String
    var channelDescription: String
    var channelTimeString: String
    
    var body: some View {
        Button(action: {
            player.pauseOrPlay(streamUrl: streamUrl)
        }) {
            ZStack {
                AsyncImage(url: URL(string: imageUrl))
                VStack {
                    HStack {
                        Text("LIVE ON \(channelName)")
                            .font(Font.custom("Univers-Bold", size: 30))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(
                                top: 10,
                                leading: 10,
                                bottom: 10,
                                trailing: 10
                            ))
                            .background(.white)
                        Spacer()
                    }.padding()
                    Spacer()
                    HStack {
                        VStack {
                            HStack {
                                Text(channelTimeString)
                                    .font(Font.custom("Univers-Condensed", size: 30))
                                Spacer()
                            }
                            .padding(EdgeInsets(
                                top: 0, leading: 0, bottom: 10, trailing: 0
                            ))
                            HStack {
                                Text(channelDescription)
                                    .lineLimit(2)
                                    .font(Font.custom("Univers-Bold", size: 30))
                                Spacer()
                            }
                        }
                        .padding()
                        .background(.black)
                    }.padding()
                }.frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2)
            }
        }
        .buttonStyle(.card)
    }
}

struct ContentView: View {
    @ObservedObject var player = Player()
    @ObservedObject var liveData = LiveDataModel()
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            if liveData.response != nil {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        ForEach(liveData.response!.results, id: \.id) { result in
                            ChannelCard(
                                channelName: result.channelName,
                                streamUrl: liveData.streamUrlForChannel(channel: result.channelName),
                                imageUrl: result.now.embeds.details.media.backgroundLarge,
                                channelDescription: result.now.broadcastTitle,
                                channelTimeString: "\(utcToLocal(dateStr: result.now.startTimestamp)!) - \(utcToLocal(dateStr: result.now.endTimestamp)!)"
                            )
                        }
                    }
                    Spacer()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
            }
        }
        .environmentObject(player)
        .onAppear {
            Task {
                await self.liveData.load()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            HStack {
                ChannelCard(
                    channelName: "1",
                    streamUrl: "",
                    imageUrl: "https://media2.ntslive.co.uk/resize/800x800/e565d72b-3dc8-4917-8811-f3da5d462ea9_1596067200.jpeg",
                    channelDescription: "THIS IS A LONG TITLE FOR A STREAM BUT IT'S REALISTIC",
                    channelTimeString: "10:00 -> 11:00"
                )
                ChannelCard(
                    channelName: "2",
                    
                    streamUrl: "",
                    imageUrl: "https://media2.ntslive.co.uk/resize/800x800/e565d72b-3dc8-4917-8811-f3da5d462ea9_1596067200.jpeg",
                    channelDescription: "HIP HOP",
                    channelTimeString: "10:00 -> 11:00"
                )
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
        }
    }
}
