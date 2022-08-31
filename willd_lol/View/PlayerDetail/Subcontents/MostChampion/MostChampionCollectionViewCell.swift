//
//  MostChampionViewController.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import Kingfisher
import SnapKit


class MostChampionCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    
    let backView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    let championImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let championNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight : .bold)
    }
    
    
    let winRateLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight : .light)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
        
    }
    
    func bind(index : IndexPath, _ viewModel : MostChampionViewModel) {
        viewModel.bind(index: index)
        
        viewModel.championImageUrl?
            .drive(self.championImageView.rx.setImage)
            .disposed(by: disposeBag)
        
        viewModel.championName?
            .drive(self.championNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.winRate?
            .drive(winRateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    private func attribute() {
        
    }
    
    
    private func layout() {
        [
            backView,
            championImageView,
            championNameLabel,
            winRateLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        championImageView.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
        }
        
        championNameLabel.snp.makeConstraints {
            $0.top.equalTo(championImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(18)
        }
        
        winRateLabel.snp.makeConstraints {
            $0.top.equalTo(championNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(championNameLabel)
        }
        
    }
    

    
}
