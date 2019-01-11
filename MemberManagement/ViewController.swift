//
//  ViewController.swift
//  MemberManagement
//
//  Created by Shin on 21/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

//swift에서 import는 네임스페이스를 가져오는 역할
//java에서 import는 이름을 줄여쓰기 위한 역할
//c에서 include는 파일의 내용을 가져오는 역할
//c나 swift에서는 import나 include를 하지 않으면 그 기능을 사용할 수 없습니다. java는 import를 하지 않고도 전체 이름을 이용해서 원하는 기능을 사용할 수 있습니다.
//html에서 script src도 c에서의 include 개념입니다.
import UIKit
import Alamofire    //URL 통신을 쉽게 할 수 있도록 해주는 외부 라이브러리

class ViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func moveMemo(_ sender: Any) {
        let memoListVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoListVC") as! MemoListVC
        memoListVC.title = "메모 목록"
        self.navigationController?.pushViewController(memoListVC, animated: true)
    }
    
    @IBAction func moveMovie(_ sender: Any) {
        //하위 뷰 컨트롤러 객체 만들기
        let movieListController = self.storyboard?.instantiateViewController(withIdentifier: "MovieListController") as! MovieListController
        
        let theaterListController = self.storyboard?.instantiateViewController(withIdentifier: "TheaterListController") as! TheaterListController
        
        //네비게이션 컨트롤러가 있을 때는 바로 푸시를 하면 됩니다.
        //없을 때는 네비게이션 컨트롤러를 만들고나서 네비게이션 컨트롤러를 present로 출력
        //뒤로 버튼을 새로 만들기
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "메인화면", style: .done, target: nil, action: nil)
        
        //탭 바 컨트롤러 생성
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [movieListController, theaterListController]
        
        //네비게이션으로 이동
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    //AppDelegate 객체에 대한 참조 변수
    var appDelegate : AppDelegate!
    
    @IBAction func login(_ sender: Any) {
        if loginBtn.title(for: .normal) == "로그인"{
            //로그인 대화상자 생성
            let alert = UIAlertController(title: "로그인", message: nil, preferredStyle: .alert)
            
            //대화상자에 입력을 받을 수 있는 텍스트 필드 2개 추가
            alert.addTextField(){(tf) in tf.placeholder = "아이디를 입력하시오"}
            alert.addTextField(){(tf) in tf.placeholder = "비밀번호를 입력하시오"
                tf.isSecureTextEntry = true
            }
            //버튼 생성
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "로그인", style: .default){
                (_) in
                //입력한 아이디와 비밀번호 가져오기
                let id = alert.textFields![0].text
                let pw = alert.textFields![1].text
                //웹에 요청
                let request = Alamofire.request("http://10.211.55.2:8080/server/member/login?id=\(id!)&pw=\(pw!)", method : .get, parameters : nil)
                //결과 사용
                request.responseJSON{
                    response in
                    //결과 확인
                    //                    print(response.result.value!)
                    if let jsonObject = response.result.value! as? [String : Any]{
                        //result 키의 내용 가져오기
                        let result = jsonObject["result"] as! NSDictionary
                        print(result)
                        let id = result["id"] as! NSString
                        print(id)
                        if id == "NULL"{
                            self.title = "로그인 실패"
                        }else{
                            //로그인 성공시 로그인 정보 저장
                            self.appDelegate.id = id as String
                            self.appDelegate.nickname = (result["nickname"] as! NSString) as String
                            self.appDelegate.image = (result["image"] as! NSString) as String
                            //self.title = "\(self.appDelegate.nickname!)님 로그인"
                            
                            //image에 저장된 데이터로 서버에서 이미지를 다운로드 받아서 타이틀로 설정
                            let request = Alamofire.request("http://10.211.55.2:8080/server/images/\(self.appDelegate.image!)", method : .get, parameters : nil)
                            request.response{
                                response in
                                //다운로드 받은 데이터를 가지고 Image 생성
                                let image = UIImage(data: response.data!)
                                //이미지를 출력하기 위해서 ImageView 만들기
                                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                                imageView.contentMode = .scaleAspectFit
                                imageView.image = image
                                //네비게이션바에 배치
                                self.navigationItem.titleView = imageView
                            }
                            self.loginBtn.setTitle("로그아웃", for: .normal)
                            //로그인 상태일 때, 회원가입 버튼 비활성화
                            self.signUpBtn.isEnabled = false
                        }
                    }
                }
            })
            //로그인 대화상자 출력
            self.present(alert, animated: true)
        }else{
            //로그인 정보 삭제
            appDelegate.id = nil
            appDelegate.nickname = nil
            appDelegate.image = nil
            //네비게이션바의 타이틀과 버튼의 타이틀 변경
            self.title = "로그아웃상태"
            self.loginBtn.setTitle("로그인", for: .normal)
            //로그아웃 상태일 떄, 회원가입 버튼 활성화
            self.signUpBtn.isEnabled = true
            self.navigationItem.titleView = nil
        }
    }
    //회원가입
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "회원가입", message: nil, preferredStyle: .alert)
        alert.addTextField(){(tf) in tf.placeholder = "아이디를 입력하시오"}
        alert.addTextField(){(tf) in tf.placeholder = "비밀번호를 입력하시오"
            tf.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "회원가입", style: .default){
            (_) in
            //입력한 아이디와 비밀번호 가져오기
            let id = alert.textFields![0].text
            let pw = alert.textFields![1].text
            //웹에 요청
            let checkRequest = Alamofire.request("http://10.211.55.2:8080/server/member/login?id=\(id!)&pw=\(pw!)", method : .get, parameters : nil)
            checkRequest.responseJSON{
                response in
                if let jsonObject = response.result.value! as? [String : Any]{
                    //result 키의 내용 가져오기
                    let result = jsonObject["result"] as! NSDictionary
                    print(result)
                    let id = result["id"] as! NSString
                    print(id)
                    if id == "NULL"{
                        //중복값이 없어서 회원가입 성공
                        self.title = "회원가입 성공"
                    }else{
                        //중복값에 의해서 회원가입 실패
                        self.title = "회원가입 실패"
                    }
                }
            }
            Alamofire.request("http://10.211.55.2:8080/server/member/signUp?id=\(id!)&pw=\(pw!)", method : .get, parameters : nil)
        })
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AppDelegate에 대한 참조를 생성
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let revealVC = self.revealViewController(){
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.navigationItem.leftBarButtonItem = btn
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //상위 클래스의 메소드 호출
        super.viewWillAppear(animated)
        
        //로그인 여부 확인
        if appDelegate.id == nil{
            self.title = "로그아웃상태"
            self.loginBtn.setTitle("로그인", for: .normal)
        }else{
            self.title = "로그인상태"
            self.loginBtn.setTitle("로그아웃", for: .normal)
        }
    }
    
}

