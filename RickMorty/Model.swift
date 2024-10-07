//
//  Model.swift
//  RickMorty
//
//  Created by Alejandro Guerra Hernandez on 02/10/24.
//

import Foundation

struct Response: Codable {
    var info: Info
    var results: [CharacterDetail]
}

struct Info: Codable {
    var count: Int
    var pages: Int
    var prev: String?
    var next: String?
}

struct CharacterDetail: Codable {
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String

    struct Origin: Codable {
      var name: String
      var url: String
    }
    var origin: Origin
    
    struct Location: Codable {
      var name: String
      var url: String
    }
    var location: Location
    
    var image: String
    
    // episode
    var episode: [String]
    
    var url: String
    var created: String
    
}

