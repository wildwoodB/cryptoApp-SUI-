//
//  HaptickManager.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 03.08.2023.
//

import Foundation
import SwiftUI

class HaptickManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
