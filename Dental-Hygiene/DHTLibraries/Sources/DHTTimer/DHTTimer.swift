//
//  DHTimer.swift
//  DHTimer
//
//  Created by Mayur Dhaka on 09/11/19.
//  Copyright © 2019 Mayur Dhaka. All rights reserved.
//

import Foundation
import Combine

/// A re-usable timer that you can start and stop using those respective methods.
/// DHTimer emits `StartTime` instances every second.
public class DHTTimer {
    private var timerSubscription: AnyCancellable!
    public init() {}
    
    /// Starts this timer, emitting `SmallTime` values every second.
    /// The closure `c` is called on the main thread, everytime a new value is emitted.
    public func start(_ c: @escaping (SmallTime) -> Void) {
        timerSubscription = TimerPublisher().subscribe(on: RunLoop.main).sink(receiveValue: c)
    }
    
    /// Stops this timer--resetting any value that existed.
    public func stop() {
        timerSubscription.cancel()
    }
}

// This class is heavily inspired from:
// https://www.avanderlee.com/swift/custom-combine-publisher/
final class TimerSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == SmallTime {
    
    // Optional so it can be deinitialised when cancelling subscription.
    private var subscriber: SubscriberType?
    
    // Being forced to make this an unwrapped optional
    // since the compiler thinks it isnt initialised otherwise.
    private var timeSubscription: AnyCancellable!
    private var startDate: Date

    init(subscriber: SubscriberType) {
        startDate = Date()
        self.subscriber = subscriber
        timeSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink() {
                let duration = $0.timeIntervalSince(self.startDate)
                let time = try! SmallTime(timeInterval: duration)
         
                // We don't care about the subscriber's demands.
               _ = subscriber.receive(time)
        }
        
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        // Cancelling the subscription for safe measure.
        // We'd know if there is a bug here, this way.
        timeSubscription.cancel()
        subscriber = nil
    }
}

struct TimerPublisher: Publisher {
    typealias Output = SmallTime
    typealias Failure = Never
    
    func receive<S>(subscriber: S)
        where S : Subscriber, S.Failure == TimerPublisher.Failure, S.Input == TimerPublisher.Output {
        let subscription = TimerSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}
