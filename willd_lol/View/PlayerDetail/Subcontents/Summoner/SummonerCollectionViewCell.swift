//
//  SummonerCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/20.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then



class SummonerCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    let playerNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let rankStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
        $0.distribution = .equalCentering
    }
        
    let rankLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    let tierLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let lpLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    let rateLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    
    let kdaLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    
    let tierImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(_ viewModel : SummonerViewModel) {
        
        viewModel.profileImageUrl
            .drive(self.profileImageView.rx.setImage)
            .disposed(by: disposeBag)
        
        viewModel.playerName
            .drive(self.playerNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.rank
            .drive(self.rankLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tier
            .drive(self.tierLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lp
            .drive(self.lpLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.rate
            .drive(self.rateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tierImageUrl
            .drive(self.tierImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            rankLabel,
            tierLabel,
            lpLabel,
            rateLabel,
            kdaLabel
        ].forEach {
            rankStackView.addArrangedSubview($0)
        }
        
        [
            profileImageView,
            playerNameLabel,
            rankStackView,
            tierImageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        
        profileImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.leading.top.equalToSuperview().inset(24)
        }
        
        playerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImageView)
        }
        
        
        rankStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.leading.equalTo(profileImageView)
        }
        
        tierImageView.snp.makeConstraints {
            $0.width.height.equalTo(124)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(rankStackView)
        }
        
        
        
        
    }
    
    
}
