//
//  Library.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class Library: NSObject, NSCoding {
  var name: String
  var shelves = [Shelf]()
  var unshelvedBooks = [Book]()
  
  init(name: String, shelfCount: Int) {
    self.name = name
    //shelves = [Shelf](count: shelfCount, repeatedValue: Shelf()) - bug: each element shares empty shelf instance
    for _ in 0..<shelfCount {
      shelves.append(Shelf())
    }
  }
  convenience override init() {
    self.init(name: "new library", shelfCount: 0)
  }
  required init(coder decoder: NSCoder) {
    self.name = decoder.decodeObjectForKey("Name") as? String ?? "no name"
    self.shelves = decoder.decodeObjectForKey("Shelves") as? [Shelf] ?? [Shelf]()
    self.unshelvedBooks = decoder.decodeObjectForKey("UnshelvedBooks") as? [Book] ?? [Book]()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "Name")
    aCoder.encodeObject(shelves, forKey: "Shelves")
    aCoder.encodeObject(unshelvedBooks, forKey: "UnshelvedBooks")
  }
  
  func addBook(book: Book) {
    if let library = book.library {
      library.removeBook(book)
    }
    book.library = self
    unshelvedBooks.append(book)
  }
  func removeBook(book: Book) -> Bool {
    if let shelf = book.unshelf() {
      book.library = nil
      return true
    }
    else {
      return false
    }
  }
  func findBook(title: String) -> Book? {
    for book in unshelvedBooks {
      if title == book.title {
        println("Book: [\(book.title)] found, unshelved")
        return book
      }
    }
    for (index, shelf) in enumerate(shelves) {
      for book in shelf.books {
        if title == book.title {
          println("Book: [\(book.title)] found, shelf: \(index)")
          return book
        }
      }
    }
    println("Book: [\(title)] not found")
    return nil
  }
  
  func shelveBooks() {
    var tempUnshelvedBooks = [Book]()
    for book in unshelvedBooks {
      if let shelf = book.enshelf() {
        //println("Shelving book: \"\(book.fullTitle)\"")
      }
      else {
        tempUnshelvedBooks.append(book)
      }
    }
    unshelvedBooks = tempUnshelvedBooks
  }
  func listAllBooks() {
    for book in unshelvedBooks {
      println("Book: [\(book.title)] unshelved")
    }
    for (index, shelf) in enumerate(shelves) {
      //println("shelf: \(index) has \(shelf.books.count) books")
      for book in shelf.books {
        println("Book: [\(book.title)] shelf: \(index)")
      }
    }
  }
}
