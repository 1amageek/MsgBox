//
//  Room.swift
//  Sample
//
//  Created by 1amageek on 2018/01/10.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import FirebaseFirestore
import RealmSwift
import Pring
import MsgBox

@objcMembers
class Room: Pring.Object, RoomProtocol {
    var transcripts: SubCollection<Transcript> = []


    typealias Transcript = Messenger.Transcript

    typealias User = Messenger.User

//    var transcripts: NestedCollection<Transcript> = []

    var members: ReferenceCollection<User> = []

    var viewers: ReferenceCollection<User> = []

    dynamic var name: String?
}
