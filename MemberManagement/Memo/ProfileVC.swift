//
//  ProfileVC.swift
//  MemberManagement
//
//  Created by Shin on 03/12/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //이미지 뷰와 테이블 뷰 인스턴스 생성
    let profileImage = UIImageView()
    let tv = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //배경 이미지 설정
        let bg = UIImage(named: "profile-bg")
        let bgimg = UIImageView(image: bg)
        bgimg.frame.size = CGSize(width: bgimg.frame.width, height: bgimg.frame.height)
        bgimg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        //이미지 뷰의 옵션 설정
        bgimg.layer.cornerRadius = bgimg.frame.size.width / 2
        bgimg.layer.borderWidth = 0
        bgimg.layer.masksToBounds = true
        
        self.view.addSubview(bgimg)
        
        //프로필 이미지를 저장할 이미지 뷰를 만들어서 배치
        let image = UIImage(named: "이력서사진.JPG")
        self.profileImage.image = image
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        //이미지 뷰 모양 변경
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        self.view.addSubview(profileImage)
        
        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.height + 20, width: self.view.frame.width, height: 100)
        self.tv.dataSource = self
        self.tv.delegate = self
        self.view.addSubview(self.tv)
    }
    //테이블 뷰 출력 관련 메소드
    //섹션별 행의 갯수를 설정하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //셀을 만들어주는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = "신준호"
        case 1:
            cell.textLabel?.text = "이메일"
            cell.detailTextLabel?.text = "jhshin7551@naver.com"
        
        default:
            ()
        }
        return cell
    }
}
