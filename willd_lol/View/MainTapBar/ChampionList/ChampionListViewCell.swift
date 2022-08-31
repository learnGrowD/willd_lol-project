//
//  ChampionListViewCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/10.
//

import Foundation
import UIKit
import Then
import SnapKit
import Kingfisher


class ChampionListViewCell : UICollectionViewCell {
    
    let imagView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight : .bold)
        $0.textColor = .willdWhite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func layout() {
        contentView.backgroundColor = .willdBlack
        [imagView, nameLabel].forEach {
            contentView.addSubview($0)
        }
        
        imagView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        
        }
        
        nameLabel.snp.makeConstraints {
            $0.trailing.bottom.equalTo(imagView).inset(12)
        }
    }
    
    func configure(data : ChampionListApi.Champion) {
        imagView.kf.setImage(with: UrlConverter.convertChampionImgUrl(type: .middle, championKey: data.key))
        nameLabel.text = data.name
        
    }
    
    
}
