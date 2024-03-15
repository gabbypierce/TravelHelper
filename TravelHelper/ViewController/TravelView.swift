import SwiftUI

struct TravelView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Where to Next?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                NavigationLink(destination: SecondView()) {
                    Text("Next Destination")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                
                NavigationLink(destination: JournalView()) {
                    Text("Journal View")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            .background(
                Image("newPhoto") 
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }
            
        }
    }

struct TravelView_Previews: PreviewProvider {
    static var previews: some View {
        TravelView()
    }
}
