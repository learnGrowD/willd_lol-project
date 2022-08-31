//
//  PlayerDetailViewController.swift
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
import Alamofire

class PlayerDetailViewController : UIViewController {
    let disposeBag = DisposeBag()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .willdBlack
        $0.register(DefaultCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultCollectionViewHeader")
        $0.register(SummonerCollectionViewCell.self, forCellWithReuseIdentifier: "SummonerCollectionViewCell")
        $0.register(MostChampionGuideCollectionViewCell.self, forCellWithReuseIdentifier: "MostChampionGuideCollectionViewCell")
        $0.register(MostChampionCollectionViewCell.self, forCellWithReuseIdentifier: "MostChampionCollectionViewCell")
        $0.register(MatchCollectionViewCell.self, forCellWithReuseIdentifier: "MatchCollectionViewCell")
    }
    
    
    let activityIndicator = UIActivityIndicatorView().then {
        $0.color = .white
        $0.startAnimating()
    }
    
    let indicatorBackView = UIView().then {
        $0.backgroundColor = .willdBlack
        $0.isHidden = true
    }
    
    let alertLabel = UILabel().then {
        $0.text = "검색결과가 없습니다."
        $0.textAlignment = .center
        $0.isHidden = true
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 18, weight : .bold)
    }
    
    let alertImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(systemName: "exclamationmark.triangle.fill")
        $0.tintColor = .willdWhite
    }
    
    var playerDetailData : [PlayerDetailData] = []
    var viewModel : PlayerDetailViewModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(_ viewModel : PlayerDetailViewModel) {
        self.viewModel = viewModel
        
        
        viewModel.uiState
            .map {
                switch $0 {
                case.loading:
                    return false
                default:
                    return true
                }
            }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        
        
        
        viewModel.uiState
            .map {
                switch $0 {
                case.loading:
                    return false
                default:
                    return true
                }
            }
            .drive(indicatorBackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.uiState
            .map {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .drive(alertImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.uiState
            .map {
                switch $0 {
                case.invalid( _):
                    return false
                default:
                    return true
                }
            }
            .drive(alertLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.uiState
            .map {
                switch $0 {
                case.invalid(let msg):
                    return msg
                default:
                    return ""
                }
            }
            .drive(alertLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.playerDetailData
            .filter { !$0.isEmpty }
            .drive(onNext : { [weak self] in
                self?.playerDetailData = $0
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.collectionView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        
        
    }
    
    private func attribute() {
        collectionView.collectionViewLayout = generateLayout()
    }
    
    private func layout() {
        [
            collectionView,
            indicatorBackView,
            activityIndicator,
            alertLabel,
            alertImageView
        ].forEach {
            view.addSubview($0)
        }
            
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.center.equalToSuperview()
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(alertImageView)
        }
        
        
    }
}


//layout...
extension PlayerDetailViewController {
    
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch self.playerDetailData[sectionNumber] {
            case.summoner( _, _):
                return self.createSummnerLayout()
            case.mostChampionGuide( _, _):
                return self.createMostChampionGuideLayout()
            case.mostChampion( _, _):
                return self.createMostChampionLayout()
            case.match( _, _):
                return self.createMatchLayout()
            }
        }
    }
    
    
    private func createSummnerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 0, bottom: 80, trailing: 0)
        return section
    }
    
    private func createMostChampionGuideLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.contentInsets = .init(top: 18, leading: 18, bottom: 0, trailing: 18)

        return section
    }
    
    private func createMostChampionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 18
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 12, leading: 18, bottom: 80, trailing: 18)
        return section
    }
    
    private func createMatchLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeaderLayout()]
        section.interGroupSpacing = 24
        section.contentInsets = .init(top: 18, leading: 18, bottom: 0, trailing: 18)
        return section
        
    }
    
    
    
}


extension PlayerDetailViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return playerDetailData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch playerDetailData[section] {
        case.summoner( _, _):
            return 1
        case.mostChampionGuide( _, _):
            return 1
        case.mostChampion(_ , let data):
            return data.count
        case.match(_, let data):
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch playerDetailData[indexPath.section] {
        case.summoner( _, _):
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummonerCollectionViewCell", for: indexPath) as? SummonerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bind(viewModel.summonerViewModel)
            return cell
        case.mostChampionGuide( _, _):
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MostChampionGuideCollectionViewCell", for: indexPath) as? MostChampionGuideCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bind(viewModel.mostChampionGuideViewModel)
            return cell
        case.mostChampion(_ , _):
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MostChampionCollectionViewCell", for: indexPath) as? MostChampionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bind(index: indexPath, viewModel.mostChampionViewModel)
            return cell
        case.match(_, _):
            guard let viewModel = viewModel,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as? MatchCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bind(index: indexPath, viewModel.matchViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DefaultCollectionViewHeader", for: indexPath) as! DefaultCollectionViewHeader
            switch playerDetailData[indexPath.section] {
            case.summoner(let title, _):
                header.sectionNameLabel.text = title
            case.mostChampionGuide(let title, _):
                header.sectionNameLabel.text = title
            case.mostChampion(let title, _):
                header.sectionNameLabel.text = title
            case.match(let title, _):
                header.sectionNameLabel.text = title
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
}
