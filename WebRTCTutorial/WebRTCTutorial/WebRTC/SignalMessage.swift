//
//  SignalMessage.swift
//  WebRTCTutorial
//
//  Created by Adonis Rumbwere on 11/5/2021.
//  Copyright © 2021 Adonis Inc. All rights reserved.
//

import Foundation
import WebRTC

enum SignalMessage {
    case none
    case candidate(_ message: RTCIceCandidate)
    case answer(_ message: RTCSessionDescription)
    case offer(_ message: RTCSessionDescription)
    case bye
    
    static func from(message: String) -> SignalMessage {
        if let dict = message.convertToDictionary() {
            var messageDict: [String: Any]?

            if dict.keys.contains("msg") {
                let messageStr = dict["msg"] as? String
                messageDict = messageStr?.convertToDictionary()
            } else {
                messageDict = dict
            }
            
            if let messageDict = messageDict,
                let type = messageDict["type"] as? String {
                
                if type == "candidate",
                    let candidate = RTCIceCandidate.candidate(from: messageDict) {
                    return .candidate(candidate)
                } else if type == "answer",
                    let sdp = messageDict["sdp"] as? String {
                    return .answer(RTCSessionDescription(type: .answer, sdp: sdp))
                } else if type == "offer",
                    let sdp = messageDict["sdp"] as? String {
                    return .offer(RTCSessionDescription(type: .offer, sdp: sdp))
                } else if type == "bye" {
                    return .bye
                }
            }
        }
        return none
    }
}
