//
//  LibrariesViewController.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class LibrariesViewController: UIViewController, UITableViewDataSource,
          MLDLibraryArchiveCallee {

  @IBOutlet weak var librariesTableView: UITableView!
  
  var libraries = [Library]()
  let archiveFileName = "LotsOfBooks.bplist"
  let inBundleFileName = "LotsOfBooks"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if !read(fromArchiveFile: archiveFileName) {
      read(fromPlist: inBundleFileName)
    }

    for library in libraries {
      //println("LIBRARY \(library.name)")
      library.shelveBooks()
      //library.listAllBooks()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowShelves" {
      if let shelvesInLibraryVC = segue.destinationViewController as? ShelvesViewController,
         indexPath = librariesTableView.indexPathForSelectedRow() {
        shelvesInLibraryVC.library = libraries[indexPath.row]
        shelvesInLibraryVC.archiveDelegate = self
      }
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return libraries.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("LibraryCell", forIndexPath: indexPath) as? UITableViewCell {
      cell.textLabel?.text = libraries[indexPath.row].name
      return cell
    } else {
      return UITableViewCell()
    }
  }
  
  func read(fromPlist inBundleFileName: String) -> Bool {
    // Plist is a dictionary of arrays of dictionaries
    if let path = NSBundle.mainBundle().pathForResource(inBundleFileName, ofType: "plist"),
        initData = NSDictionary(contentsOfFile: path) as? [String:[[String:String]]],
        libraryArray = initData["Libraries"] {
          
      for libraryData in libraryArray {
        if let name = libraryData["Name"],
            countStr = libraryData["ShelfCount"],
            count = countStr.toInt() {
          let library = Library(name: name, shelfCount: count)
          libraries.append(library)
        }
      }
      
      // add books to libraries randomly
      if let bookArray = initData["Books"] {
        for bookData in bookArray {
          if let title = bookData["Title"],
              author = bookData["Author"] {
            let libraryIndex = Int(arc4random_uniform(UInt32(libraries.count)))
            let book = Book(title: title, author: author)
            libraries[libraryIndex].addBook(book)
          }
        }
      }
      return true
    }
    else {
      return false
    }
  }
  // okay to read from multiple archive files
  func read(fromArchiveFile archiveFileName: String) -> Bool {
    var result = false
    var filePath = archiveFileName
    
    if let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
        .UserDomainMask, true).last as? String {
      filePath = documentsPath.stringByAppendingPathComponent(filePath)
      if let libraries = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Library] {
        //println("read from archive file: \(filePath)")
        println("read from archive file")
        for library in libraries {
          self.libraries.append(library)
        }
        result = true
      }
    }
    if !result {
      println("cannot read from archive file: \(filePath)")
    }
    return result
  }
  func save(toArchiveFile archiveFileName: String) -> Bool {
    var result = false
    var filePath = archiveFileName
    
    if let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
        .UserDomainMask, true).last as? String {
      filePath = documentsPath.stringByAppendingPathComponent(filePath)
      if NSKeyedArchiver.archiveRootObject(libraries, toFile: filePath) {
        //println("saved to archive file: \(filePath)")
        println("saved to archive file")
        result = true
      }
    }
    if !result {
      println("cannot save to archive file: \(filePath)")
    }
    return result
  }
  
  func archiveLibrary(viewController: MLDLibraryArchiveCaller, newOrChangedBook book: Book?) {
    save(toArchiveFile: archiveFileName)
  }
}

protocol MLDLibraryArchiveCallee {
  func archiveLibrary(viewController: MLDLibraryArchiveCaller, newOrChangedBook book: Book?)
}
protocol MLDLibraryArchiveCaller {
  var archiveDelegate: LibrariesViewController? { get set }
}

