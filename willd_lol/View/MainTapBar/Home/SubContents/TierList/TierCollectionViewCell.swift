//
//  TierCollectionViewCell.swift
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


class TierCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let backView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    let numberLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight : .bold)
    }
    
    let opLabel = UILabel().then {
        $0.text = "OP"
        $0.textColor = .systemRed
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let championImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
    }
    
    let championNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14)
    }
    
    let tierLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 12, weight : .bold)
    }
    
    let pickRateImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.tintColor = .gray
        $0.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    let winRateImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.tintColor = .gray
        $0.image = UIImage(systemName: "w.circle.fill")
    }
    
    let banRateImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.tintColor = .gray
        $0.image = UIImage(systemName: "x.circle.fill")
    }
    
    
    let rateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let rateLabels = (0...2).map { _ in // 0 : pick , 1 : win, 2 : ban
        UILabel().then {
            $0.textColor = .willdWhite
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 11, weight: .bold)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(row : Observable<Int>, _ viewModel : TierListViewModel) {
        row
            .map {
                "\($0 + 1)"
            }
            .bind(to: self.numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        let tierInfo = row
            .flatMapLatest { row in
                viewModel.tierList
                    .map { tierList in
                        tierList[row]
                    }
            }
        
        
            
        
        tierInfo
            .bind(onNext : { [weak self] in
                guard let self = self else { return }
                self.championImageView.kf.setImage(with: UrlConverter.convertChampionImgUrl(
                    type: .small,
                    championKey: $0.championKey
                ))
                if $0.isOp == true {
                    self.opLabel.isHidden = false
                } else {
                    self.opLabel.isHidden = true
                }
                self.championNameLabel.text = $0.championName ?? ""
                self.tierLabel.text = "\($0.opTier ?? 0) 티어"
                if $0.opTier == 1 {
                    self.tierLabel.textColor = .purple
                } else if $0.opTier == 2 {
                    self.tierLabel.textColor = .systemBlue
                } else if $0.opTier == 3 {
                    self.tierLabel.textColor = .green
                } else if $0.opTier == 4 {
                    self.tierLabel.textColor = .yellow
                } else {
                    self.tierLabel.textColor = .gray
                }
                
                self.rateLabels[0].text = "\($0.pickRate ?? "")%" //pick
                self.rateLabels[1].text = "\($0.winRate ?? "")%" //win
                self.rateLabels[2].text = "\($0.banRate ?? "")%" //ban
            })
            .disposed(by: disposeBag)
        

    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        rateLabels.forEach {
            rateStackView.addArrangedSubview($0)
        }
        
        [
            backView,
            numberLabel,
            championImageView,
            championNameLabel,
            rateStackView,
            pickRateImageView,
            winRateImageView,
            banRateImageView,
            opLabel,
            tierLabel,
        ].forEach {
            contentView.addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        championImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
        }
        
        opLabel.snp.makeConstraints {
            $0.leading.top.equalTo(championImageView)
        }
        
        championNameLabel.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.top.equalTo(championImageView).offset(12)
            $0.leading.equalTo(championImageView.snp.trailing).offset(18)
        }
        
        tierLabel.snp.makeConstraints {
            $0.top.equalTo(championNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(championNameLabel)
        }
        
        
        rateStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-18)
            $0.leading.equalTo(tierLabel.snp.trailing).offset(24)
            $0.top.bottom.equalTo(tierLabel)
        }
        
        pickRateImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.bottom.equalTo(rateLabels[0].snp.top).offset(-8) //pick
            $0.centerX.equalTo(rateLabels[0].snp.centerX)
        }

        winRateImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.bottom.equalTo(rateLabels[1].snp.top).offset(-8) //win
            $0.centerX.equalTo(rateLabels[1].snp.centerX)
        }

        banRateImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.bottom.equalTo(rateLabels[2].snp.top).offset(-8) //ban
            $0.centerX.equalTo(rateLabels[2].snp.centerX)
        }
        
    }
}
