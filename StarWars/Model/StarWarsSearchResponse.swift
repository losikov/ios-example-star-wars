//
//  StarWarsSearchResponse.swift
//  StarWars
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import Foundation

struct PeopleSearch {
    
    var people: [Person]?
    var count: Int?
    
}

extension PeopleSearch: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case people = "results"
        case count
    }
    
}
