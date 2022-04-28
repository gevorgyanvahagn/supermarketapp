//
//  File.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import Foundation
import Combine
import SwiftUI

open class BaseViewModel: ObservableObject {
    
    @Published public var alertItem: AlertItem?
    public var subscriptions = Set<AnyCancellable>()

    public init() {}
}

extension BaseViewModel {
    open func show(error: Error, message: String? = nil, completion: (() -> Void)? = nil) {
        guard alertItem.isNone else {
            return
        }
        var dismissButton: Alert.Button?
        if let completion = completion {
            dismissButton = .default(Text("Ok"), action: completion)
        }
        if let message = message {
            alertItem = AlertItem(id: UUID.init(), title: error.localizedDescription, message: message, dismissButton: dismissButton)
        } else {
            alertItem = AlertItem(id: UUID.init(), title: error.localizedDescription, message: nil, dismissButton: dismissButton)
        }
    }
}
