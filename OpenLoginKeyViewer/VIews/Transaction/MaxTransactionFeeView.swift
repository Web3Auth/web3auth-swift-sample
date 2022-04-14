//
//  MaxTransactionFeeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 13/04/22.
//

import SwiftUI
import BigInt

struct MaxTransactionFeeView: View {
    @EnvironmentObject var ethManager:EthManager
    @Binding var show:Bool
    @Binding var selectedId:Int
    var dataModel:ETHGasAPIModel
    var body: some View {
        ZStack{
        PopUpView()
        VStack{
            VStack{
            Text("Max Transaction Fee")
                .font(.custom(POPPINSFONTLIST.Bold, size: 21))
            }
            .background(.white)
            .padding()
            VStack(alignment: .center,spacing: 5){
                Text("Select Max Transaction Fee payable")
                    .font(.custom(POPPINSFONTLIST.Bold, size: 14))
                Text("Your transaction will be priortised by the network when you pay a higher fee.")
                    .multilineTextAlignment(.center)
                    .font(.custom(POPPINSFONTLIST.Regular, size: 12))
            }
            VStack{
                MaxTransactionFeeOptionView(selectedItem: $selectedId, id:0,title: "High", amt: "\(dataModel.fastEstInEth)", processInTime: "\(dataModel.fastTimeInSec)")
                MaxTransactionFeeOptionView(selectedItem: $selectedId, id:1,title: "Average", amt: "\(dataModel.averageInEth)", processInTime: "\(dataModel.avgTimeInSec)")
                MaxTransactionFeeOptionView(selectedItem: $selectedId, id:2,title: "Low", amt: "\(dataModel.slowInEth)", processInTime: "\(dataModel.slowTimeInSec)")
            }
            .padding()
            HStack{
                Button {
                    save()
                } label: {
                    Text("Cancel")
                }
                .frame(width: 142, height: 45, alignment: .center)
                Button {
                    save()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .frame(width: 142, height: 45, alignment: .center)
                .background(Color(uiColor: .themeColor()))
                .cornerRadius(5)
           
             
            }
            .padding()
        }
    }
        .frame(width: UIScreen.screenWidth - 32, height: 500, alignment: .center)
        .background(.white)
        .cornerRadius(20)
    }
    
    func save(){
        show.toggle()
    }
    
    func cancel(){
        show.toggle()
    }
    
}

struct MaxTransactionFeeView_Previews: PreviewProvider {
    static var previews: some View {
        MaxTransactionFeeView(show: .constant(true), selectedId: .constant(1), dataModel: ETHGasAPIModel(fast: 390, fastest: 360, safeLow: 250, average: 200, speed: 10, safeLowWait: 0.5, avgWait: 2, fastWait: 0.1, fastestWait: 0.5))
        MaxTransactionFeeOptionView(selectedItem: .constant(1), id:0,title: "High", amt: "5", processInTime: "5")
    }
}

struct MaxTransactionFeeOptionView: View {
    @Binding var selectedItem : Int
    var id:Int
    var title:String
    var amt:String
    var processInTime:String
    var body: some View {
        HStack(alignment:.center){
            HStack{
                HStack(spacing:12){
                Circle()
                        .stroke(selectedItem == id ? .blue : .black,lineWidth: 2)
                        .background(Circle().fill(.blue)
                            .frame(width: selectedItem == id ? 14 : 0, height: selectedItem == id ? 14 : 0, alignment: .center))
                    .frame(width: 21, height: 21, alignment: .center)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                Text(title)
                        .font(.custom(POPPINSFONTLIST.Medium, size: 13))
                }
                Spacer()
                VStack{
                    Text("Up to \(amt) ETH")
                        .font(.custom(POPPINSFONTLIST.Medium, size: 13))
                    Text("Process in ~ \(processInTime) seconds")
                        .font(.custom(POPPINSFONTLIST.Regular, size: 13))
                }
            }
            .padding()
        }
        .onTapGesture {
            selectedItem = id
        }
        .background(selectedItem == id ? .blue.opacity(0.3) : .clear)
        .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedItem == id ? Color.blue : .clear, lineWidth: selectedItem == id ? 1:0)
            )
        .frame(height: 58, alignment: .center)
        .frame(width: 290)

    }
    
}


