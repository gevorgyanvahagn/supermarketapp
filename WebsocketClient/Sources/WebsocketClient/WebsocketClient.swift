//
//  WebsocketClient.swift
//  SupermarketApp
//
//  Created by Vahagn Gevorgyan on 4/28/22.
//

import Foundation
import SwiftUI
import Combine

public protocol WebsocketClientProtocol {
    var subject: PassthroughSubject<Result<Data, Error>, Never> { get }
    func connect()
    func disconnect()
}

final public class WebsocketClient: ObservableObject, WebsocketClientProtocol {
    
    public let subject = PassthroughSubject<Result<Data, Error>, Never>()
    
    private var socket: URLSessionWebSocketTask
    private var urlSession: URLSession
    private let socketUrl: URL
    
    public init(urlSession: URLSession = URLSession(configuration: .default),
         socketUrl: URL) {
        self.urlSession = urlSession
        self.socketUrl = socketUrl
        socket = urlSession.webSocketTask(with: socketUrl)
    }
    
    public func connect() {
        socket = urlSession.webSocketTask(with: socketUrl)
        socket.resume()
        listen()
    }
    
    public func disconnect() {
        socket.cancel(with: .goingAway, reason: nil)
    }
    
    private func handle(_ data: Data) {
        subject.send(.success(data))
    }
    
    private func listen() {
        self.socket.receive { [weak self] (result) in
            guard let self = self else {
                assertionFailure()
                return
            }
            switch result {
            case .failure(let error):
                self.subject.send(.failure(error))
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let string):
                    guard let data = string.data(using: .utf8) else { return }
                    self.handle(data)
                @unknown default:
                    break
                }
            }
            self.listen()
        }
    }
}
