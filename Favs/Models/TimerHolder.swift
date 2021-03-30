//
//  TimerHolder.swift
//  Favs
//
//  Created by yum on 2021/03/28.
//

import Foundation
import Combine

class TimerHolder : ObservableObject {
    @Published var timer : Timer!
    @Published var count = 0
    
    func start() {
        self.timer?.invalidate()
        self.count = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            self.count += 1
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.count = 0
    }
}
