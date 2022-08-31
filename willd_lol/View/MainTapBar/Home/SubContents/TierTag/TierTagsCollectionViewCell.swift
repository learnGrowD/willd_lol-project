//
//  TierTagsCollectionViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/18.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class TierTagsCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let tierImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    let tierLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    let laneImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let laneLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    let traslateInfoButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
    }
    
    let traslateInfoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .willdWhite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(_ viewModel : TierTagViewModel) {
        viewModel.tier
            .map {
                switch $0 {
                case.etc:
                    return "브실골"
                case.platinum:
                    return "플레티넘"
                case.diamond:
                    return "다이아몬드"
                case.master:
                    return "마스터"
                }
            }
            .drive(self.tierLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tier
            .map {
                switch $0 {
                case.etc:
                    return UIImage(named: "Emblem_Gold")!
                case.platinum:
                    return UIImage(named: "Emblem_Platinum")!
                case.diamond:
                    return UIImage(named: "Emblem_Diamond")!
                case.master:
                    return UIImage(named: "Emblem_Master")!
                }
            }
            .drive(tierImageView.rx.image)
            .disposed(by: disposeBag)
        
        
        
        
        viewModel.playerLane
            .map {
                switch $0 {
                case.top:
                    return "탑"
                case.jungle:
                    return "정글"
                case.mid:
                    return "미드"
                case.bottom:
                    return "바텀"
                case.supporter:
                    return "서포터"
                }
            }
            .drive(self.laneLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.playerLane
            .map {
                
                switch $0 {
                case.top:
                    return UIImage(named: "Position_Diamond-Top")!
                case.jungle:
                    return UIImage(named: "Position_Diamond-Jungle")!
                case.mid:
                    return UIImage(named: "Position_Diamond-Mid")!
                case.bottom:
                    return UIImage(named: "Position_Diamond-Bot")!
                case.supporter:
                    return UIImage(named: "Position_Diamond-Support")!
                }
            }
            .drive(laneImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            tierImageView,
            tierLabel,
            laneImageView,
            laneLabel,
            traslateInfoButton,
            traslateInfoImageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        tierImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.centerY.equalToSuperview()
        }
        
        tierLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(tierImageView)
            $0.leading.equalTo(tierImageView.snp.trailing).offset(8)
        }
        
        laneImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalTo(tierLabel.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        laneLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(laneImageView)
            $0.leading.equalTo(laneImageView.snp.trailing).offset(8)
        }
        
        
        traslateInfoImageView.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-18)
            $0.centerY.equalToSuperview()
        }
        
        traslateInfoButton.snp.makeConstraints {
            $0.top.bottom.equalTo(traslateInfoImageView)
            $0.trailing.equalTo(traslateInfoImageView.snp.leading).offset(-8)
        }
        
        
        
    }
}
