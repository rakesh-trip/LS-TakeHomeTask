//
//  GetFilmDetailsOperation.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 05/03/20.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

class GetFilmDetailsOperation: NetworkOperation<FilmDetails> {
    private let path = ""
    init(url: String?, completion: @escaping (FilmDetails?,  RequestError?) -> Void) {
        super.init(url: url, method: .GET,path: path,  body: nil, completion: completion)
        self.name = "Get Film Details Operation"
    }
}

