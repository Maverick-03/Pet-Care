//
//  PetDetails.swift
//  Pet Care
//
//  Created by Maverick on 25/09/25.
//
import Foundation

struct PetDesc: Codable{
    let record: Record
}

class Record: Codable, ObservableObject {
    @Published var pet: Pet
    @Published var actions: [Actions]
    @Published var recents: [Recents]
    
    init(pet: Pet, actions: [Actions], recents: [Recents]) {
        self.pet = pet
        self.actions = actions
        self.recents = recents
    }
    
    enum CodingKeys: String, CodingKey {
           case pet, actions, recents
       }
    
    // MARK: - Codable conformance
      required init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          pet = try container.decode(Pet.self, forKey: .pet)
          actions = try container.decode([Actions].self, forKey: .actions)
          recents = try container.decode([Recents].self, forKey: .recents)
      }
      
      func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(pet, forKey: .pet)
          try container.encode(actions, forKey: .actions)
          try container.encode(recents, forKey: .recents)
      }
}

struct Pet: Codable {
    let name: String
    let description: String
}

struct Actions: Codable, Identifiable {
    var id: UUID = UUID()
    let title: String
    var image: String = "bell.fill"
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}

struct Recents: Codable, Identifiable {
    var id: UUID = UUID()
    let activityTitle: String
    var image: String = "bell.fill"
    
    enum CodingKeys: String, CodingKey {
        case activityTitle
    }
}

