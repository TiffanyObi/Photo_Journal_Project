//
//  PersistenceHelper.swift
//  Photo_Journal_Project
//
//  Created by Tiffany Obi on 1/23/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error { // conforming to the Error protocol
  case savingError(Error) // associative value
  case fileDoesNotExist(String)
  case noData
  case decodingError(Error)
  case deletingError(Error)
}

class PersistenceHelper {
  
  // CRUD - create, read, update, delete
  
  // array of events
  private var images = [ImagesObject]()
  
  private var filename: String
  
  init(filename: String) {
    self.filename = filename
  }
  
  private func save() throws {
    // step 1.
     // get url path to the file that the Event will be saved to
     let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    // events array will be object being converted to Data
    // we will use the Data object and write (save) it to documents directory
    do {
      // step 3.
      // convert (serialize) the events array to Data
      let data = try PropertyListEncoder().encode(images)
      
      // step 4.
      // writes, saves, persist the data to the documents directory
      try data.write(to: url, options: .atomic)
    } catch {
      // step 5.
      throw DataPersistenceError.savingError(error)
    }
  }
  
  // for re-ordering
  public func reorderEvents(item: [ImagesObject]) {
    self.images = item
    try? save()
  }
  
  // DRY - don't repeat yourself
  
  // create - save item to documents directory
  public func create(item: ImagesObject) throws {
    // step 2.
    // append new event to the events array
   images.append(item)
    
    do {
      try save()
    } catch {
      throw DataPersistenceError.savingError(error)
    }
  }

  // read - load (retrieve) items from documents directory
  public func loadEvents() throws -> [ImagesObject] {
    // we need access to the filename URL that we are reading from
    let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    // check if file exist
    // to convert URL to String we use .path on the URL
    if FileManager.default.fileExists(atPath: url.path) {
      if let data = FileManager.default.contents(atPath: url.path) {
        do {
          images = try PropertyListDecoder().decode([ImagesObject].self, from: data)
        } catch {
          throw DataPersistenceError.decodingError(error)
        }
      } else {
        throw DataPersistenceError.noData
      }
    }
    else {
      throw DataPersistenceError.fileDoesNotExist(filename)
    }
    return images
  }
  
  // delete - remove item from documents directory
  public func delete(event index: Int) throws {
    // remove the item from the events array
    images.remove(at: index)
    
    // save our events array to the documents directory
    do {
      try save()
    } catch {
      throw DataPersistenceError.deletingError(error)
    }
  }
}
