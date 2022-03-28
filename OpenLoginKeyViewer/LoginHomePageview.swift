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
    @State var selectedBlockChain:BlockchainEnum = .Ethereum
    @State var selectedNetwork:Network = .mainnet
    var networkArr:[Network] = [.mainnet,.testnet,.cyan]
    var body: some View {
        VStack(){
        VStack{
            Image("web3auth-banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 32, alignment: .center)
                Text("Select network and Blockchain to login")
                .foregroundColor(.gray)
                .font(.init(.system(size: 16)))
        }
        .padding([.top,.bottom] ,100)
            VStack(spacing:24){
            VStack(alignment:.leading){
            Text("Web3Auth Network")
                .foregroundColor(.init(.labelColor()))
                .fontWeight(.semibold)
                .font(.init(.system(size: 14)))
                Menu(content: {
                    ForEach(networkArr,id:\.self){ category in
                        Button {
                            changeNetwork(val: category)
                                           } label: {
                                               Text(category.name)
                                           }
                                        }
                }, label: {
                    HStack(alignment:.center){
                    Text(selectedNetwork.name)
                            .font(.system(size: 16))
                            .padding()
                        Spacer()
                    Image("dropDown")
                            .frame(alignment: .trailing)
                            .padding()
                    }
                })
                .foregroundColor(.gray)
                .frame(width: 308, height: 48, alignment: .center)
                .background(Color.white)
                .cornerRadius(36)
            
        }
            VStack(alignment:.leading){
            Text("Blockchain")
                .foregroundColor(.init(.labelColor()))
                .fontWeight(.semibold)
                .font(.init(.system(size: 14)))
                Menu(content: {
                    ForEach(BlockchainEnum.allCases, id: \.self) { category in
                        Button {
                            changeBlockChain(val: category.rawValue)
                                           } label: {
                                               Text(category.name)
                                           }
                                        }
                }, label: {
                    HStack(alignment:.center){
                    Text(selectedBlockChain.name)
                            .font(.system(size: 16))
                            .padding()
                        Spacer()
                    Image("dropDown")
                            .frame(alignment: .trailing)
                            .padding()
                    }
                })
                .foregroundColor(.gray)
                .frame(width: 308, height: 48, alignment: .center)
                .background(Color.white)
                .cornerRadius(36)
            
        }
            .padding(.bottom,48)
                Button {
                    showNext.toggle()
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(width: 308, height: 48)
                        .background(Color(UIColor.themeColor()))
                        .cornerRadius(24)
                }
              
              
                
            }
            .fullScreenCover(isPresented: $showNext) {
                LoginMethodSelectionPage()
            }
            
            Spacer()
            
        }
        
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color(uiColor: .bkgColor()))
    }
    
    
        
  
    
    func changeNetwork(val:Network){
        selectedNetwork = val
        Env.shared.changeNetwork(net: selectedNetwork)
    }
    

    
    func changeBlockChain(val:Int){
        selectedBlockChain = BlockchainEnum(rawValue:val) ?? .Ethereum
    }
}

struct HomePageview_Previews: PreviewProvider {
    static var previews: some View {
        LoginHomePageview()
    }
}


