//
//  countdown_timer.swift
//  countdown-timer
//
//  Created by Libor Kučera on 02.06.2021.
//  Copyright © 2021 IC Servis, s.r.o. All rights reserved.
//

import Foundation

final public class CountDownManager: NSObject {
    public typealias CompletionBlock = () -> Void

    public let queue: OperationQueue
    public struct Configuration {
        let maxConcurrentOperationCount: Int
        let qualityOfService: DispatchQoS
    }
    public let configuration: Configuration

    public init(configuration: Configuration) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = configuration.maxConcurrentOperationCount
        queue.isSuspended = true
        self.configuration = configuration
        self.queue = queue
    }

    public convenience init(maxConcurrentOperationCount: Int) {
        let configuration = Configuration(
            maxConcurrentOperationCount: maxConcurrentOperationCount,
            qualityOfService: .background
        )
        self.init(configuration: configuration)
    }

    public convenience override init() {
        let configuration = Configuration(
            maxConcurrentOperationCount: 1,
            qualityOfService: .background
        )
        self.init(configuration: configuration)
    }

    public func startAsync(completion: CompletionBlock?) {
        DispatchQueue(
            label: "\(Bundle.main.bundleIdentifier!).countdown-queue",
            qos: configuration.qualityOfService
        ).async { [weak self] in
            self?.queue.isSuspended = false
            self?.queue.waitUntilAllOperationsAreFinished()
            completion?()
        }
    }

    public func queueOperations(_ operations: [Operation]) {
        operations.forEach { self.queue.addOperation($0) }
    }

    public func processAsync(_ operations: [Operation], completion: CompletionBlock?) {
        queueOperations(operations)
        startAsync(completion: completion)
    }

    public func cancel() {
        queue.cancelAllOperations()
    }
}
