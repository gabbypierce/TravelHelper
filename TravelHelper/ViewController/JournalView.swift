//  JournalView.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 2/26/24.
//

import SwiftUI
import PhotosUI

// MARK: - Models and ViewModel
struct JournalEntry: Identifiable, Codable {
    let id: UUID
    var placeName: String
    var favoritePlace: String
    var favoriteMemory: String
    var imageData: Data?
    
    init(id: UUID = UUID(), placeName: String, favoritePlace: String, favoriteMemory: String, imageData: Data? = nil) {
        self.id = id
        self.placeName = placeName
        self.favoritePlace = favoritePlace
        self.favoriteMemory = favoriteMemory
        self.imageData = imageData
    }
}

class EntriesViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    init() {
        loadEntries()
    }
    
    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
    }
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }
    
    private func saveEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "Entries")
        }
    }
    
    private func loadEntries() {
        if let savedEntries = UserDefaults.standard.object(forKey: "Entries") as? Data {
            let decoder = JSONDecoder()
            if let loadedEntries = try? decoder.decode([JournalEntry].self, from: savedEntries) {
                self.entries = loadedEntries
            }
        }
    }
}

// MARK: - JournalView
struct JournalView: View {
    @ObservedObject var viewModel = EntriesViewModel()
    @State private var showingAddEditEntry = false
    @State private var entryToEdit: JournalEntry?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                                VStack {
                                    Text("MY JOURNAL ENTRIES")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding(.top, 50)
                                    List {
                                                            ForEach(viewModel.entries) { entry in
                                                                JournalEntryCard(entry: entry, editAction: {
                                                                    self.entryToEdit = entry
                                                                    self.showingAddEditEntry = true
                                                                })
                                                                .padding(.vertical, 5)
                                                            }
                                                            .onDelete(perform: deleteItems)
                                                        }
                                                        .listStyle(PlainListStyle())
                                    
                                    FloatingActionButton(action: {
                                        self.entryToEdit = nil // for adding a new entry
                                        self.showingAddEditEntry = true
                                    })
                                }
                            }
                            .sheet(isPresented: $showingAddEditEntry) {
                                AddEditEntryView(entry: self.$entryToEdit) { result in
                                    if let entry = self.entryToEdit {
                                        viewModel.updateEntry(result)
                                    } else {
                                        viewModel.addEntry(result)
                                    }
                                    self.entryToEdit = nil
                                }
                            }
                            .navigationBarHidden(true)
                        }
                    }
    private func deleteItems(at offsets: IndexSet) {
            viewModel.deleteEntry(at: offsets)
        }
    }
    // MARK: - AddEditEntryView
    struct AddEditEntryView: View {
        @Binding var entry: JournalEntry?
        var onSave: (JournalEntry) -> Void
        @Environment(\.presentationMode) var presentationMode
        
        @State private var placeName: String = ""
        @State private var favoritePlace: String = ""
        @State private var favoriteMemory: String = ""
        @State private var showingImagePicker = false
        @State private var entryImageData: Data?
        
        var body: some View {
            NavigationView {
                Form {
                    TextField("Place Name", text: $placeName)
                    TextField("Favorite Place", text: $favoritePlace)
                    TextField("Favorite Memory", text: $favoriteMemory)
                    Button("Choose Image"){
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        PhotoPicker(selectedImageData: $entryImageData)
                    }
                    if let entryImageData = entryImageData, let uiImage = UIImage(data: entryImageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                    Button("Save") {
                        let savingEntry = JournalEntry(id: entry?.id ?? UUID(), placeName: placeName, favoritePlace: favoritePlace, favoriteMemory: favoriteMemory, imageData: entryImageData)
                        onSave(savingEntry)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .navigationBarTitle(entry == nil ? "Add Entry" : "Edit Entry", displayMode: .inline)
                .onAppear {
                    //Pre-populate the fields if editing an existing entry
                    if let entry = entry {
                        placeName = entry.placeName
                        favoritePlace = entry.favoritePlace
                        favoriteMemory = entry.favoriteMemory
                        
                        if entryImageData == nil {
                            entryImageData = entry.imageData
                        }
                    }
                }
            }
        }
    }
    
    struct PhotoPicker: UIViewControllerRepresentable {
        @Binding var selectedImageData: Data?
        
        func makeUIViewController(context: Context) -> some UIViewController {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            var parent: PhotoPicker
            
            init(_ parent: PhotoPicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                
                guard let provider = results.first?.itemProvider else { return }
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            self.parent.selectedImageData = image.jpegData(compressionQuality: 1.0)
                        }
                    }
                }
            }
        }
        
    }
struct JournalEntryCard: View {
    var entry: JournalEntry
    var editAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Place: \(entry.placeName)")
                    .fontWeight(.medium)
                Text("Favorite Place: \(entry.favoritePlace)")
                Text("Favorite Memory: \(entry.favoriteMemory)")
            }
            .padding()
            
            HStack {
                Spacer()
                Button(action: editAction) {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

// MARK: - FloatingActionButton View
struct FloatingActionButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 4)
        .padding()
    }
}
