//
//  BISearchResultTableViewController.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/4.
//  Copyright © 2018 EF Education. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class BISearchResultTableViewController: UIViewController {
    var viewModel: BIHomeViewModel!
    let tableView:UITableView = {
        let tv = UITableView()
        
        return tv
    }()

    var searchBar: UISearchBar!
    let bag = DisposeBag()
    var published = PublishSubject<[BIItemCellModel]>()
    var observableResults: Observable<[BIItemCellModel]> = Observable.of([])

    func bindToPublished() {
        guard let product = self.viewModel.product else {
            return
        }
        observableResults = searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query) -> Observable<[BIItemCellModel]> in
                if query.isEmpty {
                    return .just([])
                }
                let models = product.data.filter({ (datum) -> Bool in

                    datum.symbol.lowercased().contains(query.lowercased())
                }).map({ (datum) -> BIItemCellModel in
                    BIItemCellModel(datum: datum)
                })
                return Observable.of(models)
            }
        observableResults.bind(to: published)
            .disposed(by: bag)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            return
        }

        viewModel = BIHomeViewModel(success: {
            self.bindToPublished()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nib = UINib(nibName: "BIItemCell", bundle: nil)
        view.addSubview(tableView)
        tableView.register(nib, forCellReuseIdentifier: "ItemCell")
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.black
        
        viewModel = BIHomeViewModel(success: {
            self.published.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "ItemCell")) {
                (_, item: BIItemCellModel, cell: BIItemCell) in
                cell.configure(with: item)
            }.disposed(by: self.bag)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


