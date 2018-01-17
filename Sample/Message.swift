//
//  Message.swift
//  Sample
//
//  Created by 1amageek on 2018/01/16.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Pring

class Message: RealmSwift.Object, MessageProtocol {

    typealias Transcript = Sample.Transcript

    var id: String = ""

    var roomID: String = ""

    var userID: String = ""

    var createdAt: Date = Date()

    var updatedAt: Date = Date()

    var text: String?

}
