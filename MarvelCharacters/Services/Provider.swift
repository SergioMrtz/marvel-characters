//
//  Provider.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import Alamofire
import SwiftyJSON

enum MCErrorType: Error {
    case incorrectData
    case unathorized
    case resourceNotFound
    case incorrectParameters
    case serverError
    case noConnection
    case unknown
}

class Provider {

    static func fetch(_ requestURL: String,
                      method: Alamofire.HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      completion: @escaping (Result<JSON, MCErrorType>) -> Void){

        let safeURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let request = AF.request(safeURL,
                                  method: method,
                                  parameters: parameters)

        request.validate().responseJSON { response in

            switch response.result {
            case .success(let data):

                print("Request Success")
                let json = JSON(data)
                completion(.success(json))

            case .failure(let error):
                completion(.failure(self.getErrorType(error: error)))
            }
        }
    }

    static func getErrorType(error: (AFError)) -> MCErrorType {

        guard let errorCode = error.responseCode else {
            if error.isSessionTaskError {
                return .noConnection
            } else {
                return .unknown
            }
        }

        switch errorCode {
        case 401:
            return .unathorized
        case 404:
            return .resourceNotFound
        case 500, 503:
            return .serverError
        case 409:
            return .incorrectParameters
        default:
            return .unknown
        }
    }
}
