//
//  GroceryView.swift
//  SupermarketApp
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import SwiftUI
import WebsocketClient
import Models
import Core
import Combine

struct GroceryView: View {
    
    @StateObject private var viewModel = ViewModel(client: WebsocketClient(socketUrl: Constants.Endpoints.socketUrl))
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.groceryItems, id: \.self) { groceryItem in
                        GroceryItemView(groceryItem: groceryItem)
                    }
                    .padding(.top)
                }
            }
            .showAlert($viewModel.alertItem)
            .navigationTitle(Assets.navigationTitle)
        }
    }
}

// MARK: - Assets
extension GroceryView {
    fileprivate struct Assets {
        static let navigationTitle = "Supermarket"
    }
}

// MARK: - Suviews
extension GroceryView {
}

// MARK: - View model
extension GroceryView {
    final class ViewModel<T: WebsocketClientProtocol>: BaseViewModel {
        
        @Published fileprivate var groceryItems = [GroceryItem]()
        private var client: T
        
        init(client: T) {
            self.client = client
            super.init()
            client.connect()
            bind()
        }
        
        func connectToWebsocket() {
            client.connect()
        }
        
        func disconnectFromWebsocket() {
            client.disconnect()
        }
        
        private func bind() {
            client.subject.sink { [weak self] result in
                guard let self = self else {
                    assertionFailure()
                    return
                }
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.handleGroceryItemData(data)
                    }
                case .failure(let error):
                    self.show(error: error)
                }
            }
            .store(in: &subscriptions)
        }
        
        private func decode(_ data: Data) throws -> GroceryItem {
            return try JSONDecoder().decode(GroceryItem.self, from: data)
        }
        
        private func handleGroceryItemData(_ data: Data) {
            do {
                let groceryItem = try self.decode(data)
                self.groceryItems.append(groceryItem)
            } catch let error {
                self.show(error: error)
            }
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        GroceryView()
        
    }
}
