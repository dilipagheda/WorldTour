//
//  NetworkService.swift
//  WorldTour
//
//  Created by Dilip Agheda on 1/4/22.
//

import Foundation
import Alamofire

class NetworkService {
    
    public static let shared: NetworkService = NetworkService()
    
    private init() {}

    private func getFlagImage(flagImageUrl: String, completion: @escaping (Data?, String?) -> Void) {
        AF.request(flagImageUrl)
            .validate()
            .response() {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    if let value = response.value {
                        completion(value, nil)
                    }
                    
                case let .failure(error):
                    print(error)
                    completion(nil, error.errorDescription)
                }
            }
    }
    
    public func getAllCountries(completion: @escaping ([Country]?, String?) -> Void) {
        AF.request("https://restcountries.com/v2/all")
            .validate()
            .responseDecodable(of: [Country].self) {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    if let value = response.value {
                        self.fetchAllCountryFlags(countries: value) {
                            (data) in
                            completion(data, nil)
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    completion(nil, error.errorDescription)
                }
            }
    }
    
    private func fetchAllCountryFlags(countries: [Country], completion: @escaping ([Country])->Void) {
        
        let total = countries.count
        
        func fetchCountryFlag(index: Int) {
            
            if(index >= total) {
                completion(countries)
                return
            }
            
            self.getFlagImage(flagImageUrl: countries[index].flags.png) {
                (data, errorMessage) in
                if let data = data {
                    countries[index].flagPNGImage = data
                    fetchCountryFlag(index: index + 1)
                }
            }
        }
        
        fetchCountryFlag(index: 0)
    }
}
