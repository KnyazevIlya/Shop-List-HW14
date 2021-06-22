
import Foundation
import RealmSwift

class StorageManager {
    
    static let realm = try! Realm()
    static func saveShoppingList (_ shoppingLists: [ShoppingList]) {
        try! realm.write {
            realm.add(shoppingLists)
        }
    }
    
}
