//
//  Transcript.swift
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
class Transcript: Pring.Object, TranscriptProtocol {

    typealias User = Messenger.User

    typealias Room = Messenger.Room

    var user: Reference<User> = .init()

    var room: Reference<Room>  = .init()

    dynamic var text: String?

    dynamic var image: File?

    dynamic var video: File?

    dynamic var audio: File?

    dynamic var location: GeoPoint?

    dynamic var sticker: String?

    dynamic var imageMap: [File] = []
}
