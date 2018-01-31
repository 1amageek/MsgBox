//
//  RoomViewCell.swift
//  MsgBox
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
    class RoomViewCell: UITableViewCell, Reusable {
        @IBOutlet weak var thumbnailImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var messageLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!

        struct Dependency {
            var thread: Thread
        }

        func inject(_ dependency: MsgBox<Thread, Sender, Message>.RoomViewCell.Dependency) {
            self.textLabel?.text = dependency.thread.name
        }
    }
}
