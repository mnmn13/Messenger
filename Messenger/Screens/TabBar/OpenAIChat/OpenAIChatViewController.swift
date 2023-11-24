//
//  OpenAIChatViewController.swift
//  Messenger
//
//  Created by MN on 02.04.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class OpenAIChatViewController: MessagesViewController {
    
    var viewModel: OpenAIChatViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat GPT 3"
        bindForReloadAndScroll()
        setupMessageDelegate()
    }
    
    func bindForReloadAndScroll() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    func setupMessageDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.delegate = self
    }
}

extension OpenAIChatViewController: MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        viewModel.getSelfSender()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        viewModel.messageForItem(indexPath: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    
}

extension OpenAIChatViewController: MessagesLayoutDelegate {}

extension OpenAIChatViewController: MessagesDisplayDelegate {}

extension OpenAIChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.didPressSendButton(text: text)
        inputBar.inputTextView.text.removeAll()
    }
}
