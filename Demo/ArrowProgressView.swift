//
//  ArrowProgressView.swift
//  Demo
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit
import RefreshControlKit


class ArrowProgressView: UIView {
    private var circleView = CircleView()

    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: 0, height: 60)))

        translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(circleView)

        circleView.heightAnchor.constraint(equalToConstant: 37).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArrowProgressView {
    class CircleView: UIView {
        private let circleLayer = CAShapeLayer()
        private let strokeLayer = CAShapeLayer()
        private let arrowImageView = UIImageView()
        private var isAnimating = false

        init() {
            super.init(frame: .zero)
            initialize()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func draw(_: CGRect) {
            let radius = bounds.width / 2
            let startAngle = CGFloat.pi * (3 / 2)
            let endAngle = startAngle + CGFloat.pi * 2.0
            let path = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            circleLayer.frame = bounds
            circleLayer.path = path.cgPath
            circleLayer.lineWidth = 1.5
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = UIColor.gray.cgColor
            circleLayer.strokeEnd = 0.0
            layer.addSublayer(circleLayer)

            strokeLayer.frame = bounds
            strokeLayer.path = path.cgPath
            strokeLayer.lineWidth = 1.5
            strokeLayer.fillColor = UIColor.clear.cgColor
            strokeLayer.strokeColor = UIColor.black.cgColor
            strokeLayer.strokeEnd = 0.2
            layer.addSublayer(strokeLayer)
        }

        override func didMoveToWindow() {
            if let _ = window, isAnimating {
                addAnimation()
            }
        }

        func setProgress(_ progress: CGFloat) {
            circleLayer.isHidden = false
            circleLayer.strokeEnd = progress
        }

        func startAnimating() {
            guard !isAnimating else { return }

            isAnimating = true

            addAnimation()
        }

        func stopAnimating() {
            guard isAnimating else { return }

            isAnimating = false
            strokeLayer.isHidden = true

            circleLayer.removeAllAnimations()
            strokeLayer.removeAllAnimations()
            arrowImageView.layer.removeAllAnimations()
        }

        private func initialize() {
            strokeLayer.isHidden = true
            backgroundColor = .clear

            translatesAutoresizingMaskIntoConstraints = false
            arrowImageView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(arrowImageView)

            let arrowImage = UIImage(named: "down_arrow")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.image = arrowImage
            arrowImageView.tintColor = .darkGray

            arrowImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            arrowImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(viewWillEnterForeground),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }

        private func addAnimation() {
            CATransaction.begin()

            let arrowAnimation = CABasicAnimation(keyPath: "transform.rotation")
            arrowAnimation.fromValue = 0.0
            arrowAnimation.toValue = 180 * CGFloat.pi / 180
            arrowAnimation.duration = 0.2
            arrowAnimation.fillMode = .forwards
            arrowAnimation.isRemovedOnCompletion = false

            let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
            circleAnimation.fromValue = circleLayer.strokeEnd
            circleAnimation.toValue = 1.0
            circleAnimation.duration = 0.2
            circleAnimation.fillMode = .forwards
            circleAnimation.isRemovedOnCompletion = false

            CATransaction.setCompletionBlock { [weak self] in
                self?.strokeLayer.isHidden = false

                let arrowAnimation = CABasicAnimation(keyPath: "opacity")
                arrowAnimation.toValue = 0.0
                arrowAnimation.duration = 0.1
                arrowAnimation.fillMode = .forwards
                arrowAnimation.isRemovedOnCompletion = false

                self?.arrowImageView.layer.add(arrowAnimation, forKey: "arrowOpacityAnimation")

                let strokeAnimation = CABasicAnimation(keyPath: "transform.rotation")
                strokeAnimation.fromValue = 0.0
                strokeAnimation.toValue = 2.0 * Double.pi
                strokeAnimation.duration = 1.0
                strokeAnimation.repeatCount = .infinity
                strokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

                self?.strokeLayer.add(strokeAnimation, forKey: "strokeRotationAnimation")
            }

            arrowImageView.layer.add(arrowAnimation, forKey: "arrowRotationAnimation")
            circleLayer.add(circleAnimation, forKey: "circleRotationAnimation")

            CATransaction.commit()
        }

        @objc func viewWillEnterForeground(_: Notification) {
            if let _ = window, isAnimating {
                addAnimation()
            }
        }
    }
}

extension ArrowProgressView: RefreshControlView {
    func willRefresh() {
        circleView.setProgress(1.0)
        circleView.startAnimating()
    }

    func didRefresh() {
        circleView.setProgress(0.0)
        circleView.stopAnimating()
    }

    func didScroll(_ progress: RefreshControl.Progress) {
        circleView.setProgress(progress.value)
    }
}
