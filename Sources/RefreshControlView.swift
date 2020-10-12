//
//  RefreshControlView.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

public protocol RefreshControlView: UIView {
    func willRefresh()
    func didRefresh()
    func didScroll(_ progress: RefreshControl.Progress)
}
