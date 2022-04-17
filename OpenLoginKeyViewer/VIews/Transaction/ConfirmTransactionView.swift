//
//  ConfirmTransactionView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/04/22.
//

import SwiftUI
import BigInt
import web3

struct ConfirmTransactionView: View {
    @EnvironmentObject var ethManager:EthManager
    @Binding var showPopUp:Bool
    @Binding var usdRate:Double
    var dataModel:TransactionModel
    var confirmTap:(() -> Void)?
    var body: some View {
        ScrollView(){
            ZStack(alignment: .center){
        PopUpView()
            VStack{
        Text("Confirm Transaction")
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                HStack{
                    VStack{
                        Image("Facebook")
                            .resizable()
                            .frame(width: 49, height: 49, alignment: .center)
                        Text("nattchireddi@...")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                        Text("0xC95C..2Aa11")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                    }
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
                            Text("Ethereum Testnet")
                                .foregroundColor(.black)
                                .font(.custom(DMSANSFONTLIST.Medium, size: 10))
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .frame(width: 109, height: 20, alignment: .center)
                                    .foregroundColor(Color(uiColor: .bkgColor()))

                        )
                    }
                VStack{
                    Image("Google")
                        .resizable()
                        .frame(width: 49, height: 49, alignment: .center)
                    Text("nattchireddi@...")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                    Text("0xC95C..2Aa11")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                }
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
                        Text("\(TorusUtil.toEther(wei: dataModel.amount)) ETH")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))

                        Text("~\(TorusUtil.toEther(wei: dataModel.amount) * usdRate) USD")

                            .font(.custom(DMSANSFONTLIST.Regular, size: 10))
                    }
                }
                HStack{
                    Text("Max Transaction Fee")
                        .font(.custom(DMSANSFONTLIST.Regular, size: 14))

                    Spacer()
                    VStack{
                        Text("\(TorusUtil.toEther(wei: dataModel.maxTransactionFee))")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                        Text("(In < 30 Seconds)")
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
                        Text("\(TorusUtil.toEther(wei: dataModel.totalCost)) ETH")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 14))
                        Text("~\(TorusUtil.toEther(wei: dataModel.totalCost) * usdRate) USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 14))
                    }
                }
                .padding()
                VStack
                {
                    Button {
                      confirmTap?()
                        showPopUp.toggle()
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
                
            }
        }
        .frame(width: UIScreen.screenWidth - 32, height: 590, alignment: .center)
        .background(.white)
        .cornerRadius(20)
    }
    }
    

}

struct ConfirmTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTransactionView(showPopUp: .constant(true), usdRate: .constant(0), dataModel: .init(amount: 2, maxTransactionFee: 2, totalCost: 2, senderAddress: .init("Test"), reciepientAddress: .init("Test"), network: .Ropsten))
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
