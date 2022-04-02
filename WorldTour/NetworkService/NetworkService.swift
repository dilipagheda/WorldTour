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
    
    public func getAllCountries() {
        AF.request("https://restcountries.com/v2/all")
            .validate()
            .responseDecodable(of: [Country].self) {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    if let value = response.value {
                        for v in value {
                            debugPrint(v.name)
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                }
            }
    }
}
