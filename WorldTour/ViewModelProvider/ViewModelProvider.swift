//
//  ViewModelService.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import Foundation
import UIKit

struct BorderingCountryViewModel {
    let alpha3Code: String
    let flagImage: Data?
    let countryName: String
}

class ConvertToDictionaryArray {
    
    private let dbCountries: [DBCountry]
    private var dictArray: [ [String: [DBCountry]] ] = [ [String: [DBCountry]] ]()
    
    init(dbCountries: [DBCountry]) {
        self.dbCountries = dbCountries
    }
    
    struct ArrayElement {
        let index: Int
        let dict: [String: [DBCountry]]
    }

    private func process(region: String, dbCountry: DBCountry) {
        
        for (index,item) in dictArray.enumerated() {
            
            let itemValue = item[region]
            
            if(itemValue != nil) {
                
                var elementAt = dictArray.remove(at: index)
                var currentValue = elementAt[region]
                currentValue?.append(dbCountry)
                elementAt[region] = currentValue
                
                dictArray.insert(elementAt, at: index)
                
                return
            }
        }
        
        let newElement = [region: [dbCountry]]
        dictArray.append(newElement)
        
    }
    
    func convert() -> [ [String: [DBCountry]] ] {
       
        for dbCountry in dbCountries {
            process(region: dbCountry.region!, dbCountry: dbCountry)
        }
        
        return dictArray
    }
}

class ViewModelProvider {
    
    public static let shared: ViewModelProvider = ViewModelProvider()
    
    private init() {}
    
    public func getCountriesList(completion: @escaping ([[String: [DBCountry]]]?, String?)->Void) {

        let allDBCountries = DataService.shared.getAllDBCountries()
        
        if(!allDBCountries.isEmpty) {
            let convertToDictinaryArray = ConvertToDictionaryArray(dbCountries: allDBCountries)
            let dictinaryArray = convertToDictinaryArray.convert()
            completion(dictinaryArray, nil)
            return
        }
        
        NetworkService.shared.getAllCountries() {
            (countries, errorMessage) in
            if let countries = countries {
                
                DataService.shared.addAllCountries(countries: countries)
                let allDBCountries = DataService.shared.getAllDBCountries()
                
                let convertToDictinaryArray = ConvertToDictionaryArray(dbCountries: allDBCountries)
                let dictinaryArray = convertToDictinaryArray.convert()
                
                completion(dictinaryArray, nil)
                return
            }
            if let errorMessage = errorMessage {
                completion(nil, errorMessage)
                return
            }
            completion(nil, "Sorry! Something went wrong!")
        }
            
    }
    
    public func getFavoriteCountriesList() -> [DBCountry] {
        
        let favCountries = DataService.shared.getFavoriteDBCountries(isFavorite: true)
        
        if let favCountries = favCountries {
            return favCountries
        }
        
        return []
    }
    
    public func getBorderingCountries(dbCountry: DBCountry) -> [BorderingCountryViewModel] {

        let borderingCountries = DataService.shared.getBorderingCountryByDBCountry(dbCountry: dbCountry)
        
        guard let borderingCountries = borderingCountries else {
            return []
        }
        
        var borderingCountriesViewModel: [BorderingCountryViewModel] = []
        
        for borderingCountry in borderingCountries {
            
            if let alpha3Code = borderingCountry.alpha3Code {
                let dbCountry = DataService.shared.getDBCountryByAlpha3Code(alpha3Code: alpha3Code)
                
                let borderingCountryViewModel = BorderingCountryViewModel(alpha3Code: alpha3Code,  flagImage: dbCountry?.flag ?? nil, countryName: dbCountry?.name ?? "")
                
                borderingCountriesViewModel.append(borderingCountryViewModel)
            }
        }
        return borderingCountriesViewModel
    }
    
    public func setFavoriteCountry(dbCountry: DBCountry, isFavorite: Bool) {
        DataService.shared.setFavoriteCountry(dbCountry: dbCountry, isFavorite: isFavorite)
    }
    
    public func getPhotosByCountry(dbCountry: DBCountry, completion: @escaping ([DBPhoto]?, String?) -> Void) {
     
        let allDBPhotos = DataService.shared.getDBPhotosByDBCountry(dbCountry: dbCountry)
        
        if(!allDBPhotos.isEmpty) {
            completion(allDBPhotos, nil)
            return
        }
        
        var keyword = ""
        if(dbCountry.capital != nil) {
            keyword = dbCountry.capital!
        }else if(dbCountry.name != nil) {
            keyword = dbCountry.name!
        }else{
            keyword = "flowers"
        }
        
        NetworkService.shared.getPhotosByKeyword(keyword: keyword) {
            (data, errorMessage) in
            if let data = data {
                DataService.shared.addAllPhotosToCountry(dbCountry: dbCountry , data: data)
                let allDBPhotos = DataService.shared.getDBPhotosByDBCountry(dbCountry: dbCountry)
                completion(allDBPhotos, nil)
                return
            }else{
                if let errorMessage = errorMessage {
                    completion(nil, errorMessage)
                }else{
                    completion(nil, "Sorry! Something went wrong!")
                }

            }
        }
    }
    
    public func getCurrentWeather(dbCountry: DBCountry, completion: @escaping (DBWeather?, String?) -> Void) {
        
        let currentDBWeather = DataService.shared.getCurrentWeatherByDBCountry(dbCountry: dbCountry)
        
        if(currentDBWeather != nil) {
            completion(currentDBWeather, nil)
            return
        }
        
        NetworkService.shared.getCurrentWeather(lat: dbCountry.lat, lon: dbCountry.lon) {
            (weather, errorMessage) in
            guard let weather = weather else {
                completion(nil, errorMessage)
                return
            }

            DataService.shared.addCurrentWeatherToCountry(dbCountry: dbCountry, weather: weather)
            let currentDBWeather = DataService.shared.getCurrentWeatherByDBCountry(dbCountry: dbCountry)
            completion(currentDBWeather, nil)
        }
    }
}
