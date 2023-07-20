//
//  CoinDetailDataService.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 04.08.2023.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    
    @Published var coinDetail: CoinDetailInfo? = nil
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        ////Создается объект `coinDetailSubscription`, который представляет собой подписку на таск получения данных о монетах из сети
        coinDetailSubscription = NetworkingManager.downland(url: url)
        //В этой строке выполняется декодирование данных типа `CoinDetailInfo.self` из полученного JSON с использованием `JSONDecoder`
            .decode(type: CoinDetailInfo.self, decoder: JSONDecoder())
        ////Здесь происходит обработка результата:
            .sink(receiveCompletion: NetworkingManager.complitionHandler,
                  //// предоставляет декодированный объект `CoinDetailInfo` внутри его замыкания. Обновление `self?.coinDetail`
                  receiveValue: { [weak self] (returnedCoinsDetails) in
                self?.coinDetail = returnedCoinsDetails
                ////выполняется для сохранения списка монет и отмены подписки.
                self?.coinDetailSubscription?.cancel()
            })
    }
}
