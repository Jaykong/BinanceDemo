//
//  ViewController.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import SVProgressHUD
import UIKit
class HomeViewController: UIViewController {
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor.white
        let nib = UINib(nibName: "BIHomeCollectionViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        
        return cv
    }()
    
    var viewModel: HomeViewModel!
    var segmenttitleView: BISegmentTitleView!
    var cellModels: [ItemCellModel] = []
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.showsCancelButton = true
        return sb
    }()
    let controller = BISearchResultTableViewController()

    //MARK: - Help Methods
    func cancelHandler() {
        searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self.addSearchBtn()
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Markets"
            self.removeChild()
        }).disposed(by: disposeBag)
    }
    
    func removeChild() {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func addChild() {
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.searchBar = searchBar
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    @objc func searchBtnClicked() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        addChild()
    }
    
    func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnClicked))
    }
    
    @objc func refreshDataum(rf: UIRefreshControl) {
        viewModel = HomeViewModel(success: {
            self.collectionView.reloadData()
        })
        
        rf.endRefreshing()
    }
    
    func createRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshDataum), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }
    
    fileprivate func configureNavigation() {
        title = "Markets"
        addSearchBtn()
        cancelHandler()
    }
    
    fileprivate func addSubviews() {
        segmenttitleView = BISegmentTitleView(numberOfItems: viewModel.titles)
        segmenttitleView.delegate = self
        view.addSubview(segmenttitleView)
        view.addSubview(collectionView)
    }
    
    fileprivate func addConstraints() {
        segmenttitleView.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(segmenttitleView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        viewModel = HomeViewModel(success: {
            SVProgressHUD.dismiss()
            self.cellModels = self.viewModel.dataum(for: .bnb)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self

        })
        
        configureNavigation()
        
        addSubviews()
        
        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: - Collection View Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! BIHomeCollectionViewCell
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.estimatedRowHeight = 66
        cell.tableView.refreshControl = createRefreshControl()
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: collectionView.bounds.size.height)
    }
}

// MARK: - Scroll view delegate

extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if type(of: scrollView) == UICollectionView.self {
            let index = Int(scrollView.contentOffset.x / view.bounds.size.width)
            segmenttitleView.updateIndicator(index: index)
            let title = viewModel.titles[index]
            let asset = QuoteAsset(rawValue: title)
            cellModels = viewModel.dataum(for: asset!)
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? BIHomeCollectionViewCell
            
            cell?.tableView.reloadData()
        }
    }
}

// MARK: - UITable ViewData Source & Delegate

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

// MARK: - Title View Delegate

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
