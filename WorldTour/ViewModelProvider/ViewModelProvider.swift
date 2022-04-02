//
//  ViewModelService.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import Foundation
import UIKit

class CountryViewModel {
    let name: String
    let flag: Data
    
    public init(name:String, flag:Data) {
        self.name = name
        self.flag = flag
    }
}

class ViewModelProvider {
    
    public static let shared: ViewModelProvider = ViewModelProvider()
    
    private init() {}
    
    public func getCountriesList() -> [[String: [CountryViewModel]]] {
        
        let flag = UIImage(named: "au")?.pngData()
        
        return [
            
            [ "Region A": [
                CountryViewModel(name: "Country 1", flag: flag! ),
                CountryViewModel(name: "Country 2", flag: flag! ),
                CountryViewModel(name: "Country 3", flag: flag! )
                ]
            ],
            ["Region B": [CountryViewModel(name: "Country 1", flag: flag! )]],
            ["Region C": [CountryViewModel(name: "Country 11", flag: flag! ), CountryViewModel(name: "Country 15", flag: flag! )]]
        ]
        
    }
    
    public func getFavoriteCountriesList() -> [CountryViewModel] {
        
        let flag = UIImage(named: "au")?.pngData()
        
        return [
                CountryViewModel(name: "Country 1", flag: flag! ),
                CountryViewModel(name: "Country 3", flag: flag! ),
                CountryViewModel(name: "Country 1", flag: flag! )
            ]
        
    }
}
