import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    // Массив для хранения всех сохраненных сущностей портфолио
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        // Инициализация CoreData контейнера с указанным именем
        container = NSPersistentContainer(name: containerName)
        // Загрузка хранилища данных CoreData
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading coreData! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: - Public
    
    // проверяем какой из методов нам использовать
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // проверяем есть ли монета уже в сохраненных данных
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - Private
    
    // Получение данных о портфолио из CoreData
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            // Получение сохраненных сущностей портфолио из контекста CoreData
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities \(error)")
        }
    }
    
    // Добавление новой монеты в портфолио
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        // Применение изменений (сохранение) после добавления монеты в портфолио
        applyChanges()
    }
    
    // Обновление количества монет в портфолио
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        // Применение изменений (сохранение) после обновления количества монет в портфолио
        applyChanges()
    }
    
    // Удаление монеты из портфолио
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        // Применение изменений (сохранение) после удаления монеты из портфолио
        applyChanges()
    }
    
    // Применение изменений (сохранение) в CoreData
    private func applyChanges() {
        // Сохранение данных в CoreData
        save()
        // Получение обновленных данных о портфолио после применения изменений
        getPortfolio()
    }
    
    // Сохранение данных в CoreData
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Saving error \(error)")
        }
    }
}
