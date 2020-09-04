//
//  RefreshControlView.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

public protocol RefreshControlView: UIView {
    func beginRefreshing()
    func endRefreshing()
    func scrolling(_ progress: RefreshControl.Progress)
}
