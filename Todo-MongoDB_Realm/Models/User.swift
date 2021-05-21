//
//  User.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import RealmSwift

@objcMembers
class User: Object {
    dynamic var _id: String = ""
    dynamic var _partition: String = ""
    dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "_id"
    }

    convenience init(user: String) {
        self.init()
        self._id = DefaultRealmService.userID
        self._partition = DefaultRealmService.partitionKeyToAssign
        self.name = user
    }
}
