//
//  ViewController.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import SnapKit
import UIKit
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        cv.isPagingEnabled = true
        let nib = UINib(nibName: "BIHomeCollectionViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        return cv
    }()
    
    var viewModel = HomeViewModel()
    var titleView: BITitleView!
    var cellModels: [ItemCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView = BITitleView(numberOfItems: viewModel.titles)
        titleView.delegate = self
        view.addSubview(titleView)
        titleView.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(topLayoutGuide.snp.bottom)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(titleView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.contentInset = UIEdgeInsetsMake(100, 0, 100, 0)
        cellModels = viewModel.dataum(for: .bnb)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! BIHomeCollectionViewCell
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.estimatedRowHeight = 66
        return cell
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if type(of: scrollView) == UICollectionView.self {
            let index = Int(scrollView.contentOffset.x / view.bounds.size.width)
            titleView.updateIndicator(index: index)
            let title = viewModel.titles[index]
            let asset = QuoteAsset(rawValue: title)
            cellModels = viewModel.dataum(for: asset!)
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? BIHomeCollectionViewCell
            cell?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! BIItemCell
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension HomeViewController: BITitleViewDelegate {
    func didSelectButton(at index: Int) {
        let width = view.bounds.size.width
        
        let y = collectionView.contentOffset.y
        switch index {
        case 0:
            collectionView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            
        case 1:
            collectionView.setContentOffset(CGPoint(x: width, y: y), animated: true)

        case 2:
            collectionView.setContentOffset(CGPoint(x: 2 * width, y: y), animated: true)

        case 3:
            collectionView.setContentOffset(CGPoint(x: 3 * width, y: y), animated: true)

        default:
            break
        }
    }
}
