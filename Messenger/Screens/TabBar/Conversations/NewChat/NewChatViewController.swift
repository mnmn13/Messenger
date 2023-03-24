//
//  NewChatViewController.swift
//  Messenger
//
//  Created by MN on 21.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {

    let searchController = UISearchController()
    private var searchBar: UISearchBar!
    private var noResultsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavSearch()
        view.backgroundColor = .black
    }
    
    private func setupNoResultsLabel() {
        noResultsLabel.isHidden = true
        noResultsLabel.text = "No Results"
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = .systemFont(ofSize: 21, weight: .medium)
    }
    
    private func setupNavSearch() {
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        searchController.searchBar.searchTextField.leftView?.tintColor = .systemGray
//        searchBar.becomeFirstResponder() to make keyboard visible when controller was presented 
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancellTapped))
    }
    
    @objc private func cancellTapped() {
        dismiss(animated: true)
    }
    
    
    
}

//MARK: - UISearchBarDelegate
extension NewChatViewController: UISearchBarDelegate {
    
}
