//
//  MemoFormVC.swift
//  MemberManagement
//
//  Created by Shin on 28/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController {

    //텍스트를 입력하는 도중에 호출되는 메소드
    var subject : String!
    
    //이미지 피커의 타입을 매개변수로 받아서 이미지 피커를 출력해주는 사용자 정의 메소드
    func presentPicker(source : UIImagePickerController.SourceType){
        //유효한 소스 타입이 아니면 중단
        guard UIImagePickerController.isSourceTypeAvailable(source) == true else {
            let alert = UIAlertController(title: "사용할 수 없는 타입입니다.", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true)
            return
        }
        //이미지 피커 출력
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        self.present(picker, animated: true)
    }
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    @IBAction func pick(_ sender: Any) {
        //대화상자 생성
        let select = UIAlertController(title: "이미지를 가져올 곳을 선택하시오", message: nil, preferredStyle: .actionSheet)
        
        select.addAction(UIAlertAction(title: "카메라", style: .default){
            (_) in self.presentPicker(source: .camera)
        })
        select.addAction(UIAlertAction(title: "앨범", style: .default){
            (_) in self.presentPicker(source: .savedPhotosAlbum)
        })
        select.addAction(UIAlertAction(title: "사진 라이브러리", style: .default){
            (_) in self.presentPicker(source: .photoLibrary)
        })
        select.addAction(UIAlertAction(title: "닫기", style: .cancel))
        self.present(select, animated: false)
    }
    
    @IBAction func save(_ sender: Any) {
        //대화상자 중간에 삽입할 ViewController 생성
        let contentVC = UIViewController()
        let image = UIImage(named: "warning-icon-60")
        contentVC.view = UIImageView(image: image)
        //image.size가 nil이라면 CGSize.zero를 대입
        contentVC.preferredContentSize = image?.size ?? CGSize.zero
        
        //텍스트뷰에 내용이 없으면 경고창을 출력하고 종료
        //조건을 만족하지 않으면 종료 : guard
        //조건에 맞는 경우와 그렇지 않은 경우에 따른 처리 : if
        guard self.contents.text.isEmpty == false else{
            let alert = UIAlertController(title: "텍스트뷰에 내용을 작성해야 합니다.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            //ContentView 설정
            alert.setValue(contentVC, forKey: "contentViewController")
            
            self.present(alert, animated: true)
            return
        }
        //입력한 문자열이 있는 경우 데이터를 생성
        let memo = MemoVO()
        memo.title = self.subject
        memo.contents = self.contents.text
        memo.image = self.preview.image
        memo.regdate = Date()
        
        //print("memo : \(memo)")
        
        /*
        //데이터 변수를 소유하고 있는 AppDelegate 인스턴스에 대한 포인터를 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //데이터 저장 - 이 작업 후에 memo 데이터를 Core Data나 Server에 저장하고 다시 출력
        appDelegate.memoList.append(memo)
        */
        //print("memoList : \(appDelegate.memoList)")
        
        //CoreData에 데이터 삽입
        let dao = MemoDAO()
        dao.insert(memo)
        
        //이전 뷰컨트롤러로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contents.delegate = self
        
        //현재 뷰의 배경을 설정
        let bgImage = UIImage(named: "memo-background.png")
        self.view.backgroundColor = UIColor(patternImage: bgImage!)

        //텍스트뷰의 배경을 투명으로 변경
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear

        //텍스트뷰의 줄 간격 조절
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: "  ", attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.contents.text = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//UIImagePickerControllerDelegate
extension MemoFormVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.preview.image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        picker.dismiss(animated: false)
    }
}

extension MemoFormVC : UITextViewDelegate{
    //텍스트를 입력하는 도중에 호출되는 메소드
    func textViewDidChange(_ textView: UITextView) {
        //입력된 문자열을 가져오기
        let contents = self.contents.text as NSString
        //글자수가 15자가 넘으면 15, 그렇지 않으면 글자수를 저장
        let length = (contents.length > 15) ? 15 : contents.length
        self.subject = contents.substring(with : NSRange(location: 0, length: length))
        self.navigationItem.title = subject
    }
    
    //터치를 하고 난 후 호출되는 메소드
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        UIView.animate(withDuration: TimeInterval(0.5)){
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
}
