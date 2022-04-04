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
            
            if let borders = country.borders {

                for border in borders {
                    let dbBorderingCountry = DBBorderingCountry(context: viewContext)
                    dbBorderingCountry.alpha3Code = border
                    dbBorderingCountry.country = dbCountry
                    appDelegate.saveContext()
                }

            }

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
    
    public func getDBCountryByAlpha3Code(alpha3Code: String) -> DBCountry? {
        
        guard let viewContext = viewContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<DBCountry>(entityName: "DBCountry")

        let predicate = NSPredicate(format: "alpha3Code == %@", alpha3Code)

        fetchRequest.predicate = predicate
        
        do {
            let dbCountries = try viewContext.fetch(fetchRequest)
            
            if(dbCountries.isEmpty) {
                return nil
            }
            return dbCountries[0]
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func getFavoriteDBCountries(isFavorite: Bool) -> [DBCountry]? {
        
        guard let viewContext = viewContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<DBCountry>(entityName: "DBCountry")

        let predicate = NSPredicate(format: "isFavorite == %d", isFavorite)

        fetchRequest.predicate = predicate
        
        do {
            let dbCountries = try viewContext.fetch(fetchRequest)
            
            if(dbCountries.isEmpty) {
                return nil
            }
            return dbCountries
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func getBorderingCountryByDBCountry(dbCountry: DBCountry) -> [DBBorderingCountry]? {

        guard let viewContext = viewContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<DBBorderingCountry>(entityName: "DBBorderingCountry")

        let predicate = NSPredicate(format: "country == %@", dbCountry)

        fetchRequest.predicate = predicate
        
        do {
            let dbBorderingCountries = try viewContext.fetch(fetchRequest)
            
            if(dbBorderingCountries.isEmpty) {
                return nil
            }
            return dbBorderingCountries
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func setFavoriteCountry(dbCountry: DBCountry, isFavorite: Bool) {

        guard let viewContext = viewContext, let appDelegate = appDelegate else {
            return
        }
        
        guard let alpha3Code = dbCountry.alpha3Code else {
            return
        }
        
        let fetchRequest = NSFetchRequest<DBCountry>(entityName: "DBCountry")

        let predicate = NSPredicate(format: "alpha3Code == %@", alpha3Code)

        fetchRequest.predicate = predicate
        
        do {
            let dbCountries = try viewContext.fetch(fetchRequest)
            
            if(dbCountries.isEmpty) {
                return
            }
            dbCountries[0].isFavorite = isFavorite
            appDelegate.saveContext()
        }catch{
            print(error.localizedDescription)
        }
        return

    }
    
    public func getDBPhotosByDBCountry(dbCountry: DBCountry) -> [DBPhoto] {
        
        guard let viewContext = viewContext else {
            return []
        }
        
        let fetchRequest = NSFetchRequest<DBPhoto>(entityName: "DBPhoto")
        
        let predicate = NSPredicate(format: "country == %@", dbCountry)

        fetchRequest.predicate = predicate
        
        do {
            let dbPhotos = try viewContext.fetch(fetchRequest)
            return dbPhotos
        }catch{
            print(error.localizedDescription)
        }
        return []
    }
 
    public func addAllPhotosToCountry(dbCountry: DBCountry, data: [Data]) {
        
        guard let viewContext = viewContext, let appDelegate = appDelegate else {
            return
        }

        for d in data {
            let photo = DBPhoto(context: viewContext)
            photo.image = d
            photo.country = dbCountry
            appDelegate.saveContext()
        }
    }

    public func addCurrentWeatherToCountry(dbCountry: DBCountry, weather: Weather) {
        
        guard let viewContext = viewContext, let appDelegate = appDelegate else {
            return
        }
        
        let weatherInfo = weather.data[0].weather
        
        let dbWeather = DBWeather(context: viewContext)
        dbWeather.country = dbCountry
        dbWeather.datetime = weather.data[0].datetime
        dbWeather.icon = weatherInfo.icon
        dbWeather.isCurrentWeather = true
        dbWeather.temp = weather.data[0].temp
        dbWeather.weatherDescription = weatherInfo.description
        appDelegate.saveContext()
    }
    
    public func getCurrentWeatherByDBCountry(dbCountry: DBCountry) -> DBWeather? {
        
        guard let viewContext = viewContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<DBWeather>(entityName: "DBWeather")
        
        let predicate1 = NSPredicate(format: "country == %@", dbCountry)
        let predicate2 = NSPredicate(format: "isCurrentWeather == %d", true)

        let p = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])

        fetchRequest.predicate = p
        
        do {
            let dbWeatherRecords = try viewContext.fetch(fetchRequest)

            if(dbWeatherRecords.isEmpty) {
                return nil
            }
            
            return dbWeatherRecords[0]
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
}
