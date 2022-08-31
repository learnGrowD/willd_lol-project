//
//  SearchListViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Then
import Kingfisher
import SnapKit



class SearchTableViewCell : UITableViewCell {
    let disposeBag = DisposeBag()
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 14, weight: .bold)
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
    
    
    func bind(index : IndexPath, _ viewModel : SearchTableViewCellViewModel) {
        viewModel.bind(index: index)
        
        viewModel.profileImageUrl?
            .drive(profileImageView.rx.setImage)
            .dispose()
        
        viewModel.summonerName?
            .drive(nameLabel.rx.text)
            .dispose()
        
        viewModel.summonerTier?
            .drive(tierLabel.rx.text)
            .dispose()
    }
    
    private func attribute() {
        contentView.backgroundColor = .willdBlack
    }
    
    private func layout() {
        [
            nameLabel,
            tierLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
            
        [
            profileImageView,
            stackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(64)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(18)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        
        
    }
    
}
