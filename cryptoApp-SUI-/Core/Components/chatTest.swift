//
//  chatTest.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 27.07.2023.
//
//
//import SwiftUI
//import Combine
//
//struct OrderView: View {
//    @State private var orderPlaced = false
//    //@StateObject private var orderViewModel = OrderViewModel()
//
//    var body: some View {
//        VStack {
//            // Здесь разместите интерфейс для добавления товаров в корзину
//            // и отображения выбранных товаров и их количество.
//
//            Button("Оформить заказ") {
//                //orderViewModel.placeOrder()
//            }
//            .padding()
//            .disabled(orderPlaced)
//        }
//        .onReceive(orderViewModel.$orderPlaced) { placed in
//            orderPlaced = placed
//        }
//    }
//}

//class OrderViewModel: ObservableObject {
//    @Published var orderPlaced = false
//
//    private let orderAPIService = OrderAPIService()
//    private var cancellables = Set<AnyCancellable>()
//
//    func placeOrder() {
//        let order = Order(orderId: 1, items: [], totalAmount: 0) // Ваша логика для создания заказа
//
//        orderAPIService.placeOrder(order: order)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    // Обработка ошибок при отправке заказа
//                    print("Error placing order: \(error)")
//                }
//            }, receiveValue: { [weak self] placed in
//                self?.orderPlaced = placed
//                if placed {
//                    // Действия, которые нужно выполнить при успешной отправке заказа
//                    print("Order placed successfully!")
//                }
//            })
//            .store(in: &cancellables)
//    }
//}

//struct OrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderView()
//    }
//}

