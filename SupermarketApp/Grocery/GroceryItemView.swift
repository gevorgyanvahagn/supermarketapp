//
//  GroceryItemView.swift
//  SupermarketApp
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import SwiftUI
import Models
import Core

struct GroceryItemView: View {
    
    var groceryItem: GroceryItem
    
    var body: some View {
        HStack {
            colorView(withHex: groceryItem.bagColor)
            VStack(alignment: .leading, spacing: 8) {
                Text(groceryItem.name ?? "")
                    .font(.system(.title2))
                    .padding(.leading)
                Text(groceryItem.weight ?? "")
                    .font(.system(.body))
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 16)
            .border(Color.gray, width: 0.5, cornerRadius: 5)
        }
        .padding(.horizontal)
        
    }
}

extension GroceryItemView {
    @ViewBuilder
    private func colorView(withHex hex: String?) -> some View {
        Group {
            if let hex = groceryItem.bagColor {
                Color(uiColor: UIColor(hex))
            } else {
                Color.black
            }
        }
        .frame(width: 55, height: 55)
        .cornerRadius(27.5)
        
    }
}

struct GroceryItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryItemView(groceryItem: .init(bagColor: "", name: "Test Name", weight: "1.0 kg"))
    }
}
