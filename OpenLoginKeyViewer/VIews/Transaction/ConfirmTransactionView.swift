//
//  ConfirmTransactionView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/04/22.
//

import SwiftUI
import BigInt
import web3


protocol ConfirmTransactionViewDelegate{
    func confirmBtnTap()
}

struct ConfirmTransactionView: View {
    @EnvironmentObject var vm:TransferAssetViewModel
    @Binding var showPopUp:Bool
    @Binding var usdRate:Double
  var delegate:ConfirmTransactionViewDelegate?
    var body: some View {
        ScrollView{
        ZStack(alignment: .center){
        PopUpView()
            VStack{
        Text("Confirm Transaction")
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                    .padding()
                HStack{
                    VStack(spacing:10){
                        Image((vm.manager.authManager.currentUser?.typeOfDisabledImage ?? ""))
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                        Text("\(vm.manager.addressString)")
                            .multilineTextAlignment(.center)
                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                    }
                    .frame(width:60)
                    VStack{
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(uiColor: .lightGray))
                                  .frame(height: 1)
                        Button {
                         
                        } label: {
                            Image("wi-fi")
                                .frame(width: 13, height: 13, alignment: .center)
                                .foregroundColor(.black)
                            Text("\(vm.manager.type.name) Network")
                                .foregroundColor(.black)
                                .font(.custom(DMSANSFONTLIST.Medium, size: 10))
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(width: 109, height: 20, alignment: .center)
                                    .foregroundColor(Color(uiColor: .bkgColor()))

                        )
                        .frame(width: 120, height: 16, alignment: .center)
                    }
                    VStack(spacing:10){
                    Image("ethAddress")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                    Text("\(vm.sendingAddress)")
                        .multilineTextAlignment(.center)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                }
                .frame(width:60)
                }
                .padding()
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color(uiColor: .lightGray))
                              .frame(height: 1)
                VStack(spacing:24){
                HStack{
                    Text("Amount to send")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                    Spacer()
                    VStack{
                        Text("\(String(format: "%.6f", vm.convertAmountToNative())) \(vm.manager.type.shortName)")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))

                        Text("~\(vm.convertAmountToNative() * vm.currentUSDRate) USD")

                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                    }
                }
                HStack{
                    Text("Max Transaction Fee")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 14))

                    Spacer()
                    VStack{
                        Text("\(vm.manager.getMaxtransactionFee(amount: vm.selectedMaxTransactionDataModel.amt)) \(vm.manager.type.shortName)")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                        Text(" In \(String(format: "%.0f", vm.selectedMaxTransactionDataModel.timeInSec)) seconds")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                        
                    }
                }
                }
                .padding()
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color(uiColor: .lightGray))
                              .frame(height: 1)
                HStack{
                    Text("Total Cost")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                    Spacer()
                    VStack{
                        Text("\(vm.totalAmountInNative) \(vm.manager.type.shortName)")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                        Text("~\(vm.totalAmountInUSD) USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                    }
                }
                .padding([.leading,.trailing,.top])
                VStack
                {
                    Button {
                        showPopUp.toggle()
                        delegate?.confirmBtnTap()
         
                    } label: {
                        Text("Confirm")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                            .foregroundColor(.white)
                            .frame(width: 308, height: 48)
                            .background(Color(UIColor.themeColor()))
                            .cornerRadius(24)
                        
                    }
                    Button {
                        showPopUp.toggle()
                    } label: {
                        Text("Cancel")
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                            .foregroundColor(.black)
                            .frame(width: 308, height: 48)
                            .background(.white)
                            .cornerRadius(24)
                        
                    }
                }
                .padding(.top,36)
                .padding(.bottom,10)
    
            }
            .padding()
        }
        .frame(width: UIScreen.screenWidth - 32, height: 550, alignment: .center)
        .background(.white)
        .cornerRadius(20)
        .padding(.top,UIScreen.screenWidth - 590/2)
    }
    
    }
    

}

struct ConfirmTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTransactionView(showPopUp: .constant(true), usdRate: .constant(75))
            .environmentObject(TransferAssetViewModel(manager: EthManager( authManager: AuthManager(), network: .constant(.mainnet))!))
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

struct TransactionModel{
    var amount:BigUInt
    var maxTransactionFee:BigUInt
    var totalCost:BigUInt
    var senderAddress:EthereumAddress
    var reciepientAddress:EthereumAddress
    var network:EthereumNetwork
}
