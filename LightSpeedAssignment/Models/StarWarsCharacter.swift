//
//  Model.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

// MARK: - StarWarsCharacter
struct StarWarsCharacters: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [StarWarsCharacterDetails]?
}
