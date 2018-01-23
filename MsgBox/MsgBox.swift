//
//  MsgBox.swift
//  MsgBox
//
//  Created by 1amageek on 2018/01/16.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import Pring
import RealmSwift


public class MsgBox<User, Room: RoomDocument, Transcript, Message: MessageProtocol, Sender: SenderProtocol>: NSObject
where   Message: RealmSwift.Object, Message.Transcript == Transcript,
        Sender: RealmSwift.Object, Sender.User == User,
        Room.User == Sender.User {

    let realm: Realm = try! Realm()

    let dataSource: DataSource<Transcript>

    init(userID: String) {
        let user: User = User(id: userID)
        self.dataSource = DataSource<Transcript>.Query(user.messageMox.reference)
            .order(by: "updatedAt")
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
