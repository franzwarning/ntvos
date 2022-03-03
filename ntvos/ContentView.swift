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


struct ContentView: View {
    @ObservedObject var player = Player()
    @ObservedObject var liveData = LiveDataModel()
    
    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            HomeView()
        }
        .onPlayPauseCommand(perform: {
            player.toggle()
        })
        .environmentObject(player)
        .environmentObject(liveData)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Color(.black)
    }
}
