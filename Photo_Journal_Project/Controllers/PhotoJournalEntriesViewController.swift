//
//  ViewController.swift
//  Photo_Journal_Project
//
//  Created by Tiffany Obi on 1/23/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoJournalEntriesViewController: UIViewController {

    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
private var imagePickerController = UIImagePickerController()
    
private var imageObjects = [ImageObject]()
    
private var dataPersistence = PersistenceHelper(filename: "image.plist")
    
    var imageFromJounal: UIImage? {
        didSet{
            appendNewPhotoToCollection()
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            photoCollectionView.dataSource = self
            photoCollectionView.delegate = self
            
            //set UIImagePickerController delegate as this view controller
            
            loadImageObjects()
        }
    override func viewWillAppear(_ animated: Bool) {
        loadImageObjects()
    }
        
        private func loadImageObjects() {
            do {
                imageObjects = try dataPersistence.loadEvents()
            } catch {
                print("loading error: \(error)")
            }
        }
        @IBAction func cancelButtonPressed(segue: UIStoryboardSegue) {
               // get a reference to the CreateEventController instance
            guard segue.source is AddPhotoJournalEntryViewController else {
          return
           }
           
                }
    
    @IBAction func saveButtonPressed(segue: UIStoryboardSegue) {
          

        loadImageObjects()
        
        
    
      }
      
private func appendNewPhotoToCollection() {
            guard let image = imageFromJounal else {
                return
            }
            
            print("original image size is : \(image.size)")
        
            //the size for the resizing of the image
            
            let size = UIScreen.main.bounds.size
            
            // we will maintain the aspect:ratio of the image
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
            
            
            // resize image
            let resizedImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
            
            guard let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
                    print("image is nil")
                return
            }
            print("resizedImage image size is : \(resizedImage.size)")
            // here we need to create an image object
            let imageObject = ImageObject(imageData: imageData, date: Date())
            
        imageObjects.insert(imageObject, at: 0)
            
          imageFromJounal = image
            dismiss(animated: true)
        
            //persist image object to documents directory
            do {
                try dataPersistence.create(item: imageObject)
            } catch {
                print(" saving error: \(error) ")
            }
        }

}
    // MARK: - UICollectionViewDataSource
    extension PhotoJournalEntriesViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print(imageObjects.count)
            return imageObjects.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //STEP 4: creating custon delegate - set delegate object must have an instance of what u want to set the delegate on.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? ImageCell else {
                fatalError("could not downcast to an ImageCell")
            }
            
            let imageObject = imageObjects[indexPath.row]
            
            cell.configureCell(for: imageObject)
            //STEP 5: creating custon delegate - set delegate object
            //similar to tableView.delegate = self.
            cell.delegate = self
            return cell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    extension PhotoJournalEntriesViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let maxWidth: CGFloat = UIScreen.main.bounds.size.width
            let itemWidth: CGFloat = maxWidth * 0.80
            return CGSize(width: itemWidth, height: itemWidth)  }
    }

  
    

    //STEP 6 : comform to delegate

    extension PhotoJournalEntriesViewController: ImageCellDelegate {
        func didLongPress(_ imageCell: ImageCell) {
            
            guard let indexPath = photoCollectionView.indexPath(for: imageCell) else {
                return
            }
            
    //        present an action sheet
            
            
    //        actions: delete , cancel
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
                self?.deleteImageObject(indexPath: indexPath)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
         present(alertController,animated: true)
        }
        
        private func deleteImageObject(indexPath: IndexPath){
            //delete image object from documents directory
            
            do {
                //delete image object from documents directory
                try dataPersistence.delete(event: indexPath.row)
                
                //delete image from ImageObjects.
                imageObjects.remove(at: indexPath.row)
                
                //delete cell from collection view
//                photoCollectionView.deleteItems(at: [indexPath])
            } catch {
                print("error removing image \(error)")
            }
            
        }
        
    }
    
    // MARK: - UIImage extension
    extension UIImage {
        func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
            let size = CGSize(width: width, height: height)
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
        }


}

