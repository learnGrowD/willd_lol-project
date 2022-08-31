//
//  SkillDetailViewController.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import AVFoundation
import AVKit
import Kingfisher


class SkillDetailViewController : UIViewController {
    let disposeBag = DisposeBag()

    let skillImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let skillKeyLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    let skillNameLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 20, weight : .bold)
    }
    let descriptionLabel = UILabel().then {
        $0.textColor = .willdWhite
        $0.font = .systemFont(ofSize: 16, weight : .light)
        $0.numberOfLines = 0
    }
    
    
    let videoView = UIView().then {
        $0.backgroundColor = .willdBlack
    }
    
    var player : AVPlayer!
    var avpContoller = AVPlayerViewController()

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func startVideo(url : URL?) {
        player = AVPlayer(url: url!)
        avpContoller.player = player
        avpContoller.view.frame.size.height = videoView.frame.size.height
        avpContoller.view.frame.size.width = videoView.frame.size.width
        self.videoView.addSubview(avpContoller.view)
        player.play()
    }
    
    
    func bind(_ viewModel : SkillDetailViewModel) {
        viewModel.skillImage
            .drive(onNext : { [weak self] in
                self?.skillImageView.kf
                    .setImage(with: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.skillKey
            .drive(skillKeyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.skillName
            .drive(skillNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.skillVideo
            .drive(onNext : { [weak self] in
                self?.startVideo(url : UrlConverter.convertVideoURl(championKey: $0.dataKey, of: $0.skillKey))
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
    
    }
    
    private func layout() {
        [
            skillImageView,
            skillKeyLabel,
            skillNameLabel,
            descriptionLabel,
            videoView
        ].forEach {
            view.addSubview($0)
        }
        
        skillImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(64)
            $0.leading.equalToSuperview().inset(24)
        }
        
        
        skillNameLabel.snp.makeConstraints {
            $0.leading.equalTo(skillImageView.snp.trailing).offset(24)
            $0.bottom.equalTo(skillImageView).offset(-12)
        }
        
        skillKeyLabel.snp.makeConstraints {
            $0.leading.equalTo(skillNameLabel)
            $0.bottom.equalTo(skillNameLabel.snp.top).offset(-8)
            
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(skillImageView.snp.bottom).offset(36)
            $0.leading.equalTo(skillImageView)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        videoView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    
    }
    
}

