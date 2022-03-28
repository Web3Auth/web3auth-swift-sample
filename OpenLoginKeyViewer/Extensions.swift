//
//  Extensions.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 24/03/22.
//

import UIKit
import SwiftUI
import Web3Auth

enum BlockchainEnum:Int,CaseIterable,Hashable {
    case Ethereum, Solana, Binance, Polygon
    
    var name:String{
        switch self {
        case .Ethereum:
            return "Ethereum"
        case .Solana:
            return "Solana"
        case .Binance:
            return "Binance"
        case .Polygon:
            return "Polygon"
        }
    }
}

extension Network{
    
    var name:String{
        switch self {
        case .mainnet:
            return "MAINNET"
        case .testnet:
            return "TESTNET"
        case .cyan:
            return "CYAN"
        }
    }
}
enum NetworkEnum:Int,CaseIterable,Hashable {
    case MAINNET, TESTNET, CYAN
    
    var name:String{
        switch self {
        case .MAINNET:
            return "MAINNET"
        case .TESTNET:
            return "TESTNET"
        case .CYAN:
            return "CYAN"
        }
    }
}


extension UIColor{
    static func bkgColor() -> UIColor{
        return UIColor(named: "background") ?? .white
    }
    static func labelColor() -> UIColor{
        return UIColor(named: "LabelColor") ?? .white
    }
    static func themeColor() -> UIColor{
        return UIColor(named: "themeColor") ?? .white
    }
}

extension String{
    
    func InvalidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return !emailPred.evaluate(with: self)
    }
}

extension Web3AuthProvider{
    var img:String{
        switch self {
        case .GOOGLE:
            return "Google"
        case .FACEBOOK:
            return "Facebook"
        case .REDDIT:
            return ("Twitter")
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
        case .WEBAUTHN:
            return ""
        case .KAKAO:
            return "Kakao"
        case .WECHAT:
            return "Wechat"
        }
    }
}




extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct KeyboardManagment: ViewModifier {
    @State private var offset: CGFloat = 0
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            offset = keyboardFrame.height - geo.safeAreaInsets.bottom - 10
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                        withAnimation(Animation.easeOut(duration: 0.1)) {
                            offset = 0
                        }
                    }
                }
                .padding(.bottom, offset)
        }
    }
}
extension View {
    func keyboardManagment() -> some View {
        self.modifier(KeyboardManagment())
    
    }
}
