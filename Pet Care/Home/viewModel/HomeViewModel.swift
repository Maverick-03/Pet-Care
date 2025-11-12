//
//  HomeViewModel.swift
//  Pet Care
//
//  Created by Maverick on 24/09/25.
//

struct HomeViewModel{
    let service: HomeAPIProtocol
    
    init(service: HomeAPIProtocol) {
        self.service = service
    }
}
