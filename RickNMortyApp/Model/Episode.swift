//
//  Episode.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import Foundation

struct Episode: Codable{
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
        case created = "created"
        case url = "url"
    }
}
