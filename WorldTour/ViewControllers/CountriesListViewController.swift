//
//  ViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    
}


class CountriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var countriesList: [[String: [CountryViewModel]]] {
        return ViewModelProvider.shared.getCountriesList()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countriesList[section].keys.first
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = indexPath.section
        let row = indexPath.row
        let countryDict = countriesList[section]
        let countryViewModelRecord = (countryDict.values.first!)[row]
        
        let cell: CountryTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "allCountryListTableCell") as? CountryTableViewCell

        if let cell = cell {
            
            cell.flagImage.image = UIImage(data: countryViewModelRecord.flag)
            cell.countryName.text = countryViewModelRecord.name
            return cell
        }else{
            let newCell = CountryTableViewCell()
            newCell.flagImage.image = UIImage(data: countryViewModelRecord.flag)
            newCell.countryName.text = countryViewModelRecord.name
            return newCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x =  countriesList[section].values.first!.count
        debugPrint("rows in section \(section) is \(x)")
        return x
    }
    

}

