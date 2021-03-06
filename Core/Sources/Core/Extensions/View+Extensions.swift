//
//  View+Extensions.swift
//  
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import Foundation
import SwiftUI

public extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func showAlert(_ alertItem: Binding<AlertItem?>) -> some View {
        self.modifier(AlertPresenter(alertItem: alertItem))
    }
    
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}
