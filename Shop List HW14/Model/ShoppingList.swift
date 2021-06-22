//
//  ShoppingList.swift
//  Shop List HW14
//
//  Created by admin2 on 22.06.2021.
//

import Foundation
import RealmSwift

class ShoppingList: Object {
    @objc dynamic var name = ""
    @objc dynamic var load = 0
    @objc dynamic var maxLoad = 0
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
    
    let purchases = List<Purchase>()
}
