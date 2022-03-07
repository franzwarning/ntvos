//
//  ChannelView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI

// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                  let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}

struct ChannelView: View {
    var result: Result
    @EnvironmentObject var player: Player
    @EnvironmentObject var liveData: LiveDataModel
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Spacer()
                HStack {
                    if player.customerPlayerStatus == .Loading {
                        LoadingView()
                    } else if player.customerPlayerStatus == .Playing {
                        Button(action: {
                            player.pause()
                        }){
                            VStack {
                                Spacer()
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(.white)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .buttonStyle(.card)
                        
                    } else if player.customerPlayerStatus == .Paused {
                        Button(action: {
                            player.play()
                        }){
                            VStack {
                                Spacer()
                                Image(systemName: "play.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(.white)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        .buttonStyle(.card)
                        
                    }
                    Spacer()
                }
                .frame(height: 100)
                HStack {
                    VStack(alignment: .leading) {
                        Text(result.now.broadcastTitle.stringByDecodingHTMLEntities.uppercased())
                            .font(Font.custom("Univers-BoldCondensed", size: 30))
                            .foregroundColor(.black)
                        Text(result.now.embeds.details.locationLong?.uppercased() ?? "UNKNOWN")
                            .font(Font.custom("Univers-Condensed", size: 30))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                        
                        Text(result.now.embeds.details.detailsDescription.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .lineLimit(3)
                            .frame(minWidth: 200, idealWidth: 200, maxWidth: UIScreen.main.bounds.width / 2, alignment: .leading)
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                        
                    }
                    .padding(35)
                    .background {
                        Color(.white)
                    }
                    Spacer()
                }
            }
        }.background {
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
        }
        
        .onAppear {
            let streamUrl = liveData.streamUrlForChannel(channel: result.channelName)
            if (player.customerPlayerStatus != .Playing || player.currentStreamUrl != streamUrl) {
                player.startPlay(streamUrl: liveData.streamUrlForChannel(channel: result.channelName))
            }
            
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

