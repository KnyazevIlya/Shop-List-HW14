
import Foundation
import RealmSwift

class StorageManager {
    
    enum listProperty {
        case name, load, maxLoad, isCopleted
    }
    
    static let realm = try! Realm()
    
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
                if let name = tryToCast(value, type: String.self) {
                    shoppingList.name = name
                }
            case .load:
                if let load = tryToCast(value, type: Int.self) {
                    shoppingList.load = load
                }
            case .maxLoad:
                if let maxLoad = tryToCast(value, type: Int.self) {
                    shoppingList.maxLoad = maxLoad
                }
            case .isCopleted:
                if let isComleted = tryToCast(value, type: Bool.self) {
                    shoppingList.isCompleted = isComleted
                }
            }
        }
    }
    
    static func tryToCast<T>(_ value: Any, type: T.Type) -> T? {
        guard let castedValue = value as? T else { return nil }
        return castedValue
    }
    
}
