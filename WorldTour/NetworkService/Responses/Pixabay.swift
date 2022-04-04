//
//  Pixabay.swift
//  WorldTour
//
//  Created by Dilip Agheda on 4/4/22.
//

import Foundation

class Hits: Codable {
    let webformatURL: String
}

class Pixabay: Codable {
    let hits: [Hits]
}
