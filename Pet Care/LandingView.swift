//
//  ContentView.swift
//  Pet Care
//
//  Created by Maverick on 06/09/25.
//

import SwiftUI

struct LandingView: View {
    @StateObject var petDesc: Record = Record(pet: Pet(name: "Dog", description: "Golden Retriever"), actions: [], recents: [])
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            PetView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Pet")
                }
            
            LogsView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Logs")
                }
            
            RemindersView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Reminders")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .environmentObject(petDesc)

    }
}


#Preview {
    LandingView()
}
