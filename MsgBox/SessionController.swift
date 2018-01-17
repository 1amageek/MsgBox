//
//  MessageSessionController.swift
//  MessageBox
//
//  Created by 1amageek on 2018/01/16.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring
import RealmSwift

extension MessageBox {
    class SessionController {

        let roomID: String

        let dataSource: DataSource<Transcript>

        let realm: Realm = try! Realm()

        init(roomID: String) {
            self.roomID = roomID
            let room: Room = Room(id: roomID)
            self.dataSource = DataSource<Transcript>.Query(room.transcripts.reference)
                .order(by: "createdAt")
                .dataSource()
        }

        public func listen() {
            self.dataSource.on({ [weak self] (_, change) in
                guard let realm: Realm = self?.realm else { return }
                switch change {
                case .initial:
                    if let transcripts: [Transcript] = self?.dataSource.documents {
                        Message.saveIfNeeded(transcripts: transcripts, realm: realm)
                    }
                case .update(deletions: _, insertions: let insertions, modifications: let modifications):
                    if !insertions.isEmpty {
                        let transcripts: [Transcript] = insertions.flatMap { return self?.dataSource[$0] }
                        Message.saveIfNeeded(transcripts: transcripts, realm: realm)
                    }
                    if !modifications.isEmpty {
                        let transcripts: [Transcript] = modifications.flatMap { return self?.dataSource[$0] }
                        Message.saveIfNeeded(transcripts: transcripts, realm: realm)
                    }
                case .error(let error): print(error)
                }
            }).listen()
        }
    }
}
