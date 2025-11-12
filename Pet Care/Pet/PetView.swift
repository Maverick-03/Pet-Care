//
//  Pet.swift
//  Pet Care
//
//  Created by Maverick on 09/09/25.
//
import SwiftUI
import PhotosUI
import Foundation



struct PetImageListView: View {
    let petsList: PetImageList
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            let messages: [String] = petsList.message
            ScrollView{
                LazyVGrid(columns: Array.init(repeating: GridItem(spacing: 20), count: 4)) {
                    ForEach(messages, id: \.self) { urls in
                        AsyncView(str: urls,selectedImage: $selectedImage)
                    }
                }
            }
            .padding()
        }
    }
    
    
    struct AsyncView: View {
        let str: String
        @Binding var selectedImage: UIImage?

        @State var image: Image = Image("dog")
        @State var imageUI: UIImage? = nil
        @Environment(\.dismiss) private var dismiss
        var body: some View {
            VStack{
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        selectedImage = imageUI
                        dismiss()
                    }
            }
            .onAppear {
                Task{
                    await loadImage(string: str)
                }
            }
            
        }
        
        func loadImage(string: String) async {
            let url = URL(string: string)
            let (data, _) = try! await URLSession.shared.data(from: url!)
            imageUI = UIImage(data: data)!
            image = Image(uiImage: imageUI!)
        }
    }
    
    
}

struct PetView: View {
    let detailsHeadings: [String] = ["Age", "Weight"]
    @EnvironmentObject var petDesc: Record
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var image: Image = Image("dog")
    @State var selectedImageAPI: UIImage?

    @State var presentActionSheet: Bool = false
    @State var showPicker: Bool = false
    @State var showloader: Bool = false
    @State var selectedDestination: String? = nil
    @State var petList: PetImageList?

    var petViewModel: PetViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack{
                if showloader {
                    ProgressView().progressViewStyle(.circular)
                        .scaleEffect(2)
                }
                VStack(spacing: 10) {
                    ScrollView {
                        headerView()
                        blockView(
                            petDetails()
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .navigationTitle("Pet")
                .navigationDestination(item: $selectedDestination, destination: {  value in
                    if value == "list" {
                        if let petList = petList{
                            PetImageListView(petsList: petList, selectedImage: $selectedImageAPI)
                        }
                    }
                })
            }
        }
        
    }
    
    
    func headerView() -> some View {
        VStack(spacing: 10) {
            image
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .background(.green)
                .cornerRadius(50)
            VStack {
                Text(petDesc.pet.name)
                    .font(.title)
                    .fontWeight(.bold)
                Text(petDesc.pet.description)
                    .font(.title2)
                Button {
                    presentActionSheet = true
                } label: {
                    Text("Edit")
                }

            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ImageUpdate"), object: uiImage)
                }
                
            }
        }
        .onChange(of: selectedImageAPI, { oldValue, newValue in
            image = Image(uiImage: newValue!)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ImageUpdate"), object: newValue)
        })
        .actionSheet(isPresented: $presentActionSheet) {
            let listButton: ActionSheet.Button = .default(Text("list")) {
                Task {
                    showloader = true
                    self.petList = try await petViewModel.fetchImage()
                    selectedDestination = "list"
                    showloader = false
                }
            }
            
            let pickerButton: ActionSheet.Button = .default(Text("Gallery")) {
                showPicker = true
            }
            
            let cancel: ActionSheet.Button = .default(Text("cancel"))
            
            return ActionSheet(title: Text("Get Images"), buttons: [listButton, pickerButton, cancel])
        }
        
    }
    
    func petDetails() -> some View {
        VStack(alignment: .leading){
            Text("Pet Details")
                .font(.title3)
                .frame(maxWidth: .infinity)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(0..<2) { index in
                    VStack {
                        Text(detailsHeadings[index])
                            .font(.title2)
                        Text("12")
                            .font(.title3)
                    }
                }
            }
            .frame(maxWidth: .infinity)

        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
}

#Preview {
    
    PetView( petList: PetImageList(message: [""]))
        .environmentObject(Record(pet: Pet(name: "Dog", description: "Golden Retriever"), actions: [], recents: []))
}
