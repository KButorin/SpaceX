//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by ESSIP on 01.12.2024.
//

import Foundation

class LaunchesViewModel {
    
    let launchRequest: LaunchesRequest?
    private var launches: [Launch] = []
    
    init(launchRequest: LaunchesRequest){
        self.launchRequest = launchRequest
        getData()
    }
    
    public func getData(){
        launchRequest?.fetchData { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let launchesData):
                    self?.launches = launchesData
                case .failure(let failure):
                    print("failure = \(failure)")
                }
            }
        }
    }
}
    
    
    

