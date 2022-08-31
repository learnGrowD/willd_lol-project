//
//  SearchDetailViewController.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/23.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit



class SearchDetailViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let tableView = UITableView().then {
        $0.backgroundColor = .willdBlack
        $0.rowHeight = 96
        $0.contentInset = .init(top: 0, left: 0, bottom: 18, right: 0)
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : SearchDetailViewModel) {
        viewModel.bind()
        searchBar.bind(viewModel.searchBarViewModel)
        
        viewModel.searchTableViewCellViewModel.searchListData
            .asObservable()
            .bind(to : self.tableView.rx.items) { tv, row, data in
                print("\(row)####################################################################################################################################")
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: index) as! SearchTableViewCell
                cell.bind(index: index, viewModel.searchTableViewCellViewModel)
                return cell
            }
            .disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(SearchPreview.self)
            .bind(onNext : { [weak self] data in
                let vc = PlayerDetailViewController().then {
                    let viewModel = PlayerDetailViewModel(playerName: data.name ?? "")
                    $0.hidesBottomBarWhenPushed = true
                    $0.view.backgroundColor = .willdBlack
                    $0.title = "소환사"
                    $0.bind(viewModel)
                }
                self?.show(vc, sender: nil)
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.searchBarViewModel.shouldLoadResult
            .bind(onNext : { [weak self] query in
                let vc = PlayerDetailViewController().then {
                    let viewModel = PlayerDetailViewModel(playerName: query)
                    $0.hidesBottomBarWhenPushed = true
                    $0.view.backgroundColor = .willdBlack
                    $0.title = "소환사"
                    $0.bind(viewModel)
                }
                self?.show(vc, sender: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            searchBar,
            tableView
        ].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(18)
            $0.trailing.leading.bottom.equalToSuperview()
        }
    }
    
}
