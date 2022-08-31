//
//  SkinCollectionView.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit


class SkinsCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    let skinName = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    func bind(index : IndexPath, _ viewModel : SkinsViewModel) {
        let row = Observable.just(index.row)
        let skin = row
            .flatMapLatest { row in
                viewModel.skins
                    .filter { $0.count != 0 }
                    .map { skins in
                        skins[row]
                    }
            }
        
        skin
            .bind(onNext : { [weak self] in
                self?.imageView.kf.setImage(with: UrlConverter.convertChampionImgUrl(
                    type: .full,
                    championKey: $0.championIdentity,
                    skinIdentity: $0.skinIdentity
                )
                
            )
                self?.skinName.text = $0.skinName
            })
            .disposed(by: disposeBag)
    }

    private func attribute() {
        
    }

    private func layout() {
        [imageView, skinName].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        skinName.snp.makeConstraints {
            $0.bottom.trailing.equalTo(imageView).inset(12)
        }

    }
    
}
