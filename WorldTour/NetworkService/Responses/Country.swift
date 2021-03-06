//
//  CountriesAPIAllResponse.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import Foundation

class Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

class Flag: Codable {
    let svg: String
    let png: String
}

class Language: Codable {
    let name: String
    let nativeName: String?
}

class Country: Codable {
    let alpha3Code: String
    let alpha2Code: String
    let name: String
    let nativeName: String
    let capital: String?
    let subregion: String
    let region: String
    let population: Int64
    let latlng: [Double]?
    let area: Double?
    let flags: Flag
    var flagPNGImage: Data?
    let currencies: [Currency]?
    let languages: [Language]
    let borders: [String]?
}
