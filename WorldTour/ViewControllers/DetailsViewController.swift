//
//  DetailsViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 2/4/22.
//

import Foundation
import UIKit

class BorderCountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    
}

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {

    var dbCountry: DBCountry?
    
    var countryMetaDict: [[String: String]] = [[String: String]]()
    
    var borderingCountries: [BorderingCountryViewModel] = [BorderingCountryViewModel]()
    
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var countryNativeNameLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var borderingCountryLabel: UILabel!
    
    // CollectionView is for bordering countries
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TableView is for country meta information
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //Styles
        flagImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
        flagImageView.layer.borderWidth = 1
        
        //Update data
        if let dbCountry = dbCountry {
            self.flagImageView.image = UIImage(data: dbCountry.flag!)
            self.countryNameLabel.text = dbCountry.name
            self.countryNativeNameLabel.text = dbCountry.nativeName
            
            countryMetaDict.append(["Region": dbCountry.region ?? "Data not available"])
            countryMetaDict.append(["Subregion": dbCountry.subregion ?? "Data not available"])
            countryMetaDict.append(["Capital": dbCountry.capital ?? "Data not available"])
            countryMetaDict.append(["Population": "\(dbCountry.population)"])
            countryMetaDict.append(["Area": "\(dbCountry.area)"])
            countryMetaDict.append(["Popular Language": dbCountry.popularLanguage ?? "Data not available"])
            let currencyName = dbCountry.currencyName ?? ""
            let currencySymbol = dbCountry.currencySymbol ?? ""
            let currencyCode = dbCountry.currencyCode ?? ""
            countryMetaDict.append(["Currency": "\(currencyName) \(currencySymbol) \(currencyCode)"])
            tableView.reloadData()
            
            //Bordering Countries
            self.borderingCountries =  ViewModelProvider.shared.getBorderingCountries(dbCountry: dbCountry)
            if(self.borderingCountries.isEmpty) {
                collectionView.isHidden = true
                borderingCountryLabel.isHidden = true
            }else{
                collectionView.isHidden = false
                borderingCountryLabel.isHidden = false
                collectionView.reloadData()
            }

            //Favorite
            updateFavButton(isFavorite: dbCountry.isFavorite)
        }
    }
    
    //Helpers
    func updateFavButton(isFavorite: Bool) {
        
        if(isFavorite) {
            self.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            self.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    //Action Handlers
    
    @IBAction func onTapFavButton(_ sender: Any) {
            
        if let dbCountry = self.dbCountry {
            let favFlag = !dbCountry.isFavorite
            ViewModelProvider.shared.setFavoriteCountry(dbCountry: dbCountry, isFavorite: favFlag)
            updateFavButton(isFavorite: favFlag)
        }
    }
    
    @IBAction func onTapWeatherButton(_ sender: Any) {
            
        performSegue(withIdentifier: "showWeather", sender: self.dbCountry)

    }
    
    @IBAction func onTapGallaryButton(_ sender: Any) {
        
        performSegue(withIdentifier: "showGallary", sender: self.dbCountry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showWeather") {
            let vc = segue.destination as! WeatherViewController
            if let sender = sender {
                vc.dbCountry = sender as? DBCountry
            }
        }
        
        if(segue.identifier == "showGallary") {
            let vc = segue.destination as! GallaryViewController
            if let sender = sender {
                vc.dbCountry = sender as? DBCountry
            }
        }
    }
    
    //Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.countryMetaDict[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableViewCell")
        
        if let cell = cell {
            cell.textLabel?.text = dict.keys.first!
            cell.detailTextLabel?.text = dict.values.first!
            return cell
        }else {
            let newCell = UITableViewCell()
            newCell.textLabel?.text = dict.keys.first!
            newCell.detailTextLabel?.text = dict.values.first!
            return newCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryMetaDict.count
    }
    
    //Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.borderingCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let borderCountry = self.borderingCountries[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "borderCountryCell", for: indexPath) as? BorderCountryCollectionViewCell
        
        if let cell = cell {
            
            if let flagImage = borderCountry.flagImage {
                cell.countryFlagImage.image = UIImage(data: flagImage)
            }else{
                cell.countryFlagImage.image = UIImage(named: "placeholder")
            }

            cell.countryName.text = borderCountry.countryName
            return cell
            
        }else {
            let newCell = BorderCountryCollectionViewCell()
            
            if let flagImage = borderCountry.flagImage {
                newCell.countryFlagImage.image = UIImage(data: flagImage)
            }else{
                newCell.countryFlagImage.image = UIImage(named: "placeholder")
            }

            newCell.countryName.text = borderCountry.countryName
            
            return newCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
}
