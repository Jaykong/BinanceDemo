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
    let viewModel = HomeViewModel()
    let tableView = UITableView()
    var searchBar: UISearchBar!
    let bag = DisposeBag()
    var observableResults: Observable<[ItemCellModel]>!
    override func didMove(toParentViewController parent: UIViewController?) {

        observableResults = searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query) -> Observable<[ItemCellModel]> in
                if query.isEmpty {
                    return .just([])
                }
                let models = self.viewModel.product.data.filter({ (datum) -> Bool in
                    datum.symbol.contains(query)
//                    datum.quoteAsset.rawValue == query
                }).map({ (datum) -> ItemCellModel in
                    ItemCellModel(datum: datum)
                })
//                print(models)
                print(query)
                return Observable.of(models)
            }
        
        observableResults.bind(to: tableView.rx.items(cellIdentifier: "ItemCell")) {
            (_, item: ItemCellModel, cell: BIItemCell) in
            cell.configure(with: item)
            }.disposed(by: bag)

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
