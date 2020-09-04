//
//  UIScrollView+RefreshControllable.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

extension UIScrollView: RefreshControllable {
    public func addRefreshControl(_ refresh: RefreshControl) {
        refresh.add(to: self)
    }
}

extension Optional: RefreshControllable where Wrapped: UIScrollView {
    public func addRefreshControl(_ refresh: RefreshControl) {
        map(refresh.add(to:))
    }
}
