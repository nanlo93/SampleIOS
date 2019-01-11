//
//  SideBarVC.swift
//  MemberManagement
//
//  Created by Shin on 30/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit

class SideBarVC: UITableViewController {

    let titles = ["메모 작성", "친구 새글", "달력 보기", "공지사항", "통계", "계정 관리"]
    let icons = [UIImage(named: "icon01.png"),
                 UIImage(named: "icon02.png"),
                 UIImage(named: "icon03.png"),
                 UIImage(named: "icon04.png"),
                 UIImage(named: "icon05.png"),
                 UIImage(named: "icon06.png")]
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        headerView.backgroundColor = UIColor.brown
        self.tableView.tableHeaderView = headerView
        
        nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        nameLabel.text = "신준호"
        self.nameLabel.backgroundColor = UIColor.clear
        headerView.addSubview(nameLabel)
        
        emailLabel.frame = CGRect(x: 70, y: 45, width: 200, height: 30)
        emailLabel.text = "jhshin7551@naver.com"
        self.emailLabel.backgroundColor = UIColor.clear
        headerView.addSubview(emailLabel)
        
        let defaultProfile = UIImage(named: "이력서사진.JPG")
        profileImage.image = defaultProfile
        profileImage.frame = CGRect(x: 10, y: 22, width: 50, height: 50)
        //네모난 이미지 뷰를 둥글게 만들기
        profileImage.layer.cornerRadius = (profileImage.frame.width/2)
        profileImage.layer.masksToBounds = true
        headerView.addSubview(profileImage)
    }

    // MARK: - Table view data source
    //섹션의 갯수를 설정하는 메소드
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //행의 갯수를 설정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    //셀을 만드는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]

        return cell
    }
    
    //셀을 선택했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
            //사이드 바의 네비게이션 컨트롤러를 찾아오기
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            //화면 출력
            target.pushViewController(uv, animated: true)
            //사이드 바 제거
            self.revealViewController()?.revealToggle(self)
        }else if indexPath.row == 5{
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            let target = self.revealViewController()?.frontViewController as! UINavigationController
            //화면 출력
            target.pushViewController(uv, animated: true)
            //사이드 바 제거
            self.revealViewController()?.revealToggle(self)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
