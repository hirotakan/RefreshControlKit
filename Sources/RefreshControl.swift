//
//  RefreshControl.swift
//  RefreshControlKit
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit

public class RefreshControl: UIControl {
    public private(set) var isRefreshing = false
    private var view: RefreshControlView
    private let configuration: Configuration
    private var heightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var progress = Progress()
    private weak var scrollView: UIScrollView?
    private var originScrollViewContentInset: UIEdgeInsets = .zero
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentInsetObservation: NSKeyValueObservation?

    public init(view: RefreshControlView, configuration: Configuration = .default) {
        self.view = view
        self.configuration = configuration

        super.init(frame: .zero)

        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true

        setRefreshControlView(view)
    }

    deinit {
        contentOffsetObservation?.invalidate()
        contentInsetObservation?.invalidate()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isHidden: Bool {
        didSet {
            guard !isHidden else { return }

            scrollView?.sendSubviewToBack(self)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if configuration.layout == .top, let scrollView = self.scrollView {
            switch scrollView.contentInsetAdjustmentBehavior {
            case .automatic, .always, .scrollableAxes:
                topConstraint?.constant = scrollView.safeAreaInsets.top + originScrollViewContentInset.top
            case .never:
                topConstraint?.constant = originScrollViewContentInset.top
            @unknown default:
                break
            }
        }
    }

    public override func removeFromSuperview() {
        let previousOffset = scrollView?.contentOffset ?? .zero
        scrollView?.contentInset.top = originScrollViewContentInset.top
        scrollView?.contentOffset.y = previousOffset.y

        super.removeFromSuperview()
    }

    public func setRefreshControlView(_ view: RefreshControlView) {
        self.view.removeFromSuperview()

        self.view = view
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        heightConstraint?.constant = view.bounds.height
    }

    public func beginRefreshing() {
        guard !isRefreshing else { return }

        isHidden = false
        isRefreshing = true

        sendActions(for: .valueChanged)

        progress.value = 1.0

        view.willRefresh()
    }

    public func endRefreshing() {
        guard isRefreshing else { return }

        progress.value = 0.0
        view.didRefresh()

        let previousOffset = scrollView?.contentOffset ?? .zero
        scrollView?.contentInset.top = originScrollViewContentInset.top
        scrollView?.contentOffset.y = previousOffset.y

        let nextOffsetY = -(scrollView?.adjustedContentInset.top ?? 0)

        if configuration.layout == .top {
            // NOTE: Since animating a change of `contentOffset` causes a visual shift in position, adjust it by `transform`.
            transform = CGAffineTransform(translationX: 0, y: min(0, previousOffset.y - nextOffsetY))
        }

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self, let scrollView = self.scrollView else { return }

            if self.configuration.layout == .top {
                self.transform = .identity
            }

            let scrollThreshold = previousOffset.y

            // NOTE: Do not change the `contentOffset` if `scrollView` are scrolling while refreshing.
            guard scrollThreshold < nextOffsetY else { return }

            scrollView.contentOffset.y = nextOffsetY
        }, completion: { [weak self] _ in
            self?.isHidden = true
            self?.isRefreshing = false
        })
    }

    func add(to scrollView: UIScrollView) {
        self.scrollView = scrollView

        contentInsetObservation = scrollView
            .observe(\.contentInset, options: .new) { [weak self] scrollView, _ in
                guard let self = self, !self.isRefreshing else {
                    return
                }

                self.originScrollViewContentInset = scrollView.contentInset
            }

        contentOffsetObservation = scrollView
            .observe(\.contentOffset, options: .new) { [weak self] scrollView, change in
                guard let self = self,
                    !self.isRefreshing, let offset = change.newValue
                else {
                    return
                }

                let contentOffsetY = offset.y + scrollView.adjustedContentInset.top

                guard contentOffsetY < 0.0 else {
                    self.isHidden = true
                    return
                }

                self.isHidden = false

                let triggerHeight = self.configuration.trigger.height ?? self.view.bounds.height

                let fraction = triggerHeight <= 0 ? 0 : abs(contentOffsetY) / triggerHeight

                self.progress.value = fraction

                self.view.didScroll(self.progress)
            }

        originScrollViewContentInset = scrollView.contentInset

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        recognizer.delegate = self
        scrollView.addGestureRecognizer(recognizer)

        scrollView.addSubview(self)

        switch self.configuration.layout {
        case .top:
            let topConstraint = topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor)
            topConstraint.isActive = true
            self.topConstraint = topConstraint
        case .bottom:
            bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        }

        widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor).isActive = true
    }

    private func expandScrollViewContentInsetTop() {
        let previousOffset = scrollView?.contentOffset ?? .zero
        let insetTop = self.originScrollViewContentInset.top + self.bounds.height
        scrollView?.contentInset.top = insetTop
        scrollView?.contentOffset.y = previousOffset.y
    }

    @objc private func viewPanned(_ recognizer: UIPanGestureRecognizer) {
        let shouldRefresh: Bool
        let shouldExpandInset: Bool

        switch configuration.trigger.event {
        case .dragging:
            shouldRefresh = !isRefreshing
                && recognizer.state == .changed
                && progress.value == 1.0
            shouldExpandInset = isRefreshing
                && recognizer.state == .ended
                && scrollView?.contentInset.top == originScrollViewContentInset.top
        case .released:
            shouldRefresh = !isRefreshing
                && recognizer.state == .ended
                && progress.value == 1.0

            shouldExpandInset = shouldRefresh
        }

        if shouldRefresh {
            beginRefreshing()
        }

        if shouldExpandInset {
            expandScrollViewContentInsetTop()
        }
    }
}

extension RefreshControl: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        true
    }
}
