//
//  MsgProtocol.swift
//  MsgBox
//
//  Created by 1amageek on 2018/01/16.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Pring
import RealmSwift

public typealias MsgUser = UserType & Document
public typealias MsgRoom = RoomType & Document
public typealias MsgTranscript = TranscriptType & Document

public typealias UserProtocol = UserType & HasRooms & HasMessageBox
public typealias RoomProtocol = RoomType & HasTranscripts & HasMembers
public typealias TranscriptProtocol = TranscriptType & HasContent

public typealias UserDocument = UserProtocol & Document
public typealias RoomDocument = RoomProtocol & Document
public typealias TranscriptDocument = TranscriptProtocol & Document


// MARK: User

public protocol UserType {
    var name: String? { get }
    var thumbnail: File? { get }
}

public protocol HasMessageBox {
    associatedtype Transcript: MsgTranscript
    var messageMox: ReferenceCollection<Transcript> { get }
}

public protocol HasRooms {
    associatedtype Room: MsgRoom
    var rooms: SubCollection<Room> { get }
}

// MARK: Room

public protocol RoomType {
    var name: String? { get }
}

public protocol HasMembers {
    associatedtype User: UserDocument
    var members: ReferenceCollection<User> { get }
}

public protocol HasTranscripts {
    associatedtype Transcript: TranscriptDocument
    var transcripts: SubCollection<Transcript> { get }
}

// MARK: Transcript

public protocol TranscriptType {

    associatedtype User: MsgUser
    associatedtype Room: MsgRoom

    var user: Reference<User> { get }
    var room: Reference<Room> { get }
}

public protocol HasContent {

    var text: String? { get set }
    var image: File? { get set }
    var video: File? { get set }
    var audio: File? { get set }
    var location: GeoPoint? { get set }
    var sticker: String? { get set }
    var imageMap: [File] { get set }
}

// MARK: Sender

public protocol SenderProtocol {

    associatedtype User: UserDocument

    var id: String { get set }
    var createdAt: Date { get set }
    var updatedAt: Date { get set }
    var name: String? { get set }
    var thumbnailImageURL: String? { get set }

    init(user: User)

    static func primaryKey() -> String?
}

public extension SenderProtocol where Self: RealmSwift.Object {

    static func primaryKey() -> String? {
        return "id"
    }

    public init(user: User) {
        self.init()
        self.id = user.id
        self.createdAt = user.createdAt
        self.updatedAt = user.updatedAt
        self.name = user.name
        self.thumbnailImageURL = user.thumbnail?.downloadURL?.absoluteString
    }

    public static func saveIfNeeded(users: [User], realm: Realm = try! Realm()) {
        var updateMembers: [Self] = []
        var insertMembers: [Self] = []
        users.forEach { (user) in
            let user: Self = Self(user: user)
            if let _user = realm.objects(Self.self).filter("id == %@", user.id).first {
                if _user.updatedAt < user.updatedAt {
                    updateMembers.append(user)
                }
            } else {
                insertMembers.append(user)
            }
        }

        try! realm.write {
            if !updateMembers.isEmpty {
                realm.add(updateMembers, update: true)
            }
            if !insertMembers.isEmpty {
                realm.add(insertMembers)
            }
        }
    }

    public static func saveIfNeeded(user: User, realm: Realm = try! Realm()) {
        let user: Self = Self(user: user)
        if let _user = realm.objects(Self.self).filter("id == %@", user.id).first {
            if _user.updatedAt < user.updatedAt {
                try! realm.write {
                    realm.add(user, update: true)
                }
            }
        } else {
            try! realm.write {
                realm.add(user)
            }
        }
    }
}

// MARK: Message

public protocol MessageProtocol {

    associatedtype Transcript: TranscriptDocument

    var id: String { get set }
    var roomID: String { get set }
    var userID: String { get set }
    var createdAt: Date { get set }
    var updatedAt: Date { get set }
    var text: String? { get set }

    init(transcript: Transcript)

    static func primaryKey() -> String?
}

public extension MessageProtocol where Self: RealmSwift.Object {

    static func primaryKey() -> String? {
        return "id"
    }

    public init(transcript: Transcript) {
        self.init()
        self.id = transcript.id
        self.roomID = transcript.room.id!
        self.userID = transcript.user.id!
        self.createdAt = transcript.createdAt
        self.updatedAt = transcript.updatedAt
        self.text = transcript.text
    }

    public static func saveIfNeeded(transcripts: [Transcript], realm: Realm = try! Realm()) {
        var updateMessages: [Self] = []
        var insertMessages: [Self] = []
        transcripts.forEach { (transcript) in
            let message: Self = Self(transcript: transcript)
            if let _message = realm.objects(Self.self).filter("id == %@", transcript.id).first {
                if _message.updatedAt < message.updatedAt {
                    updateMessages.append(message)
                }
            } else {
                insertMessages.append(message)
            }
        }

        try! realm.write {
            if !updateMessages.isEmpty {
                realm.add(updateMessages, update: true)
            }
            if !insertMessages.isEmpty {
                realm.add(insertMessages)
            }
        }
    }

    public static func saveIfNeeded(transcript: Transcript, realm: Realm = try! Realm()) {
        let message: Self = Self(transcript: transcript)
        if let _message = realm.objects(Self.self).filter("id == %@", transcript.id).first {
            if _message.updatedAt < message.updatedAt {
                try! realm.write {
                    realm.add(message, update: true)
                }
            }
        } else {
            try! realm.write {
                realm.add(message)
            }
        }
    }
}
