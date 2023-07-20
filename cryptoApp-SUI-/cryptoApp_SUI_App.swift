//
//  cryptoApp_SUI_App.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 20.07.2023.
//

import SwiftUI

@main
struct cryptoApp_SUI_App: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        //UINavigationBar.appearance().titleTextAttributes = [.font : ]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
