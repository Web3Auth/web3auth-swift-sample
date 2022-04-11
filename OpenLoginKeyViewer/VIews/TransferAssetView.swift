//
//  TransferAssetView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 29/03/22.
//

import SwiftUI

struct TransferAssetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var sendTo:String = ""
    @State var Amt:String = ""
    @State var maxTranscFee:String = ""
    @State var selectedBlockChain:BlockchainEnum = .Ethereum
    let blockChainArr = BlockchainEnum.allCases.map{return $0}
    var body: some View {
        ScrollView{
        VStack{
            HStack(){
                Button {
                    dismissView()
                } label: {
                    Image("arrow-left")
                }

                Text("Transfer assets")
                    .foregroundColor(.black)
                    .font(.custom(POPPINSFONTLIST.Bold, size: 24))
            }
            .padding(.top,20)
            .frame(height: 115,alignment: .center)
            .frame(maxWidth:.infinity)
            .background(.white)
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
                VStack(alignment:.leading){
                    Text("Amount")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                HStack{
        TextField("0.00", text: $Amt)
                HStack{
                Button {
                    amtToEth()
                } label: {
                    Text("ETH")
                }
                .foregroundColor(.gray)
                .frame(width: 55, height: 24, alignment: .center)
                .background(Color.white)
                .border(.gray)
                .cornerRadius(24)
                Button {
                    amtToUSD()
                } label: {
                    Text("USD")
                }
                .foregroundColor(.gray)
                .frame(width: 55, height: 24, alignment: .center)
                .background(Color.white)
                .cornerRadius(24)
                .border(.gray)
                }
                .frame(width: 120, height: 24, alignment: .center)
                }
                .padding()
                .foregroundColor(.gray)
                .frame(width: 308, height: 48, alignment: .center)
                .background(Color.white)
                .cornerRadius(36)
                }
                VStack(alignment:.leading){
                Text("Max Transaction Fee*")
                        .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                    HStack{
                TextField("Up to 0.00004157", text: $maxTranscFee)
                        Spacer()
                    Text("Eth")
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
                        Text("0.000096 ETH")
                            .font(.custom(DMSANSFONTLIST.Bold, size: 24))
                        Text("= 0.012 USD")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 12))
                    }
                    .padding()
                }
                Button {
                    transfer()
                } label: {
                    Text("Transfer")
                        .foregroundColor(.gray)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.gray)
                        .background(.white)
                        .frame(width: 308, height: 48, alignment: .center)
                        .cornerRadius(24)
                            
    
                            
                )
                


        }
        }
       
    }
        .frame(alignment: .center)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: .bkgColor()))
    }
    
    func transfer(){
        
    }
    
    func amtToEth(){
        
    }
    
    func amtToUSD(){
        
    }
    
    
    func openScanner(){
        
    }
    
    func dismissView(){
        presentationMode.wrappedValue.dismiss()
    }
    
    func changeBlockChain(val:BlockchainEnum){
        
    }
}

struct TransferAssetView_Previews: PreviewProvider {
    static var previews: some View {
        TransferAssetView()
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "xs")
    }
}


