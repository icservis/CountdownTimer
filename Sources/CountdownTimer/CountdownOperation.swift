//
//  CountDownOperation.swift
//  countdown-timer
//
//  Created by Libor Kučera on 02.06.2021.
//  Copyright © 2021 IC Servis, s.r.o. All rights reserved.
//

import Foundation

public class CountDownOperation: Operation {
    public typealias ActionBlock = () -> Void
    private let actionBlock: ActionBlock?
    private var dispatchTime: TimeInterval = 1

    public init(actionBlock: ActionBlock?, dispatchTime: TimeInterval) {
        self.actionBlock = actionBlock
        self.dispatchTime = dispatchTime
    }

    public convenience init(actionBlock: ActionBlock?) {
        self.init(actionBlock: actionBlock, dispatchTime: 1)
    }

    private let lockQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).async-operation", attributes: .concurrent)

    public override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    public override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    public override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    public override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    public override func main() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.dispatchTime) {
            self.finish()
        }
        actionBlock?()
    }

    public func finish() {
        isExecuting = false
        isFinished = true
    }

    public override func cancel() {
        super.cancel()
    }
}
