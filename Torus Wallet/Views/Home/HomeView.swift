//
//  HomeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 28/03/22.
//

import SwiftUI

struct HomeView: View {
    @State var showTransferScreen = false
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var currentRate: Double = 0
    @State var didStartEditing = false
    @State var showPublicAddressQR: Bool = false
    @State var message: String = ""
    @State var showPopup = false
    @State var signedMessageHashString: String = ""
    @State var signedMessageResult: Bool = false
    @Environment(\.openURL) private var openURL
    @State var showQRCode: Bool = false
    @StateObject var vm: HomeViewModel

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Image(vm.user.typeOfImage)
                                .resizable()
                                .frame(width: 18, height: 18, alignment: .center)
                                .aspectRatio(contentMode: .fit)
                            Text(verbatim: "\(vm.user.userInfo.email)")
                                .font(.custom(POPPINSFONTLIST.Regular, size: 14))

                            Spacer()
                        }
                        .padding(.leading)
                        HStack(alignment: .center) {
                            Text("Account Details")
                                .font(.custom(POPPINSFONTLIST.SemiBold, size: 16))
                                .foregroundColor(.labelColor())
                                .padding()

                            Spacer()
                            HStack {
                                Button {
                                    openQRCode()
                                    HapticGenerator.shared.hapticFeedbackOnTap()
                                } label: {
                                    Image("qr-code")
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .background(Color.whiteGrayColor())
                                        .cornerRadius(12)

                                }

                                Button {
                                    copyPublicKey()
                                    HapticGenerator.shared.hapticFeedbackOnTap()

                                } label: {
                                    Image("Shape")
                                    Text(vm.publicAddress)
                                        .lineLimit(1)
                                        .frame(width: 63)
                                        .font(.custom(DMSANSFONTLIST.Bold, size: 12))
                                        .foregroundColor(.labelColor())
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .frame(width: 100, height: 24, alignment: .center)
                                        .foregroundColor(.whiteGrayColor())
                                )

                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        }
                        VStack {
                            HStack {
                                Text("Account Balance")
                                    .frame(alignment: .leading)
                                    .font(.custom(POPPINSFONTLIST.Medium, size: 14))
                                    .foregroundColor(.labelColor())
                                    .padding(.leading, -10)
                                Spacer()
                                Button {

                                } label: {
                                    HStack {
                                        Image("wi-fi")
                                            .frame(width: 13, height: 13, alignment: .center)
                                            .foregroundColor(.black)
                                        Text("\(vm.blockchain.name)")
                                            .foregroundColor(.black)
                                            .font(.custom(DMSANSFONTLIST.Medium, size: 12))
                                    }
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                    .background(Color.blockchainIndicatorBkgColor())
                                    .clipShape( Capsule(style: .continuous)
                                        )
                                }

                            }
                            .padding(.top, 20)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .lastTextBaseline) {
                                        Text("\(String(format: "%.4f", vm.convertedBalance))")
                                            .font(.custom(POPPINSFONTLIST.Bold, size: 32))
                                        Menu {
                                            ForEach(TorusSupportedCurrencies.allCases, id: \.self) { category in
                                                Button {
                                                    vm.changeCurrency(val: category)
                                                    HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                                                } label: {
                                                    Text(category.rawValue)
                                                }

                                            }
                                        } label: {
                                            Text(  vm.currentCurrency.rawValue)
                                                .font(.custom(POPPINSFONTLIST.Bold, size: 12))
                                                .foregroundColor(.labelColor())
                                            Image("dropDown")
                                                .frame(width: 16, height: 16, alignment: .center)
                                        }
                                        .onTapGesture {
                                            HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                                        }

                                    }

                                    Text("1 \(vm.manager.type.shortName) = \(String(format: "%.2f", vm.currentRate)) \(  vm.currentCurrency.rawValue)")
                                        .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                                }
                                Spacer()
                            }
                            .padding([.bottom], 10)
                            Button {
                                pastTransactionOnEtherScan()
                            } label: {
                                Text("View past transaction’s status on \(vm.manager.type.urlLinkName)")
                                    .foregroundColor(.blue)
                                    .font(.custom(DMSANSFONTLIST.Medium, size: 14))
                                    .minimumScaleFactor(0.95)
                                Image("open-in-browser")
                                    .frame(width: 16, height: 16, alignment: .center)
                            }
                            NavigationLink {
                                TransferAssetView(vm: .init(manager: vm.getManager))
                            } label: {
                                Text("Transfer assets")
                                    .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                                    .foregroundColor(.labelColor())
                                    .frame(width: UIScreen.screenWidth - 57, height: 48, alignment: .center)
                                    .cornerRadius(24)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.labelColor(), lineWidth: 1)
                                    )
                            }
                            .padding()
                            Spacer()

                        }
                        .padding()
                        .background(Color.dropDownBkgColor())
                        .frame(height: 280, alignment: .center)
                        .frame(maxWidth: UIScreen.screenWidth - 32)
                        .cornerRadius(24)

                        HStack {
                            Text("Sign Message")
                                .font(.custom(POPPINSFONTLIST.SemiBold, size: 16))
                                .foregroundColor(.labelColor())
                                .padding(.leading, 27)
                            Spacer()
                        }
                        .padding(.top, 20)
                        VStack(alignment: .center, spacing: 0) {
                            HStack {
                                Text("Message")
                                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                                    .foregroundColor(.labelColor())
                                    .padding(.leading, 27)
                                Spacer()

                            }
                            .padding(.top, 20)
                            TextView(text: $message, placeholderText: "Enter your message here")
                                .frame(width: 308, height: 210, alignment: .center)
                                .cornerRadius(24)
                                .padding()
                            Button {
                                signMessage()
                                HapticGenerator.shared.hapticFeedbackOnTap(style: .medium)
                            } label: {
                                Text("Sign Message")
                                    .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                                    .foregroundColor(.labelColor())
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(Color.labelColor())
                                    .frame(width: 308, height: 48, alignment: .center)
                                    .foregroundColor(.white)

                            )
                            .disabled(message.isEmpty)
                            .opacity(message.isEmpty ? 0.5 : 1)
                            .padding(.top, 24)
                            .padding(.bottom, 24)

                        }
                        .frame(height: 362, alignment: .center)
                        .frame(maxWidth: UIScreen.screenWidth - 32)
                        .background(Color.dropDownBkgColor())
                        .cornerRadius(24)

                    }

                }
                .navigationTitle("Welcome \(vm.user.firstName)!")

                .onTapGesture {
                    self.endEditing()
                }
                .offset(y: -keyboardResponder.currentHeight * 0.9)
                // .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bkgColor())
            }
            .accentColor(.tabBarColor())
            if showPopup {
                    MessageSignedView(success: $signedMessageResult, info: signedMessageHashString)
                .onTapGesture {
                    withAnimation {
                        showPopup.toggle()
                    }

                }

            }

            if showPublicAddressQR, showPublicAddressQR, let key = vm.publicAddress {
                        QRCodeAlert(publicAddres: key, isPresenting: $showPublicAddressQR)
                    .onTapGesture {
                        withAnimation {
                            showPopup.toggle()
                        }
                    }
                    }

            }
    }

    // FIX
    func pastTransactionOnEtherScan() {
//        guard let url = vm.manager.type.allTransactionURL(address: vm.publicAddress)
//        else {return}
//        openURL(url)
    }

    func signMessage() {
        endEditing()
        Task {
        signedMessageHashString = await vm.signMessage(message: message)
                signedMessageResult = true
                withAnimation {
                    showPopup = true
                }
            }
    }

    func logout() {
        vm.logout()
    }

    func openQRCode() {
        showPublicAddressQR.toggle()
    }

    func copyPublicKey() {
        UIPasteboard.general.string = vm.publicAddress

    }

    func endEditing() {
            UIApplication.shared.endEditing()
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: .init(blockchainManager: DummyBlockchainManager()))
        }
    }
