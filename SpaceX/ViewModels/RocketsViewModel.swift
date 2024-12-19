//
//  RocketsViewModel.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation

class RocketsViewModel {
    
    private var rockets: [Rockets] = []
    private var request: RocketsRequest?
    
    init(){
        getData()
    }
    
    public func getData(){
        request?.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rocketsData):
                    self?.rockets = rocketsData
                case .failure(let failure):
                    print("failure = \(failure)")
                }
            }
        }
    }
    
}



