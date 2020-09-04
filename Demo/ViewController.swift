//
//  ViewController.swift
//  Demo
//
//  Created by hirotaka on 2020/09/04.
//  Copyright © 2020 hiro. All rights reserved.
//

import UIKit
import RefreshControlKit

class ViewController: UIViewController {
    @RefreshControlling(wrappedValue: nil, view: ArrowProgressView(), configuration: .init(layout: .bottom, trigger: .init(height: nil, event: .dragging)))
    @IBOutlet private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let className = UICollectionViewCell.self
        let name = String(describing: className)

        collectionView.register(className, forCellWithReuseIdentifier: name)

        collectionView.delegate = self
        collectionView.dataSource = self

        $collectionView.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: floor(collectionView.bounds.width / 3) - 1, height: 200)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }

    @objc private func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.$collectionView.endRefreshing()
        }
    }
}

extension ViewController: UICollectionViewDelegate {}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
}
