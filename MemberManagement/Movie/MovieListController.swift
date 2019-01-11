//
//  MovieListController.swift
//  MemberManagement
//
//  Created by Shin on 26/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit

class MovieListController: UITableViewController {
    
    //현재 출력중인 마지막 페이지 번호를 저장할 변수를 선언
    var page = 1
    
    //데이터를 다운로드 받는 메소드
    func download(){
        //URL을 생성해서 다운로드 받기
        //다운로드 받을 URL 만들기
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(page)&count=20&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        
        //REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        //데이터 전송 결과를 로그로 출력
        //        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        //        print("API Result=\( log )")
        
        //예외처리
        do{
            //전체 데이터를 디셔너리로 만들기
            let apiDict = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            //hoppin 키의 값을 디셔너리로 가져오기
            let hoppin = apiDict["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let ar = movies["movie"] as! NSArray
            //배열 순회
            for row in ar{
                let imsi = row as! NSDictionary
                var movie = MovieVO()
                movie.title = imsi["title"] as! String
                movie.genreNames = imsi["genreNames"] as! String
                movie.linkUrl = imsi["linkUrl"] as! String
                movie.ratingAverage = (imsi["ratingAverage"] as! NSString).doubleValue
                movie.thumbnailImage = imsi["thumbnailImage"] as! String
                //이미지 URL을 가지고 이미지 데이터를 다운로드 받아서 저장
                let url = URL(string: movie.thumbnailImage!)
                //데이터 다운로드
                let imageData = try Data(contentsOf: url!)
                //저장
                movie.image = UIImage(data: imageData)
                self.list.append(movie)
            }
            //            print(self.list)
            //테이블 뷰 재출력
            self.tableView.reloadData()
            
            //전체 데이터를 표시한 경우에는 refreshControl을 숨김
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            if totalCount <= self.list.count{
                self.refreshControl?.isHidden = true
                self.refreshControl = nil
            }
        }catch{
            print("파싱 예외 발생")
        }
    }
    
    //refreshControl이 화면에 보여질 때 호출될 메소드
    @objc func handleRequest(_ refreshControl : UIRefreshControl){
        //페이지 번호를 1 증가시키고 데이터를 다시 받아오기
        self.page = self.page + 1
        self.download()
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
    }
    
    //파싱한 결과를 저장할 List 변수 - 지연생성 이용
    //지연생성 - 처음부터 만들어두지 않고 처음 사용할 때 생성
    lazy var list : [MovieVO] = {
        var dataList = [MovieVO]()
        return dataList
    }()
    
    //인덱스에 해당하는 UIImage를 리턴하는 메소드
    func getThemnailImage(_ index : Int) -> UIImage{
        //배열에서 인덱스에 해당하는 데이터 가져오기
        var movie = self.list[index]
        //이미지가 있으면 바로 리턴
        if let savedImage = movie.image{
            return savedImage
        }else{
            //이미지가 없으면 다운로드 받아서 리턴
            let url : URL! = URL(string: movie.thumbnailImage!)
            let imageData = try! Data(contentsOf: url)
            movie.image = UIImage(data: imageData)
            return movie.image!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "영화 목록"
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MovieListController.handleRequest(_:)), for: .valueChanged)
//        self.refreshControl?.tintColor = UIColor.red
        download()
    }
    
    //화면에 뷰가 보여질 때 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        //추상 메소드가 아니라면 항상 상위 클래스의 메소드를 호출하고 기능 추가
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table view data source
    
    //섹션의 갯수를 설정하는 메소드
    //없으면 1을 리턴한 것으로 간주합니다.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //섹션별 행의 갯수를 설정하는 메소드
    //없으면 에러 - 필수
    //TableViewController의 경우는 이 메소드도 없으면 1을 리턴한 것으로 간주합니다.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }
    
    //셀의 모양을 만드는 메소드 - 필수
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //사용자 정의 셀 만들기
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //행번호에 해당하는 데이터 찾기
        let movie = self.list[indexPath.row]
        //데이터 출력
        cell.lblTitle.text = movie.title!
        cell.lblGenre.text = movie.genreNames!
        cell.lblRating.text = "👍\(movie.ratingAverage!)"
        
        if movie.ratingAverage! >= 8.0{
            cell.lblRating.textColor = UIColor.blue
        }
            //        else if movie.ratingAverage! >= 7.0{
            //            cell.lblRating.textColor = UIColor.init(red: 51.0/255.0, green: 238.0/255.0, blue: 97.0/255.0, alpha: 1.0)
            //        }
        else if movie.ratingAverage! < 6.0{
            cell.lblRating.textColor = UIColor.red
        }else{
            cell.lblRating.textColor = UIColor.black
        }
        
        // cell.thumbnailImage.image = movie.image!
        //비동기적으로 이미지 출력
        DispatchQueue.main.async(execute: {
            cell.thumbnailImage.image = self.getThemnailImage(indexPath.row)
        })
        
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //셀을 선택했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택한 행번호에 해당하는 데이터 찾아오기
        let movie = self.list[indexPath.row]
        //하위 뷰 컨트롤러 인스턴스 생성
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        //데이터 넘겨주기
        detailViewController?.linkUrl = movie.linkUrl!
        detailViewController?.title = movie.title!
        //네비게이션으로 출력
        self.navigationController?.pushViewController(detailViewController!, animated: true)
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
