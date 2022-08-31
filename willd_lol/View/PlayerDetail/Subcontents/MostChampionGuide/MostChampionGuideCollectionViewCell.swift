//
//  MostChampionCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/20.
//
import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then



class MostChampionGuideCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let backView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    let laneImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 8
        $0.distribution = .equalCentering
    }
    
    let laneNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight : .bold)
    }
    
    let matchImfoLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight : .light)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(_ viewModel : MostChampionGuideViewModel) {
        viewModel.laneImageUrl
            .drive(self.laneImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.lane
            .drive(self.laneNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.matchInfo
            .drive(self.matchImfoLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            laneNameLabel,
            matchImfoLabel
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        
        [
            backView,
            laneImageView,
            infoStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        laneImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(laneImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(laneImageView)
        }
        
    }
    
    
}
