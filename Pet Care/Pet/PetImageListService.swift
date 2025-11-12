//
//  PetApiService.swift
//  Pet Care
//
//  Created by Maverick on 07/10/25.
//

import Foundation

protocol PetImageApiClientProtocol {
    func fetchPetsImage<T:Codable>() async -> Result<T, HomeAPIServicesError>
}

enum PetImageAPIRequest{
    case fetchPetImages

    var path: String {
        switch self{
        case .fetchPetImages:
            return "https://dog.ceo/api/breed/hound/images"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var mock: Bool {
        return false
    }
    
    var headers: [String: String] {
        return [:]
    }
    
}


actor PetImageListService: PetImageApiClientProtocol {
    
    func fetchPetsImage<T:Codable>() async -> Result<T, HomeAPIServicesError> {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        do {
            let request = try buildRequest(request: PetImageAPIRequest.fetchPetImages)
            
            let (data,_) = try await session.data(for: request)
            
            let result = try JSONDecoder().decode(T.self, from: data)
            
            return .success(result)

        } catch let error{
            return .failure(.errorOccured(error))
        }
    }
    
    private func buildRequest(request: PetImageAPIRequest) throws -> URLRequest {
        guard let url = URL(string: request.path) else{
            throw HomeAPIServicesError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        request.headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
        
    }
}
