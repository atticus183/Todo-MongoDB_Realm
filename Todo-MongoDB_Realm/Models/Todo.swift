//
//  Todo.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import Foundation
import RealmSwift

@objcMembers
class Todo: Object {
    dynamic var _id: String = ""
    dynamic var _partition: String = ""

    dynamic var title: String = ""
    dynamic var isCompleted: Bool = false
    dynamic var dateCreated: Date = Date()
    dynamic var dateCompleted: Date?

    convenience init(title: String) {
        self.init()
        self._id = UUID().uuidString
        // initialize _partition value with the user's UUID.
        self.title = title
    }
}

extension Todo {
    static func add(in realm: Realm, text: String) {
        try! realm.write {
            let todo = Todo(title: text)
            realm.add(todo)
        }
    }
}
