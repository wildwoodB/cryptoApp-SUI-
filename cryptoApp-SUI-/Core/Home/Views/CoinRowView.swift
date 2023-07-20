//
//  CoinRowView.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 21.07.2023.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldings: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldings {
                midlColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background {
            Color.theme.background.opacity(0.001)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldings: true)
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secendaryText)
                .frame(width: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .padding(.leading, 6)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var midlColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .fontWeight(.bold)
            Text(coin.currentHoldings?.asNubmerString() ?? "")
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentNubmer() ?? "")
                .fontWeight(.bold)
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
