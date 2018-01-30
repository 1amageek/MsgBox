//
//  RoomViewController.swift
//  Msg
//
//  Created by 1amageek on 2018/01/23.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import UIKit
import Pring
import Instantiate
import InstantiateStandard
import RealmSwift

extension MsgBox {
    public class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        let userID: String

        let sessionController: MsgBox<Thread, Sender, Message>.RoomController

        public init(userID: String) {
            self.userID = userID
            self.sessionController = MsgBox.RoomController(userID: userID)
            super.init(nibName: nil, bundle: nil)
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private(set) lazy var tableView: UITableView = {
            let view: UITableView = UITableView(frame: self.view.bounds, style: .plain)
            view.delegate = self
            view.dataSource = self
            view.register(type: RoomViewCell.self)
            view.keyboardDismissMode = .interactive
            return view
        }()

        public override func loadView() {
            super.loadView()
            self.view.addSubview(tableView)
        }

        public override func viewDidLoad() {
            super.viewDidLoad()
            self.sessionController.listen()
            self.view.layoutIfNeeded()
        }

        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataSource.count
        }

        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return RoomViewCell.dequeue(from: tableView, for: indexPath)
        }

        // MARK: - Realm

        let realm = try! Realm()

        private(set) var notificationToken: NotificationToken?

        private(set) lazy var dataSource: Results<Thread> = {
            var results: Results<Thread> = self.realm.objects(Thread.self)
                .sorted(byKeyPath: "updatedAt")
            self.notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial: tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.performBatchUpdates({
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .bottom)
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    }, completion: { _ in

                    })
                case .error(let error): fatalError("\(error)")
                }
            }
            return results
        }()

        deinit {
            self.notificationToken?.invalidate()
        }
    }
}
