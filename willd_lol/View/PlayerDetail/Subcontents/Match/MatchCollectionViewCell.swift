//
//  MatchCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/20.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit



class MatchCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let backView = UIView().then {
        $0.alpha = 0.1
        $0.layer.cornerRadius = 8
    }
    
    let resultLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let gameTimeLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 12, weight: .light)
        $0.alpha = 0.7
    }
    
    let championImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let laneImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 4
        $0.distribution = .equalCentering
    }
    
    let kdaInfoLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    let csInfoLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    let killpointLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(index : IndexPath, _ viewModel : MatchViewModel) {
        viewModel.bind(index: index)
        
        viewModel.resultColor?
            .drive(self.backView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.result?
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.resultColor?
            .drive(resultLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.laneImage?
            .drive(laneImageView.rx.image)
            .disposed(by: disposeBag)
        
        
        viewModel.gameTime?
            .drive(gameTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.championImageUrl?
            .drive(championImageView.rx.setImage)
            .disposed(by: disposeBag)
        
        viewModel.kdaInfo?
            .drive(kdaInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.csInfo?
            .drive(csInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.killPoint?
            .drive(killpointLabel.rx.text)
            .disposed(by: disposeBag)
            
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            killpointLabel,
            kdaInfoLabel,
            csInfoLabel
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        [
            backView,
            championImageView,
            laneImageView,
            resultLabel,
            gameTimeLabel,
            infoStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        laneImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(18)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(laneImageView)
            $0.leading.equalTo(laneImageView.snp.trailing).offset(4)
        }
        
        championImageView.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.top.equalTo(laneImageView.snp.bottom).offset(8)
            $0.leading.equalTo(laneImageView)
        }

        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(championImageView.snp.trailing).offset(18)
            $0.centerY.equalTo(championImageView)
        }
        
        gameTimeLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(laneImageView)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        
    }
    
    
}
