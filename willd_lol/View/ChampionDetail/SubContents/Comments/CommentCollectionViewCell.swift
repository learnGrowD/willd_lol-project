//
//  CommentCell.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit



class CommentCollectionViewCell : UICollectionViewCell {
    let disposeBag = DisposeBag()
    let nameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let backView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    }
        
    let contentLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .light)
    }
    let voteLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let voteImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .darkGray
        $0.image = UIImage(systemName: "hand.thumbsup.fill")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }
     
     
    func bind(index : IndexPath,_ viewModel : CommentViewModel) {
        
        let row = Observable.just(index.row)
        let comment = row
            .flatMapLatest { row in
                viewModel.comment
                    .filter { $0.count != 0 }
                    .map {
                        $0[row]
                    }
            }
        comment
            .bind(onNext : { [weak self] in
                guard let self = self else { return }
                self.nameLabel.text = $0.user.username
                self.contentLabel.text = $0.content
                self.voteLabel.text = String(describing: $0.vote ?? 0)
            })
            .disposed(by: disposeBag)
         
     }
     
     private func attribute() {
        
     }
     
     private func layout() {
         [
            backView,
            voteLabel,
            nameLabel,
            contentLabel,
            voteImageView
            
         ].forEach {
             contentView.addSubview($0)
         }
         
         backView.snp.makeConstraints {
             $0.edges.equalToSuperview()
         }
         
         voteLabel.snp.makeConstraints {
             $0.trailing.equalToSuperview().offset(-24)
             $0.centerY.equalToSuperview()
         }
         
         voteImageView.snp.makeConstraints {
             $0.width.height.equalTo(24)
             $0.bottom.equalTo(voteLabel.snp.top).offset(-4)
             $0.trailing.equalToSuperview().offset(-24)
         }
         
         nameLabel.snp.makeConstraints {
             $0.leading.top.equalToSuperview().inset(18)
         }
         contentLabel.snp.makeConstraints {
             $0.top.equalTo(nameLabel.snp.bottom).offset(8)
             $0.leading.equalTo(nameLabel)
             $0.trailing.equalTo(voteLabel.snp.leading).offset(-24)
             $0.bottom.lessThanOrEqualToSuperview().inset(18)
         }
    
     }
}
