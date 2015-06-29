//
//  Book.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class Book: NSObject, NSCoding {
  var title: String
  var author: String
  var library: Library?
  
  init(title: String, author: String) {
    self.title = title
    self.author = author
  }
  convenience override init() {
    self.init(title: "new book title", author: "new book author")
  }
  required init(coder decoder: NSCoder) {
    self.title = decoder.decodeObjectForKey("Title") as? String ?? "no title"
    self.author = decoder.decodeObjectForKey("Author") as? String ?? "no author"
    self.library = decoder.decodeObjectForKey("Library") as? Library
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: "Title")
    aCoder.encodeObject(author, forKey: "Author")
    if let library = library {
      aCoder.encodeObject(library, forKey: "Library") // hopefully detects duplicate and records reference and not a copy, otherwise we have infinite loop
    }
  }
  
  // add to shelf at index
  func enshelf(shelfIndex: Int) -> Shelf? {
    var theShelf: Shelf?
    if let library = self.library {
      if shelfIndex >= 0 && shelfIndex < library.shelves.count {
        theShelf = library.shelves[shelfIndex]
      }
    }
    if let shelf = theShelf {
      shelf.books.append(self)
    }
    return theShelf
  }
  // add to shelf with fewest books
  func enshelf() -> Shelf? {
    var mostEmptyShelf: Shelf?
    if let library = self.library {
      for shelf in library.shelves {
        if let count = mostEmptyShelf?.books.count {
          if shelf.books.count < count {
            mostEmptyShelf = shelf
          }
        } else {
          // start with first shelf
          mostEmptyShelf = shelf
        }
      }
    }
    if let shelf = mostEmptyShelf {
      shelf.books.append(self)
    }
    return mostEmptyShelf
  }
  
  func unshelf() -> Shelf? {
    var foundShelf: Shelf?
    if let library = self.library {
      for shelf in library.shelves {
        for (index, book) in enumerate(shelf.books) {
          if title == book.title {
            foundShelf = shelf
            shelf.books.removeAtIndex(index)
          }
        }
      }
    }
    return foundShelf
  }
}
