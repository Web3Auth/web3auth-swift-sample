//
//  SettingsManager.swift
//  Torus Wallet
//
//  Created by Dhruv Jaiswal on 14/04/23.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    @Published var colorScheme: ColorScheme = .light

    init() {
    }

    func changeColorSchemeTo(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
}

extension ColorScheme {
    var name: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
