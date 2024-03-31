//
//  ServiceManager.swift
//  TemplateProjSwift
//
//  Created by Mac22 on 13/09/18.
//  Copyright © 2018 Mac22. All rights reserved.
//

import Foundation

protocol ServiceLocating {
    func getService<T>() -> T?
}

class ServiceManager {
    
    public static let shared = ServiceManager.init()
    
    let serverCommunicationManager: ServerCommunicationManager
    private lazy var services: [String: Any] = [:]
    
    init() {
        self.serverCommunicationManager = ServerCommunicationManager.init()
    }
    
    private func typeName(some: Any) -> String {
        return (some is Any.Type) ?
        "\(some)" : "\(type(of: some))"
    }
    
    func getService<T>() -> T? {
        let key = typeName(some: T.self)
        return services[key] as? T
    }
}
