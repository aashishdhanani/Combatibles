//
//  BluetoothDeviceSearch.swift
//  combatible
//
//  Created by Aiden Seibel on 4/28/24.
//

import SwiftUI

struct BluetoothDeviceSearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            List(viewModel.centralBluetoothModel?.nearbyUsers ?? [], id: \.self) { user in
                Button{
                    viewModel.addToBattleSetup(user: user)
                } label:{
                    Text(user.firstName)
                }
            }
        }
        .navigationTitle("All Devices")
        .padding(12)
    }
}

#Preview {
    BluetoothDeviceSearchView()
}
