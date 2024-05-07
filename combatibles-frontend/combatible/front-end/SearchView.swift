//
//  SearchView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var searchBarText: String = ""
    @FocusState var focusSearch: Bool
        
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack(alignment: .center, spacing: 1){
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 1))
                
                TextField("Search Friends...", text: $searchBarText)
                    .padding(10)
                    .focused($focusSearch)
                
                Spacer()
            }
            .background(.white)
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))
            
            NavigationLink(destination: BluetoothDeviceSearchView()) {
                Text("Search via Bluetooth...")
                    .font(.title2)
                    .bold()
            }
            
            // search results
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Text("Search Results")
                        .font(.title2)
                        .bold()
                
                    ForEach(getSearchUserResults(searchString: searchBarText), id: \.self){ user in
                        NavigationLink {
                            ViewUserView(user: user)
                        } label: {
                            SearchResultView(user: user)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(10)
        .onAppear{
            focusSearch = true
        }
    }
    
    func getSearchUserResults(searchString: String) -> [user]{
        var results: [user] = []
        let lowercaseSearchString = searchString.lowercased()
        
        return viewModel.localUserFriends.filter { user in
            let lowercaseFirstName = user.firstName.lowercased()
//            let lowercaseLastName = user.lastName.lowercased()
            let lowercaseUsername = user.username.lowercased()
            return lowercaseFirstName.contains(lowercaseSearchString) ||
//                   lowercaseLastName.contains(lowercaseSearchString) ||
                   lowercaseUsername.contains(lowercaseSearchString)
        }
    }
}

#Preview {
    SearchView()
}
