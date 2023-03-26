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
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    var viewModel: ConversationsViewModelType!
    
    let searchController = UISearchController()
    private var searchBar: UISearchBar!
    private var tableView = UITableView()
    private let noChatsLabel = UILabel()
    private let loading = JGProgressHUD(style: .dark) // Loading circle
    let refrechControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        guard let name = UserDefaults.standard.value(forKey: "firstName") as? String else { return }
        title = "Chats"
        bind()
//        viewModel.loadInfo()
//        setupNavSearch()
        setupTV()
        setupNoChatsLabel()
        fetchChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.hidesBackButton = false
//        navigationController?.navigationBar.prefersLargeTitles = false
    }
    // ????????
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupRefreshControl() {
        refrechControl.attributedTitle = NSAttributedString(string: "Loading")
        refrechControl.addTarget(self, action: #selector(refresh), for: .allEvents)
        tableView.addSubview(refrechControl)
    }
    
    @objc private func refresh() {
        viewModel.refreshData()
    }
    
    private func setupNavSearch() {
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(logOut))
        let newChatButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newChat))
        self.navigationItem.rightBarButtonItems = [newChatButton, editButton]
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(newChat))
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemGray
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func logOut() {
        viewModel.logOut()
    }
    
    @objc private func newChat() {
//        let storyboard = UIStoryboard(name: "NewChat", bundle: .main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "newChat")
//        let navController = UINavigationController(rootViewController: vc)
//        present(navController, animated: true)
    }
    
    private func setupTV() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: ConversationCell.identifier, bundle: .main), forCellReuseIdentifier: ConversationCell.identifier)
    }
    // If the user does not have any active chat
    private func setupNoChatsLabel() {
        view.addSubview(noChatsLabel)
        noChatsLabel.isHidden = true
        noChatsLabel.text = "You haven't started any chat yet!"
        noChatsLabel.textAlignment = .center
        noChatsLabel.textColor = .systemGray
        noChatsLabel.font = .systemFont(ofSize: 21, weight: .medium)
    }
    
    private func fetchChats() {
        tableView.isHidden = false
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
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as? ConversationCell else { return .init()}
        let viewModel = ConversationCellViewModel(conversationModel: conversationModel, companion: userModel)
        cell.viewModel = viewModel
        cell.configure(with: viewModel)
        
//        cell.textLabel?.text = viewModel.verifyData(chat: model)
//        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}
