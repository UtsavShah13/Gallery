//
//  SocketIOManager.swift
//  SocketConnectionDemo
//
//  Created by i Mac on 21/02/20.
//  Copyright © 2020 i Mac. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject,StreamDelegate {
    
    static let sharedInstance = SocketIOManager()
    
//    let userName : String = Constant.appDelegate.email!
//    let type : Bool = UserDefaults.getBool(forKey: Constant.UserDefaultsKey.isUserLogin)
    let senderId : Int =  UserDefaults.getInt(forKey: Constant.Key.userId)
    let manager = SocketManager(socketURL: URL(string: ServerConstant.socketIODomain)!, config: [.log(true),
                                                                                                 .compress,
                                                                                                 .extraHeaders(["Authorization": Constant.appDelegate.autorization!])])
    
    override init() {
        super.init()
    }
    
    func establishConnection(completionHandler: @escaping(_ status: String) -> Void) {
      let socket = manager.defaultSocket
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
              print(data)
//            GeneralUtility.showAlert(message: "Connected")
            GeneralUtility.showToast(message: "Connected")
            completionHandler("Connected")
          }

          socket.on(clientEvent: .error) { (data, eck) in
              print(data)
//             GeneralUtility.showAlert(message: "error")
              print("socket error")
             completionHandler("Error")
          }

          socket.on(clientEvent: .disconnect) { (data, eck) in
              print(data)
//             GeneralUtility.showAlert(message: "Disconnected")
              print("socket disconnect")
            
          }

          socket.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
              print(data)
//              GeneralUtility.showAlert(message: "socket reconnect")
              print("socket reconnect")
        }
    }
     
     
    func closeConnection() {
        let socket = manager.defaultSocket
        socket.disconnect()
    }

    func connectToServerWithNickname(nickname: String, completionHandler: @escaping(_ userList: String) -> Void) {
        print(manager.defaultSocket.status)
         if manager.defaultSocket.status == .connected {
            manager.defaultSocket.emit("add user", nickname)
            completionHandler("connected")
        }
        
    }

    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        let socket = manager.defaultSocket
        socket.emit(nickname, nickname)
        completionHandler()
    }

    func sendMessage(message: String, sentToUserId: Int) {
        let socket = manager.defaultSocket
        if socket.status == .connected {
            let msgDic = ["stMessage": message,
                          "inReceiverUserId": sentToUserId,
                          "stMessageType": "text"] as [String : Any]
            
            socket.emit("chat",msgDic)
            socket.emit("sent",msgDic)
            socket.emit("delivered",msgDic)
            socket.emit("readed",msgDic)
        }
    }
    
    func senderNewEventResponse(completionHandler: @escaping(_ eventData: SocketAnyEvent) -> Void) {
        let socket = manager.defaultSocket
        if socket.status == .connected {
            socket.onAny { newEventReceived in
                completionHandler(newEventReceived)
            }
        }
    }
    
    func receiverMesaageReaded(lastMessageId: Int) {
        let socket = manager.defaultSocket
        if socket.status == .connected {
            print(lastMessageId)
            let msgDic = ["inUserChatId": lastMessageId] as [String : Any]
            socket.emit("readed",msgDic)
        }
    }
    
    func getChatMessage(completionHandler: @escaping(_ messageInfo: [String: Any]) -> Void) {
        let socket = manager.defaultSocket
        socket.on("chat") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: Any]()
            print(dataArray)
            
            for dic in dataArray {
                messageDictionary = dic as! [String : Any]
            }
            print("****************")
            print(messageDictionary)
            print("****************")
            completionHandler(messageDictionary)
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("connnection")
    }
    
    
    
}
