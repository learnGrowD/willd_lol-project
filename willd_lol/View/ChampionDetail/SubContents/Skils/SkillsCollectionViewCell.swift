//
//  SkillsCell.swift
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
import Kingfisher



class SkillsCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    let skillKey = UILabel().then {
        $0.textColor = .willdWhite
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let skillImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 4
    }
    
    let skillNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12)
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
     
     
    func bind(index : IndexPath, _ viewModel : SkillsViewModel) {
        let row = Observable.just(index.row)
        let skill = row
            .flatMapLatest { row in
                viewModel.skills
                    .filter { $0.count != 0 }
                    .map {
                        $0[row]
                    }
            }
        skill
            .bind(onNext : { [weak self] in
                self?.skillKey.text = $0.key ?? ""
                if $0.key == "P" {
                    self?.skillImageView.kf.setImage(with: UrlConverter.convertPassiveImgUrl(passiveIdentity: $0.image ?? ""), placeholder: UIImage(named: "skin_logo"))
                } else {
                    self?.skillImageView.kf.setImage(with: UrlConverter.convertSpellImgUrl(spellIdentity: $0.image ?? ""), placeholder: UIImage(named: "skin_logo"))
                }
                self?.skillNameLabel.text = $0.name
            })
            .disposed(by: disposeBag)
     }
     
     private func attribute() {
         
     }
     
     private func layout() {
         [
            skillImageView,
            skillKey,
            skillNameLabel
         ].forEach {
             contentView.addSubview($0)
         }
         skillKey.snp.makeConstraints {
             $0.top.leading.equalTo(skillImageView)
         }
         skillImageView.snp.makeConstraints {
             $0.width.height.equalTo(72)
             $0.top.centerX.equalToSuperview()
         }
         
         skillNameLabel.snp.makeConstraints {
             $0.top.equalTo(skillImageView.snp.bottom).offset(8)
             $0.centerX.equalToSuperview()
         }
         
         
     }
}
