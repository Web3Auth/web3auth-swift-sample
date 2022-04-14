//
//  TransferAssetView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import SwiftUI
import web3
import BigInt
import CodeScanner

struct TransferAssetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var ethManager: EthManager
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var scannedCode:String = ""
    @State var sendTo:String = ""
    @State var amt:String = ""
    @State var showPopup = false
    @State var maxTranscFee:String = ""
    @State var showScanner = false
    @State var isPresentingScanner = false
    @State var selectedTransactionFee = 1
    @State var selectedBlockChain:BlockchainEnum = .ethereum
   var currentTransactionFeeSelected:[Double]{
       maxTranscFeeDataModel?.valueBasedOnIndex(val: selectedTransactionFee) ?? [0,0]
    }
    @State var showMaxTransactionPopUp = false
   @State var maxTranscFeeDataModel:ETHGasAPIModel?
    @State var transactionModel:TransactionModel?
    let blockChainArr:[BlockchainEnum] = [.ethereum]
    let currencyInArr:[TorusSupportedCurrencies] = [.ETH,.USD]
    @State var currentCurrency:TorusSupportedCurrencies = .ETH
    
    var body: some View {
        ZStack{
        ScrollView{
        VStack{
            HStack(){
                HStack(alignment: .center,spacing:24){
                Button {
                    dismissView()
                } label: {
                    Image("arrow-left")
                }

                Text("Transfer assets")
                    .foregroundColor(.black)
                    .font(.custom(POPPINSFONTLIST.Bold, size: 24))
                }
                
                .padding(.leading,40)
                Spacer()
                 
            }
            .padding(.top,20)
            .frame(height: 115,alignment: .center)
            .frame(maxWidth:.infinity)
            .background(.white)
            .padding(.leading,-20)
            VStack(alignment: .center, spacing: 24){
                VStack(alignment: .leading){
                    MenuPickerView(currentSelection: $selectedBlockChain, arr: blockChainArr, title: "Send to")
                }
                VStack(alignment:.center,spacing: 8){
                HStack{
            Text("Send to")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                    Spacer()
                    Button {
                        openScanner()
                    } label: {
                        Image("scan")
                            .frame(width: 13, height: 13, alignment: .center)
                    }

                }
                .padding([.leading,.trailing],40)
                    TextRoundedFieldView(text: $sendTo,placeHolder: "0xC951C5A85BE62F1Fe9337e698349bD7")
                        .truncationMode(.middle)
                    MenuPickerView(currentSelection: $selectedBlockChain, arr: blockChainArr, title: "")
            }
                VStack(alignment:.center,spacing: 16){
                    HStack{
                    Text("Amount")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                        Spacer()
                        Picker("", selection: $currentCurrency) {
                            ForEach(currencyInArr,id:\.self){
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 110, height:24)
                    }
                    .padding([.leading,.trailing],40)
                    TextRoundedFieldView(text: $amt,placeHolder: "0.00")
                        .truncationMode(.middle)
                }
                VStack(alignment:.center){
                    HStack{
                Text("Max Transaction Fee*")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                        Spacer()
                        Button {
                            editTransacationFee()
                        } label: {
                            Text("Edit")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        }

                    }
                    .padding([.leading,.trailing],40)
                    HStack{
                        Text("\(currentTransactionFeeSelected[0])")
                        Spacer()
                    Text("ETH")
                }
                    .padding()
                    .foregroundColor(.gray)
                    .frame(width: 308, height: 48, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(36)
                }
                HStack{
                    Spacer()
                    VStack(spacing: 5){
                        Text("Total cost")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        Text(" 0 ETH")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 24))
                        Text("= 0.012 USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                    }
                    .padding()
                }
                Button {
                    transfer()
                }
            label: {
                    Text("Transfer")
                        .foregroundColor(.gray)
                        .frame(width: 308, height: 48, alignment: .center)
                        .background(.white)
                        .cornerRadius(24)
                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .stroke(Color(uiColor: .grayColor()), lineWidth: 1)
                                        )
                }
            
          
                
               
                


        }
        }
            if showScanner{
                QRCodeScannerExampleView()
            }
        
       
    }
      

        .onTapGesture {
            endEditing()
        }
        .frame(alignment: .center)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: .bkgColor()))
        .sheet(isPresented: $showScanner) {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    sendTo = result.string
                    isPresentingScanner = false
                    showScanner.toggle()
                }
            }
        }
     
        .offset(y: -keyboardResponder.currentHeight * 0.9)
            if showPopup,let transactionModel = transactionModel{
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        ConfirmTransactionView(showPopUp: $showPopup, dataModel: transactionModel)
                            .environmentObject(ethManager)
                    }
            }
            if showMaxTransactionPopUp,let maxTranscFeeDataModel = maxTranscFeeDataModel{
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        MaxTransactionFeeView(show: $showMaxTransactionPopUp, selectedId: $selectedTransactionFee,dataModel: maxTranscFeeDataModel)
                    }
              
            }

        }
        .onAppear{
            getMaxtransAPIModel()
        }
    }
    
    func getConversionRate(val:String){
//        guard let amt = BigUInt(val) else{return}
        Task(priority: .userInitiated){
//        do{
//            currentRate = await NetworkingClient.shared.getCurrentPrice(forCurrency: currentCurrency)
//            balance = userBalance * currentRate
//
//        }
//        catch{
//            print(error)
//        }

        }
    }
    
    func editTransacationFee(){
        showMaxTransactionPopUp.toggle()
    }
    
     func getMaxtransAPIModel(){
        Task{
          maxTranscFeeDataModel = try await NetworkingClient.shared.getSuggestedGasFees()
        
        }
    }
    
    
    
    func transfer(){
        guard !amt.isEmpty,!sendTo.isEmpty else{return}
        let maxFee = BigUInt(currentTransactionFeeSelected[0])
        let conAmt = TorusUtil.toWei(ether: amt)
        showPopup.toggle()
        transactionModel = .init(amount: conAmt, maxTransactionFee: BigUInt(currentTransactionFeeSelected[0]), totalCost: conAmt + maxFee , senderAddress: ethManager.address, reciepientAddress: EthereumAddress(sendTo), network: .Mainnet)
    }
    
    func amtToEth(){
        
    }
    
    func amtToUSD(){
        
    }
    
    
    func openScanner(){
        showScanner.toggle()
    }
    
    func dismissView(){
        presentationMode.wrappedValue.dismiss()
    }
    
    func changeBlockChain(val:BlockchainEnum){
        
    }
    func endEditing() {
            UIApplication.shared.endEditing()
        }
}

struct TransferAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TransferAssetView()
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "xs")
    }
}


