//
//  RefreshControl+Configuration.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/27.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

extension RefreshControl {
    public struct Configuration {
        public var layout: Layout
        public var trigger: Trigger

        public init(layout: Layout = .top, trigger: Trigger = .default) {
            self.layout = layout
            self.trigger = trigger
        }
    }
}

extension RefreshControl.Configuration {
    public static let `default` = RefreshControl.Configuration()

    public enum Layout {
        /// The top of the `RefreshControl` is anchored at the top of the `ScrollView` frame.
        case top
        /// The bottom of the `RefreshControl` is anchored above the content of the `ScrollView`.
        case bottom
    }

    public struct Trigger {
        /// Specify the height at which the refreshing starts. The default is the height of the custom view.
        public var height: CGFloat?
        public var event: Event

        public static let `default` = RefreshControl.Configuration.Trigger()

        public init(height: CGFloat? = nil, event: Event = .dragging) {
            self.height = height
            self.event = event
        }
    }
}

extension RefreshControl.Configuration.Trigger {
    public enum Event {
        /// When it is pulled to the trigger height, `beginRefreshing` is called.
        case dragging
        /// If the height of the trigger is exceeded at the time of release, `beginRefreshing` is called.
        case released
    }
}
