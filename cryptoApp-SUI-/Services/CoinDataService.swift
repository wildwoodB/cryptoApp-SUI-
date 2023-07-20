//
//  CoinDataService.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 24.07.2023.
//

import Foundation
import Combine


class CoinDataService {
    
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=500&page=1&sparkline=true&price_change_percentage=24h&locale=en")
        else { return }
        
        ////Создается объект `coinSubscription`, который представляет собой подписку на таск получения данных о монетах из сети
        coinSubscription = NetworkingManager.downland(url: url)
        //В этой строке выполняется декодирование данных типа `[CoinModel].self` из полученного JSON с использованием `JSONDecoder`
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
        ////Здесь происходит обработка результата:
            .sink(receiveCompletion: NetworkingManager.complitionHandler,
                  //// предоставляет декодированный объект `[CoinModel]` внутри его замыкания. Обновление `self?.allCoins`
                  receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                ////выполняется для сохранения списка монет и отмены подписки.
                self?.coinSubscription?.cancel()
            })
    }
}
