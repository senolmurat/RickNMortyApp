// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let character = try? newJSONDecoder().decode(Character.self, from: jsonData)

import Foundation
import UIKit

// MARK: - Character
struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationInfo
    let location: LocationInfo
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var statusNSpecieString: String {
        return String("\(status) - \(species)")
    }
    
    var statusNSubspecieString: String {
        return type.isEmpty ? statusNSpecieString : statusNSpecieString + "(\(type))"
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episode = "episode"
        case url = "url"
        case created = "created"
    }
}

struct LocationInfo : Codable{
    let name : String
    let url : String
}


enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

extension UIColor{
    struct StatusColor{
        static var alive : UIColor{return UIColor.systemGreen}
        static var dead : UIColor{return UIColor.systemRed}
        static var unknown : UIColor{return UIColor.systemGray2}
    }
}


