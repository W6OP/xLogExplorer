//
//  Utility.swift
//  xLogExplorer
//
//  Created by Peter Bourget on 7/4/22.
//

import Foundation

// https://stackoverflow.com/questions/39307800/how-to-check-current-thread-in-swift-3
extension Thread {
    var threadName: String {
        if isMainThread {
            return "main"
        } else if let threadName = Thread.current.name, !threadName.isEmpty {
            return threadName
        } else {
            return description
        }
    }

    var queueName: String {
        if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)) {
            return queueName
        } else if let operationQueueName = OperationQueue.current?.name, !operationQueueName.isEmpty {
            return operationQueueName
        } else if let dispatchQueueName = OperationQueue.current?.underlyingQueue?.label, !dispatchQueueName.isEmpty {
            return dispatchQueueName
        } else {
            return "n/a"
        }
    }
}

/*
 Use cases:
 print("Current thread: \(Thread.current.threadName)")
 */
