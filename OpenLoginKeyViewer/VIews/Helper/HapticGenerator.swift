//
//  HapticGenerator.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 19/04/22.
//

import UIKit

enum HapticGeneratorEnum{
    case error
    case success
}

class HapticGenerator{
    
    static let shared = HapticGenerator()
    var generator = UINotificationFeedbackGenerator()
   private init(){
    }
    
    func generateHaptic(val:HapticGeneratorEnum){
        switch val {
        case .error:
            generator.notificationOccurred(.error)
        case .success:
            generator.notificationOccurred(.success)
        }
    }
}
