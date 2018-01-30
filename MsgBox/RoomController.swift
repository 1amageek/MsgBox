//
//  RoomController.swift
//  MsgBox
//
//  Created by 1amageek on 2018/01/23.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring
import RealmSwift

public extension MsgBox {
    public class RoomController {

        public let userID: String

        public let dataSource: DataSource<Room>

        public let realm: Realm = try! Realm()

        public init(userID: String, limit: Int = 30) {
            self.userID = userID
            let user: User = User(id: userID)
            self.dataSource = DataSource<Room>.Query(user.rooms.reference)
                .order(by: "createdAt")
                .limit(to: limit)
                .dataSource()
        }

        public func listen() {
            self.dataSource.on({ [weak self] (_, change) in
                guard let realm: Realm = self?.realm else { return }
                switch change {
                case .initial:
                    if let rooms: [Room] = self?.dataSource.documents {
                        Thread.saveIfNeeded(rooms: rooms, realm: realm)
                    }
                case .update(deletions: _, insertions: let insertions, modifications: let modifications):
                    if !insertions.isEmpty {
                        let rooms: [Room] = insertions.flatMap { return self?.dataSource[$0] }
                        Thread.saveIfNeeded(rooms: rooms, realm: realm)
                    }
                    if !modifications.isEmpty {
                        let rooms: [Room] = modifications.flatMap { return self?.dataSource[$0] }
                        Thread.saveIfNeeded(rooms: rooms, realm: realm)
                    }
                case .error(let error): print(error)
                }
            }).listen()
        }

        public func next() {
            self.dataSource.next()
        }
    }
}

