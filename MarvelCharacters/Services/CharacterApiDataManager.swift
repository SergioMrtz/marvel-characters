//
//  APIDataManager.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 20/7/21.
//

import Foundation
import CommonCrypto

class CharacterApiDataManager {

    let baseURL = "https://gateway.marvel.com"
    let charactersService = "/v1/public/characters"
    let pubK: Data = Data([57, 99, 51, 49, 54, 100, 99, 97, 49, 54, 57, 56, 98, 53, 100, 51, 99, 57, 48, 51, 52, 56, 54, 54, 53, 49, 50, 49, 56, 53, 50, 52])
    let privK: Data = Data([54, 57, 57, 101, 52, 102, 102, 101, 51, 52, 97, 98, 100, 49, 52, 98, 56, 52, 101, 51, 50, 53, 99, 55, 98, 97, 102, 51, 97, 54, 102, 98, 98, 98, 101, 57, 102, 57, 50, 100])

    func fetchCharacterList(offset:Int = 0,
                            nameStartsWith: String? = nil,
                            completion: @escaping (Result<CharactersListEntity, Error>) -> Void) {

        let timestamp = currentTimestamp()
        let hashMD5 = (timestamp + String(bytes: privK, encoding: .utf8)! + String(bytes: pubK, encoding: .utf8)!).md5()

        var url: String = baseURL + charactersService

        let ts = "?ts=" + timestamp
        let apiKey = "&apikey=" + String(bytes: pubK, encoding: .utf8)!
        let hash = "&hash=" + hashMD5
        let offset = offset != 0 ? "&offset=" + String(offset) : ""

        let name = nameStartsWith != nil
            ? nameStartsWith! != ""
                ? "&nameStartsWith=" + String(nameStartsWith!)
                : ""
            : ""

        url += ts + apiKey + hash + offset + name

        Provider.fetch(url, completion: { result  in
            switch result {
                case .success(let data):
                    let parsedData = CharactersListEntity(json: data)
                    completion(.success(parsedData))
                case .failure(let failure):
                    completion(.failure(failure))
            }
        })
    }

    func fetchSmallPortraitImage(completion: @escaping (Result<Data, Error>) -> Void) {

    }

    private func currentTimestamp() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let timestamp = dateFormatter.string(from: now)
        return timestamp
    }
    
}

extension String {
    func md5() -> String {
        let data = Data(utf8) as NSData
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(data.bytes, CC_LONG(data.length), &hash)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
