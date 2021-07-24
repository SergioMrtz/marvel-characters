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
    //TODO: Obfuscate
    let pubK = "9c316dca1698b5d3c903486651218524"
    let privK = "699e4ffe34abd14b84e325c7baf3a6fbbbe9f92d"

    func fetchCharacterList(offset:Int = 0,
                            nameStartsWith: String? = nil,
                            completion: @escaping (Result<CharactersListEntity, Error>) -> Void) {

        let timestamp = currentTimestamp()
        let hashMD5 = (timestamp + privK + pubK).md5()

        var url: String = baseURL + charactersService

        let ts = "?ts=" + timestamp
        let apiKey = "&apikey=" + pubK
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
