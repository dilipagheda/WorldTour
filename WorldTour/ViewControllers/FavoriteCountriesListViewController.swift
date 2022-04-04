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

    var favoriteCountriesList: [DBCountry] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noFavLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.favoriteCountriesList = ViewModelProvider.shared.getFavoriteCountriesList()
        if(self.favoriteCountriesList.isEmpty) {
            noFavLabel.isHidden = false
        }else {
            noFavLabel.isHidden = true
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FavoriteTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "favoriteCountryListTableCell") as? FavoriteTableViewCell

        if let cell = cell {
            
            cell.flagImage.image = UIImage(data: favoriteCountriesList[indexPath.row].flag!)
            cell.countryName.text = favoriteCountriesList[indexPath.row].name
            return cell
        }else{
            let newCell = FavoriteTableViewCell()
            newCell.flagImage.image = UIImage(data: favoriteCountriesList[indexPath.row].flag!)
            newCell.countryName.text = favoriteCountriesList[indexPath.row].name
            return newCell
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCountriesList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let dbCountry = favoriteCountriesList[row]
        performSegue(withIdentifier: "showCountryDetailsFromFav", sender: dbCountry)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showCountryDetailsFromFav") {
            let vc = segue.destination as! DetailsViewController
            if let sender = sender {
                vc.dbCountry = sender as? DBCountry
            }
        }
    }
   
    
}

