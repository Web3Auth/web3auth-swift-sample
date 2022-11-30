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
        TextRoundedFieldView(text: .constant("Hello"), placeHolder: "Hello", error: .constant(true), errorInfoString: "Hello")
        let arr: [Network] = [.mainnet, .testnet, .cyan]
        MenuPickerView(currentSelection: .constant(arr[0]), arr: arr, title: "web3Auth Network")
        Blur(radius: 25, opaque: true)

    }
}

struct TextRoundedFieldView: View {
    @Binding var text: String
    var placeHolder: String
    var widht: CGFloat = 308
    var height: CGFloat = 48
    @Binding var error: Bool
    var errorInfoString: String?
    var body: some View {
        VStack {
        TextField(placeHolder, text: $text)
                 .padding([.leading, .trailing], 20)
                 .foregroundColor(.gray)
      .frame(width: widht, height: height, alignment: .center)
      .background(Color.dropDownBkgColor())
         .cornerRadius(36)
         .background(RoundedRectangle(cornerRadius: 36)
            .stroke(error ? .red : .clear))
            if error {
                HStack {
                Text(errorInfoString ?? "")
                .font(.custom(POPPINSFONTLIST.Regular, size: 12))
                .foregroundColor(.red)
                .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: 308, alignment: .leading)
            }
        }
        .frame(alignment: .center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.bkgColor())
    }
}

struct MenuPickerView<T: MenuPickerProtocol>: View {
    @Binding var currentSelection: T
    var arr = [T]()
    var title: String
    var font: Font?
    var color: Color?
    var widht: CGFloat = 308
    var height: CGFloat = 48
    var body: some View {
        VStack(alignment: .leading) {
        Text(title)
            .foregroundColor(color ?? .init(.labelColor()))
            .font(font ?? .custom(POPPINSFONTLIST.SemiBold, size: 14))
            Menu(content: {
                ForEach(arr, id: \.self) { category in
                    Button {
                        currentSelection = category
                                       } label: {
                                           Text("\(category.name)")
                                       }

                                    }
            }, label: {
                HStack(alignment: .center) {
                Text(currentSelection.name)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                        .padding()
                    Spacer()
                Image("dropDown")
                        .frame(alignment: .trailing)
                        .padding()
                }
            })
            .foregroundColor(Color.grayColor())
            .frame(width: widht, height: height, alignment: .center)
            .background(Color.dropDownBkgColor())
            .cornerRadius(36)

    }
    }

}

class UIBackdropView: UIView {
    override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

struct Backdrop: UIViewRepresentable {
    func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }

    func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

struct Blur: View {
    var radius: CGFloat = 3
    var opaque: Bool = false

    var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
    }
}
