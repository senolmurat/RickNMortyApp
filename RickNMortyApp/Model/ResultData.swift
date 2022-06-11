// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let resultsData = try? newJSONDecoder().decode(ResultsData.self, from: jsonData)

import Foundation

// MARK: - ResultData
class ResultData: Codable {
    let info: Info?

    enum CodingKeys: String, CodingKey {
        case info = "info"
    }
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}

struct CharacterResultData: Codable{
    let info: Info?
    var results: [Character]
}
struct LocationResultData : Codable{
    let info: Info?
    var results: [Location] = []

}
struct EpisodeResultData : Codable{
    let info: Info?
    var results: [Episode] = []
    
}


