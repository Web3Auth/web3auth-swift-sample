//
//  HomeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 28/03/22.
//

import SwiftUI
import Web3Auth
import UIKit

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @State var userInfo:Web3AuthState?
    @State var showTransferScreen = false
    @State var message:String = "Enter your message here"
    var body: some View {
        ScrollView{
            VStack{
            HStack{
            VStack(alignment:.leading,spacing: 8){
            Text("Welcome! Vinay")
                .fontWeight(.bold)
                .font(.custom(POPPINS_FONT_LIST.Bold, size: 24))
                HStack{
                    Image("Facebook")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                    Text(verbatim: "nattchireddi@gmail.com")
                        .font(.custom(POPPINS_FONT_LIST.Regular, size: 14))
                        .foregroundColor(.black)
                       
                }
            
        }
            .padding(.top,37)
       
                Spacer()
                VStack{
                    Button {
                        logout()
                    } label: {
                        Image("logout")
                    }
                    .frame(width: 24, height: 24, alignment: .center)
                    Text("Logout")
                        .font(.custom(POPPINS_FONT_LIST.Regular, size: 14))

                }
                .padding(.top,37)
        }
            .ignoresSafeArea()
            .frame(height: 115)
            .frame(maxWidth:.infinity)
            .padding()
            .background(.white)
                
                HStack(alignment: .center){
                    Text("Account Details")
                        .font(.custom(POPPINS_FONT_LIST.SemiBold, size: 16))
                        .padding()
                
                    Spacer()
                HStack{
                    Button {
                        openQRCode()
                    } label: {
                        Image("qr-code")
                            .frame(width: 24, height: 24, alignment: .center)
                            .background(.white)
                            .cornerRadius(12)
                            
                    }
                  
                    Button {
                        showPublicKey()
                    } label: {
                        Image("Shape")
                        Text("cxdjdk")
                            .foregroundColor(.gray)
                    }
                    .padding()
                            .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .frame(width: 100, height: 24, alignment: .center)
                                        .foregroundColor(.white)
                            )
                        

                }
                .padding(.leading,16)
                .padding(.trailing,16)
                }
                VStack(alignment: .center,spacing: 10){
                    HStack{
                        Text("Account Balance")
                            .font(.custom(POPPINS_FONT_LIST.Medium, size: 14))
                        Spacer()
                        Button {
                            changeNetwork()
                        } label: {
                            Image("wi-fi")
                                .frame(width: 13, height: 13, alignment: .center)
                                .foregroundColor(.black)
                            Text("Ethereum Testnet")
                                .font(.custom(DM_SANS_FONT_LIST.Medium, size: 12))
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(width: 145, height: 20, alignment: .center)
                                    .foregroundColor(Color(uiColor: .bkgColor()))

                        )
                        

                    }
                    .padding()
                    HStack{
                        VStack(alignment: .leading){
                            HStack(alignment:.bottom){
                    Text("0.000044")
                                    .font(.custom(POPPINS_FONT_LIST.Bold, size: 32))
                        Menu {
                            ForEach(BlockchainEnum.allCases ,id:\.self) { category in
                                Button {
                                    changeNetwork()
                                } label: {
                                    Text(category.name)
                                }

                            }
                        } label: {
                            Text("ETH")
                          .font(.custom(POPPINS_FONT_LIST.Bold, size: 12))
                                .foregroundColor(.black)
                            Image("dropDown")
                                .frame(width: 16, height: 16, alignment: .center)
                        }

                    }
                    Text("1 ETH = 268.21 USD")
                                .font(.custom(DM_SANS_FONT_LIST.Regular, size: 12))
                        }
                        Spacer()
                        Text("= 0.012 USD")
                            .font(.custom(DM_SANS_FONT_LIST.Regular, size: 12))
                    }
                    .padding([.leading,.trailing,.bottom],10)
                    Button {
                        pasTransOnEtherScan()
                    } label: {
                       Text("View past transaction’s status on Etherscan")
                            .font(.custom(DM_SANS_FONT_LIST.Medium, size: 14))
                        Image("open-in-browser")
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    .padding(.bottom,5)
                    Button {
                        transferAsset()
                    } label: {
                        Text("Transfer assets")
                            .font(.custom(DM_SANS_FONT_LIST.Medium, size: 16))
                            .foregroundColor(.gray)
                    }
                    .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.gray)
                                .frame(width: 308, height: 48, alignment: .center)
                                .foregroundColor(.white)
                        
                                
                    )
                    .fullScreenCover(isPresented: $showTransferScreen, content: {
                        TransferAssetView()
                    })
                    .padding()
                    Spacer()

                    

                }
                .frame(height:248,alignment: .center)
                .frame(maxWidth:.infinity)
                .background(.white)
                .cornerRadius(24)
                .padding()
                HStack{
                Text("Sign Message (Demo)")
                    .font(.custom(POPPINS_FONT_LIST.SemiBold, size: 16))
                    .padding(.leading,27)
                    Spacer()
                }
                VStack(alignment:.center,spacing: 8){
                    HStack{
                    Text("Message")
                            .font(.custom(POPPINS_FONT_LIST.SemiBold, size: 14))
                            .padding(.leading,27)
                        Spacer()
                        
                    }
                    TextView(text: $message)
                        .frame(width:308,height: 210, alignment: .center)
                        .cornerRadius(24)
                        .padding()
                    Button {
                        signMessage()
                    } label: {
                        Text("Sign Message")
                            .font(.custom(DM_SANS_FONT_LIST.Medium, size: 16))
                            .foregroundColor(.gray)
                    }
                    .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.gray)
                                .frame(width: 308, height: 48, alignment: .center)
                                .foregroundColor(.white)
                                
                        
                                
                    )
                    .padding(.top,24)
                    

                    
                }
                .frame(height:362,alignment: .center)
                .frame(maxWidth:.infinity)
                .background(.white)
                .cornerRadius(24)
                .padding()
                
        }
        }
        .ignoresSafeArea()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color(uiColor: .bkgColor()))
    }
    
    func transferAsset(){
        showTransferScreen = true
    }
    
    func pasTransOnEtherScan(){
        
    }
    
    
    func changeNetwork(){
        
    }
    
    func signMessage(){
        
    }
    
    func logout(){
        
        authManager.removeUser()
    }
    
    func openQRCode(){
        
    }
    
    func showPublicKey(){
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userInfo: nil)
    }
}


struct TextView: UIViewRepresentable {
 
    @Binding var text: String
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.textColor = .gray
        textView.backgroundColor = .bkgColor()
        textView.layer.cornerRadius = 24
        textView.clipsToBounds = true
        textView.font = .init(name: DM_SANS_FONT_LIST.Regular, size: 16)
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
