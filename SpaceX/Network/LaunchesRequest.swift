//
//  LaunchesRequest.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation

class LaunchesRequest {
    
    static let shared = LaunchesRequest()
    
    //MARK: -Properties
    private let urlString = "https://api.spacexdata.com/v4/launches"
    
    //MARK: -fetchDataMethod
    
    public func fetchData( _ completion: @escaping(Result<[Launch], Error>) -> ()){
        
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
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode([Launch].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(Errors.decodingError))
                print("Error: \(error)")
            }
        }
        .resume()
    }
}
