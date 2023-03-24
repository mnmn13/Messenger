//
//  ChatViewController.swift
//  Messenger
//
//  Created by MN on 05.12.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatTableViewController: MessagesViewController {
    
    var viewModel: ChatViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindForReload()
        setupMessageDelegate()
        view.backgroundColor = .white
        title = viewModel.getTitle()
//        scrollsToLastItemOnKeyboardBeginsEditing = true
        showMessageTimestampOnSwipeLeft = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.becomeFirstResponder()
        navigationController?.navigationBar.backgroundColor = .white
        typingIndicatorViewTopInset(in: messagesCollectionView)
        
    }
    
    func bindForReload() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
    }
    
    // Delegate
    
    func setupMessageDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
}
//MARK: - MessagesDataSource
extension ChatTableViewController: MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        return viewModel.currentSender()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return viewModel.messageForItem(indexPath: indexPath)
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    
}
//MARK: - MessagesLayoutDelegate
extension ChatTableViewController: MessagesLayoutDelegate {
    
}
//MARK: - MessagesDisplayDelegate
extension ChatTableViewController: MessagesDisplayDelegate {
        func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            avatarView.initials = "MN"
//            avatarView.initials = viewModel.configureAvatarView(indexPath: indexPath)
        }
    
}

extension ChatTableViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.didPressSendButton(with: text)
        //        text.removeAll()
        inputBar.inputTextView.text.removeAll()

        
        
    }
    
    
    
}
