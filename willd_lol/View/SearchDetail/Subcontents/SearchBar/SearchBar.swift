//
//  SearchBar.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then


class SearchBar : UIView {
    let disposeBag = DisposeBag()
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "소환사를 검색해 보세요 : )"
        $0.searchTextField.textColor = .willdWhite
        $0.barTintColor = .willdBlack
    }
    let searchButton = UIButton().then {
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.willdWhite, for: .normal)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(_ viewModel : SearchBarViewModel) {
        searchBar.rx.text
            .bind(to: viewModel.query)
            .disposed(by: disposeBag)
        
        
        
        
        Observable
            .merge(
                searchButton.rx.tap.asObservable(),
                searchBar.rx.searchButtonClicked.asObservable()
            )
            .bind(to: viewModel.tap)
            .disposed(by: disposeBag)
    
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            searchButton,
            searchBar
        ].forEach {
            addSubview($0)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-4)
        }
    }
    
    
}
