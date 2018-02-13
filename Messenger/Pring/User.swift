//
//  User.swift
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
class User: Pring.Object, UserProtocol {

    typealias Transcript = Messenger.Transcript

    typealias Room = Messenger.Room

    dynamic var name: String?

    dynamic var thumbnail: File?

    var rooms: ReferenceCollection<Room> = []

    var messageMox: ReferenceCollection<Transcript> = []
}
