//
//  Todo.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import Foundation
import RealmSwift

@objcMembers
class Todo: Object, ObjectKeyIdentifiable {
    dynamic var _id: String = UUID().uuidString
    dynamic var _partition: String = ""

    dynamic var title: String = ""
    dynamic var isCompleted: Bool = false
    dynamic var dateCreated: Date = Date()
    dynamic var dateCompleted: Date?

    convenience init(title: String) {
        self.init()
        // initialize _partition value with the user's UUID.
        self.title = title
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension Todo {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }

    var dateCreatedFormatted: String {
        dateFormatter.string(from: self.dateCreated)
    }

    var dateCompletedFormatted: String {
        guard let dateCompleted = self.dateCompleted else { return "Not Completed" }
        return dateFormatter.string(from: dateCompleted)
    }

    static func add(in realm: Realm, text: String) {
        try! realm.write {
            let todo = Todo(title: text)
            realm.add(todo)
        }
    }

    static func delete(in realm: Realm, todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }

    static func toggleCompleted(in realm: Realm, todo: Todo) {
        try! realm.write {
            todo.isCompleted.toggle()
            todo.dateCompleted = todo.isCompleted ? Date() : nil
        }
    }
}
