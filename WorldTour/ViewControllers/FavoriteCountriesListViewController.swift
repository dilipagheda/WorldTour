//
//  ViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    
}


class FavoriteCountriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var favoriteCountriesList: [CountryViewModel] {
        return ViewModelProvider.shared.getFavoriteCountriesList()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FavoriteTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "favoriteCountryListTableCell") as? FavoriteTableViewCell

        if let cell = cell {
            
            cell.flagImage.image = UIImage(data: favoriteCountriesList[indexPath.row].flag)
            cell.countryName.text = favoriteCountriesList[indexPath.row].name
            return cell
        }else{
            let newCell = FavoriteTableViewCell()
            newCell.flagImage.image = UIImage(data: favoriteCountriesList[indexPath.row].flag)
            newCell.countryName.text = favoriteCountriesList[indexPath.row].name
            return newCell
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCountriesList.count
    }
}
