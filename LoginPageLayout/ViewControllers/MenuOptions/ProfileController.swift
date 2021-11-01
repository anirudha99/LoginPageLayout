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
    
    @IBOutlet weak var NameTextField: UITextField!

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var pullImage: UIButton!
    
    @IBOutlet weak var choosePictureBtn: UIButton!
    
    var imagePickerController: UIImagePickerController!
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureUI()
        imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        checkPermissions()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        profileImage.layer.cornerRadius = profileImage.bounds.height/2
        profileImage.clipsToBounds = true
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
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let ref = storageRef.child("UploadphotoOne")
//
//        print(ref)
//        profileImage.sd_setImage(with: ref )

    }
    
    @IBAction func choosePictureBtn(_ sender: UIButton) {
//        self.imagePickerController.sourceType = .photoLibrary
//        self.present(self.imagePickerController,animated: true)
    }
    
    func checkPermissions(){
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization(
                { (status: PHAuthorizationStatus)-> Void in
                    ()
                })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            
        } else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("You have access to photos")
        } else{
            print("You don't have access to photos")
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            print(url)
//            uploadToFirebase(fileURL: url)
//        }
//        imagePickerController.dismiss(animated: true, completion: nil)
//    }
//
    
    func uploadProfileImage(_ image : UIImage, completion : @escaping((_ url: URL?)->())){
        guard let uid = NetworkManager.shared.getUID() else{
            return
        }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else{
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                //success
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                //fail
                completion(nil)
            }
        }
    }
    
    
    
    
    
    func uploadToFirebase(fileURL: URL){
//        guard let uid = NetworkManager.shared.getUID() else{
//            return
//        }
        let storage = Storage.storage()
        
        let data = Data()
        
        let storageRef = storage.reference()
        
        let localFile = fileURL
        
        let photoRef = storageRef.child("UploadphotoOne")
        
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil) { (metadata, err) in
            guard let metadata =  metadata else{
                print(err?.localizedDescription)
                return
            }
            print("Photo  Upload")
        }
    }
    
    //MARK: - Helper functions
    
    func configureUI(){
//        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Profile"
//        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app.fill")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
       picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImage.image = pickedImage
        }
        
//        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//            print("-----------------------")
//            print(url)
//            uploadToFirebase(fileURL: url)
//        }
        picker.dismiss(animated: true, completion: nil)
    }
}
