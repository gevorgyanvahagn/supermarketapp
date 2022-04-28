//
//  File.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import Foundation

public extension Optional {
    var isNone: Bool {
        return self == nil
    }
    var isSome: Bool {
        return self != nil
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
