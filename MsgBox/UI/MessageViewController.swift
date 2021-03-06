//
//  MessageViewController.swift
//  Msg
//
//  Created by 1amageek on 2018/01/10.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import UIKit
import Pring
import Toolbar
import OnTheKeyboard
import RealmSwift
import AsyncDisplayKit

extension MsgBox {
    class MessageViewController: ASViewController<MsgView>, ASTableDelegate, ASTableDataSource, OnTheKeyboard, UITextViewDelegate {

        let roomID: String

        let userID: String

        let sessionController: MsgBox<Thread, Sender, Message>.TranscriptController

        init(roomID: String, userID: String) {
            self.roomID = roomID
            self.userID = userID
            self.sessionController = MsgBox.TranscriptController(roomID: roomID)
            super.init(node: msgView)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        var keyboardObservers: [Any] = []

        var toolBar: Toolbar = Toolbar()

        var toolbarBottomConstraint: NSLayoutConstraint?

        lazy var msgView: MsgView = {
            let view: MsgView = MsgView()
            view.tableNode.delegate = self
            view.tableNode.dataSource = self
            view.tableNode.inverted = true
            view.tableView.keyboardDismissMode = .interactive
            view.tableView.separatorStyle = .none
            return view
        }()

        var tableNode: ASTableNode {
            return self.msgView.tableNode
        }

        var tableView: UITableView {
            return self.msgView.tableNode.view
        }

        override func loadView() {
            super.loadView()
            showToolBar(view)
            toolBar.setItems([ToolbarItem(customView: self.textView), self.sendBarItem], animated: false)
            toolBar.layoutIfNeeded()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.sessionController.listen()

        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            addKeyboardObservers()
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            removeKeyboardObservers()
        }

        override func viewSafeAreaInsetsDidChange() {
            super.viewSafeAreaInsetsDidChange()
            let invertedTop: CGFloat = toolBar.bounds.height - self.view.safeAreaInsets.top
            let invertedBottom: CGFloat = self.view.safeAreaInsets.top
            let contentInset: UIEdgeInsets = UIEdgeInsets(top: invertedTop, left: 0, bottom: invertedBottom, right: 0)
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
        }

        func keyboardWillLayout(_ frame: CGRect, isHidden: Bool) {
            _layoutTableView(frame, isHidden: isHidden)
            if !isHidden {
                let contentOffset: CGPoint = CGPoint(x: 0, y: -(self.toolBar.bounds.height + frame.height))
                tableView.setContentOffset(contentOffset, animated: true)
            }
        }

        private func _layoutTableView(_ frame: CGRect = .zero, isHidden: Bool) {
            let keyboardHeight: CGFloat = isHidden ? 0 : frame.height
            let toolbarHeight: CGFloat = isHidden ? self.toolBar.bounds.height : (self.toolBar.bounds.height - self.toolBar.safeAreaInsets.bottom)
            let invertedTop: CGFloat = toolbarHeight - self.view.safeAreaInsets.top + keyboardHeight
            let invertedBottom: CGFloat = self.view.safeAreaInsets.top
            let contentInset: UIEdgeInsets = UIEdgeInsets(top: invertedTop, left: 0, bottom: invertedBottom, right: 0)
            self.tableView.contentInset = contentInset
            self.tableView.scrollIndicatorInsets = contentInset
        }

        private func _scrollsToBottom() {
            let visibleHeight: CGFloat = self.tableView.bounds.height - self.tableView.safeAreaInsets.top - self.tableView.contentInset.bottom - self.tableView.safeAreaInsets.bottom
            if self.tableView.contentSize.height > visibleHeight {
                let offsetY: CGFloat = max(self.tableView.contentSize.height - self.tableView.safeAreaInsets.top - visibleHeight, 0)
                self.tableView.contentOffset = CGPoint(x: 0, y: offsetY)
            }
        }

        // MARK: -

        var constraint: NSLayoutConstraint?

        private(set) lazy var sendBarItem: ToolbarItem = {
            let item: ToolbarItem = ToolbarItem(title: "Send", target: self, action: #selector(_send))
            return item
        }()

        private(set) lazy var textView: UITextView = {
            let textView: UITextView = UITextView(frame: .zero)
            textView.delegate = self
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.clipsToBounds = true
            textView.layer.cornerRadius = 16
            textView.layer.borderWidth = 0.5
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            return textView
        }()

        @objc private func _send() {
            let text: String = self.textView.text
            guard !text.isEmpty else {
                return
            }

            self.sendBarItem.isEnabled = true
            self.textView.text = ""
            self.send(text: text) { _ in

            }
            if let constraint: NSLayoutConstraint = self.constraint {
                textView.removeConstraint(constraint)
            }
            self.toolBar.setNeedsLayout()
        }

        public func send(text: String, block: ((Error?) -> Void)? = nil) {
            var transcript: Transcript = Transcript()
            let room: Room = Room(id: self.roomID)
            transcript.text = text
            transcript.room.set(room)
            transcript.user.set(User(id: self.userID))
            room.transcripts.insert(transcript)
            room.update(block)
        }

        public func send(image: Data, mimeType: File.MIMEType, block: ((Error?) -> Void)? = nil) {
            var transcript: Transcript = Transcript()
            let room: Room = Room(id: self.roomID)
            transcript.image = File(data: image, mimeType: mimeType)
            transcript.room.set(room)
            transcript.user.set(User(id: self.userID))
            room.transcripts.insert(transcript)
            room.update(block)
        }

        func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
            return self.dataSource.count
        }

        func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
            let message: Message = self.dataSource[indexPath.item]
            let ref = ThreadSafeReference(to: message)
            return {
                let realm = try! Realm()
                guard let message = realm.resolve(ref) else {
                    fatalError()
                }
                let dependency: TextCellNode.Dependency = TextCellNode.Dependency(message: message)
                if indexPath.row % 2 == 0 {
                    return TextLeftCellNode(dependency)
                }
                return TextRightCellNode(dependency)
            }
        }

        // MARK: - Realm

        let realm = try! Realm()

        private(set) var notificationToken: NotificationToken?

        private(set) lazy var dataSource: Results<Message> = {
            var results: Results<Message> = self.realm.objects(Message.self)
                .filter("roomID == %@", self.roomID)
                .sorted(byKeyPath: "updatedAt", ascending: false)
            self.notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableNode = self?.tableNode else { return }
                switch changes {
                case .initial:
                    tableNode.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableNode.performBatchUpdates({
                        tableNode.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        tableNode.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                        tableNode.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    }) { finished in

                    }
                case .error(let error): fatalError("\(error)")
                }
            }
            return results
        }()

        deinit {
            self.notificationToken?.invalidate()
        }

        // MARK:

        func textViewDidChange(_ textView: UITextView) {
            let size: CGSize = textView.sizeThatFits(textView.bounds.size)
            if let constraint: NSLayoutConstraint = self.constraint {
                textView.removeConstraint(constraint)
            }
            self.constraint = textView.heightAnchor.constraint(equalToConstant: size.height)
            self.constraint?.priority = .defaultHigh
            self.constraint?.isActive = true
        }
    }
}
