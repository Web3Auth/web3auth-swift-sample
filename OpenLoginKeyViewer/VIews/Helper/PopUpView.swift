//
//  PopUpView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 08/04/22.
//

import SwiftUI

struct MessageSignedView: View {
    @Binding var success:Bool
    @State var successMessage:String = "Signed Successfully"
    @State var errorMessage:String = "Sign Failed"
    @State var info:String
    var body: some View {
        ZStack(alignment:.center){
            PopUpView()
            VStack{
            Image(success ? "success" : "failure")
                .resizable()
                .frame(width: 88, height: 88, alignment: .center)
            Text(success ? successMessage : errorMessage)
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 18))
                if success{
            Text(info)
                .multilineTextAlignment(.center)
                .padding(.leading,30)
                .padding(.trailing,30)
                .padding(.top,10)
            HStack{
                Button {
                    UIPasteboard.general.string = info
                } label: {
                    Image("copy")
                        .frame(width: 16, height: 16, alignment: .center)
                    Text("Copy")
                }

            }
                }
            }
        }
    }
    
}

struct PopUpView: View {
    var body: some View {
        VStack{
            
            }
        .frame(width: UIScreen.screenWidth - 32, height: UIScreen.screenHeight * 0.5, alignment: .center)
        .background(.white)
        .cornerRadius(20)
    }
    
}



struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView()
        MessageSignedView(success: .constant(true), info: "saasa")
        MessageSignedView(success: .constant(false), info: "samsa")
    }
}


