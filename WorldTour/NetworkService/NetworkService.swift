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

    private func getImage(imageUrl: String, completion: @escaping (Data?, String?) -> Void) {
        AF.request(imageUrl)
            .validate()
            .response() {
                response in
                switch response.result {
                case .success:
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
            
            self.getImage(imageUrl: countries[index].flags.png) {
                (data, errorMessage) in
                if let data = data {
                    countries[index].flagPNGImage = data
                    fetchCountryFlag(index: index + 1)
                }
            }
        }
        
        fetchCountryFlag(index: 0)
    }
    
    private func fetchAllPhotosData(hits: [Hits], completion: @escaping ([Data])->Void) {
        
        let total = hits.count
        var photosData: [Data] = []
        
        func fetchPhotoData(index: Int) {
            
            if(index >= total) {
                completion(photosData)
                return
            }
            
            self.getImage(imageUrl: hits[index].webformatURL) {
                (data, errorMessage) in
                if let data = data {
                    photosData.append(data)
                    fetchPhotoData(index: index + 1)
                }
            }
        }
        
        fetchPhotoData(index: 0)
    }
    
    public func getPhotosByKeyword(keyword: String, completion: @escaping ([Data]?, String?) -> Void) {
        
        //let urlString = "https://pixabay.com/api/?key=17840818-48ce838c22eb5fa37ac01548d&q=\(keyword)"
        
        var urlParams = URLComponents(string: "https://pixabay.com/api/")!
        urlParams.queryItems = [
            URLQueryItem(name: "key", value: "17840818-48ce838c22eb5fa37ac01548d"),
            URLQueryItem(name: "q", value: keyword)
        ]
        
        let s = urlParams.url!.absoluteString
        
        AF.request(s)
            .validate()
            .responseDecodable(of: Pixabay.self) {
                response in
                switch response.result {
                case .success:
                    if let value = response.value {
                        self.fetchAllPhotosData(hits: value.hits) {
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
}
