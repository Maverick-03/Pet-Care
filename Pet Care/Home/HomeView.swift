//
//  Home.swift
//  Pet Care
//
//  Created by Maverick on 09/09/25.
//
import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel = .init(service: HomeAPIServices())
    @EnvironmentObject var petDesc: Record
    @State var loading: Bool = true
    @State var image: Image = Image("dog")
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(spacing: 20) {
                    ScrollView(.vertical){
                        VStack{
                            blockView(
                                petDetails()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                
                            )
                            blockView(
                                QuickActions().padding()
                            )
                            blockView(
                                recentItems().padding()
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .navigationTitle("Home")
                .onAppear {
                    Task{
                        let result: Result<PetDesc, HomeAPIServicesError> = await viewModel.service.fetchPetDetails(request: .fetchPetDetails)
                        loading = false
                        switch result {
                        case .success(let value):
                            self.petDesc.pet = value.record.pet
                            self.petDesc.actions = value.record.actions
                            self.petDesc.actions = value.record.actions
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                        
                    }
                }
                
                if loading {
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(2)
                }
            }
        }

    }
    
    func QuickActions() -> some View {
        let items: [Actions] = petDesc.actions
        
        return VStack {
            Text("Quick Actions")
                .font(.title)
                .fontWeight(.regular)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 2), spacing: 20) {
                    ForEach(items) { item in
                        blockView(
                            VStack(spacing: 10){
                                VStack(spacing: 10){
                                    Image(systemName: item.image)
                                    Text(item.title)
                                            .font(.body)
                                            .fontWeight(.regular)
                                            .fixedSize()
                                    }
                            }
                                .frame(width: 120,height: 60)
                            .padding()
                        )
                    }
                }
            }
            .scrollDisabled(true)
        }
    }
    
    
    func recentItems() -> some View {
        let recents = petDesc.recents
        return VStack(alignment: .leading) {
            Text("Recent Activity")
                .font(.title)
                .fontWeight(.regular)
                .frame(alignment: .leading)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100)), count: 1), alignment: .leading, spacing: 20) {
                    ForEach(recents) { recent in
                        HStack{
                            Image(systemName: recent.image)
                            Text(recent.activityTitle)
                                .font(.body)
                                .fontWeight(.regular)
                        }
                    }
                }
            }
        }
    }
    
    func petDetails() -> some View {
        HStack {
            image
                .resizable()
                .frame(width: 60, height: 60)
                .background(.gray)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .cornerRadius(30)

            VStack(alignment: .leading) {
                Text(petDesc.pet.name )
                    .font(.title)
                    .fontWeight(.bold)
                Text(petDesc.pet.description)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "ImageUpdate"))) { notification in
            image = Image(uiImage: notification.object as! UIImage)
        }
    }

}

func blockView(_ view: some View) -> some View {
    VStack{
        view
    }
    .cornerRadius(10.0)
    .border(Color(hex: "#d3d3d3"))
    .frame(maxWidth: .infinity)
}

#Preview {
    HomeView()
}
