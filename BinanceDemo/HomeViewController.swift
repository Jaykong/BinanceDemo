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

    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.setup()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        cv.setup()
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
    
    var controller:BISearchResultTableViewController!
    
    // MARK: - Help Methods
    
    func cancelHandler() {
        searchBar.rx.cancelButtonClicked.subscribe(onNext: {
            self.addSearchBtn()
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Markets"
            self.removeChild(self.controller)
        }).disposed(by: disposeBag)
    }
    
    @objc func searchBtnClicked() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        addChild(controller)
        controller.searchBar = searchBar
    }
    
    func addSearchBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBtnClicked))
    }
    
  
    
    fileprivate func configureNavigation() {
        title = "Markets"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.nevada]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
        setStatusBarBackgroundColor(color: UIColor.black)

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
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    //MARK: - Refresh
    @objc func refreshDataum(rf: UIRefreshControl) {
        viewModel = HomeViewModel(success: {
            self.reloadTableView(at: self.segmenttitleView.seletedIndex)
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "BISearchResult", bundle: nil)
        controller = sb.instantiateInitialViewController() as! BISearchResultTableViewController
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

// MARK: - Collection View Delegate & DataSource

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
    func reloadTableView(at index:Int) {
        let title = viewModel.titles[index]
        let asset = QuoteAsset(rawValue: title)
        cellModels = viewModel.dataum(for: asset!)
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? BIHomeCollectionViewCell
        
        cell?.tableView.reloadData()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if type(of: scrollView) == UICollectionView.self {
            let index = Int(scrollView.contentOffset.x / view.bounds.size.width)
            segmenttitleView.updateIndicator(index: index)
           reloadTableView(at: index)
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
