//
//  CustomButton.swift
//  
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import SwiftUI

struct CustomButton: View {
    var body: some View {
        CustomButtonUIKit(showloader: .constant(true), title: "Hello")
            .foregroundColor(.gray)
            .frame(width: 300, height: 48, alignment: .center)
            .cornerRadius(24)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
           
    }
}


struct CustomButtonUIKit: UIViewRepresentable {
    func updateUIView(_ uiView: UIButton, context: Context) {
   
        uiView.configuration?.showsActivityIndicator = showloader
    }
    
    @Binding var showloader:Bool
    var title:String
    func makeUIView(context: UIViewRepresentableContext<CustomButtonUIKit>) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .gray
        config.imagePlacement = .trailing
      
        config.imagePadding = 10
        config.showsActivityIndicator = showloader
        let button = UIButton(configuration: config)
        button.tintColor = .themeColor()
        button.titleLabel?.font = UIFont(name: DMSANSFONTLIST.Medium, size: 16)
        button.layer.borderColor = UIColor.grayColor().cgColor
      return button
    }

}



