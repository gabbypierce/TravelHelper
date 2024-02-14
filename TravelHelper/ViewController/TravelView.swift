//
//  TravelView.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 2/12/24.
//

import SwiftUI
import SwiftData

struct TravelView: View {
    
    var body: some View {
        NavigationStack
        {
            VStack
            {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundStyle(.tint)
                Text("Where to Next?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .position(CGPoint(x: 180.0, y: 100.0))
                NavigationLink("Click Here", destination: SecondView())
            }
        .padding()
        }
    }
}
#Preview
{
    TravelView()
}
       
