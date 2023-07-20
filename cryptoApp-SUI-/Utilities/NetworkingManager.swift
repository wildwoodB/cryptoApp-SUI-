//
//  NetworkingManager.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 24.07.2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingErrors: LocalizedError {
        case badServerResponse(url: URL)
        case unowned
        
        var errorDescription: String? {
            switch self {
            case .badServerResponse(url: let url): return "[🔥] Bad response from URL. \(url)"
            case .unowned: return "[⚠️] Unknown error"
            }
        }
    }
    
    static func downland(url: URL) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
        ////Здесь задается вызов подписки на глобальной очереди с качеством обслуживания `.default`. Это гарантирует, что работа с сетевыми данными будет выполняться в фоновом режиме.
            .subscribe(on: DispatchQueue.global(qos: .default))
        ////вызываем хэндл в замыкании и проверяем все данные
            .tryMap( { try handleURLResponse(output: $0, url: url) } )
        ////Здесь происходит переключение на основную (главную) очередь для выполнения кода, связанного с пользовательским интерфейсом.
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    ////В этом блоке выполняется обработка ответа от сервера. Если ответ содержит успешный статус код (от 200 до 299), то возвращается полученные данные. Если статус код неверный, выбрасывается ошибка типа `URLError.badServerResponse`.
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingErrors.badServerResponse(url: url)
        }
        return output.data
    }
    
    ////вытаскиваем обработчик в отдельную функцию
    static func complitionHandler(complition: Subscribers.Completion<Error>) {
            switch complition {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
    }
}
