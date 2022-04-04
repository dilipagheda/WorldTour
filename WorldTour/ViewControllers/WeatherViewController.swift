//
//  WeatherViewController.swift
//  WorldTour
//
//  Created by Dilip Agheda on 2/4/22.
//

import Foundation
import UIKit


class WeatherViewController :UIViewController {
    
    var dbCountry: DBCountry?
    var currentDBWeather: DBWeather?
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!

    @IBOutlet weak var currentWeatherTemp: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var staticLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    func updateUI(isLoading: Bool) {
        capitalLabel.isHidden = isLoading
        weatherIconImageView.isHidden = isLoading
        currentWeatherDescriptionLabel.isHidden = isLoading
        currentWeatherTemp.isHidden = isLoading
        staticLabel.isHidden = isLoading
        refreshButton.isHidden = isLoading
    }
    
    
    @IBAction func onRefreshTap(_ sender: Any) {
        
        getCurrentWeather(shouldRefresh: true)
    }

    func getCurrentWeather(shouldRefresh:Bool) {
        
        activityView.startAnimating()
        updateUI(isLoading: true)

        ViewModelProvider.shared.getCurrentWeather(dbCountry: dbCountry!, shouldRefresh: shouldRefresh) {
            (dbWeather, errorMessage) in
            guard let dbWeather = dbWeather else {
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentWeather(shouldRefresh: false)
    }
}
