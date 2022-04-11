//
//  Extensions.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 24/03/22.
//

import UIKit
import SwiftUI
import Web3Auth


protocol MenuPickerProtocol:Hashable{
    var name:String { get }
}



enum BlockchainEnum:Int,CaseIterable,Hashable,MenuPickerProtocol{
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





extension Network:MenuPickerProtocol{
    

    
    
    var networkURL:String{
        switch self {
        case .mainnet:
            return "mainnet"
        case .testnet:
            return "testnet"
        case .cyan:
            return "cyan"
        }
    }
    
    
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

enum OpenLoginError:Error{
    case AccountError
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

import Foundation
import SwiftUI
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
var _center: NotificationCenter
    init(center: NotificationCenter = .default) {
            _center = center
        //4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
            _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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


