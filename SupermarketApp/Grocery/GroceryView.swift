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
            .navigationBarItems(trailing: statusButton)
        }
    }
}

// MARK: - Assets
extension GroceryView {
    fileprivate struct Assets {
        static let navigationTitle = "Supermarket"
        static let startButtonTitle = "Start"
        static let stopButtonTitle = "Stop"
    }
}

// MARK: - Suviews
extension GroceryView {
    var statusButton: some View {
        Button {
            viewModel.changeStatus()
        } label: {
            if viewModel.isAvtive {
                Text(Assets.stopButtonTitle)
            } else {
                Text(Assets.startButtonTitle)
            }
        }
    }
}

// MARK: - View model
extension GroceryView {
    final class ViewModel<T: WebsocketClientProtocol>: BaseViewModel {
        
        @Published fileprivate var groceryItems = [GroceryItem]()
        @Published fileprivate var isAvtive = false
        private var client: T
        
        init(client: T) {
            self.client = client
            super.init()
            connectToWebsocket()
            bind()
        }
        
        func changeStatus() {
            if isAvtive {
                disconnectFromWebsocket()
            } else {
                connectToWebsocket()
            }
        }
        
        private func connectToWebsocket() {
            client.connect()
            isAvtive = true
        }
        
        private func disconnectFromWebsocket() {
            client.disconnect()
            isAvtive = false
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
                self.groceryItems.insert(groceryItem, at: 0)
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
