//
//  StringExtension.swift
//  LotsOfBooks
//
//  Created by mike davis on 6/22/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

extension String {
  var length: Int { return count(self) }
  func substring(index: Int) -> String {
    return self.substringFromIndex(advance(self.startIndex, index))
  }
}
