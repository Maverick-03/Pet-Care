//
//  Reminders.swift
//  Pet Care
//
//  Created by Maverick on 09/09/25.
//
import SwiftUI

struct RemindersView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Reminders")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Set and manage reminders for pet care")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Reminders")
        }
    }
}
