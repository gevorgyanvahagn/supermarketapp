//
//  File.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import Foundation

public struct GroceryItem: Codable, Hashable {
    
    public init(bagColor: String? = nil, name: String? = nil, weight: String? = nil) {
        self.bagColor = bagColor
        self.name = name
        self.weight = weight
    }
    
    public var bagColor: String?
    public var name: String?
    public var weight: String?
    
}
