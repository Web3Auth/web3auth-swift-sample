//
//  TransactionDoneView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 17/04/22.
//

import SwiftUI

protocol TransactionDoneViewDelegate {
    func viewOnEtherscan()
}

struct TransactionDoneView: View {
    @Binding var success: Bool
    var infoText: String
    @State var successMessage: String = "Transaction Successful"
    @State var errorMessage: String = "Transaction Failed"
    var urlLinkName: String
    var delegate: TransactionDoneViewDelegate?
    var body: some View {
        ZStack(alignment: .center) {
               PopUpView()
            VStack {
                Image(success ? "transactionSuccess" : "failure")
                    .resizable()
                    .frame(width: 88, height: 88, alignment: .center)
                Text(success ? successMessage : errorMessage)
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                    .padding()
                if success {
                    HStack {
                        Text("View transaction’s status on")
                           // .foregroundColor(Color(uiColor: <#T##UIColor#>))
                          //  .foregroundColor(Color(uiColor: .grayColor()))
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                        HStack {
                            Button {
                                delegate?.viewOnEtherscan()
                            } label: {
                                Text(urlLinkName)
                                    .font(.custom(DMSANSFONTLIST.Regular, size: 16))

                            }

                        }
                    }
                    .padding([.leading, .trailing], 10)
                    .padding(.top, 5)
                } else {
                    VStack {
                        Text(infoText)
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
//                    HStack {
//                        Button {
//
//                        } label: {
//                            Text("Try again now")
//                                .font(.custom(DMSANSFONTLIST.Regular, size: 16))
//
//                        }
//
//                    }
//                    .padding([.leading, .trailing], 10)
//                    .padding(.top, 5)
                    }
                }
            }
        }
    }

}

struct TransactionDoneView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDoneView(success: .constant(true), infoText: "", urlLinkName: "Etherscan")
        TransactionDoneView(success: .constant(false), infoText: "", urlLinkName: "Etherscan")
    }
}
