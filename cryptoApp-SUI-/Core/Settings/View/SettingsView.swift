//
//  SettingsView.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 08.08.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private var coinGeckoURL: URL = URL(string: "https://www.coingecko.com/en/api")!
    private var myGit: URL = URL(string: "https://github.com/wildwoodB")!
    
    var body: some View {
        NavigationView {
            List {
                coinGeckoSection
                developerSection
                applicationSections
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    private var coinGeckoSection: some View {
        
        Section {
            VStack {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocarrency data that is used in this app comes from a free API from CoinGecko! Price maybe slightly delayed! ")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit a CoinGecko website! ", destination: coinGeckoURL)
                .tint(.blue)
            
            
        } header: {
            Text("CoinGecko Info")
        }
    }
    
    private var developerSection: some View {
        
        Section {
            VStack(alignment: .leading) {
                Image("ava")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Nikita Borisov. It used SwiftUI/Combine/MVVM and 100% Swift.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Look at my GIT!", destination: myGit)
                .tint(.blue)
            
            
        } header: {
            Text("Developer info")
        }
    }
    
    private var applicationSections: some View {
        
        Section {
            Link("Terms of Service", destination: coinGeckoURL)
            Link("Privacy Policy", destination: coinGeckoURL)
            Link("Company Website", destination: coinGeckoURL)
            Link("Lern More", destination: coinGeckoURL)
        } header: {
            Text("Application Info")
        }
        .tint(.blue)
    }
}
