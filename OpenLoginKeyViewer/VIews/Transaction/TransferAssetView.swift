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
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var scannedCode:String = ""
    @State var showPopup = false
    @State var maxTranscFee:String = ""
    @State var showScanner = false
    @State var isPresentingScanner = false
    @State var showTransactionPopup:Bool = false
    @State var selectedBlockChain:BlockchainEnum = .ethereum
    @StateObject var vm:TransferAssetViewModel
    @State var showMaxTransactionPopUp = false
    let blockChainArr:[BlockchainEnum] = [.ethereum]
    let currencyInArr:[TorusSupportedCurrencies] = [.ETH,.USD]
    @State var currentCurrency:TorusSupportedCurrencies = .ETH
   @State var transactionInfo = ""
    
    var body: some View {
        ZStack{
        ScrollView{
        VStack{
            HStack(){
                HStack(alignment: .center,spacing:24){
                Button {
                    presentationMode.wrappedValue.dismiss()
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
                        showScanner.toggle()
                    } label: {
                        Image("scan")
                            .frame(width: 13, height: 13, alignment: .center)
                    }

                }
                .padding([.leading,.trailing],40)
                    TextRoundedFieldView(text: $vm.sendingAddress,placeHolder: "0xC951C5A85BE62F1Fe9337e698349bD7")
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
                    TextRoundedFieldView(text: $vm.amount,placeHolder: "0.00")
                        .truncationMode(.middle)
                }
                VStack(alignment:.center){
                    HStack{
                Text("Max Transaction Fee*")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                        Spacer()
                        Button {
                            showMaxTransactionPopUp.toggle()
                        } label: {
                            Text("Edit")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        }

                    }
                    .padding([.leading,.trailing],40)
                    HStack{
                        Text("\(vm.selectedMaxTransactionDataModel.maxTransAmtInEth)")
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
                    VStack(alignment:.trailing,spacing: 5){
                        Text("Total cost")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        Text("\(vm.totalAmountInEth) ETH")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 24))
                        Text("= \(vm.totalAmountInUSD) USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                    }
                    .padding(.trailing,20)
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
            .disabled(vm.sendingAddress.isEmpty || vm.amount.isEmpty)


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
                    vm.sendingAddress = result.string
                    isPresentingScanner = false
                    showScanner.toggle()
                }
            }
        }
     
        .offset(y: -keyboardResponder.currentHeight * 0.9)
            if showPopup{
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        ConfirmTransactionView(showPopUp: $showPopup, usdRate: $vm.currentUSDRate,confirmTap: {
                      transfer()
                        })
                            .environmentObject(vm)
                    }
            }
            if showMaxTransactionPopUp{
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        MaxTransactionFeeView(show: $showMaxTransactionPopUp, selectedId: $vm.selectedTransactionFee,dataModel: vm.maxTransactionDataModel)
                    }
              
            }
            
                if showTransactionPopup{
                        ZStack{
                            Rectangle()
                                .fill(.black)
                                .opacity(0.5)
                                .ignoresSafeArea()
                            TransactionDoneView(success: $vm.transactionSuccess, infoText: transactionInfo)
                        }
                        .onTapGesture {
                            withAnimation {
                                showTransactionPopup.toggle()
                                if vm.transactionSuccess{
                                presentationMode.wrappedValue.dismiss()
                                }
                            }
                            
                        }
                  
                }


        }
    }
    
    
    func transfer(){
        Task{
            do{
             try await vm.transferAsset()
                showTransactionPopup.toggle()
            }
            catch(let error){
                transactionInfo = error.localizedDescription
                showTransactionPopup.toggle()
            }
        }
    }
    

 
    func endEditing() {
            UIApplication.shared.endEditing()
        }
}

struct TransferAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TransferAssetView( vm: .init(ethManager: EthManager(authManager: AuthManager())!))
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "xs")
    }
}


