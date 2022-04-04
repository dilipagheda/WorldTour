//
//  WeatherViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 2/4/22.
//

import Foundation
import UIKit

class WeatherTableCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
}


class WeatherViewController :UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dbCountry: DBCountry?
    var currentDBWeather: DBWeather?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!

    @IBOutlet weak var currentWeatherTemp: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var staticLabel: UILabel!
    
    func updateUI(isLoading: Bool) {
        tableView.isHidden = isLoading
        capitalLabel.isHidden = isLoading
        weatherIconImageView.isHidden = isLoading
        currentWeatherDescriptionLabel.isHidden = isLoading
        currentWeatherTemp.isHidden = isLoading
        staticLabel.isHidden = isLoading
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        activityView.startAnimating()
        updateUI(isLoading: true)
        
        ViewModelProvider.shared.getCurrentWeather(dbCountry: dbCountry!) {
            (dbWeather, errorMessage) in
            guard let dbWeather = dbWeather else {
                return
            }
            
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.updateUI(isLoading: false)
                self.capitalLabel.text = self.dbCountry!.capital
                self.weatherIconImageView.image = UIImage(named: dbWeather.icon!)
                self.currentWeatherTemp.text = "\(dbWeather.temp)º"
                self.currentWeatherDescriptionLabel.text = dbWeather.weatherDescription
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? WeatherTableCell
        
        if let cell = cell {
            cell.dateLabel.text = "2022-03-04"
            cell.weatherImage.image = UIImage(named: "c03d")
            cell.weatherConditionLabel.text="Partly cloudy"
            cell.tempLabel.text="23º"
            return cell
            
        }else{
            let newCell = WeatherTableCell()
            newCell.dateLabel.text = "2022-03-04"
            newCell.weatherImage.image = UIImage(named: "c03d")
            newCell.weatherConditionLabel.text="Partly cloudy"
            newCell.tempLabel.text="23º"
            return newCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
