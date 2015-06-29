//
//  BookDetailViewController.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/26/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, MLDLibraryArchiveCaller {

  var book: Book?
  var editChange = false
  private var archiveVC: LibrariesViewController?
  var archiveDelegate: LibrariesViewController? {
    get { return self.archiveVC }
    set(archiveVC) { self.archiveVC = archiveVC }
  }
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var authorTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleTextField.text = book?.title
    authorTextField.text = book?.author
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func titleDidEndOnExit(sender: AnyObject) {
    authorTextField.becomeFirstResponder()
  }
  @IBAction func authorDidEndOnExit(sender: AnyObject) {
  }
  
  @IBAction func titleEditingDidEnd(sender: AnyObject) {
    if editChange {
      book?.title = titleTextField.text
      if let delegate = archiveDelegate, book = book {
        delegate.archiveLibrary(self, newOrChangedBook: book)
      }
      editChange = false
    }
  }
  @IBAction func authorEditingDidEnd(sender: AnyObject) {
    if editChange {
      book?.author = authorTextField.text
      if let delegate = archiveDelegate, book = book {
        delegate.archiveLibrary(self, newOrChangedBook: book)
      }
      editChange = false
    }
  }
  
  @IBAction func titleEditingChanged(sender: AnyObject) {
    editChange = true
  }
  @IBAction func authorEditingChanged(sender: AnyObject) {
    editChange = true
  }
}
