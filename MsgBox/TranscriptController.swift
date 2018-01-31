//
//  TranscriptController.swift
//  MsgBox
//
//  Created by 1amageek on 2018/01/23.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring
import RealmSwift

public extension MsgBox {
    public class TranscriptController {

        public let roomID: String

        public let dataSource: DataSource<Transcript>

        public let realm: Realm = try! Realm()

        public init(roomID: String, limit: Int = 30) {
            self.roomID = roomID
            let room: Room = Room(id: roomID)
            self.dataSource = DataSource<Transcript>.Query(room.transcripts.reference)
                .order(by: "createdAt")
                .limit(to: limit)
                .dataSource()
        }

        public func listen() {
            self.dataSource.on({ [weak self] (_, change) in
                switch change {
                case .initial:
                    if let transcripts: [Transcript] = self?.dataSource.documents {
                        Message.saveIfNeeded(transcripts: transcripts)
                    }
                case .update(deletions: _, insertions: let insertions, modifications: let modifications):
                    if !insertions.isEmpty {
                        let transcripts: [Transcript] = insertions.flatMap { return self?.dataSource[$0] }
                        Message.saveIfNeeded(transcripts: transcripts)
                    }
                    if !modifications.isEmpty {
                        let transcripts: [Transcript] = modifications.flatMap { return self?.dataSource[$0] }
                        Message.saveIfNeeded(transcripts: transcripts)
                    }
                case .error(let error): print(error)
                }
            }).listen()
        }

        public func next() {
            self.dataSource.next()
        }

        public func fetchMembers(_ block: ((Error?) -> Void)?) {
            let room: Room = Room(id: roomID)
            room.members
                .query
                .dataSource()
                .onCompleted { [weak self] (_, users) in
                    guard let realm: Realm = self?.realm else { return }
                    if !users.isEmpty {
                        Sender.saveIfNeeded(users: users, realm: realm)
                    }
                }.get()
        }
    }
}
