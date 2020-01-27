//
//  AddPhotoJournalEntryViewController.swift
//  Photo_Journal_Project
//
//  Created by Tiffany Obi on 1/24/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation

class AddPhotoJournalEntryViewController: UITableViewController {
    
    @IBOutlet weak var saveToAlbumButton: UIButton!
    
    @IBOutlet weak var commentsTextFeild: UITextField!
    
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var selectedImage: UIImage?  {
        
    didSet {
            
    displaySelectedImage()
            
        }
    }
    
    var commentText = ""
    
    private var imagePickerController = UIImagePickerController()
    
    private var dataPersistence = PersistenceHelper(filename: "image.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       imagePickerController.delegate = self
    }

    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {[weak self]
            alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        
        } else {
        alertController.addAction(cancelAction)
        }
        present(alertController,animated: true)

    }
    
    
    private func showImageController(isCameraSelected:Bool) {
               //source type default will be .photoLibrary
               
               imagePickerController.sourceType = .photoLibrary
               
               if isCameraSelected {
                   imagePickerController.sourceType = .camera
           }
           present(imagePickerController, animated: true)
           }
    
    private func displaySelectedImage() {

        
       imageView.image = selectedImage
        dismiss(animated: true)
    
        //persist image object to documents directory
        
    }
    
}
extension AddPhotoJournalEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                    we need to access the UIImagePickerController.InfoKey.origainalImage key to get the UIImage that was selected.
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {

                print("Image selection not found")
                return
            }
            
            selectedImage = image
            dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
        }
    }

extension AddPhotoJournalEntryViewController:UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        commentText = textField.text ?? "Not Comment"
    }
}
