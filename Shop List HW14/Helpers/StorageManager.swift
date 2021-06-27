
import Foundation
import RealmSwift

class StorageManager {
    
    enum listProperty {
        case name, load, maxLoad, isCopleted, purchase
    }
    
    enum PurchaseProperty {
        case name, amount, isCompleted, mesurement
    }
    
    static let realm = try! Realm()
    static let shared = StorageManager()
    
    static func saveShoppingList(_ shoppingLists: [ShoppingList]) {
        try! realm.write {
            realm.add(shoppingLists)
        }
    }
    
    static func deleteShoppingList(_ shoppingLists: [ShoppingList]) {
        try! realm.write {
            realm.delete(shoppingLists)
        }
    }
    
    static func updateList(_ shoppingList: ShoppingList, property: listProperty, value: Any) {
        try! realm.write {
            switch property {
            case .name:
                if let name = shared.tryToCast(value, type: String.self) {
                    shoppingList.name = name
                }
            case .load:
                if let load = shared.tryToCast(value, type: Int.self) {
                    shoppingList.load = load
                }
            case .maxLoad:
                if let maxLoad = shared.tryToCast(value, type: Int.self) {
                    shoppingList.maxLoad = maxLoad
                }
            case .isCopleted:
                if let isComleted = shared.tryToCast(value, type: Bool.self) {
                    shoppingList.isCompleted = isComleted
                }
            case .purchase:
                if let purchase = shared.tryToCast(value, type: Purchase.self) {
                    shoppingList.purchases.append(purchase)
                }
            }
        }
    }
    
    static func updatePurchase(inList shoppingList: ShoppingList, atIndex index: Int, property: PurchaseProperty, value: Any) {
        
        try! realm.write {
            switch property {
            case .name:
                if let name = shared.tryToCast(value, type: String.self) {
                    shoppingList.purchases[index].name = name
                }
            case .isCompleted:
                if let isCompleted = shared.tryToCast(value, type: Bool.self) {
                    shoppingList.purchases[index].isCompleted = isCompleted
                }
            default:
                return 
            }
        }
    }
    
    func tryToCast<T>(_ value: Any, type: T.Type) -> T? {
        guard let castedValue = value as? T else { return nil }
        return castedValue
    }
    
}
