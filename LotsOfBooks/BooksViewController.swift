//
//  BooksViewController.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDataSource,
          MLDLibraryArchiveCaller {

  var shelf = Shelf()
  private var archiveVC: LibrariesViewController?
  var archiveDelegate: LibrariesViewController? {
    get { return self.archiveVC }
    set(archiveVC) { self.archiveVC = archiveVC }
  }
  
  @IBOutlet weak var booksTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    booksTableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shelf.books.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as? UITableViewCell {
      cell.textLabel?.text = shelf.books[indexPath.row].title
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let book = shelf.books.removeAtIndex(indexPath.row)
      println("deleting book: [\(book.title)] at index: \(indexPath.row)")
      booksTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      archiveDelegate?.archiveLibrary(self, newOrChangedBook: nil)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowBookDetail" {
      if let detailVC = segue.destinationViewController as? BookDetailViewController,
          indexPath = booksTableView.indexPathForSelectedRow() {
        detailVC.book = shelf.books[indexPath.row]
        detailVC.archiveDelegate = archiveVC
      }
    } else if segue.identifier == "ShowNewBookDetail" {
      if let detailVC = segue.destinationViewController as? BookDetailViewController {
        var book = Book()
        shelf.books.append(book)
        detailVC.book = book
        detailVC.archiveDelegate = archiveVC
      }
    }
  }
}
