//
//  TransferAssetView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import CodeScanner
import SwiftUI

struct TransferAssetView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var scannedCode: String = ""
    @State var showPopup = false
    @State var maxTranscFee: String = ""
    @State var showScanner = false
    @State var isPresentingScanner = false
    @State var showTransactionPopup: Bool = false
    @StateObject var vm: TransferAssetViewModel
    @State var showMaxTransactionPopUp = false
    var tfWidht: CGFloat = UIScreen.screenWidth - 48

    @State var transactionInfo = ""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack(alignment: .center, spacing: 24) {
                        VStack(alignment: .center) {
                            HStack {
                                Text("Select item to transfer")
                                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                                    .foregroundColor(.labelColor())
                                Spacer()
                            }
                            MenuPickerView(currentSelection: .constant([vm.manager.type][0]), arr: [vm.manager.type], title: "", color: .black, widht: tfWidht)
                        }
                        .padding([.leading, .trailing], 20)
                        VStack(alignment: .center, spacing: 8) {
                            HStack {
                                Text("Send to")
                                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                                    .foregroundColor(.labelColor())
                                Spacer()
                                Button {
                                    showScanner.toggle()
                                } label: {
                                    Image("scan")
                                        .frame(width: 13, height: 13, alignment: .center)
                                }
                            }
                            .padding([.leading, .trailing], 20)
                            TextRoundedFieldView(text: $vm.sendingAddress, placeHolder: vm.manager.type.sampleAddress, widht: tfWidht, error: $vm.recipientAddressError, errorInfoString: "Invalid Address")
                                .onChange(of: vm.sendingAddress) {
                                    _ in
                                    vm.checkRecipentAddressError()
                                }

                                .truncationMode(.middle)
                            MenuPickerView(currentSelection: .constant([vm.manager.type.addressStr][0]), arr: [vm.manager.type.addressStr], title: "", widht: tfWidht)
                        }
                        VStack(alignment: .center, spacing: 16) {
                            HStack {
                                Text("Amount")
                                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                                    .foregroundColor(.labelColor())
                                Spacer()
                                Picker("", selection: $vm.currentCurrency) {
                                    ForEach(vm.currencyInArr, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .onChange(of: vm.currentCurrency, perform: { _ in
                                    HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                                    if !vm.amount.isEmpty {
                                        vm.checkBalanceError()
                                    }
                                })
                                .pickerStyle(.segmented)
                                .frame(width: 110, height: 24)
                            }
                            .padding([.leading, .trailing], 20)
                            TextRoundedFieldView(text: $vm.amount, placeHolder: "0.00", widht: tfWidht, error: $vm.balanceError, errorInfoString: "Insufficient balance for transaction")
                                .keyboardType(.decimalPad)
                                .truncationMode(.middle)
                                .onChange(of: vm.amount) { _ in
                                    vm.checkBalanceError()
                                }
                        }
                        if vm.manager.showTransactionFeeOption == true {
                            VStack(alignment: .center) {
                                HStack {
                                    Text("Max Transaction Fee*")
                                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                                        .foregroundColor(.labelColor())
                                    Spacer()
                                    Button {
                                        showMaxTransactionPopUp.toggle()
                                    } label: {
                                        if vm.manager.showTransactionFeeOption {
                                            Text("Edit")
                                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                                                .foregroundColor(.themeColor())
                                        }
                                    }
                                }
                                .padding([.leading, .trailing], 20)
                                HStack {
                                    Text("\(vm.manager.getMaxtransactionFee(amount: vm.selectedMaxTransactionDataModel.amt))")
                                    Spacer()
                                    Text("\(vm.manager.type.shortName)")
                                }
                                .padding()
                                .foregroundColor(.gray)
                                .frame(width: tfWidht, height: 48, alignment: .center)
                                .background(Color.dropDownBkgColor())
                                .cornerRadius(36)
                            }
                        }
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 5) {
                                Text("Total cost")
                                    .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                                    .foregroundColor(.labelColor())
                                Text("\(vm.totalAmountInNative) \(vm.manager.type.shortName)")
                                    .font(.custom(DMSANSFONTLIST.Bold, size: 24))
                                Text("= \(vm.totalAmountInUSD) USD")
                                    .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                            }
                            .padding(.trailing, 20)
                            .padding()
                        }
                        Button {
                            if !vm.loading {
                                showPopup.toggle()
                                HapticGenerator.shared.hapticFeedbackOnTap(style: .medium)
                            }
                        }
            label: {
                            CustomButtonUIKit(showloader: $vm.loading, title: "Transfer")
                                .frame(width: 300, height: 48, alignment: .center)
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.grayColor(), lineWidth: 1)
                                )
                        }
                        .disabled(vm.enableDisableSendBtnCheck())
                        .opacity(vm.enableDisableSendBtnCheck() ? 0.5 : 1)
                    }
                }
                if showScanner {
                    QRCodeScannerExampleView()
                }
            }
            .navigationTitle("Transfer Assets")

            .onTapGesture {
                endEditing()
            }
            .frame(alignment: .center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bkgColor())
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
            if showPopup {
                ConfirmTransactionView(vm: vm, showPopUp: $showPopup, usdRate: $vm.currentUSDRate, delegate: self)
                    .navigationBarTitleDisplayMode(.inline)
            }
            if showMaxTransactionPopUp {
                MaxTransactionFeeView(show: $showMaxTransactionPopUp, selectedId: $vm.selectedTransactionFee, dataModel: vm.maxTransactionDataModel, vm: vm)
                    .navigationBarTitleDisplayMode(.inline)
            }
            if showTransactionPopup {
                ZStack {
                    TransactionDoneView(success: $vm.transactionSuccess, infoText: transactionInfo, urlLinkName: vm.manager.type.urlLinkName, delegate: self)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .onTapGesture {
                    withAnimation {
                        showTransactionPopup.toggle()
                        if vm.transactionSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }

    func transfer() {
        Task {
            do {
                try await vm.transferAsset()
                showTransactionPopup.toggle()
            } catch let error {
                transactionInfo = error.localizedDescription
                showTransactionPopup.toggle()
            }
        }
    }

    func endEditing() {
        UIApplication.shared.endEditing()
    }
}

extension TransferAssetView: ConfirmTransactionViewDelegate {
    func confirmBtnTap() {
        transfer()
    }
}

extension TransferAssetView: TransactionDoneViewDelegate {
    func viewOnEtherscan() {
        guard let url = vm.manager.type.transactionURL(tx: vm.lastTransactionHash)
        else { return }
        openURL(url)
    }
}

struct TransferAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TransferAssetView(vm: .init(manager: Dummy()))
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "xs", error: .constant(false))
    }
}
