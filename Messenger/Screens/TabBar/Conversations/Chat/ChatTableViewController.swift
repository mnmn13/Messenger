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
    
    let refrechController = UIRefreshControl()
    var viewModel: ChatViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindForReloadAndScroll()
        bindForReloadAndKeepOffset()
        bindForReload()
        setupMessageDelegate()
        view.backgroundColor = .white
        title = viewModel.getTitle()
        showMessageTimestampOnSwipeLeft = true
    }
    
    func bindForReloadAndScroll() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    func bindForReloadAndKeepOffset() {
        viewModel.onReload2 = { [weak self] in
            self?.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    func bindForReload() {
        viewModel.onReload3 = { [weak self] in
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
            }
        }
    }
    
    // Delegate
    func setupMessageDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refrechController
        messageInputBar.delegate = self
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refrechController.isRefreshing {
            viewModel.increaseLimit()
            refrechController.endRefreshing()
        }
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
extension ChatTableViewController: MessagesLayoutDelegate {}
//MARK: - MessagesDisplayDelegate
extension ChatTableViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.initials = viewModel.configureAvatarView(indexPath: indexPath)
    }
}

extension ChatTableViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        viewModel.didPressSendButton(with: text)
        inputBar.inputTextView.text.removeAll()
    }
}
