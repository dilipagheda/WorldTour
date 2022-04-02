//
//  DetailsViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 2/4/22.
//

import Foundation
import UIKit

//"20º"

class BorderCountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    
}

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Action Handlers
    
    @IBAction func onTapWeatherButton(_ sender: Any) {
            
        performSegue(withIdentifier: "showWeather", sender: nil)

    }
    
    @IBAction func onTapGallaryButton(_ sender: Any) {
        
    }
    
    
    //Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableViewCell")
        
        if let cell = cell {
            cell.textLabel?.text = "Population"
            cell.detailTextLabel?.text = "20º"
            return cell
        }else {
            let newCell = UITableViewCell()
            newCell.textLabel?.text = "Population"
            newCell.detailTextLabel?.text = "202 Million"
            return newCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    
    //Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "borderCountryCell", for: indexPath) as? BorderCountryCollectionViewCell
        
        if let cell = cell {
            cell.countryFlagImage.image = UIImage(named: "au")
            cell.countryName.text = "Australia"
            return cell
            
        }else {
            let newCell = BorderCountryCollectionViewCell()
            newCell.countryFlagImage.image = UIImage(named: "au")
            newCell.countryName.text = "Australia"
            return newCell
        }
    }
    
}
