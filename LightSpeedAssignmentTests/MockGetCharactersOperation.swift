//
//  MockGetCharactersOperation.swift
//  LightSpeedAssignmentTests
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation
@testable import LightSpeedAssignment
class MockGetCharactersOperation: GetCharactersOperation {
    
    var returnError: Bool? = false
    var errorType: RequestError.ErrorType? = nil
    var errorCode: Int? = nil
    
    var responseJSON = [
        "count": 87,
        "next": "https://swapi.co/api/people/?page=2"
        ] as [String : Any]
    
    func reset() {
        returnError = false
        errorType = nil
        errorCode = nil
    }
    
    override func main() {
        
        if returnError == true {
            if errorCode != nil {
                let errorTemp = RequestError(statusCode: errorCode)
                self.completion(nil, errorTemp)
            } else {
                self.completion(nil, RequestError(errorType: self.errorType ?? .SomeError))
            }
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted)

            let parsedJson = try decoder.decode(StarWarsCharacters.self, from: jsonData)
            self.completion(parsedJson, nil)
        } catch {
            // Parsing Error
            self.completion(nil, error as? RequestError)
        }
    }
}
