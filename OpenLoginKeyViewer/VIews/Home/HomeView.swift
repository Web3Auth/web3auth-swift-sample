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
    @StateObject private var vm:HomeViewModel
    var manager:BlockChainManagerProtocol
    
    
    init(manager:BlockChainManagerProtocol){
        self.manager = manager
        _vm = .init(wrappedValue: HomeViewModel(manager: manager))
    }

    
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
                        HapticGenerator.shared.hapticFeedbackOnTap()
                    } label: {
                        Image("qr-code")
                            .frame(width: 24, height: 24, alignment: .center)
                            .background(.white)
                            .cornerRadius(12)
                            
                    }
                  
                    Button {
                        copyPublicKey()
                        HapticGenerator.shared.hapticFeedbackOnTap()
                       
                    } label: {
                        Image("Shape")
                        Text(vm.publicAddress)
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
                            Text("\(vm.manager.type.name) Mainnet")
                                .foregroundColor(.black)
                                .font(.custom(DMSANSFONTLIST.Medium, size: 12))
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(width: 145, height: 20, alignment: .center)
                                    .foregroundColor(Color(uiColor: .bkgColor()))

                        )
                        

                    }
                     .padding(.top,20)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                    HStack(alignment:.center){
                        VStack(alignment: .leading){
                            HStack(alignment:.lastTextBaseline){
                                Text("\(String(format: "%.4f",vm.convertedBalance))")
                                    .font(.custom(POPPINSFONTLIST.Bold, size: 32))
                        Menu {
                            ForEach(TorusSupportedCurrencies.allCases ,id:\.self) { category in
                                Button {
                                    vm.currentCurrency = category
                                    vm.getConversionRate()
                                    HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
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
                        .onTapGesture {
                            HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                        }

                    }
                          
                            Text("1 \(vm.manager.type.shortName) = \(String(format: "%.2f",vm.currentRate)) \(  vm.currentCurrency.rawValue)")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                        }
                        Spacer()
                    }
                    .padding([.bottom],10)
                    Button {
                        pastTransactionOnEtherScan()
                    } label: {
                        Text("View past transaction’s status on \(vm.manager.type.urlLinkName)")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 14))
                            .minimumScaleFactor(0.95)
                        Image("open-in-browser")
                            .frame(width: 16, height: 16, alignment: .center)
                    }
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
                        TransferAssetView( vm: TransferAssetViewModel(manager: vm.manager))
                    })
                    .padding()
                    Spacer()

                    

                }
                .padding()
                .background(.white)
                .frame(height:280,alignment: .center)
                .frame(maxWidth:UIScreen.screenWidth - 32)
                .cornerRadius(24)
                HStack{
                Text("Sign Message (Demo)")
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 16))
                    .padding(.leading,27)
                    Spacer()
                }
                .padding(.top,20)
                VStack(alignment:.center,spacing: 0){
                    HStack{
                    Text("Message")
                            .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                            .padding(.leading,27)
                        Spacer()
                        
                    }
                    .padding(.top,20)
                    TextView(text: $message, placeholderText: "Enter your message here")
                        .frame(width:308,height: 210, alignment: .center)
                        .cornerRadius(24)
                        .padding()
                    Button {
                        signMessage()
                        HapticGenerator.shared.hapticFeedbackOnTap(style: .medium)
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
                    .padding(.bottom,24)
                    

                    
                }
                .frame(height:362,alignment: .center)
                .frame(maxWidth:UIScreen.screenWidth - 32)
                .background(.white)
                .cornerRadius(24)
            
                
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
                            
                            if showPublicAddressQR, let key = vm.publicAddress{
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
        .onDisappear {
            vm.cleanup()
        }
    }
    
    
    func pastTransactionOnEtherScan(){
        guard let url = vm.manager.type.allTransactionURL(address: vm.publicAddress)
        else {return}
        openURL(url)
    }
    
    
    func signMessage() {
        endEditing()
        Task{
        signedMessageHashString = await vm.signMessage(message: message)
                signedMessageResult = true
                withAnimation {
                    showPopup = true
                }
            }
    }
    
    func logout(){
        
        authManager.removeUser()
    }
    
    func openQRCode(){
        showPublicAddressQR.toggle()
    }
    
    func copyPublicKey(){
        UIPasteboard.general.string = vm.publicAddress
        
    }
    
    func endEditing() {
            UIApplication.shared.endEditing()
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        if let ethManager = EthManager(authManager: AuthManager(), network: .constant(.mainnet)){
            HomeView(manager: ethManager)
                .environmentObject(AuthManager())
            }
        }
    }









