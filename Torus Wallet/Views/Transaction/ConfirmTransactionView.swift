//
//  ConfirmTransactionView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/04/22.
//

import SwiftUI

protocol ConfirmTransactionViewDelegate {
    func confirmBtnTap()
}

struct ConfirmTransactionView: View {
    @StateObject var vm: TransferAssetViewModel
    @Binding var showPopUp: Bool
    @Binding var usdRate: Double
    var delegate: ConfirmTransactionViewDelegate?
    var body: some View {
        ZStack(alignment: .center) {
            Blur(radius: 5, opaque: true)
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            ScrollView {
                VStack {
                    Text("Confirm Transaction")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                        .padding()
                    HStack {
                        VStack(spacing: 10) {
                            Image((vm.user.typeOfDisabledImage))
                                                        .resizable()
                                                        .frame(width: 40, height: 40, alignment: .center)
                                                        .cornerRadius(20)
                            Text("\(vm.manager.addressString)")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                                .lineLimit(1)
                        }
                        VStack {
                            Image("transferLine")
                            Button {

                            } label: {
                                HStack {
                                    Image("wi-fi")
                                        .frame(width: 13, height: 13, alignment: .center)
                                        .foregroundColor(.black)
                                    Text("\(vm.manager.type.name)")
                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                        .font(.custom(DMSANSFONTLIST.Medium, size: 10))
                                }
                                .frame(minWidth: 110)
                                .padding([.leading, .trailing], 10)
                                .padding([.top, .bottom], 5)
                                .background(Color.blockchainIndicatorBkgColor())
                                .clipShape( Capsule(style: .continuous))
                            }

                        }
                        VStack(spacing: 10) {
                            Image("ethAddress")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .cornerRadius(20)
                            Text("\(vm.sendingAddress)")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                                .lineLimit(1)
                        }
                    }
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(uiColor: .lightGray))
                        .frame(height: 1)
                    VStack(spacing: 24) {
                        HStack {
                            Text("Amount to send")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                            Spacer()
                            VStack {
                                Text("\(String(format: "%.6f", vm.convertAmountToNative())) \(vm.manager.type.shortName)")
                                    .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                                    .foregroundColor(.labelColor())

                                Text("~\(vm.convertAmountToNative() * vm.currentUSDRate) USD")

                                    .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                            }
                        }
                        HStack {
                            Text("Max Transaction Fee")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))

                            Spacer()
                            VStack {
                                Text("\(vm.manager.getMaxtransactionFee(amount: vm.selectedMaxTransactionDataModel.amt)) \(vm.manager.type.shortName)")
                                    .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                                    .foregroundColor(.labelColor())
                                Text(" In \(String(format: "%.0f", vm.selectedMaxTransactionDataModel.timeInSec)) seconds")
                                    .font(.custom(DMSANSFONTLIST.Regular, size: 10))

                            }
                        }
                    }
                    .padding([.top, .bottom], 20)
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(uiColor: .lightGray))
                        .frame(height: 1)
                    HStack {
                        Text("Total Cost")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        Spacer()
                        VStack {
                            Text("\(vm.totalAmountInNative) \(vm.manager.type.shortName)")
                                .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                            Text("~\(vm.totalAmountInUSD) USD")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                        }
                    }
                    .padding([.top, .bottom], 10)
                    VStack {
                        Button {
                            showPopUp.toggle()
                            delegate?.confirmBtnTap()

                        } label: {
                            Text("Confirm")
                                .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                                .foregroundColor(.white)
                                .frame(width: 308, height: 48)
                                .background(Color.themeColor())
                                .cornerRadius(24)

                        }
                        Button {
                            showPopUp.toggle()
                        } label: {
                            Text("Cancel")
                                .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                                .frame(width: 308, height: 48)
                               // .background(Color.white)
                                .cornerRadius(24)

                        }
                    }
                    .padding(.top, 36)
                    .padding(.bottom, 10)

                }
                .padding()
                .frame(width: UIScreen.screenWidth - 32, height: 500, alignment: .center)
                .background(Color.whiteGrayColor())
                .cornerRadius(20)
                .padding(.top, UIScreen.screenWidth - 590/2)
            }

        }
        .onTapGesture {
            showPopUp.toggle()
        }

    }
}

struct ConfirmTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTransactionView(vm: .init(manager: Dummy()), showPopUp: .constant(false), usdRate: .constant(75))
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
