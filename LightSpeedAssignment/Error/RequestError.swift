//
//  RequestError.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

struct RequestError: LocalizedError, Decodable {
    
    enum ErrorType: Int, Decodable {
        case NotFound = 404
        case ValidationErrors = 422
        case InternalServerError = 500
        case NoDataError
        case SomeError
        
        func errorMessage() -> String {
            var message = ""
            switch self {
            case .NotFound:
                message = "Not Found"
            case .ValidationErrors:
                message = "Validation Error"
            case .InternalServerError:
                message = "Internal Server Error"
            case .NoDataError:
                message = "Error: did not receive data"
            case .SomeError:
                message = "There was some error"
            }
            return message
        }
    }
    
    var errors: [String]?
    
    var errorType: ErrorType? = nil
    
    var description: String {
        return self.errors?.joined(separator: ", ") ?? self.errorType?.errorMessage() ?? localizedDescription
    }
    
    init?(statusCode: Int?) {
        guard statusCode != nil else {return nil}
        self.errorType = ErrorType.init(rawValue: statusCode!) ?? .SomeError
    }
    
    init(errorType: ErrorType) {
        self.errorType = errorType
    }
    
    init(errors: [String]) {
        self.errors = errors
    }
    
}
