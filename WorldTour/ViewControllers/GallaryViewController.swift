//
//  GallaryViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 2/4/22.
//

import Foundation
import UIKit

class GallaryViewCell: UITableViewCell {
    
    @IBOutlet weak var gallaryImage: UIImageView!
    
}

class GallaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dbCountry: DBCountry?
    
    var photos: [DBPhoto] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        activityView.startAnimating()
        
        ViewModelProvider.shared.getPhotosByCountry(dbCountry: dbCountry!) {
            (photos, errorMessage) in
            if let photos = photos {
                DispatchQueue.main.async {
                    self.photos = photos
                    self.tableView.reloadData()
                    self.activityView.stopAnimating()
                }
            }

            DispatchQueue.main.async {
                self.activityView.stopAnimating()
            }
            
            if let errorMessage = errorMessage {
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: errorMessage)
            }else{
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: "Error while fetching user data")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gallaryCell") as? GallaryViewCell
        let photo = self.photos[indexPath.row]
        
        if let cell = cell {
            cell.gallaryImage.image = UIImage(data: photo.image!)
            return cell
            
        }else{
            let newCell = GallaryViewCell()
            newCell.gallaryImage.image = UIImage(data: photo.image!)
            return newCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
