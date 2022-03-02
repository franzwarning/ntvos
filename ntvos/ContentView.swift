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
            player.startPlay(streamUrl: streamUrl)
        }) {
            ZStack {
                VStack {
                    HStack {
                        HStack {
                            Text("LIVE ON \(channelName)")
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
                }
                .background(AsyncImage(url: URL(string: imageUrl)).scaledToFill())
                .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2)
            }
        }
        .buttonStyle(.card)
    }
}

struct LoadingView: View {
    @State private var opacitySwitch: Bool = false
    
    var body: some View {
        Text("LOADING")
            .font(Font.custom("Univers-BoldCondensed", size: 40))
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

struct PlayerView: View {
    @EnvironmentObject var player: Player
    var body: some View {
        if (player.customerPlayerStatus != .None) {
            VStack {
                if player.customerPlayerStatus == .Loading {
                    LoadingView()
                } else {
                    Button(action: {
                        self.player.stop()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 100))
                    }
                    .buttonStyle(.card)
                    
                }
            }.frame(width: 500, height: 200)
            Spacer()
            
        }
        
        
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
                    PlayerView()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
            } else {
                LoadingView()
            }
        }
        .environmentObject(player)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    ChannelCard(
                        channelName: "1",
                        streamUrl: "",
                        imageUrl: "https://media2.ntslive.co.uk/resize/800x800/e565d72b-3dc8-4917-8811-f3da5d462ea9_1596067200.jpeg",
                        channelDescription: "THIS IS A LONG TITLE FOR A STREAM BUT IT'S REALISTIC",
                        channelTimeString: "10:00 - 11:00"
                    )
                    ChannelCard(
                        channelName: "2",
                        
                        streamUrl: "",
                        imageUrl: "https://media2.ntslive.co.uk/resize/800x800/e565d72b-3dc8-4917-8811-f3da5d462ea9_1596067200.jpeg",
                        channelDescription: "HIP HOP",
                        channelTimeString: "10:00 - 11:00"
                    )
                }
                Spacer()
                PlayerView()
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
        }.environmentObject(Player())
        
    }
}
