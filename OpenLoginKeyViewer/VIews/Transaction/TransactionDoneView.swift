//
//  TransactionDoneView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 17/04/22.
//

import SwiftUI

struct TransactionDoneView: View {
    @Binding var success:Bool
    @State var successMessage:String = "Transaction Successful"
    @State var errorMessage:String = "Transaction Failed"
    var body: some View {
        ZStack(alignment:.center){
            PopUpView()
            VStack{
                Image(success ? "transactionSuccess" : "failure")
                    .resizable()
                    .frame(width: 88, height: 88, alignment: .center)
                Text(success ? successMessage : errorMessage)
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                if success{
                    HStack{
                        Text("View transaction’s status on")
                            .foregroundColor(Color(uiColor: .grayColor()))
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                        HStack{
                            Button {
                                
                            } label: {
                                Text("Etherscan")
                                    .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                                
                            }
                            
                        }
                    }
                    .padding([.leading,.trailing],10)
                    .padding(.top,5)
                }
                else{
                    HStack{
                        Button {
                            
                        } label: {
                            Text("Try again now")
                                .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                            
                        }
                        
                    }
                    .padding([.leading,.trailing],10)
                    .padding(.top,5)
                }
            }
        }
    }
    
}



struct TransactionDoneView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDoneView(success: .constant(true))
        TransactionDoneView(success: .constant(false))
    }
}


