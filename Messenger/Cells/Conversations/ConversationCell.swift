//
//  ConversationCell.swift
//  Messenger
//
//  Created by MN on 21.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var viewModel: ConversationCellViewModel!
    
    static let identifier = "ConversationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: ConversationCellViewModel) {
        self.viewModel = viewModel
        getNameLabel()
        getMessageLabel()
        getTimeLabel()
        getNotificationLabel()
    }
    
    private func getNameLabel() {
        nameLabel?.text = viewModel.name
    }
    
    private func getMessageLabel() {
        messageLabel?.text = viewModel.message
    }
    
    private func getTimeLabel() {
        timeLabel.text = viewModel.lastActionTime
    }
    
    private func getNotificationLabel() {
        if viewModel.unreadedMessages == 0 {
            notificationLabel.isHidden = true
        } else {
            notificationLabel.isHidden = false
            notificationLabel?.text = "\(viewModel.unreadedMessages)"
            notificationLabel.layer.masksToBounds = true
            notificationLabel.layer.cornerRadius = 10
        }
    }
}

