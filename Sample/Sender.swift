//
//  Sender.swift
//  Sample
//
//  Created by 1amageek on 2018/01/22.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Pring

class Sender: RealmSwift.Object, SenderProtocol {

    typealias User = Sample.User

    var id: String = ""

    var createdAt: Date = Date()

    var updatedAt: Date = Date()

    var name: String?

    var thumbnailImageURL: String?
}
