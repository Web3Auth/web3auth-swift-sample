//
//  HomePageview.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 24/03/22.
//

import SwiftUI
import Web3Auth

struct LoginHomePageview: View {
    @State var showNext = false
    @StateObject var vm:LoginMethodSelectionPageVM
    var networkArr:[Network] = [.mainnet,.testnet,.cyan]
    let blockChainArr:[BlockchainEnum] = [.ethereum,.solana] 
    var body: some View {
        VStack(){
        VStack{
            Image("web3auth-banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 32, alignment: .center)
                Text("Select network and Blockchain to login")
                .foregroundColor(.gray)
                .font(.custom(DMSANSFONTLIST.Regular, size: 16))
        }
        .padding([.top,.bottom] ,100)
            VStack(spacing:24){
                VStack(spacing:24){
                    MenuPickerView(currentSelection: $vm.web3AuthManager.network, arr: networkArr, title: "Web3Auth Network")
                    MenuPickerView(currentSelection: $vm.selectedBlockchain, arr: blockChainArr, title: "BlockChain")
        }
            .padding(.bottom,48)
                Button {
                    showNext.toggle()
                } label: {
                    Text("Login")
                        .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                        .foregroundColor(.white)
                        .frame(width: 308, height: 48)
                        .background(Color(UIColor.themeColor()))
                        .cornerRadius(24)
                    
                }
              
              
                
            }
            .fullScreenCover(isPresented: $showNext) {

                LoginMethodSelectionPage(vm: vm)
            }
            
            Spacer()
            
        }
        
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color(uiColor: .bkgColor()))
    }
    
    

    

    

}

struct HomePageview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginHomePageview( vm: .init(web3AuthManager: .init(network: .mainnet), authManager: AuthManager()))
                .environmentObject(Web3AuthManager(network: .mainnet))
            let arr:[Network] = [.mainnet,.testnet,.cyan]
            MenuPickerView(currentSelection: .constant(arr[0]), arr: arr, title: "web3Auth Network")
        }
    }
}






