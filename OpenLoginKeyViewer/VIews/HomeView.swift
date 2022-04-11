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
    @EnvironmentObject var authManager: AuthManager
    @StateObject var ethManager: EthManager
    @State var balance:Double = 0
    @State var showTransferScreen = false
    @State var currentRate:Double = 0
    @State var showPrivateKeyQRCode: Bool = false
    @State var currentCurrency:TorusSupportedCurrencies = .ETH
    @State var message:String = "Enter your message here"
    @State var showPopup = false
    @State var SignedMessageHashString:String = ""
    @State var signedMessageResult:Bool = false
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
                        Text(ethManager.account.publicKey)
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
                            changeNetwork()
                        } label: {
                            Image("wi-fi")
                                .frame(width: 13, height: 13, alignment: .center)
                                .foregroundColor(.black)
                            Text("Ethereum Testnet")
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
                                Text("\(String(format: "%.2f",balance))")
                                    .font(.custom(POPPINSFONTLIST.Bold, size: 32))
                        Menu {
                            ForEach(TorusSupportedCurrencies.allCases ,id:\.self) { category in
                                Button {
                                    currentCurrency = category
                                    getConversionRate()
                                } label: {
                                    Text(category.rawValue)
                                }

                            }
                        } label: {
                            Text(currentCurrency.rawValue)
                          .font(.custom(POPPINSFONTLIST.Bold, size: 12))
                                .foregroundColor(.black)
                            Image("dropDown")
                                .frame(width: 16, height: 16, alignment: .center)
                        }

                    }
                            Text("1 ETH = \(String(format: "%.2f",currentRate)) \(currentCurrency.rawValue)")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                        }
                        Spacer()
                        Text("= 0.012 USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                    }
                    .padding([.bottom],10)
                    Button {
                        pasTransOnEtherScan()
                    } label: {
                       Text("View past transaction’s status on Etherscan")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 14))
                            .minimumScaleFactor(0.95)
                        Image("open-in-browser")
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    .padding(.bottom,5)
                    Button {
                        transferAsset()
                    } label: {
                        Text("Transfer assets")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
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
                .padding()
                .frame(height:248,alignment: .center)
                .frame(maxWidth:.infinity)
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
                    TextView(text: $message)
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
                    .padding(.top,24)
                    

                    
                }
                .frame(height:362,alignment: .center)
                .frame(maxWidth:.infinity)
                .background(.white)
                .cornerRadius(24)
                .padding()
                
            }
              
        }
        .onAppear(perform: {
            initialSetup()
        })
        .animation(.easeInOut, value: showPrivateKeyQRCode)
        .ignoresSafeArea()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color(uiColor: .bkgColor()))
         
        }
//        messageSignedView(success: $signedMessageResult, info: SignedMessageHashString)
//        .opacity(showPopup ? 1:0)
      
        
            if showPrivateKeyQRCode, let key = authManager.currentUser?.privKey {
                            QRCodeAlert(message: key, isPresenting: $showPrivateKeyQRCode)
                        }
    }
    
    func initialSetup(){
        
        Task(priority: .userInitiated){
        do{
            let userBalance = try await ethManager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(forCurrency: currentCurrency)
            balance = userBalance * currentRate

        }
        catch{
            print(error)
        }
        }

    }
    
    func getConversionRate(){
        Task(priority: .userInitiated){
        do{
            let userBalance = try await ethManager.getBalance()
            currentRate = await NetworkingClient.shared.getCurrentPrice(forCurrency: currentCurrency)
            balance = userBalance * currentRate

        }
        catch{
            print(error)
        }
        }
    }
    
    func transferAsset(){
        showTransferScreen = true
    }
    
    func getCurrentPrice(){
        
    }
    
    func pasTransOnEtherScan(){
        
    }
    
    
    func changeNetwork(){
        
    }
    
     func signMessage(){
        if !message.isEmpty{
            if let signedMessage = ethManager.signMessage(message: message){
                SignedMessageHashString = "signedMessage"
                showPopup = true
                print(signedMessage)
            }
        }
    }
    
    func logout(){
        
        authManager.removeUser()
    }
    
    func openQRCode(){
        showPrivateKeyQRCode.toggle()
    }
    
    func copyPublicKey(){
        UIPasteboard.general.string = ethManager.account.publicKey
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(ethManager: EthManager(proxyAddress: "", authManager: AuthManager())!)
            .environmentObject(AuthManager())
        
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
        textView.font = .init(name: DMSANSFONTLIST.Regular, size: 16)
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

func generateQRCode(message: String) -> UIImage {
    let ciContext = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    filter.message = Data(message.utf8)
    filter.correctionLevel = "H"

    if let outputImage = filter.outputImage {
        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}


struct QRCodeAlert: View {
    var message: String
    @Binding var isPresenting: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack() {
                        Text("Private Key").fontWeight(.bold).padding(.all, 20).foregroundColor(.black)

                        Image(uiImage: generateQRCode(message: message))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .overlay(
                                Image("web3auth-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            )



                    }
                }
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 250, idealHeight: 250, maxHeight: 600, alignment: .top).scaledToFit()
                .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                Spacer()
            }
        }.onTapGesture {
            self.isPresenting = false
        }

    }
}
