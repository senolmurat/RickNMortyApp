//
//  Location.swift
//  RickNMortyApp
//
//  Created by Murat ŞENOL on 9.05.2022.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let url: String
    let residents: [String]
    let created: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case type = "type"
        case dimension = "dimension"
        case residents = "residents"
        case created = "created"
        case url = "url"
    }
    
    
}
