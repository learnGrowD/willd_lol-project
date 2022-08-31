//
//  SearchCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit


class SearchCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    var isFirstBinding = true
    
    let searchButton = UIButton().then {
        if #available(iOS 15.0, *) {
            var filled = UIButton.Configuration.filled()
            filled.title = "소환사 검색"
            filled.buttonSize = .large
            filled.image = UIImage(systemName: "magnifyingglass")
            filled.imagePlacement = .leading
            filled.imagePadding = 8
            filled.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
            filled.baseBackgroundColor = .willdBlack
            $0.configuration = filled
        } else {
            $0.setTitle("소환사 검색", for: .normal)
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.tintColor = .lightGray
            $0.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
            $0.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        }
        $0.setTitleColor(.willdWhite, for: .normal)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .leading
        $0.alpha = 0.5
        
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    func bind(_ viewModel : SearchCollectionViewModel) {
        if isFirstBinding {
            searchButton.rx.tap
                .bind(to: viewModel.searchButtonTap)
                .disposed(by: disposeBag)
            isFirstBinding = false
        }
        

    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [searchButton].forEach {
            contentView.addSubview($0)
        }
        
        searchButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
