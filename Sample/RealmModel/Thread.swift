//
//  Thread.swift
//  Sample
//
//  Created by 1amageek on 2018/01/30.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Pring

@objcMembers
class Thread: RealmSwift.Object, ThreadProtocol {

    typealias Room = Sample.Room

    dynamic var id: String = ""

    dynamic var createdAt: Date = Date()

    dynamic var updatedAt: Date = Date()

    dynamic var name: String?

    dynamic var thumbnailImageURL: String?

    public override static func primaryKey() -> String? {
        return "id"
    }
}
