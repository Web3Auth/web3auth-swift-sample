//
//  HomeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 28/03/22.
//

import SwiftUI
import Web3Auth
import UIKit
import BigInt
import CoreImage.CIFilterBuiltins


struct HomeView: View {
    @EnvironmentObject var web3authManager:Web3AuthManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var ethManager:EthManager
    @State var showTransferScreen = false
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var currentRate:Double = 0
    @State var didStartEditing = false
    @State var showPublicAddressQR: Bool = false
    @State var message:String = ""
    @State var showPopup = false
    @State var signedMessageHashString:String = ""
    @State var signedMessageResult:Bool = false
    @Environment(\.openURL) private var openURL
    @State var showQRCode:Bool = false
    @StateObject var vm:HomeViewModel
    
   
    
    var body: some View {
        ZStack{
        ScrollView{
            VStack{
            HStack{
            VStack(alignment:.leading,spacing: 8){
                Text("Welcome! \( authManager.currentUser?.firstName ?? "")")
                .fontWeight(.bold)
                .font(.custom(POPPINSFONTLIST.Bold, size: 24))
                HStack{
                    Image(authManager.currentUser?.typeOfImage ?? "")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                    Text(verbatim: "\(authManager.currentUser?.userInfo.email ?? "")")
                        .font(.custom(POPPINSFONTLIST.Regular, size: 14))
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
                        .font(.custom(POPPINSFONTLIST.Regular, size: 14))

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
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 16))
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
                        copyPublicKey()
                    } label: {
                        Image("Shape")
                        Text(ethManager.address.value)
                            .lineLimit(1)
                            .frame(width:63)
                            .font(.custom(DMSANSFONTLIST.Bold, size: 12))
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
                VStack(){
                    HStack{
                        Text("Account Balance")
                            .frame(alignment: .leading)
                            .font(.custom(POPPINSFONTLIST.Medium, size: 14))
                            .padding(.leading ,-10)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image("wi-fi")
                                .frame(width: 13, height: 13, alignment: .center)
                                .foregroundColor(.black)
                            Text(vm.ethManager.networkName)
                                .foregroundColor(.black)
                                .font(.custom(DMSANSFONTLIST.Medium, size: 12))
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(width: 145, height: 20, alignment: .center)
                                    .foregroundColor(Color(uiColor: .bkgColor()))

                        )
                        

                    }
                    .padding(.top,10)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                    HStack(alignment:.center){
                        VStack(alignment: .leading){
                            HStack(alignment:.lastTextBaseline){
                                Text("\(String(format: "%.4f",vm.balance))")
                                    .font(.custom(POPPINSFONTLIST.Bold, size: 32))
                        Menu {
                            ForEach(TorusSupportedCurrencies.allCases ,id:\.self) { category in
                                Button {
                                    vm.currentCurrency = category
                                    vm.getConversionRate()
                                } label: {
                                    Text(category.rawValue)
                                }

                            }
                        } label: {
                            Text(  vm.currentCurrency.rawValue)
                          .font(.custom(POPPINSFONTLIST.Bold, size: 12))
                                .foregroundColor(.black)
                            Image("dropDown")
                                .frame(width: 16, height: 16, alignment: .center)
                        }

                    }
                          
                            Text("1 ETH = \(String(format: "%.2f",vm.currentRate)) \(  vm.currentCurrency.rawValue)")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                        }
                        Spacer()
                    }
                    .padding([.bottom],10)
                    Button {
                        pastTransactionOnEtherScan()
                    } label: {
                       Text("View past transaction’s status on Etherscan")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 14))
                            .minimumScaleFactor(0.95)
                        Image("open-in-browser")
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    .padding(.bottom,5)
                    Button {
                        showTransferScreen.toggle()
                    } label: {
                        Text("Transfer assets")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                            .foregroundColor(.gray)
                            .frame(width: UIScreen.screenWidth - 57, height: 48, alignment: .center)
                            .background(.white)
                            .cornerRadius(24)
                            .overlay(
                                                RoundedRectangle(cornerRadius: 40)
                                                    .stroke(Color(uiColor: .grayColor()), lineWidth: 1)
                                            )
                            
                    }
                  
                    
                    .fullScreenCover(isPresented: $showTransferScreen, content: {
                        TransferAssetView( vm: .init(ethManager: ethManager))
                            .environmentObject(ethManager)
                    })
                    .padding()
                    Spacer()

                    

                }
                .padding()
                .frame(height:248,alignment: .center)
                .frame(maxWidth:UIScreen.screenWidth - 32)
                .background(.white)
                .cornerRadius(24)
                .padding()
                HStack{
                Text("Sign Message (Demo)")
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 16))
                    .padding(.leading,27)
                    Spacer()
                }
                VStack(alignment:.center,spacing: 8){
                    HStack{
                    Text("Message")
                            .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                            .padding(.leading,27)
                        Spacer()
                        
                    }
                    TextView(text: $message, placeholderText: "Enter your message here")
                        .frame(width:308,height: 210, alignment: .center)
                        .cornerRadius(24)
                        .padding()
                    Button {
                        signMessage()
                    } label: {
                        Text("Sign Message")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                            .foregroundColor(.gray)
                    }
                    .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.gray)
                                .frame(width: 308, height: 48, alignment: .center)
                                .foregroundColor(.white)
                                
                        
                                
                    )
                    .disabled(message.isEmpty)
                    .opacity(message.isEmpty ? 0.5 : 1)
                    .padding(.top,24)
                    

                    
                }
                .frame(height:362,alignment: .center)
                .frame(maxWidth:UIScreen.screenWidth - 32)
                .background(.white)
                .cornerRadius(24)
                .padding()
                
            }

              
        }
        .onTapGesture {
            self.endEditing()
        }
        .offset(y: -keyboardResponder.currentHeight * 0.9)
        .ignoresSafeArea()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color(uiColor: .bkgColor()))
            
                if showPopup{
                        ZStack{
                            Rectangle()
                                .fill(.black)
                                .opacity(0.5)
                                .ignoresSafeArea()
                            MessageSignedView(success: $signedMessageResult, info: signedMessageHashString)
                        }
                        .onTapGesture {
                            withAnimation {
                                showPopup.toggle()
                            }
                            
                        }
                  
                }
            
                if showPublicAddressQR{
                        ZStack{
                            Rectangle()
                                .fill(.black)
                                .opacity(0.5)
                                .ignoresSafeArea()
                            
                            if showPublicAddressQR, let key = ethManager.address.value{
                                                QRCodeAlert(publicAddres: key, isPresenting: $showPublicAddressQR)
                                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                showPopup.toggle()
                            }
                        }
                }

        }
    }
    
    
    func pastTransactionOnEtherScan(){
        guard let url = URL(string: "https://ropsten.etherscan.io/address/\(ethManager.address.value)")
        else {return}
        openURL(url)
    }
    
    
     func signMessage(){
        endEditing()
         signedMessageHashString = vm.signMessage(message: message)
                signedMessageResult = true
                withAnimation {
                    showPopup = true
                }
            }
    
    func logout(){
        
        authManager.removeUser()
    }
    
    func openQRCode(){
        showPublicAddressQR.toggle()
    }
    
    func copyPublicKey(){
        UIPasteboard.general.string = ethManager.account.address.value
        
    }
    
    func endEditing() {
            UIApplication.shared.endEditing()
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        if let ethManager = EthManager(authManager: AuthManager(), network: .constant(.mainnet)){
            HomeView( vm: .init(ethManager: ethManager))
                .environmentObject(AuthManager())
                .environmentObject(ethManager)
            }
        }
    }








