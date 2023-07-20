//
//  MarketDataService.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 26.07.2023.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        ////Создается объект `marketDataSubscription`, который представляет собой подписку на таск получения данных о монетах из сети
        marketDataSubscription = NetworkingManager.downland(url: url)
        //В этой строке выполняется декодирование данных типа `GlobalData.self` из полученного JSON с использованием `JSONDecoder`
            .decode(type: GlobalData.self, decoder: JSONDecoder())
        ////Здесь происходит обработка результата:
            .sink(receiveCompletion: NetworkingManager.complitionHandler,
                  //// предоставляет декодированный объект `GlobalData` внутри его замыкания. Обновление `self?.marketData`
                  receiveValue: { [weak self] (returnedCoins) in
                self?.marketData = returnedCoins.data
                ////выполняется для сохранения списка монет и отмены подписки.
                self?.marketDataSubscription?.cancel()
            })
    }
}
