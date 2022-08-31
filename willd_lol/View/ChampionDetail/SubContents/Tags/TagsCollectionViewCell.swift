//
//  TagCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit


class TagsCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    let tagLabel = UILabel().then {
        $0.backgroundColor = .black
        $0.textColor = .willdWhite
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
     
     
    func bind(index : IndexPath, _ viewModel : TagsViewModel) {
        let row = Observable.just(index.row)
        let tag = row
            .flatMapLatest { row in
                viewModel.tags
                    .filter { $0.count != 0 }
                    .map { tags in
                        tags[row]
                    }
            }
        
        tag
            .bind(onNext : { [weak self] in
                self?.tagLabel.text = $0
            })
            .disposed(by: disposeBag)
     }
     
     private func attribute() {
         
     }
     
     private func layout() {
         [tagLabel].forEach {
             contentView.addSubview($0)
         }
         tagLabel.snp.makeConstraints {
             $0.edges.equalToSuperview()
         }
     }
}
