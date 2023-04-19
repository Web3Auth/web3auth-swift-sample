//
//  Extensions.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 24/03/22.
//

import SwiftUI
import UIKit
import Web3Auth

extension Network: CaseIterable {
    public static var allCases: [Network] {
        return [.mainnet, .testnet, .cyan]
    }
}

protocol MenuPickerProtocol: Hashable {
    var name: String { get }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    public func popup<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content, completionHandler: ( () -> Void)? = nil) -> some View {
            ZStack {
                self
                .navigationBarHidden(isPresented.wrappedValue)
                if isPresented.wrappedValue {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                            .onTapGesture {
                                if completionHandler != nil {
                                    completionHandler?()
                                } else {
                                    isPresented.wrappedValue.toggle()
                                }
                            }
                        content()
                    }
            }
        }
    }
}

extension Network: MenuPickerProtocol {
    var networkURL: String {
        switch self {
        case .mainnet:
            return "mainnet"
        case .testnet:
            return "testnet"
        case .cyan:
            return "cyan"
        }
    }

    var name: String {
        switch self {
        case .mainnet:
            return "Mainnet"
        case .testnet:
            return "Testnet"
        case .cyan:
            return "Cyan"
        }
    }
}

enum OpenLoginError: Error {
    case accountError
}

extension Color {

}

extension Color {
    static func bkgColor() -> Color {
        return Color("background")
    }

    static func labelColor() -> Color {
        return Color("LabelColor")
    }

    static func themeColor() -> Color {
        return Color("themeColor")
    }

    static func grayColor() -> Color {
        return Color("grayColor")
    }

    static func systemBlackWhiteColor() -> Color {
        return Color("systemWhiteBlack")
    }

    static func dropDownBkgColor() -> Color {
        return Color("dropDownBkgColor")
    }

    static func borderColor() -> Color {
        return Color("borderColor")
    }
    static func blockchainIndicatorBkgColor() -> Color {
        return Color("blockchainIndicatorBkgColor")
    }

    static func whiteGrayColor() -> Color {
        return Color("whiteGrayColor")
    }
    static func tabBarColor() -> Color {
        return Color("tabBarColor")
    }
    static func blueWhiteColor() -> Color {
        return Color("blueWhiteColor")
    }
}

extension String {
    func invalidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return !emailPred.evaluate(with: self)
    }
}

extension Web3AuthProvider {
    var img: String {
        switch self {
        case .GOOGLE:
            return "Google"
        case .FACEBOOK:
            return "Facebook"
        case .REDDIT:
            return ("Reddit")
        case .DISCORD:
            return ("Discord")
        case .TWITCH:
            return ("Twitch")
        case .APPLE:
            return ("Apple")
        case .LINE:
            return ("Line")
        case .GITHUB:
            return ("Github")
        case .WEIBO:
            return ("Kakao")
        case .LINKEDIN:
            return ("Linkedin")
        case .TWITTER:
            return ("Twitter")
        case .EMAIL_PASSWORDLESS:
            return ("")
        case .JWT:
            return ""
        case .KAKAO:
            return "Kakao"
        case .WECHAT:
            return "Wechat"
        }
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

import Foundation
import web3
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var center: NotificationCenter
    init(center: NotificationCenter = .default) {
        self.center = center
        // 4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
        center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                currentHeight = keyboardSize.height
            }
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
            currentHeight = 0
        }
    }
}

extension Int {
    func toBool() -> Bool {
        self != 0
    }
}
