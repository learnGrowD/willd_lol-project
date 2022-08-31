//
//  DefaultCollectionViewHeader.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/17.
//

import Foundation
import UIKit


class DefaultCollectionViewHeader : UICollectionReusableView {
    let sectionNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func configure(title : String?) {
        sectionNameLabel.text = title
    }
    
    private func layout() {
        [sectionNameLabel].forEach {
            addSubview($0)
        }
        
        sectionNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}

func createHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24))
    let section = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    return section
}




