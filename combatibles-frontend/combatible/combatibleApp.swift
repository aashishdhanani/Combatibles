//
//  combatibleApp.swift
//  combatible
//
//  Created by Aiden Seibel on 4/15/24.
//

import SwiftUI

@main
struct combatibleApp: App {
    @StateObject var viewModel = ViewModel()
//    @ObservedObject private var bluetoothViewModel = BluetoothModel()

    var body: some Scene {
        WindowGroup {
            if !viewModel.isLoggedIn{
                LoginSignUpView()
            }else if !viewModel.hasOnboarded{
                OnboardingQuestionsView()
            }else if let battle = viewModel.currentBattle{
                BattleView(battle: battle)
            }else{
                TabView{
                    NetworkingTab()
                        .tabItem {
                            Label("Local", systemImage: "network")
                        }
//                    MapTab()
//                        .tabItem {
//                            Label("Map", systemImage: "map.fill")
//                        }
                    BattleSetupTab()
                        .tabItem {
                            Label("Battle", systemImage: "flag.2.crossed.fill")
                        }
                    ProfileTab()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                }
            }
        }
        .environmentObject(viewModel)
//        .environmentObject(bluetoothViewModel)
    }
}
