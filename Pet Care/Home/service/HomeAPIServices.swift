//
//  HomeAPIServices.swift
//  Pet Care
//
//  Created by Maverick on 24/09/25.
//

import Foundation


protocol HomeAPIProtocol {
    func fetchPetDetails<T:Codable>(request: HomeAPIRequest) async -> Result<T, HomeAPIServicesError>
}

enum HTTPMethod: String {
    case get = "GET"
}

enum HomeAPIRequest{
    case fetchPetDetails

    var path: String {
        switch self{
        case .fetchPetDetails:
            return "https://api.jsonbin.io/v3/b/68e35df3ae596e708f07b2e6"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var mock: Bool {
        return false
    }
    
    var headers: [String: String] {
        return ["X-Master-Key":"$2a$10$L1.jfeLnjdHzaHLHxvPfhu6VSl04jCZ8sdbXUfc2AkCmdO/ncJJG2"]
    }
    
    
}

enum HomeAPIServicesError: Error {
    case invalidURL
    case decodingError
    case networkingError
    case errorOccured(Error)
}

@MainActor
struct HomeAPIServices: HomeAPIProtocol{
        
    func fetchPetDetails<T:Codable>(request: HomeAPIRequest) async -> Result<T, HomeAPIServicesError> {
        guard request.mock == false else{
            guard let file = Bundle.main.path(forResource: "pets", ofType: "json") else{
                return .failure(.invalidURL)
            }
            
            guard let data = try? Data(NSData(contentsOfFile: file)) else {
                return Result.failure(.decodingError)
            }
            do {
                 let result = try JSONDecoder().decode(T.self, from: data)
                 return .success(result)

            }catch let error{
                print(error)
                return .failure(.decodingError)
            }
        }
        
        
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        do {
            let request = try buildRequest(request: request)
            
            let (data,_) = try await session.data(for: request)
            
            let result = try JSONDecoder().decode(T.self, from: data)
            
            return .success(result)

        } catch let error{
            return .failure(.errorOccured(error))
        }
        
    }
    
    
    private func buildRequest(request: HomeAPIRequest) throws -> URLRequest {
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


