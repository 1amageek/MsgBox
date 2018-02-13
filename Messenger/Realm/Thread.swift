//
//  Thread.swift
//  Sample
//
//  Created by 1amageek on 2018/01/30.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import FirebaseFirestore
import RealmSwift
import Pring
import MsgBox

@objcMembers
class Thread: RealmSwift.Object, ThreadProtocol {

    typealias Room = Messenger.Room

    typealias Message = Messenger.Message

    typealias Sender = Messenger.Sender

    dynamic var id: String = ""

    dynamic var createdAt: Date = Date()

    dynamic var updatedAt: Date = Date()

    dynamic var name: String?

    dynamic var thumbnailImageURL: String?

    dynamic var lastMessage: Message?

    dynamic var viewers: List<Sender> = .init()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
