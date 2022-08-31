//
//  RecommendCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/17.
//

import Foundation
import RxSwift
import RxCocoa
import Then
import Kingfisher
import SnapKit
import UIKit


class RecommendCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let championImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
        $0.alpha = 0.5
    }
    
    let championNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 18, weight : .bold)
    }
    
    let laneLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight : .light)
    }
    

    let directionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 18
        $0.distribution = .equalCentering
    }
    
    let directionLabels : [UILabel] = [
        UILabel().then {
            $0.text = "픽률"
            $0.textColor = . willdWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        },
        
        UILabel().then {
            $0.text = "승률"
            $0.textColor = . willdWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        },
        
        UILabel().then {
            $0.text = "밴율"
            $0.textColor = . willdWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
    ]

    let beforeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 18
        $0.distribution = .equalCentering
    }
    
    let beforeLabels : [UILabel] = (0...3).map { _ in
        UILabel().then {
            $0.textColor = .willdWhite
            $0.font = .systemFont(ofSize: 16)
        }
    }

    let nowStackVIew = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 18
        $0.distribution = .equalCentering
    }
    
    let nowLabels : [UILabel] = (0...3).map { _ in
        UILabel().then {
            $0.textColor = .willdWhite
            $0.font = .systemFont(ofSize: 16, weight : .bold)
        }
    }

    let diffStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 18
        $0.distribution = .equalCentering
    }
    
    let diffLabels : [UILabel] = (0...2).map { _ in
        UILabel().then {
            $0.font = .systemFont(ofSize: 16)
        }
    }
    

    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(row : Observable<Int> ,_ viewModel : RecommendViewModel) {
        let recommend = row
            .flatMapLatest { row in
                viewModel.championRecommendList.map { recommendList in
                    recommendList[row]
                }
            }
        

        
        recommend
            .bind(onNext : { [weak self] in
                guard let self = self else { return }
                self.championImageView.kf.setImage(with: UrlConverter.convertChampionImgUrl(
                    type: .full,
                    championKey: $0.champion.championKey,
                    skinIdentity: 0
                ))
                
                self.championNameLabel.text = "\($0.champion.name ?? "")"
                self.laneLabel.text = "(\($0.lane ?? ""))"

                self.beforeLabels[0].text = "\($0.info.before.version ?? "") 패치"
                self.beforeLabels[1].text = "\($0.info.before.pickRate ?? 0.0)%"
                self.beforeLabels[2].text = "\($0.info.before.winRate ?? 0.0)%"
                self.beforeLabels[3].text = "\($0.info.before.banRate ?? 0.0)%"

                self.nowLabels[0].text = "→ \($0.info.now.version ?? "") 패치"
                self.nowLabels[1].text = "→ \($0.info.now.pickRate ?? 0.0)%"
                self.nowLabels[2].text = "→ \($0.info.now.winRate ?? 0.0)%"
                self.nowLabels[3].text = "→ \($0.info.now.banRate ?? 0.0)%"

                if $0.info.diff.pickRate ?? 0.0 < 0.0 {
                    self.diffLabels[0].text = "[ ↓ \($0.info.diff.pickRate ?? 0.0)% ]"
                    self.diffLabels[0].textColor = .systemRed
                } else {
                    self.diffLabels[0].text = "[ ↑ \($0.info.diff.pickRate ?? 0.0)% ]"
                    self.diffLabels[0].textColor = .green
                }
                
                if $0.info.diff.winRate ?? 0.0 < 0.0 {
                    self.diffLabels[1].text = "[ ↓ \($0.info.diff.winRate ?? 0.0)% ]"
                    self.diffLabels[1].textColor = .systemRed
                } else {
                    self.diffLabels[1].text = "[ ↑ \($0.info.diff.pickRate ?? 0.0)% ]"
                    self.diffLabels[1].textColor = .green
                }
                
                if $0.info.diff.banRate ?? 0.0 < 0.0 {
                    self.diffLabels[2].text = "[ ↓ \($0.info.diff.banRate ?? 0.0)% ] "
                    self.diffLabels[2].textColor = .systemRed
                } else {
                    self.diffLabels[2].text = "[ ↑ \($0.info.diff.pickRate ?? 0.0)% ]"
                    self.diffLabels[2].textColor = .green
                }
                
            })
            .disposed(by: disposeBag)
        

    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        directionLabels.forEach {
            directionStackView.addArrangedSubview($0)
        }
        
        beforeLabels.forEach {
            beforeStackView.addArrangedSubview($0)
        }
        
        nowLabels.forEach {
            nowStackVIew.addArrangedSubview($0)
        }
        
        diffLabels.forEach {
            diffStackView.addArrangedSubview($0)
        }
        
        [
            championImageView,
            championNameLabel,
            laneLabel,
            directionStackView,
            beforeStackView,
            nowStackVIew,
            diffStackView
        ].forEach {
            contentView.addSubview($0)
        }
            
        championImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        championNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        laneLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(championNameLabel)
            $0.leading.equalTo(championNameLabel.snp.trailing)
        }
        
        directionStackView.snp.makeConstraints {
            $0.top.equalTo(championNameLabel.snp.bottom).offset(48)
            $0.leading.equalTo(championNameLabel)
            
        }
        
        beforeStackView.snp.makeConstraints {
            $0.leading.equalTo(directionStackView.snp.trailing).offset(12)
            $0.bottom.equalTo(directionStackView)
            
        }
        
        nowStackVIew.snp.makeConstraints {
            $0.leading.equalTo(beforeStackView.snp.trailing).offset(4)
            $0.bottom.equalTo(directionStackView)
        }
        
        diffStackView.snp.makeConstraints {
            $0.leading.equalTo(nowStackVIew.snp.trailing).offset(4)
            $0.bottom.equalTo(directionStackView)
        }
    }
}
