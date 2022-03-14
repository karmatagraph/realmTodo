//
//  Tasktodo.swift
//  realmTodo
//
//  Created by karma on 3/14/22.
//

import Foundation
import RealmSwift
class Tasktodo: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var createdAt: Date = Date()
}
