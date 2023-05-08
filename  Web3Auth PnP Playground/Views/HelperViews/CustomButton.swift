//
//  CustomButton.swift
//  
//
//  Created by Dhruv Jaiswal on 21/04/22.
//

import SwiftUI

struct CustomButton: View {
    var body: some View {
        CustomButtonUIKit(showloader: .constant(true), title: "Transfer")
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

    @Binding var showloader: Bool
    var title: String
    func makeUIView(context: UIViewRepresentableContext<CustomButtonUIKit>) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = UIColor(Color.dropDownBkgColor())
        config.baseForegroundColor = UIColor(Color.labelColor())
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.showsActivityIndicator = showloader
        let button = UIButton(configuration: config)
        button.tintColor = UIColor(Color.themeColor())
        button.titleLabel?.font = UIFont(name: DMSANSFONTLIST.Regular, size: 16)
        button.layer.borderColor = Color.grayColor().cgColor
      return button
    }
}
