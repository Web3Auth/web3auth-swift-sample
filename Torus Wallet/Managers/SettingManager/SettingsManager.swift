//
//  SettingsManager.swift
//  Torus Wallet
//
//  Created by Dhruv Jaiswal on 14/04/23.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    @Published var theme: Theme = .light

    init() {
            let data = UserDefaultsManager.shared.get(key: .theme) ?? Data()
        let str = String(data: data, encoding: .utf8) ?? "light"
            theme = .init(rawValue: str) ?? .light
    }

    func changeColorSchemeTo(_ theme: Theme) {
           self.theme = theme
            let data = theme.rawValue.data(using: .utf8) ?? Data()
            UserDefaultsManager.shared.save(key: .theme, val: data)
    }
}

enum Theme: String, Codable, CaseIterable {
    case dark = "dark"
    case light = "light"

    var colorScheme: ColorScheme {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        }
    }
}

extension Theme {
    var name: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
