//
//  Provider.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import Alamofire
import SwiftyJSON

class Provider {

    static func fetch(_ requestURL: String,
                      method: Alamofire.HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      completion: @escaping (Result<JSON, Error>) -> Void){

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
                print("Request Failure. Error: \(error.responseCode ?? -1), :\(error.errorDescription ?? "no info")")
                completion(.failure(error))

            }
        }
    }

}
