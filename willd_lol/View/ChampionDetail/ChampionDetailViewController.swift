//
//  ChampionDetailViewController.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/11.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SwiftUI


class ChampionDetailViewController : UIViewController {
    let disposeBag = DisposeBag()
    var viewModel : ChampionDetailViewModel?
    var detailPageData : [ChampionDetailPageDataModel] = []
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .willdBlack
        $0.register(DefaultCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultCollectionViewHeader")
        $0.register(SkinsCollectionViewCell.self, forCellWithReuseIdentifier: "SkinsCollectionViewCell")
        $0.register(TagsCollectionViewCell.self, forCellWithReuseIdentifier: "TagsCollectionViewCell")
        $0.register(SkillsCollectionViewCell.self, forCellWithReuseIdentifier: "SkillsCollectionViewCell")
        $0.register(LoreCollectionViewCell.self, forCellWithReuseIdentifier: "LoreCollectionViewCell")
        $0.register(LankCollectionViewCell.self, forCellWithReuseIdentifier: "LankCollectionViewCell")
        $0.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: "CommentCollectionViewCell")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : ChampionDetailViewModel) {
        self.viewModel = viewModel
        
        collectionView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        
        viewModel.detailPageData
            .filter { !$0.isEmpty }
            .drive(onNext : { [weak self] data in
                self?.detailPageData = data
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(onNext : { [weak self] index in
                switch self?.detailPageData[index.section] {
                case.skills(_, let data):
                    let vc = SkillDetailViewController().then { vc in
                        let viewModel = SkillDetailViewModel(skill: data[index.row])
                        vc.view.backgroundColor = .willdBlack
                        vc.bind(viewModel)
                    }
                    let navVc = UINavigationController(rootViewController: vc)
                    self?.show(navVc, sender: nil)
                case.playerLank( _, let data):
                    let playerDeatilVc = PlayerDetailViewController().then {
                        let viewModel = PlayerDetailViewModel(playerName: data[index.row].summoner.name ?? "")
                        $0.hidesBottomBarWhenPushed = true
                        $0.title = data[index.row].summoner.name ?? ""
                        $0.view.backgroundColor = .willdBlack
                        $0.bind(viewModel)
                    }
                    self?.show(playerDeatilVc, sender: nil)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func attribute() {
        collectionView.collectionViewLayout = generateLayout()
    }
    
    func layout() {
        [collectionView].forEach {
            view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        

    }
}

//generateLayout....
extension ChampionDetailViewController {
    
    func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch self.detailPageData[sectionNumber] {
            case .skins( _,  _):
                return self.createSkinsLayout()
            case.tags( _, let data):
                return self.createTagsLayout(count: data.count)
            case.skills( _, _):
                return self.createSkillsLayout()
            case .lore(_, _):
                return self.createLoreLayout()
            case.playerLank( _,  _):
                return self.createLanksLayout()
            case.championComment( _, _):
                return self.createCommentsLayout()
            }
        }
    }
    
    private func createSkinsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging

        return section
    }
    
    private func createTagsLayout(count : Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24))
        
        var group : NSCollectionLayoutGroup
        if count == 2 {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count + 3)
        } else if count == 3 {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count + 2)
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        }
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 0, bottom: 64, trailing: 0)
        return section
        
    }
    
    private func createSkillsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.contentInsets = .init(top: 18, leading: 18, bottom: 64, trailing: 18)
        return section
    }
    
    private func createLoreLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(224))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(224))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.contentInsets = .init(top: 18, leading: 18, bottom: 64, trailing: 18)
        return section
        
    }
    
    private func createLanksLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 18, leading: 18, bottom: 64, trailing: 0)

        return section
    }
    
    private func createCommentsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 18
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.contentInsets = .init(top: 18, leading: 18, bottom: 64, trailing: 18)
        return section
        
    }
}


extension ChampionDetailViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return detailPageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch detailPageData[section] {
        case .skins( _, let data):
            return data.count
        case .tags( _, let data):
            return data.count
        case .skills( _, _):
            return 5
        case .lore( _, _):
            return 1
        case .playerLank( _, let data):
            return data.count
        case .championComment( _, let data):
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch detailPageData[indexPath.section] {
        case .skins( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinsCollectionViewCell", for: indexPath) as? SkinsCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(index : indexPath, viewModel.skinViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        case .tags( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as? TagsCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(index : indexPath, viewModel.tagsViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        case .skills( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillsCollectionViewCell", for: indexPath) as? SkillsCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(index : indexPath, viewModel.skillsViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        case .lore( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoreCollectionViewCell", for: indexPath) as? LoreCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(viewModel.loreViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        case .playerLank( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LankCollectionViewCell", for: indexPath) as? LankCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(index : indexPath, viewModel.lankViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        case .championComment( _, _):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCollectionViewCell", for: indexPath) as? CommentCollectionViewCell,
                  let viewModel = self.viewModel else {
                return UICollectionViewCell()
            }
            cell.bind(index: indexPath, viewModel.commentViewModel)
            cell.contentView.backgroundColor = .willdBlack
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind  == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultCollectionViewHeader", for: indexPath) as! DefaultCollectionViewHeader
                    switch detailPageData[indexPath.section] {
                    case.skins(let title, _):
                        header.configure(title: title)
                    case.tags(let title, _):
                        header.configure(title: title)
                    case.skills(let title, _):
                        header.configure(title: title)
                    case.lore(let title, _):
                        header.configure(title: title)
                    case.playerLank(let title, _):
                        header.configure(title: title)
                    case.championComment(let title, _):
                        header.configure(title: title)
                    }
            return header
        } else {
            return UICollectionReusableView()
        }
    }

}
