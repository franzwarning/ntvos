//
//  LiveDataModel.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/1/22.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let liveData = try? newJSONDecoder().decode(LiveData.self, from: jsonData)

import Foundation

// MARK: - Response
struct Response: Codable {
    let results: [Result]
    let links: [Link]
}

// MARK: - Link
struct Link: Codable {
    let rel: String
    let href: String
    let type: String
}

// MARK: - Result
struct Result: Codable {
    let channelName: String
    let now: Now
    let id = UUID()


    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
        case now
    }
}

// MARK: - Now
struct Now: Codable {
    let broadcastTitle: String
    let startTimestamp, endTimestamp: String
    let embeds: NowEmbeds
    let links: [Link]

    enum CodingKeys: String, CodingKey {
        case broadcastTitle = "broadcast_title"
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
        case embeds, links
    }
}

// MARK: - NowEmbeds
struct NowEmbeds: Codable {
    let details: Details
}

// MARK: - Details
struct Details: Codable {
    let status: String
    let updated: String
    let name, detailsDescription, descriptionHTML: String
    let externalLinks: [String]
    let moods, genres: [Genre]
    let locationShort, locationLong: String
    let intensity: String?
    let media: Media
    let episodeAlias, showAlias: String
    let broadcast: String
    let mixcloud: String?
    let audioSources: [AudioSource]
    let embeds: DetailsEmbeds
    let links: [Link]

    enum CodingKeys: String, CodingKey {
        case status, updated, name
        case detailsDescription = "description"
        case descriptionHTML = "description_html"
        case externalLinks = "external_links"
        case moods, genres
        case locationShort = "location_short"
        case locationLong = "location_long"
        case intensity, media
        case episodeAlias = "episode_alias"
        case showAlias = "show_alias"
        case broadcast, mixcloud
        case audioSources = "audio_sources"
        case embeds, links
    }
}

// MARK: - AudioSource
struct AudioSource: Codable {
    let url: String
    let source: String
}

// MARK: - DetailsEmbeds
struct DetailsEmbeds: Codable {
}

// MARK: - Genre
struct Genre: Codable {
    let id, value: String
}

// MARK: - Media
struct Media: Codable {
    let backgroundLarge, backgroundMediumLarge, backgroundMedium, backgroundSmall: String
    let backgroundThumb, pictureLarge, pictureMediumLarge, pictureMedium: String
    let pictureSmall, pictureThumb: String

    enum CodingKeys: String, CodingKey {
        case backgroundLarge = "background_large"
        case backgroundMediumLarge = "background_medium_large"
        case backgroundMedium = "background_medium"
        case backgroundSmall = "background_small"
        case backgroundThumb = "background_thumb"
        case pictureLarge = "picture_large"
        case pictureMediumLarge = "picture_medium_large"
        case pictureMedium = "picture_medium"
        case pictureSmall = "picture_small"
        case pictureThumb = "picture_thumb"
    }
}



class LiveDataModel: ObservableObject {
    @Published var response: Response?
    @Published var loading: Bool = true
    
    func load() async {
        self.loading = true
        let url = URL(string: "https://www.nts.live/api/v2/live")!
        let urlSession = URLSession.shared
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async {
                self.response = decoded
            }
        } catch {
            // Error handling in case the data couldn't be loaded
            // For now, only display the error on the console
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
        
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    func streamUrlForChannel(channel: String) -> String {
        if (channel == "1") {
            return "https://stream-relay-geo.ntslive.net/stream?client=NTVOS"
        } else {
            return "https://stream-relay-geo.ntslive.net/stream2?client=NTVOS"
        }
    }
}
