//
//  Observable.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import Foundation

//
// MARK: - Basic Observable
//

/// Enables us to bind ViewModel<->View without using heavy frameworks like RxSwift or ReactiveSwift
class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }

    private var valueChanged: ((T) -> Void)?

    init(value: T) {
        self.value = value
    }

    /// Add closure as an observer and trigger the closure imeediately if fireNow = true
    func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }

    func removeObserver() {
        valueChanged = nil
    }

}
