//
//  BattleSetupTab.swift
//  combatible
//
//  Created by Aiden Seibel on 4/20/24.
//

import SwiftUI

struct BattleSetupTab: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var bluetoothOption: String = "central"
    var bluetoothOptions: [String] = ["central", "peripheral"]

    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                VStack(alignment: .center, spacing: 30){
                    Picker("bluetooth", selection: $bluetoothOption) {
                        ForEach(bluetoothOptions, id: \.self){option in
                            Text("\(option)")
                        }
                    }.pickerStyle(.segmented)

                    if bluetoothOption == "central"{
                        HStack{
                            VStack{
                                Text("Team 1")
                                    .bold()
                                if let t1p1 = viewModel.localUser{
                                    PersonCardMedium(user: t1p1)
                                }else{
                                    NavigationLink(destination: BluetoothDeviceSearchView()) {
                                        AddPersonCard()
                                    }
                                    .buttonStyle(.plain)
                                }
                                if let t1p2 = viewModel.battleSetupTeam1Player2{
                                    PersonCardMedium(user: t1p2)
                                }else{
                                    NavigationLink(destination: BluetoothDeviceSearchView()) {
                                        AddPersonCard()
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        viewModel.battleSetupTeamSelected = 1
                                        viewModel.battleSetupPlayerSelected = 2
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.45)
                            .background(Color("light_red"))
                            .cornerRadius(10)

                            
                            VStack{
                                Text("Team 2")
                                    .bold()
                                if let t2p1 = viewModel.battleSetupTeam2Player1{
                                    PersonCardMedium(user: t2p1)
                                }else{
                                    NavigationLink(destination: BluetoothDeviceSearchView()) {
                                        AddPersonCard()
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        viewModel.battleSetupTeamSelected = 2
                                        viewModel.battleSetupPlayerSelected = 1
                                    })
                                    .buttonStyle(.plain)

                                }
                                if let t2p2 = viewModel.battleSetupTeam2Player2{
                                    PersonCardMedium(user: t2p2)
                                }else{
                                    NavigationLink(destination: BluetoothDeviceSearchView()) {
                                        AddPersonCard()
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        viewModel.battleSetupTeamSelected = 2
                                        viewModel.battleSetupPlayerSelected = 2
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.45)
                            .background(Color("light_blue"))
                            .cornerRadius(10)
                        }
                        Button {
//                            if canBattle(){
                                viewModel.startBattle()
//                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("Start Battle")
                                    .foregroundStyle(.white)
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                        }
                    }
                    else{
                        Button {
                            viewModel.peripheralBluetoothModel?.advertise()
                        } label: {
                            Text("Advertise my device")
                        }

                    }

                }
                .padding(12)
            }
            .navigationTitle("Battle Setup")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func canBattle() -> Bool{
        return viewModel.localUser != nil && viewModel.battleSetupTeam1Player2 != nil && viewModel.battleSetupTeam2Player1 != nil && viewModel.battleSetupTeam2Player2 != nil
    }
}

#Preview {
    BattleSetupTab()
}
