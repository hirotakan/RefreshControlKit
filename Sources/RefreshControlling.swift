//
//  RefreshControlling.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

@propertyWrapper
public struct RefreshControlling<ScrollView: RefreshControllable> {
    private var scrollView: ScrollView

    public var projectedValue: RefreshControl

    public var wrappedValue: ScrollView {
        get { scrollView }
        set {
            scrollView = newValue
            scrollView.addRefreshControl(projectedValue)
        }
    }

    public init(wrappedValue: ScrollView, view: RefreshControlView, configuration: RefreshControl.Configuration = .default) {
        projectedValue = RefreshControl(view: view, configuration: configuration)
        scrollView = wrappedValue
        scrollView.addRefreshControl(projectedValue)
    }

    public mutating func setRefreshControl(view: RefreshControlView, configuration: RefreshControl.Configuration = .default) {
        projectedValue.removeFromSuperview()
        projectedValue = RefreshControl(view: view, configuration: configuration)
        scrollView.addRefreshControl(projectedValue)
    }
}
