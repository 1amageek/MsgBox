//
//  Sender.swift
//  Sample
//
//  Created by 1amageek on 2018/01/22.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import FirebaseFirestore
import RealmSwift
import Pring
import MsgBox

@objcMembers
class Sender: RealmSwift.Object, SenderProtocol {

    typealias User = Messenger.User

    dynamic var id: String = ""

    dynamic var createdAt: Date = Date()

    dynamic var updatedAt: Date = Date()

    dynamic var name: String?

    dynamic var thumbnailImageURL: String?

    public override static func primaryKey() -> String? {
        return "id"
    }
}
