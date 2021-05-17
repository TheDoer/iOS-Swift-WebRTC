//
//  WebSocketClient.swift
//  
//
//  Created by Adonis Rumbwere on 11/5/2021.
//  Copyright © 2021 Adonis Inc. All rights reserved.
//

import Foundation
import SocketRocket

//It’s called SocketRocket. It’s a WebSocket client written in modern Objective-C. It conforms to RFC 6455, the latest WebSocket specification. It supports wss since the connection is based off of CFStream (bridged to NSStream).
//
//This also means it supports iOS 4.x and doesn’t have any external dependencies. SocketRocket uses Automatic Reference Counting to keep the code simple and Grand Central Dispatch to keep the logic in the background.


//A |wss| URI identifies a WebSocket server and resource name and
//  indicates that traffic over that connection is to be protected via
//  TLS (including standard benefits of TLS such as data confidentiality
//  and integrity and endpoint authentication).


protocol WebSocketClientDelegate: class {
    func webSocketDidConnect(_ webSocket: WebSocketClient)
    func webSocketDidDisconnect(_ webSocket: WebSocketClient)
    func webSocket(_ webSocket: WebSocketClient, didReceive data: String)
}

class WebSocketClient: NSObject {
    weak var delegate: WebSocketClientDelegate?
    var socket: SRWebSocket?
    
    var isConnected: Bool {
        return socket != nil
    }
    
    func connect(url: URL) {
        socket = SRWebSocket(url: url)
        socket?.delegate = self
        socket?.open()
    }
    
    func disconnect() {
        socket?.close()
        socket = nil
        self.delegate?.webSocketDidDisconnect(self)
    }
    
    func send(data: Data) {
        guard let socket = socket else {
            dLog("Check Socket connection")
            return
        }
        
        dLog(data.prettyPrintedJSONString)
        socket.send(data)
    }
}

extension WebSocketClient: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        dLog(message)
        if let message = message as? String {
            delegate?.webSocket(self, didReceive: message)
        }
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        delegate?.webSocketDidConnect(self)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        debugPrint("did Fail to connect websocket")
        self.disconnect()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        debugPrint("did close websocket")
        self.disconnect()
    }
}
