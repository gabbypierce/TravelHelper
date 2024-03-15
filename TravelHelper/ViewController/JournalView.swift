//
//  JournalView.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 2/26/24.
//

import SwiftUI

struct JournalEntry {
    var placeName: String
    var favoritePlace: String
    var favoriteMemory: String
}

struct JournalView: View {
    @State private var showingAddEntry = false
    @State private var newEntry = JournalEntry(placeName: "", favoritePlace: "", favoriteMemory: "")
    @State private var entries: [JournalEntry] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("MY JOURNAL ENTRYS")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                
                List(entries, id: \.placeName) { entry in
                    VStack(alignment: .leading) {
                        Text("Place: \(entry.placeName)")
                        Text("Favorite Place: \(entry.favoritePlace)")
                        Text("Favorite Memory: \(entry.favoriteMemory)")
                    }
                    .padding()
                }
                
                Button(action: {
                    self.showingAddEntry = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showingAddEntry) {
                    VStack {
                        TextField("Location Name", text: $newEntry.placeName)
                        TextField("Favorite Place", text: $newEntry.favoritePlace)
                        TextField("Favorite Memory", text: $newEntry.favoriteMemory)
                        Button("Save") {
                            // Add the new entry to the list
                            self.entries.append(self.newEntry)
                            // Reset the new entry
                            self.newEntry = JournalEntry(placeName: "", favoritePlace: "", favoriteMemory: "")
                            // Dismiss the sheet
                            self.showingAddEntry = false
                        }
                    }
                    .padding()
                }
            }
            .background(
                Image("journalImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
