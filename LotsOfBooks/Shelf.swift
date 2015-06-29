//
//  Shelf.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class Shelf: NSObject, NSCoding {
  var name: String?
  var books = [Book]()
  let ignoreTitlePrefixesInSort = ["A ", "An ", "The "]
  
  override init() {
  }
  required init(coder decoder: NSCoder) {
    self.name = decoder.decodeObjectForKey("Name") as? String
    self.books = decoder.decodeObjectForKey("Books") as? [Book] ?? [Book]()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    if let name = name {
      aCoder.encodeObject(name, forKey: "Name")
    }
    aCoder.encodeObject(books, forKey: "Books")
  }
  
  func sortAZ() {
    books.sort { (one:Book, two:Book) -> Bool in
      var title1 = one.title
      var title2 = two.title
      for prefix in self.ignoreTitlePrefixesInSort {
        if title1.hasPrefix(prefix) {
          title1 = title1.substring(prefix.length)
          break
        }
      }
      for prefix in self.ignoreTitlePrefixesInSort {
        if title2.hasPrefix(prefix) {
          title2 = title2.substring(prefix.length)
          break
        }
      }
      return title1 < title2
    }
  }
}
