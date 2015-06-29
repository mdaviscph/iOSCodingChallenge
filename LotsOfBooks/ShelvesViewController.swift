//
//  ShelvesViewController.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class ShelvesViewController: UIViewController,UITableViewDataSource,
          MLDLibraryArchiveCaller{

  var library = Library()
  private var archiveVC: LibrariesViewController?
  var archiveDelegate: LibrariesViewController? {
    get { return self.archiveVC }
    set(archiveVC) { self.archiveVC = archiveVC }
  }
  
  @IBOutlet weak var shelvesTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowBooks" {
      if let booksInShelfVC = segue.destinationViewController as? BooksViewController,
          indexPath = shelvesTableView.indexPathForSelectedRow() {
        booksInShelfVC.shelf = library.shelves[indexPath.row]
        booksInShelfVC.archiveDelegate = archiveVC
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return library.shelves.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("ShelfCell", forIndexPath: indexPath) as? UITableViewCell {
      if let name = library.shelves[indexPath.row].name {
        cell.textLabel?.text = name
      } else {
        cell.textLabel?.text = "Shelf \(indexPath.row)"
      }
      return cell
    }
    return UITableViewCell()
  }
}
