//
//  HelperViews.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 30/03/22.
//

import SwiftUI
import Web3Auth

struct HelperViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HelperViews_Previews: PreviewProvider {
    static var previews: some View {
        TextRoundedFieldView(text: .constant("Hello"),placeHolder: "Hello", error:.constant(true),errorInfoString: "Hello")
        let arr:[Network] = [.mainnet,.testnet,.cyan]
        MenuPickerView(currentSelection: .constant(arr[0]), arr: arr, title: "web3Auth Network")
        
    }
}

struct TextRoundedFieldView:View{
    @Binding var text:String
    var placeHolder:String
    @Binding var error:Bool
    var errorInfoString:String?
    var body: some View{
        VStack{
        TextField(placeHolder, text: $text)
                 .padding([.leading,.trailing],20)
                 .foregroundColor(.gray)
      .frame(width: 308, height: 48, alignment: .center)
         .background(Color.white)
         .cornerRadius(36)
         .background(RoundedRectangle(cornerRadius: 36)
            .stroke(error ? .red : .clear))
            if error{
                HStack{
                Text(errorInfoString ?? "")
                .font(.custom(POPPINSFONTLIST.Regular, size: 12))
                .foregroundColor(.red)
                .padding(.leading,10)
                    Spacer()
                }
                .frame(width: 308,alignment: .leading)
            }
        }
        .frame(alignment: .center)
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: .bkgColor()))
    }
}

struct MenuPickerView<T:MenuPickerProtocol>:View{
    @Binding var currentSelection:T
    var arr = [T]()
    var title:String
    var font:Font?
    var color:Color?
    var body:some View{
        VStack(alignment: .leading){
        Text(title)
            .foregroundColor(color ?? .init(.labelColor()))
            .font(font ?? .custom(POPPINSFONTLIST.SemiBold, size: 14))
            Menu(content: {
                ForEach(arr,id:\.self){ category in
                    Button {
                        currentSelection = category
                                       } label: {
                                           Text("\(category.name)")
                                       }
                                    }
            }, label: {
                HStack(alignment:.center){
                Text(currentSelection.name)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                        .padding()
                    Spacer()
                Image("dropDown")
                        .frame(alignment: .trailing)
                        .padding()
                }
            })
            .foregroundColor(.gray)
            .frame(width: 308, height: 48, alignment: .center)
            .background(Color.white)
            .cornerRadius(36)
        
    }
    }
    
}
