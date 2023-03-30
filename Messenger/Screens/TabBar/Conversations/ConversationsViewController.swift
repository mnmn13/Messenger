//
//  PageWithChatsViewController.swift
//  Messenger
//
//  Created by MN on 13.12.2022.
//  Copyright © 2022 Nikita Moshyn. All rights reserved.
//
// Storyborard id = pageWithChats
//

import UIKit

class ConversationsViewController: UIViewController {
    
    var viewModel: ConversationsViewModelType!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let noChatsLabel = UILabel()
    let refrechControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Chats"
        setupTV()
        bind()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.hidesBackButton = false
    }
    // ????????
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                print("RELOADED")
            }
        }
    }
    
    private func setupRefreshControl() {
//        refrechControl.attributedTitle = NSAttributedString(string: "Loading")
        refrechControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        tableView.addSubview(refrechControl)
    }
    
    @objc private func refresh() {
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refrechControl.endRefreshing()
        }
    }
    
    private func setupTV() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        tableView.register(UINib(nibName: ConversationCell.identifier, bundle: .main), forCellReuseIdentifier: ConversationCell.identifier)
    }

}
//MARK: - UISearchBarDelegate
extension ConversationsViewController: UISearchBarDelegate {
    
}
//MARK: - UITableViewDelegate
extension ConversationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
}

//MARK: - UITableViewDataSource
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.cellForRowAt(with: indexPath)
        let conversationModel = model.0
        let userModel = model.1
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as? ConversationCell else { return .init()}
        let viewModel = ConversationCellViewModel(conversationModel: conversationModel, companion: userModel)
        cell.viewModel = viewModel
        cell.configure(with: viewModel)
        
        return cell
    }
}
