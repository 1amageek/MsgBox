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
    public class RoomViewCell: UITableViewCell, Reusable {

        public lazy var thumbnailImageView: UIImageView = {
            let view: UIImageView = UIImageView(frame: .zero)
            view.clipsToBounds = true
            view.contentMode = .scaleAspectFill
            view.layer.cornerRadius = self.thumbnailImageViewRadius
            view.backgroundColor = UIColor.lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        public lazy var nameLabel: UILabel = {
            let label: UILabel = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 14)
            return label
        }()

        public lazy var messageLabel: UILabel = {
            let label: UILabel = UILabel(frame: .zero)
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        public lazy var dateLabel: UILabel = {
            let label: UILabel = UILabel(frame: .zero)
            label.numberOfLines = 0
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        public struct Dependency {
            var thread: Thread
        }

        let thumbnailImageViewRadius: CGFloat = 32

        public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(thumbnailImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(dateLabel)
            contentView.addSubview(messageLabel)

            self.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true


            thumbnailImageView.widthAnchor.constraint(equalToConstant: (thumbnailImageViewRadius * 2)).isActive = true
            thumbnailImageView.heightAnchor.constraint(equalToConstant: (thumbnailImageViewRadius * 2)).isActive = true
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true

            nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true

            dateLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let dateFormatter: DateFormatter = {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

        public func inject(_ dependency: MsgBox<Thread, Sender, Message>.RoomViewCell.Dependency) {
            self.nameLabel.text = dependency.thread.name
            if let message: Message = dependency.thread.lastMessage {
                self.messageLabel.text = message.text
                self.dateLabel.text = dateFormatter.string(from: message.updatedAt)
            }
        }

        public override func setHighlighted(_ highlighted: Bool, animated: Bool) {

        }

        public override func setSelected(_ selected: Bool, animated: Bool) {

        }
    }
}
