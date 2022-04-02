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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gallaryCell") as? GallaryViewCell
        
        if let cell = cell {
            cell.gallaryImage.image = UIImage(named: "testimage")
            return cell
            
        }else{
            let newCell = GallaryViewCell()
            newCell.gallaryImage.image = UIImage(named: "testimage")
            return newCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
