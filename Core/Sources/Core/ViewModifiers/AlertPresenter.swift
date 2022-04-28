//
//  AlertPresenter.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import SwiftUI

public struct AlertPresenter: ViewModifier {
    
    @Binding public var alertItem: AlertItem?
    public func body(content: Content) -> some View {
        content
            .alert(item: $alertItem) { alertItem in
                alertItem.alert()
            }
    }
}
