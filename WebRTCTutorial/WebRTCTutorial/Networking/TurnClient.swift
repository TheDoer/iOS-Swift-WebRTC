//
//  TurnClient.swift
//  
//
//  Created by Adonis Rumbwere on 17/5/2021.
//  Copyright © 2021 Adonis Inc. All rights reserved.
//

import Foundation

//TURN server
//For most WebRTC applications to function a server is required for relaying the traffic between peers, since a direct socket is often not possible between the clients (unless they reside on the same local network). The common way to solve this is by using a TURN server. The term stands for Traversal Using Relay NAT, and it is a protocol for relaying network traffic.

struct TurnClient {
    let turnClientUrl = URL(string: "https://appr.tc/params")!
    
    func request() {
        let task = URLSession.shared.dataTask(with: turnClientUrl) {(data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("[TurnClient] Reuqest Error \(error)")
                }
                return
            }
            do {
                let resultDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let ice_server_url = resultDict?["ice_server_url"] as? String,
                    let iceURL = URL(string: ice_server_url) {
                    self.makeTurnServerRequest(iceURL: iceURL)
                }
            } catch let error {
                print("[TurnClient] Serialization Error \(error)")
            }
        }
        
        task.resume()
    }
    
    func makeTurnServerRequest(iceURL: URL) {
        var request = URLRequest(url: iceURL)
        request.httpMethod = "POST"
        request.addValue("https://appr.tc", forHTTPHeaderField: "referer")
        let task = URLSession.shared.dataTask(with: iceURL) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let resultDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(resultDict)
            } catch let error {
                print("[TurnClient] Serialization Error \(error)")
            }
        }
        task.resume()
    }
}

