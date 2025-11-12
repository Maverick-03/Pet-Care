//
//  Logs.swift
//  Pet Care
//
//  Created by Maverick on 09/09/25.
//
import SwiftUI

struct LogsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "list.bullet.clipboard.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Activity Logs")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Track your pet's activities and health records")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Logs")
        }
    }
}
