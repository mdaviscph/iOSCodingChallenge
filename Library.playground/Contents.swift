// mike davis

import Foundation

/*
Use Swift to create object models for a a public library (w/ three classes: Library, Shelf, & Book). *
The library should be aware of a number of shelves. Each shelf should know what books it contains. Make the book object have "enshelf" and "unshelf" methods that control what shelf the book is sitting on. The library should have a method to report all books it contains. Push this file to your GitHub.com account and paste in the URL to it here.
*/
/* 
Limitations:
  no shelf limit, shelf never full
  duplicate book not detected, this may be ok
  currently finds and sorts based on title only
*/

class Book {
  var title: String
  var author: String
  var library: Library?
  init(title: String, author: String) {
    self.title = title
    self.author = author
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

class Shelf {
  var books = [Book]()
  let ignoreTitlePrefixesInSort = ["A ", "An ", "The "]
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

class Library {
  var shelves = [Shelf]()
  var unshelvedBooks = [Book]()
  init(shelfCount: Int) {
    //shelves = [Shelf](count: shelfCount, repeatedValue: Shelf()) - bug: each element shares empty shelf instance
    for _ in 0..<shelfCount {
      shelves.append(Shelf())
    }
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
}
extension String {
  var length: Int { return count(self) }
  func substring(index: Int) -> String {
    return self.substringFromIndex(advance(self.startIndex, index))
  }
}

let myLib = Library(shelfCount: 4)

myLib.addBook(Book(title:"Brave New World",author:"Aldous Huxley"))
myLib.addBook(Book(title:"The Count of Monte Cristo",author:"Alexandre Dumas"))
myLib.addBook(Book(title:"The Three Musketeers",author:"Alexandre Dumas"))
myLib.addBook(Book(title:"The Color Purple",author:"Alice Walker"))
myLib.addBook(Book(title:"Black Beauty",author:"Anna Sewell"))
myLib.addBook(Book(title:"The Tenant of Wildfell Hall",author:"Anne BrontÎ"))
myLib.addBook(Book(title:"A Clockwork Orange",author:"Anthony Burgess"))
myLib.addBook(Book(title:"Barchester Towers",author:"Anthony Trollope"))
myLib.addBook(Book(title:"The Adventures of Sherlock Holmes",author:"Arthur Conan Doyle"))
myLib.addBook(Book(title:"The Casebook of Sherlock Holmes",author:"Arthur Conan Doyle"))
myLib.addBook(Book(title:"The Adventures of Pinocchio",author:"Carlo Collodi"))
myLib.addBook(Book(title:"A Tale of Two Cities",author:"Charles Dickens"))
myLib.addBook(Book(title:"David Copperfield",author:"Charles Dickens"))
myLib.addBook(Book(title:"Great Expectations",author:"Charles Dickens"))
myLib.addBook(Book(title:"Oliver Twist",author:"Charles Dickens"))
myLib.addBook(Book(title:"The Old Curiosity Shop",author:"Charles Dickens"))
myLib.addBook(Book(title:"Westward Ho!",author:"Charles Kingsley"))
//myLib.addBook(Book(title:"Jane Eyre",author:"Charlotte BrontÎ"))
//myLib.addBook(Book(title:"Lady Chatterley's Lover",author:"D.H. Lawrence"))
//myLib.addBook(Book(title:"Sons and Lovers",author:"D.H. Lawrence"))
//myLib.addBook(Book(title:"Women in Love",author:"D.H. Lawrence"))
//myLib.addBook(Book(title:"Sons and Lovers",author:"D.H. Lawrence"))
//myLib.addBook(Book(title:"Robinson Crusoe",author:"Daniel Defoe"))
//myLib.addBook(Book(title:"Tales of Mystery & Imagination",author:"Edgar Allan Poe"))
//myLib.addBook(Book(title:"Wuthering Heights",author:"Emily BrontÎ"))
//myLib.addBook(Book(title:"A Farewell to Arms",author:"Ernest Hemingway"))
//myLib.addBook(Book(title:"For Whom the Bell Tolls",author:"Ernest Hemingway"))
//myLib.addBook(Book(title:"The Sun Also Rises",author:"Ernest Hemingway"))
//myLib.addBook(Book(title:"Brideshead Revisited",author:"Evelyn Waugh"))
//myLib.addBook(Book(title:"The Great Gatsby",author:"F. Scott Fitzgerald"))
//myLib.addBook(Book(title:"Little Lord Fauntleroy",author:"Frances Hodgson Burnett"))
//myLib.addBook(Book(title:"The Secret Garden",author:"Frances Hodgson Burnett"))
//myLib.addBook(Book(title:"The Phantom Of Opera",author:"Gaston Leroux"))
//myLib.addBook(Book(title:"Adam Bede",author:"George Eliot"))
//myLib.addBook(Book(title:"Middlemarch",author:"George Eliot"))
//myLib.addBook(Book(title:"The Mill on the Floss",author:"George Eliot"))
//myLib.addBook(Book(title:"1984",author:"George Orwell"))
//myLib.addBook(Book(title:"Animal Farm",author:"George Orwell"))
//myLib.addBook(Book(title:"To Kill a Mockingbird",author:"Harper Lee"))
//myLib.addBook(Book(title:"Uncle Tom's Cabin",author:"Harriet Beecher Stowe"))
//myLib.addBook(Book(title:"Tropic of Cancer",author:"Henry Miller"))
//myLib.addBook(Book(title:"King Solomon's Mines",author:"Henry Rider Haggard"))
//myLib.addBook(Book(title:"Moby Dick",author:"Herman Melville"))
//myLib.addBook(Book(title:"The Catcher in the Rye",author:"J.D. Salinger"))
//myLib.addBook(Book(title:"The Lord of the Rings",author:"J.R.R. Tolkien"))
//myLib.addBook(Book(title:"The Call of the Wild",author:"Jack London"))
//myLib.addBook(Book(title:"The Call of the Wild",author:"Jack London"))
//myLib.addBook(Book(title:"White Fang",author:"Jack London"))
//myLib.addBook(Book(title:"Go Tell it on the Mountain",author:"James Baldwin"))
//myLib.addBook(Book(title:"The Last of the Mohicans",author:"James Fenimore Cooper"))
//myLib.addBook(Book(title:"Ulysses",author:"James Joyce"))
//myLib.addBook(Book(title:"Pride and Prejudice",author:"Jane Austen"))
//myLib.addBook(Book(title:"Sense and Sensibility",author:"Jane Austen"))
//myLib.addBook(Book(title:"Pilgrim's Progress",author:"John Bunyan"))
//myLib.addBook(Book(title:"A Separate Peace",author:"John Knowles"))
//myLib.addBook(Book(title:"Of Mice and Men",author:"John Steinbeck"))
//myLib.addBook(Book(title:"The Grapes of Wrath",author:"John Steinbeck"))
//myLib.addBook(Book(title:"Rabbit, Run",author:"John Updike"))
//myLib.addBook(Book(title:"Gulliver's Travels",author:"Jonathan Swift"))
//myLib.addBook(Book(title:"Lord Jim",author:"Joseph Conrad"))
//myLib.addBook(Book(title:"Catch-22",author:"Joseph Heller"))
//myLib.addBook(Book(title:"20,000 Leagues Under the Sea",author:"Jules Verne"))
//myLib.addBook(Book(title:"Around the World in Eighty Days",author:"Jules Verne"))
//myLib.addBook(Book(title:"The Awakening",author:"Kate Chopin"))
//myLib.addBook(Book(title:"One Flew Over the Cuckoo's Nest",author:"Ken Kesey"))
//myLib.addBook(Book(title:"Cat's Cradle",author:"Kurt Vonnegut"))
//myLib.addBook(Book(title:"Slaughterhouse-Five",author:"Kurt Vonnegut"))
//myLib.addBook(Book(title:"Alice's Adventures in Wonderland",author:"Lewis Carroll"))
//myLib.addBook(Book(title:"Little Women",author:"Louisa May Alcott"))
//myLib.addBook(Book(title:"Gone with the Wind",author:"Margaret Mitchell"))
//myLib.addBook(Book(title:"Adventures of Huckleberry Finn",author:"Mark Twain"))
//myLib.addBook(Book(title:"The Adventures of Tom Sawyer",author:"Mark Twain"))
//myLib.addBook(Book(title:"The Scarlet Letter",author:"Nathaniel Hawthorne"))
//myLib.addBook(Book(title:"The Naked and the Dead",author:"Norman Mailer"))
//myLib.addBook(Book(title:"The Importance of Being Earnest",author:"Oscar Wilde"))
//myLib.addBook(Book(title:"The Picture of Dorian Gray",author:"Oscar Wilde"))
//myLib.addBook(Book(title:"Lorna Doone",author:"R. D. Blackmore"))
//myLib.addBook(Book(title:"Invisible Man",author:"Ralph Ellison"))
//myLib.addBook(Book(title:"Native Son",author:"Richard Wright"))
//myLib.addBook(Book(title:"Kidnapped",author:"Robert Louis Stevenson"))
//myLib.addBook(Book(title:"Strange Case of Dr Jekyll and Mr Hyde",author:"Robert Louis Stevenson"))
//myLib.addBook(Book(title:"Treasure Island",author:"Robert Louis Stevenson"))
//myLib.addBook(Book(title:"All the King's Men",author:"Robert Penn Warren"))
//myLib.addBook(Book(title:"The Satanic Verses",author:"Salman Rushdie"))
//myLib.addBook(Book(title:"Ivanhoe",author:"Sir Walter Scott"))
//myLib.addBook(Book(title:"What Katy Did",author:"Susan Coolidge"))
//myLib.addBook(Book(title:"An American Tragedy",author:"Theodore Dreiser"))
//myLib.addBook(Book(title:"Far From The Madding Crowd",author:"Thomas Hardy"))
//myLib.addBook(Book(title:"Beloved",author:"Toni Morrison"))
//myLib.addBook(Book(title:"Song of Solomon",author:"Toni Morrison"))
//myLib.addBook(Book(title:"In Cold Blood",author:"Truman Capote"))
//myLib.addBook(Book(title:"The Jungle",author:"Upton Sinclair"))
//myLib.addBook(Book(title:"Les MisÈrables",author:"Victor Hugo"))
//myLib.addBook(Book(title:"The Hunchback of Notre-Dame",author:"Victor Hugo"))
//myLib.addBook(Book(title:"Lolita",author:"Vladmir Nabokov"))
//myLib.addBook(Book(title:"The Sketch Book of Geoffrey Crayon, Gent.",author:"Washington Irving"))
//myLib.addBook(Book(title:"The Moonstone",author:"Wilkie Collins"))
//myLib.addBook(Book(title:"The Woman in White",author:"Wilkie Collins"))
//myLib.addBook(Book(title:"As I Lay Dying",author:"William Faulkner"))
//myLib.addBook(Book(title:"The Lord of the Flies",author:"William Golding"))
//myLib.addBook(Book(title:"Vanity Fair",author:"William Makepeace Thackeray"))
//myLib.addBook(Book(title:"Naked Lunch",author:"William S. Burroughs"))
//myLib.addBook(Book(title:"A Midsummer Night's Dream",author:"William Shakespeare"))
//myLib.addBook(Book(title:"All's Well That Ends Well",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Anthony and Cleopatra",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Hamlet",author:"William Shakespeare"))
//myLib.addBook(Book(title:"King Lear",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Macbeth",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Much Ado About Nothing",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Romeo And Juliet",author:"William Shakespeare"))
//myLib.addBook(Book(title:"Sophie's Choice",author:"William Styron"))
//myLib.addBook(Book(title:"Their Eyes Were Watching God",author:"Zora Neale Hurston"))

myLib.listAllBooks()
myLib.findBook("Oliver Twist")
myLib.shelveBooks()
myLib.listAllBooks()

for shelf in myLib.shelves {
  shelf.sortAZ()
}
myLib.listAllBooks()

let book = myLib.findBook("Oliver Twist")
if let book = book {
  myLib.removeBook(book)
}
myLib.findBook("Oliver Twist")

myLib.findBook("A Tale of Two Cities")
myLib.findBook("Adventures of Sherlock Holmes")
myLib.findBook("The Adventures of Sherlock Holmes")

