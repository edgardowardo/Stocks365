//
//  StockViewController.swift
//  Ticker365
//
//  Created by EDGARDO AGNO on 16/07/2024.
//

import UIKit

class StockViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel: StockViewModel!
    private var stockEmitter: StockEmitter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupViewModel()
        setupStockEmitter()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 80) // Adjust height to fit content
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StockCell.self, forCellWithReuseIdentifier: "StockCell")
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        // Set up constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel = StockViewModel()
        viewModel.onUpdate = { [weak self] (stock, index, isChanged) in
            guard let cell = self?.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? StockCell 
                else { return }
            cell.configure(with: stock, isChanged: isChanged)
        }
        
        if let filePath = Bundle.main.path(forResource: "snapshot", ofType: "csv") {
            viewModel.loadStocks(from: filePath)
        }
    }
    
    private func setupStockEmitter() {
        if let deltasFilePath = Bundle.main.path(forResource: "deltas", ofType: "csv") {
            stockEmitter = StockEmitter(filePath: deltasFilePath)
            stockEmitter.start(emittingTo: viewModel)
        }
    }
}

extension StockViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfStocks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockCell", for: indexPath) as! StockCell
        let stock = viewModel.getStock(at: indexPath.row)
        cell.configure(with: stock)
        return cell
    }
}
