//
//  Item.swift
//  Todoey
//
//  Created by Moshood Alaran on 09/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


class Item: Encodable, Decodable{
    var title : String = ""
    var done : Bool = false
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
