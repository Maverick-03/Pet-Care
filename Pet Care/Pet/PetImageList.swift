//
//  Pet.swift
//  Pet Care
//
//  Created by Maverick on 07/10/25.
//

import Foundation


class PetImageList: Codable {
    let message: [String]
    
    init(message: [String]) {
        self.message = message
    }
}
