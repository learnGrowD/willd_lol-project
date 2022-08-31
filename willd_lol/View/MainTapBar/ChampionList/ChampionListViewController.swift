//
//  ChampionListViewController.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/09.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


class ChampionListViewController : UIViewController {
    let disposeBag = DisposeBag()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .willdBlack
        $0.register(ChampionListViewCell.self, forCellWithReuseIdentifier: "ChampionListViewCell")
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : ChampionListViewModel) {
        viewModel.shouldPresedentChampionList
            .filter { !$0.isEmpty }
            .bind(to : self.collectionView.rx.items) { cv, row, data in
                let index = IndexPath(row: row, section: 0)
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: "ChampionListViewCell", for: index) as? ChampionListViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(data: data)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Champion.self)
            .bind(to: self.rx.translateChampionDetailScreen)
            .disposed(by: disposeBag)
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 24, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func attribute() {
        collectionView.collectionViewLayout = generateLayout()
        
    }
    
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
