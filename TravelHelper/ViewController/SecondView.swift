//
//  SecondView.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 2/12/24.
//
import SwiftUI

struct SecondView: View {
    @State private var cityName = ""
    @State private var stateAbbreviation = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    @ObservedObject var viewModel = SecondViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter Location")
                    .font(.title)
                    .padding()
                
                TextField("City Name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("State Abbreviation (e.g., CA)", text: $stateAbbreviation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    isLoading = true
                    errorMessage = ""
                    viewModel.fetchRestaurants(cityName: cityName, stateAbbreviation: stateAbbreviation) { success, error in
                        isLoading = false
                        if let error = error {
                            errorMessage = "Failed to fetch resturants: \(error.localizedDescription)"
                        } else if !success {
                            errorMessage = "No results found."
                        }
                    }
                }) {
                    Text(isLoading ? "Loading..." : "Search")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(isLoading ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }.disabled(isLoading)
                
                Spacer()
                
                List(viewModel.restaurants, id: \.id) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)){
                        Text(restaurant.restaurantName ?? "Unknown Restaurant")
                    }
                }
            }
            .navigationBarTitle("Find Restaurants", displayMode: .inline)
            .padding()
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}

