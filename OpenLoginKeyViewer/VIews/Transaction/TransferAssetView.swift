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
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var scannedCode:String = ""
    @State var showPopup = false
    @State var maxTranscFee:String = ""
    @State var showScanner = false
    @State var isPresentingScanner = false
    @State var showTransactionPopup:Bool = false
    @StateObject var vm:TransferAssetViewModel
    @State var showMaxTransactionPopUp = false

    
   @State var transactionInfo = ""
    
    var body: some View {
        ZStack{
        ScrollView{
        VStack{
            HStack(alignment: .center){
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
                    MenuPickerView(currentSelection: .constant([vm.manager.type][0]), arr: [vm.manager.type], title: "Select item to transfer",color: .black)
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
                    TextRoundedFieldView(text: $vm.sendingAddress,placeHolder: vm.manager.type.sampleAddress, error: $vm.recipientAddressError,errorInfoString: "Invalid Address")
                        .onChange(of: vm.sendingAddress) { newValue in
                            vm.checkRecipentAddressError()
                        }

                        .truncationMode(.middle)
                    MenuPickerView(currentSelection: .constant([vm.manager.type.addressStr][0]), arr: [vm.manager.type.addressStr], title: "")
            }
                VStack(alignment:.center,spacing: 16){
                    HStack{
                    Text("Amount")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                        Spacer()
                        Picker("", selection: $vm.currentCurrency) {
                            ForEach(vm.currencyInArr,id:\.self){
                                Text($0.rawValue)
                            }
                        }
                        .onChange(of: vm.currentCurrency, perform: { newValue in
                            HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                            vm.checkBalanceError()
                        })
                        .pickerStyle(.segmented)
                        .frame(width: 110, height:24)
                    }
                    .padding([.leading,.trailing],40)
                    TextRoundedFieldView(text: $vm.amount,placeHolder: "0.00", error: $vm.balanceError,errorInfoString: "Insufficient balance for transaction")
                        .keyboardType(.decimalPad)
                        .truncationMode(.middle)
                        .onChange(of: vm.amount) { newValue in
                            vm.checkBalanceError()
                        }
                }
                if vm.manager.showTransactionFeeOption == true{
                VStack(alignment:.center){
                    HStack{
                Text("Max Transaction Fee*")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                        Spacer()
                        Button {
                            showMaxTransactionPopUp.toggle()
                        } label: {
                            if vm.manager.showTransactionFeeOption{
                            Text("Edit")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                            }
                            
                        }

                    }
                    .padding([.leading,.trailing],40)
                    HStack{
                        Text("\(vm.manager.getMaxtransactionFee(amount: vm.selectedMaxTransactionDataModel.amt))")
                        Spacer()
                        Text("\(vm.manager.type.shortName)")
                }
                    .padding()
                    .foregroundColor(.gray)
                    .frame(width: 308, height: 48, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(36)
                }
            }
                HStack{
                    Spacer()
                    VStack(alignment:.trailing,spacing: 5){
                        Text("Total cost")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        Text("\(vm.totalAmountInNative) \(vm.manager.type.shortName)")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 24))
                        Text("= \(vm.totalAmountInUSD) USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                    }
                    .padding(.trailing,20)
                    .padding()
                }
                Button {
                    if !vm.loading{
                    showPopup.toggle()
                        HapticGenerator.shared.hapticFeedbackOnTap(style: .medium)
                    }
                }
            label: {
                CustomButtonUIKit(showloader: $vm.loading, title: "Transfer")
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 48, alignment: .center)
                    .cornerRadius(24)
                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 40)
                                                                .stroke(Color(uiColor: .grayColor()), lineWidth: 1))
                }
            .disabled(vm.sendingAddress.isEmpty || vm.amount.isEmpty || vm.checkRecipentAddressError())
            .opacity(vm.sendingAddress.isEmpty || vm.amount.isEmpty || vm.checkRecipentAddressError() ? 0.5 : 1)
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
                        ConfirmTransactionView(showPopUp: $showPopup, usdRate: $vm.currentUSDRate,delegate: self)
                        .environmentObject(vm)
                    }
            }
            if showMaxTransactionPopUp{
                    ZStack{
                        Rectangle()
                            .fill(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        MaxTransactionFeeView(show: $showMaxTransactionPopUp, selectedId: $vm.selectedTransactionFee,dataModel: vm.maxTransactionDataModel, vm: vm)
                    }
              
            }
            
                if showTransactionPopup{
                        ZStack{
                            Rectangle()
                                .fill(.black)
                                .opacity(0.5)
                                .ignoresSafeArea()
                            TransactionDoneView(success: $vm.transactionSuccess, infoText: transactionInfo,urlLinkName: vm.manager.type.urlLinkName, delegate: self)
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

extension TransferAssetView:ConfirmTransactionViewDelegate{
    func confirmBtnTap() {
        transfer()
    }
}

extension TransferAssetView:TransactionDoneViewDelegate{
    func viewOnEtherscan() {
        guard let url = vm.manager.type.transactionURL(tx: vm.lastTransactionHash)
        else{return}
        openURL(url)
    }
    
   
}

struct TransferAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TransferAssetView( vm: .init(manager: EthManager(authManager: AuthManager(), network: .constant(.mainnet))!))
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "xs", error: .constant(false))
    }
}

enum AddressType:Int,MenuPickerProtocol{
    case ethAddress
    case solAddress
    
    var name:String{
        switch self {
        case .ethAddress:
            return "ETH Address"
        case .solAddress:
            return "SOL Address"
        }
    }
}


