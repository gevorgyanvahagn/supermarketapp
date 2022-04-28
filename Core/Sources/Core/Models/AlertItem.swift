//
//  AlertItem.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import SwiftUI

public struct AlertItem: Identifiable {
    public var id = UUID()
    public var title: String
    public var message: String?
    public var dismissButton: Alert.Button?
    public var primaryButton: Alert.Button?
    
    public func alert() -> Alert {
        if let primaryButton = primaryButton, let dismissButton = dismissButton {
            return Alert(title: titleText, message: messageText, primaryButton: primaryButton,
                         secondaryButton: dismissButton)
        } else {
            return Alert(title: titleText, message: messageText, dismissButton: dismissButton)
        }
    }
}

public extension AlertItem {
    private var messageText: Text? {
        if let message = message {
            return Text(message)
        }
        return nil
    }
    private var titleText: Text {
        Text(title)
    }
}
