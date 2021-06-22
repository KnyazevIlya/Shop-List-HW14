//
//  Good.swift
//  Shop List HW14
//
//  Created by admin2 on 22.06.2021.
//

import Foundation
import RealmSwift

class Purchase: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var amount = 0
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
    @objc dynamic var measurement = ""
}
