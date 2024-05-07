//
//  MapView.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI
import MapKit

struct MapTab: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.46, longitude: -98.495),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    ))
        
    @State var viewFriendsOnline: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Map(position: $cameraPosition){
                    ForEach(sampleUsers, id: \.self){ friend in
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: getRandomLatitude(), longitude: getRandomLongitude())) {
                            NavigationLink(destination: ViewUserView(user: friend)) {
                                AsyncImage(url: URL(string: friend.imageString)) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .background(.white)
                                            .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                                            .cornerRadius(UIScreen.main.bounds.width * 0.05)
                                            .clipped()
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                                            .cornerRadius(UIScreen.main.bounds.width * 0.05)
                                            .clipped()
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                    default:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFill()
                                            .background(.white)
                                            .frame(width: UIScreen.main.bounds.width * 0.10, height: UIScreen.main.bounds.width * 0.10)
                                            .cornerRadius(UIScreen.main.bounds.width * 0.05)
                                            .clipped()
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 20){
                    NavigationLink {
                        SearchView()
                    } label: {
                        HStack(alignment: .center, spacing: 1){
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 1))
                            
                            Text("Search Nearby...")
                                .foregroundStyle(Color("light_grey"))
                                .padding(10)
                            
                            Spacer()
                        }
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 1))

                    }                    
                    .buttonStyle(.plain)
                    .padding(20)

                
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Button {
                            withAnimation(.easeIn(duration: 0.25)) {
                                viewFriendsOnline.toggle()
                            }
                        } label: {
                            HStack{
                                Text("Friends Online")
                                    .bold()
                                    .font(.title2)
                                Spacer()
                                Image(systemName: (viewFriendsOnline ? "chevron.down":"chevron.forward"))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                            }
                        }.buttonStyle(.plain)
                        
                        if viewFriendsOnline{
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(sampleUsers, id: \.self){ friend in
                                        NavigationLink(destination: ViewUserView(user: friend)) {
                                            PersonCardMedium(user: friend)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(.white)
                    .cornerRadius(10)
                    .ignoresSafeArea(edges: .bottom)
                    .padding(10)
                }
            }
            .onAppear{
                cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: getRandomLatitude() ?? 29.46, longitude: getRandomLongitude() ?? -98.495),
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                ))
            }
        }
    }
}

#Preview {
    MapTab()
}
    
