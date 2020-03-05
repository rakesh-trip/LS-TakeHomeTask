//
//  StarWarsCharacterDetails.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-04.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

// MARK: - StarWarsCharacterDetails
struct StarWarsCharacterDetails: Codable {
    var name: String
    var height, mass, hair_color: String?
    var skin_color, eye_color, birth_year: String?
    var gender: String?
    var homeworld: String?
    var films, species, vehicles, starships: [String]?
    var created, edited: String?
    var url: String?
}
