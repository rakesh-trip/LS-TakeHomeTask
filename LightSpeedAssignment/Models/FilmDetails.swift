//
//  FilmDetails.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-04.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

// MARK: - FilmDetails
struct FilmDetails: Codable {
    var title: String?
    var episodeID: Int?
    var opening_crawl, director, producer, releaseDate: String?
    var characters, planets, starships, vehicles: [String]?
    var species: [String]?
    var created, edited: String?
    var url: String?
    
    var openingCrawlWordCount: String {
        return "\(opening_crawl?.components(separatedBy: " ").count ?? 0) words"
    }
}
