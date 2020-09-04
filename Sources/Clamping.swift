//
//  Clamping.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Clamping<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>

    public init(wrappedValue: Value, range: ClosedRange<Value>) {
        self.range = range
        value = range.clamp(wrappedValue)
    }

    public var wrappedValue: Value {
        get { value }
        set { value = range.clamp(newValue) }
    }
}

private extension ClosedRange {
    func clamp(_ value: Bound) -> Bound {
        switch value {
        case let value where value < lowerBound:
            return lowerBound
        case let value where value > upperBound:
            return upperBound
        default:
            return value
        }
    }
}
