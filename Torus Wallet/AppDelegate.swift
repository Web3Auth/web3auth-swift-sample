//
//  AppDelegate.swift
//  Torus Wallet
//
//  Created by Dhruv Jaiswal on 19/04/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  let  notificationCenter = NotificationCenter()

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      IQKeyboardManager.shared.enable = true
      IQKeyboardManager.shared.enableAutoToolbar = false

     return true
  }
}
