//
//  DataService.swift
//  WorldTour
//
//  Created by Dilip Agheda on 3/4/22.
//

import Foundation
import UIKit
import CoreData

class DataService {
    
    static let shared = DataService()

    var appDelegate: AppDelegate? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }

    var viewContext: NSManagedObjectContext? {
        guard let appDelegate = self.appDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private init() {}
    
    public func addAllCountries(countries: [Country]) {
       
        guard let viewContext = viewContext, let appDelegate = appDelegate else {
            return
        }
        
        for country in countries {
            let dbCountry = DBCountry(context: viewContext)
            dbCountry.alpha2Code = country.alpha2Code
            dbCountry.alpha3Code = country.alpha3Code
            dbCountry.name = country.name
            dbCountry.nativeName = country.nativeName
            dbCountry.population = country.population
            
            if let area = country.area {
                dbCountry.area = area
            }

            if let capital = country.capital {
                dbCountry.capital = capital
            }

            dbCountry.isFavorite = false
            
            if let currencies = country.currencies {
                dbCountry.currencyCode = currencies[0].code
                dbCountry.currencyName = currencies[0].name
                dbCountry.currencySymbol = currencies[0].symbol
            }
            
            dbCountry.popularLanguage = country.languages[0].name
            
            dbCountry.region = country.region
            dbCountry.subregion = country.subregion
            
            if let latlng = country.latlng {
                dbCountry.lat = latlng[0]
                dbCountry.lon = latlng[1]
            }

            dbCountry.flag = country.flagPNGImage

            appDelegate.saveContext()
        }
    }
    
    public func getAllDBCountries() -> [DBCountry] {
        
        guard let viewContext = viewContext else {
            return []
        }
        
        let fetchRequest = NSFetchRequest<DBCountry>(entityName: "DBCountry")
        
        do {
            let dbCountries = try viewContext.fetch(fetchRequest)
            return dbCountries
        }catch{
            print(error.localizedDescription)
        }
        return []
    }
    
    public func truncateDBCountries() {
        
        guard let viewContext = viewContext else {
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBCountry")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
            
        }catch{
            debugPrint(error)
        }
    }
   
}
