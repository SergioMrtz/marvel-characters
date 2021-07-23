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

        let request2 = AF.request(requestURL,
                                  method: method,
                                  parameters: parameters)

        request2.validate().responseJSON { response in

            switch response.result {
            case .success(let data):

                print("Success")
                let json = JSON(data)
                completion(.success(json))

            case .failure(let error):

                print("Failure")
                completion(.failure(error))

            }
        }
    }

}
