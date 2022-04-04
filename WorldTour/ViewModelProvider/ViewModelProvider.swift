//
//  ViewModelService.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import Foundation
import UIKit

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
        
        return []
    }
}
