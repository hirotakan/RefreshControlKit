//
//  RefreshControl+Progress.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/27.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

extension RefreshControl {
    public struct Progress {
        @Clamping(range: 0.0 ... 1.0)
        public var value: CGFloat = 0.0
    }
}
