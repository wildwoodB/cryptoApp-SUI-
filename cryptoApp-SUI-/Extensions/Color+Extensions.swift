//
//  Color.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 20.07.2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}


struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secendaryText = Color("SecondaryTextColor")
}
