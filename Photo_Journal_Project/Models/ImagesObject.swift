//
//  ImagesObject.swift
//  Photo_Journal_Project
//
//  Created by Tiffany Obi on 1/23/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct ImagesObject: Codable {
    
    let imageData: Data
    let date: Date
    let identifier = UUID().uuidString

}
