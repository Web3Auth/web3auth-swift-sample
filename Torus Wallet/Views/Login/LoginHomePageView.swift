//
//  HomePageview.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 24/03/22.
//

import SwiftUI

struct LoginHomePageview: View {
    @State var showNext = false
    @StateObject var vm: LoginMethodSelectionPageVM
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image("web3auth-banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 32, alignment: .center)
                    Text("Select network and Blockchain to login")
                        .foregroundColor(.gray)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                }
                .padding([.top, .bottom], 100)
                VStack(spacing: 24) {
                    VStack(spacing: 24) {
                        MenuPickerView(currentSelection: $vm.network, arr: vm.networkArr, title: "Web3Auth Network")
                        MenuPickerView(currentSelection: $vm.blockchain, arr: BlockchainEnum.allCases.reversed(), title: "BlockChain")
                    }
                    .padding(.bottom, 48)
                    NavigationLink {
                        LoginMethodSelectionPage(vm: vm)
                    } label: {
                            Text("Login")
                                .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                                .foregroundColor(.white)
                                .frame(width: 308, height: 48)
                                .background(Color.themeColor())
                                .cornerRadius(24)

                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bkgColor())
        }
        .tint(Color.tabBarColor())
    }
}

struct HomePageview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginHomePageview(vm: .init(authManager: .init()))
        }
    }
}
