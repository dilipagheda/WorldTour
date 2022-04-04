//
//  Weather.swift
//  WorldTour
//
//  Created by Dilip Agheda on 4/4/22.
//

import Foundation

class WeatherInfo: Codable {
    let icon: String
    let code: Int32
    let description: String
}

class WeatherData: Codable {
    let temp: Float
    let weather: WeatherInfo
    let datetime: String
}

class Weather: Codable {
    let data: [WeatherData]
}
