//
//  PetviewModel.swift
//  Pet Care
//
//  Created by Maverick on 07/10/25.
//

@MainActor
struct PetViewModel {
    let service: PetImageApiClientProtocol
    
    
    init (service: PetImageApiClientProtocol = PetImageListService()) {
        self.service = service
    }
    
    func fetchImage() async throws -> PetImageList {
        let result: Result<PetImageList, HomeAPIServicesError> = await service.fetchPetsImage()
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
}
