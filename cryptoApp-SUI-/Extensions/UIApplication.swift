//
//  UIApplication.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 25.07.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    ////расширение позволяющее нам скрывать клавиатуру после окончания редактирования текстФилда
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
