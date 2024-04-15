import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let address = restaurant.address {
                Text("Address: \(address)")
            }
            if let phone = restaurant.phone {
                Text("Phone: \(phone)")
            }
            // Safely unwrap the website URL
            if let website = restaurant.website, let url = URL(string: website) {
                Link("Visit website", destination: url)
            } else {
                Text("No website available")
            }
            if let hours = restaurant.hoursInterval {
                Text("Hours: \(hours)")
            }
            if let cuisine = restaurant.cuisineType {
                Text("Cuisine: \(cuisine)")
            }
        }
        .padding()
        .navigationBarTitle(restaurant.restaurantName ?? "Restaurant Details", displayMode: .inline)
    }
}
