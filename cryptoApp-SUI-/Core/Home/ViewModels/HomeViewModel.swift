//
//  HomeViewModel.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 22.07.2023.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    
    
    @Published var statistics: [StatisticModel] = [
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var portfolioDataService = PortfolioDataService()
    
    ////cancellables является массивом или коллекцией, которая хранит все активные подписки на наблюдаемые объекты, чтобы предотвратить утечку памяти. Когда объект, в который происходит подписка, уничтожается или не нужен, это также гарантирует отмену подписки и освобождение ресурсов.
    private var cancellables = Set<AnyCancellable>()
    
    
    enum SortOption {
        
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
        
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        //        dataService.$allCoins
        //            .sink { [weak self] (returnedCoins) in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        // update allCoins
        $searchText
        ////.combineLatest(dataService.$allCoins) - метод combineLatest объединяет значения из searchText и dataService.$allCoins. Когда хотя бы один из наблюдаемых объектов излучает новое значение, этот метод автоматически объединяет последние значения из обоих потоков данных.
            .combineLatest(coinDataService.$allCoins, $sortOption)
        ////это оператор debounce в Combine (фреймворке реактивного программирования от Apple). Он применяется к наблюдаемому объекту (Observable) и позволяет управлять частотой, с которой значения из этого наблюдаемого объекта передаются дальше по цепочке обработки.
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //// метод map принимает текущие значения из объединенных потоков данных (text и startingCoins) и выполняет преобразование этих значений в новый поток данных.
            .map(filtrAndSortCoins)
        ////. метод sink подписывается на поток данных, который получается после преобразования через map. Когда новые отфильтрованные монеты доступны, этот блок выполнится. Он обновляет свойство allCoins  со списком отфильтрованных монет.
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
        ////. это управление памятью для подписки на наблюдаемый объект (Observable). cancellables является массивом или коллекцией, которая хранит все активные подписки на наблюдаемые объекты, чтобы предотвратить утечку памяти. Когда объект, в который происходит подписка, уничтожается или не нужен, это также гарантирует отмену подписки и освобождение ресурсов.
            .store(in: &cancellables)
        
        // updates Portfolio Coins with self.sortPortfolioCoinsIfNeeded()
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedPortfolioCoin) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedPortfolioCoin)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStat) in
                guard let self = self else { return }
                self.statistics = returnedStat
            }
            .store(in: &cancellables)
        
        
    }
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.getData()
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntitis: [PortfolioEntity] ) -> [CoinModel] {
        allCoins
        .compactMap { (coin) -> CoinModel? in
            guard let entyti = portfolioEntitis.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entyti.amount)
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filtrAndSortCoins(text: String, coins: [CoinModel], sort: SortOption ) -> [CoinModel] {
        var updateCoins = filtredCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updateCoins)
        return updateCoins
    }
    
    private func filtredCoins(text: String, coins: [CoinModel] ) -> [CoinModel] {
        ///Внутри блока map происходит логика фильтрации монет. Если введенный текст пустой, то возвращаются все исходные монеты (coins). Если введенный текст не пустой, то он приводится к нижнему регистру, и монеты фильтруются так, чтобы в их названиях, идентификаторах или символах содержался введенный текст. Фильтрованный результат возвращается в виде массива [CoinModel].
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText)
        }
    }
    // функция сорта массива монет переданных по ссылке через слово inout, массив взять по ссылке а не по значению и отсортирован в функции filtrAndSortCoins, при том используется специальный метод .sort а не .sorted 🤯
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func mapGlobalMarketData(marketDtaModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDtaModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioVlaue =
        portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previosValue =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previosValue = currentValue / (1 + percentChange)
                return previosValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioVlaue - previosValue) * 100)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioVlaue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf:[
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
