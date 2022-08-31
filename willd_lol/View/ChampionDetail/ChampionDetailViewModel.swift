//
//  ChampionDetailViewModel.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/12.
//

import Foundation
import RxSwift
import RxCocoa
import Then



struct ChampionDetailViewModel {
    let disposeBag = DisposeBag()
    let repository : ChampionDetailRepository
    let skinViewModel : SkinsViewModel    = SkinsViewModel()
    let tagsViewModel : TagsViewModel     = TagsViewModel()
    let skillsViewModel : SkillsViewModel = SkillsViewModel()
    let loreViewModel : LoreViewModel     = LoreViewModel()
    let lankViewModel : LankViewModel     = LankViewModel()
    let commentViewModel : CommentViewModel = CommentViewModel()
    
    let detailPageData : Driver<[ChampionDetailPageDataModel]>
    
    init(champion : Champion) {
        repository = ChampionDetailRepository(champion: champion)
            
            repository.getSkins(champion: champion)
                .bind(to: skinViewModel.skins)
                .disposed(by: disposeBag)
    
            
            repository.getTags()
                .bind(to: tagsViewModel.tags)
                .disposed(by: disposeBag)
            
            repository.getSkills()
                .bind(to: skillsViewModel.skills)
                .disposed(by: disposeBag)
            
            repository.getLore()
                .bind(to: loreViewModel.lore)
                .disposed(by: disposeBag)
            
            repository.getPlayerLank(champion: champion)
                .bind(to: lankViewModel.lank)
                .disposed(by: disposeBag)
            
            repository.getComment(champion: champion)
                .bind(to: commentViewModel.comment)
                .disposed(by: disposeBag)
            
            
            self.detailPageData = Observable
                .combineLatest(
                    skinViewModel.skins.asObservable(),
                    tagsViewModel.tags.asObservable(),
                    skillsViewModel.skills.asObservable(),
                    loreViewModel.lore.asObservable(),
                    lankViewModel.lank.asObservable(),
                    commentViewModel.comment.asObservable()) { a, b, c, d, e, f -> [ChampionDetailPageDataModel] in
                        let result : [ChampionDetailPageDataModel] = [
                            .skins(nil, a),
                            .tags(nil, b),
                            .skills("Skills", c),
                            .lore("Story", d),
                            .playerLank("Rank", e),
                            .championComment("Comment", f)
                        ]
                        if a.isEmpty || b.isEmpty || c.isEmpty || d.isEmpty || e.isEmpty || f.isEmpty {
                            return []
                        } else {
                            return result
                        }
                    }
                    .asDriver(onErrorDriveWith: .empty())
    }
    
    init(
        championKey : String,
        championName : String) {
        repository = ChampionDetailRepository(championKey: championKey)
        
        repository.getSkins(championKey: championKey, championName: championName)
            .bind(to: skinViewModel.skins)
            .disposed(by: disposeBag)
        
        repository.getTags()
            .bind(to: tagsViewModel.tags)
            .disposed(by: disposeBag)
        
        repository.getSkills()
            .bind(to: skillsViewModel.skills)
            .disposed(by: disposeBag)
        
        repository.getLore()
            .bind(to: loreViewModel.lore)
            .disposed(by: disposeBag)
        
        repository.getPlayerLank(championKey: championKey)
            .bind(to: lankViewModel.lank)
            .disposed(by: disposeBag)
        
        repository.getComment(championKey: championKey)
            .bind(to: commentViewModel.comment)
            .disposed(by: disposeBag)
        
        
        self.detailPageData = Observable
            .zip(
                skinViewModel.skins.asObservable(),
                tagsViewModel.tags.asObservable(),
                skillsViewModel.skills.asObservable(),
                loreViewModel.lore.asObservable(),
                lankViewModel.lank.asObservable(),
                commentViewModel.comment.asObservable()) { a, b, c, d, e, f -> [ChampionDetailPageDataModel] in
                    let result : [ChampionDetailPageDataModel] = [
                        .skins(nil, a),
                        .tags(nil, b),
                        .skills("Skills", c),
                        .lore("Story", d),
                        .playerLank("Rank", e),
                        .championComment("Comment", f)
                    ]
                    if a.isEmpty || b.isEmpty || c.isEmpty || d.isEmpty || e.isEmpty || f.isEmpty {
                        return []
                    } else {
                        return result
                    }
                }
                .asDriver(onErrorDriveWith: .empty())
    }
}
