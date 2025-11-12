//
//  Profile.swift
//  Pet Care
//
//  Created by Maverick on 09/09/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Manage your account and app settings")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
