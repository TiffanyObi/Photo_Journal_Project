//
//  PhotoJournalCollectionViewCell.swift
//  Photo_Journal_Project
//
//  Created by Tiffany Obi on 1/23/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol ImageCellDelegate: AnyObject { //Any Object requires ImageCellDelegate only works with class types
    
    // list required functions, initializers, variables
    func didLongPress(_ imageCell: ImageCell)
    
    
}


class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //STEP 2:create custom delegate - define optional delegate variable
    weak var delegate: ImageCellDelegate?
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .purple
        
        // function gets called when longpress is activated
        addGestureRecognizer(longPressGesture)
    }
    
    func configureCell(for imageObject: ImagesObject) {
        
        //converting Data to UIImage
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        
        imageView.image = image
    }
    
    // function gets called when longPress is activated.
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        
        print("long press activated")
        
        //STEP 3: creating custom delegation - explicitly use
        // delegate object to notify of any updates
        // notifying the ImageViewController when the user long presses the cell
        
        delegate?.didLongPress(self)
        
        //cell.delegate = self
        // imageViewController -> didLongPress(:)
    }
}

