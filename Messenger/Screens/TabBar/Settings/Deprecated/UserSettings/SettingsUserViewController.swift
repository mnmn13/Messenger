//
//  SettingsUserViewController.swift
//  Messenger
//
//  Created by MN on 25.01.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsUserViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var userImage: UIImageView!
    
    let someData = ["Log Out"]
    
    private var profileImage: UIImage!
    var image = UIImage(systemName: "person.circle")
    
//    var userImage = SettingsUserView().userImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTV()
        setupNav()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backTapped))
//        tableView.register(SettingsUserView.self, forHeaderFooterViewReuseIdentifier: "settingsView")
        
    }
    
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    private func setupTV() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    /*
    private func setupView() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        
        emailLabel.text = email
        guard let firstName = UserDefaults.standard.value(forKey: "firstName") as? String else { return }
        guard let secondName = UserDefaults.standard.value(forKey: "lastName") as? String else { return }
        nameLabel.text = "\(firstName) \(secondName)"
        
    }
    */
    
    private func setupNav() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    private func setupTVHeader() -> UIView {
        
        let view = SettingsUserView()

        view.userImage.image = image
        view.userImage.tintColor = .gray
        view.userImage.contentMode = .scaleAspectFit
        view.userImage.layer.masksToBounds = true
        view.userImage.layer.borderWidth = 2
        view.userImage.layer.borderColor = UIColor.lightGray.cgColor
        view.userImage.isUserInteractionEnabled = true
        
        view.gesture = UITapGestureRecognizer(target: self, action: #selector(showFullPhoto))
        view.userImage.addGestureRecognizer(view.gesture)
        view.changePhotoButton.setTitle("Test", for: .normal)
        view.changePhotoButton.addTarget(self, action: #selector(presentPhotoActionSheet), for: .touchUpInside)

        return view
    }
    
    @objc func showFullPhoto() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.tintColor = .gray
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @objc private func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    private func logout() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            
            UIApplication.shared.keyWindow?.rootViewController = vc
        } catch {
            print(error)
        }
    }
    
    
}

extension SettingsUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        logout()
    }
    
}

extension SettingsUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = someData[indexPath.item]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
//MARK: TableViewHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = setupTVHeader()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
}
//MARK: - UIImagePicker
extension SettingsUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        image = selectedImage
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

