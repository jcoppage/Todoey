//
//  Item.swift
//  Todoey
//
//  Created by user  on 8/28/20.
//  Copyright © 2020 Jeff Coppage. All rights reserved.
//

import Foundation

//class Item: Encodable, Decodable{ // Means this class conforms to the protocols of Encodable, means that this object or data type (Item) canEncode itself into a .plist or JSON.

// vvvvvvvv Use this instead of above ^^^^^^ Its less code

class Item : Codable{
    
    //For a class to be "Encodable" all of its properties must have standard data types.
    
    var title: String = ""
    var done: Bool = false
}
