//
//  PlayerRankCollectionViewCell.swift
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


class PlayerRankCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let backView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    let rankingLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let profileImageUrl = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    
    let tierStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    let tierImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let tierLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 12, weight: .light)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
    
    
    func bind(row : Observable<Int>, _ viewModel : PlayerLankViewModel) {
        row
            .map {
                "\($0 + 1)"
            }
            .bind(to: self.rankingLabel.rx.text)
            .disposed(by: disposeBag)
        
        let playerLank = row
            .flatMapLatest { row  in
                viewModel.playerRankList
                    .map { playerRankList in
                        playerRankList[row]
                    }
            }
        
        playerLank
            .bind(onNext : { [weak self] in
                guard let self = self else { return }
                self.profileImageUrl.kf.setImage(with: UrlConverter.convertImgUrl($0.imageUrl ?? ""))
                self.nameLabel.text = $0.displayName ?? ""
                
                let tier = $0.tier ?? ""
                self.tierLabel.text = "\(tier) (\($0.lp ?? 0)lp)"
                switch tier {
                case "Challenger":
                    self.tierImageView.image = UIImage(named: "Emblem_Challenger")
                case "Grandmaster":
                    self.tierImageView.image = UIImage(named: "Emblem_Grandmaster")
                case "Master":
                    self.tierImageView.image = UIImage(named: "Emblem_Master")
                case "Diamond":
                    self.tierImageView.image = UIImage(named: "Emblem_Diamond")
                case "Platinum":
                    self.tierImageView.image = UIImage(named: "Emblem_Platinum")
                case "Gold":
                    self.tierImageView.image = UIImage(named: "Emblem_Gold")
                case "Silver":
                    self.tierImageView.image = UIImage(named: "Emblem_Silver")
                case "Bronze":
                    self.tierImageView.image = UIImage(named: "Emblem_Bronze")
                case "Iron":
                    self.tierImageView.image = UIImage(named: "Emblem_Iron")
                default:
                    return
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            tierImageView,
            tierLabel
        ].forEach {
            tierStackView.addArrangedSubview($0)
        }
        
        [
            backView,
            rankingLabel,
            profileImageUrl,
            nameLabel,
            tierStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }
    
        profileImageUrl.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.top.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageUrl.snp.bottom).offset(12)
            $0.centerX.equalTo(profileImageUrl.snp.centerX)
            
        }
        
        tierImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        tierStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.centerX.equalTo(nameLabel)
        }
        
    }
}
