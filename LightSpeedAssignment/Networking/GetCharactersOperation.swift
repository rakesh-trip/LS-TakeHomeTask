//
//  GetCharactersOperation.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

class GetCharactersOperation: NetworkOperation<StarWarsCharacters> {
    private let path = ""
    init(url: String?, completion: @escaping (StarWarsCharacters?,  RequestError?) -> Void) {
        super.init(url: url, method: .GET,path: path,  body: nil, completion: completion)
        self.name = "Get Characters Operation"
    }
}
