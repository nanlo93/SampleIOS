//
//  MemoListVC.swift
//  MemberManagement
//
//  Created by Shin on 28/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    //AppDelegate에 대한 참조 변수
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //이벤트 처리에 사용할 메소드
    @objc func add(_ barButtonItem : UIBarButtonItem){
        //MemoFormVC 화면 출력하기
        let memoFormVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoFormVC") as! MemoFormVC
        memoFormVC.title = "메모작성"
        self.navigationController?.pushViewController(memoFormVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        //네비게이션 바의 오른쪽에 + 버튼 배치
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(MemoListVC.add(_:)))
    }
    
    //뷰가 출력될 때마다 호출되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //데이터를 코어데이터에서 가져오기
        let dao = MemoDAO()
        self.appDelegate.memoList = dao.fetch()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    //섹션의 갯수를 설정하는 메소드
    //없으면 1을 리턴
    //그룹화를 하지 않을 거라면 삭제 또는 1을 리턴
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //그룹 별 행의 갯수를 설정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.memoList.count
    }
    
    //셀을 설정하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //행 번호에 해당하는 데이터를 가져오기
        let memo = appDelegate.memoList[indexPath.row]
        //image 존재 여부에 따라 셀의 아이디를 설정
        let cellId = memo.image == nil ? "MemoCell" : "MemoCellWithImage"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        cell.subject.text = memo.title
        cell.contents.text = memo.contents
        //cell.regDate.text = memo.regdate
        //날짜를 원하는 형식의 문자열로 만들어주는 객체를 생성
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd(EEE) HH:mm:ss"
        cell.regDate.text = formatter.string(from: memo.regdate!)
        //어떤 경우에는 존재하고 어떤 경우에는 nil인 데이터를 사용할 때는 항상 ?를 사용해야 합니다. !는 안됩니다.
        cell.img?.image = memo.image
        return cell
    }
    
    //셀의 높이를 설정하는 메소드 재정의
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //셀을 선택했을 떄 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = appDelegate.memoList[indexPath.row]
        let memoReadVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoReadVC") as! MemoReadVC
        memoReadVC.memo = memo
        self.navigationController?.pushViewController(memoReadVC, animated: true)
    }
    
    //편집 기능을 실행할 때 보여질 버튼을 설정하는 메소드
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //편집 기능을 실행할 때 보여지는 버튼을 눌렀을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //행번호에 해당하는 데이터 찾아오기
        let data = self.appDelegate.memoList[indexPath.row]
        let dao = MemoDAO()
        //CoreData에서 삭제
        if dao.delete(data.objectID!){
            //메모리에서도 삭제
            self.appDelegate.memoList.remove(at: indexPath.row)
            //행번호에 해당하는 데이터를 삭제하는 애니메이션 수행
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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

extension MemoListVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        let dao = MemoDAO()
        self.appDelegate.memoList = dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
}
