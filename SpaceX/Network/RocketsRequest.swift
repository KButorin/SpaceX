//
//  RocketsRequest.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation


class RocketsRequest {
    
    static let shared = RocketsRequest()
    
    //MARK: -Properties
    
    private let urlString = "https://api.spacexdata.com/v4/rockets"
    
    //MARK: -fetchDataMethod
    public func fetchData(completion: @escaping(Result<[Rockets], Error>) -> ()){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(Errors.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    print("Error: \(error)")
                    return completion(.failure(error))
                }
                return
            }
            
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode([Rockets].self, from: data)
                completion(.success(result))
                
            } catch {
                print("Error: \(error)")
                completion(.failure(Errors.decodingError))
            }
        }
        .resume()
    }
}

