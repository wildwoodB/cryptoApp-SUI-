//
//  String.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 08.08.2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
    }
}
