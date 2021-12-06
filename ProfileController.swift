//
//  ProfileController.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 27/10/21.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseUI
import RealmSwift


class ProfileController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var profilePageLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var pullImage: UIButton!
    
    @IBOutlet weak var choosePictureBtn: UIButton!
    
    var imagePickerController: UIImagePickerController!
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        getImage()
        
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        choosePictureBtn.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
    }
    
    
    //MARK: - Selectors
    
    
    @objc func openImagePicker(){
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pullImageTapped(_ sender: UIButton) {
        self.profileImage.image = Constants.Image.profileDefaultImage
        UserDefaults.standard.set("", forKey: "url")
    }
    
    @IBAction func choosePictureBtn(_ sender: UIButton) {
    }
    
    //MARK: - Helper functions
    
    func configureUI(){

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Profile"
        view.backgroundColor = .systemGray5
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    func getImage(){
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String else { return }
        print(urlString)
        NetworkManager.shared.downloadImage(fromURL: urlString) { image in
            guard let image = image else {
                self.profileImage.image = Constants.Image.profileDefaultImage
                return
            }
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
            
        }
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profileImage.image = image
        ImageUploader.uploadImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
}
