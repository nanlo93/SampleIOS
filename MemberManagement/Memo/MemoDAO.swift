//
//  MemoDAO.swift
//  MemberManagement
//
//  Created by Shin on 03/12/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemoDAO{
    //AppDelegate에 있는 CoreData 사용을 위한 변수에 접근하는 변수 생성
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //전체 데이터를 가져오는 메소드
    func fetch(keyword : String? = nil) -> [MemoVO]{
        //리스트 생성
        var memoList = [MemoVO]()
        //요청 객체 생성
        let fetchRequest : NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        //검색조건이 있는 경우 검색 조건 추가
        if let t = keyword, t.isEmpty == false{
            fetchRequest.predicate = NSPredicate(format: "contents CONTAINS[c] %@", t)
        }
        //2개 이상의 데이터를 가져올 때는 정렬 조건을 추가
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        do{
            //데이터 가져오기
            let resultSet = try self.context.fetch(fetchRequest)
            //데이터 순회
            for record in resultSet{
                //1개의 데이터를 저장할 객체 생성
                let data = MemoVO()
                data.title = record.title
                data.contents = record.contents
                //날짜는 형변환해서 저장
                data.regdate = record.regdate as! Date?
                //ID 저장
                data.objectID = record.objectID
                //image는 존재하면 변환해서 저장
                if let image = record.image as! Data?{
                    data.image = UIImage(data: image)
                }
                //목록에 저장
                memoList.append(data)
            }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
        
        return memoList
    }
    
    //데이터를 삽입하는 메소드
    func insert(_ data : MemoVO){
        //새로 저장할 객체를 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        if let image = data.image{
            //읽어온 이미지를 png 타입의 데이터로 변환해서 저장
            object.image = image.pngData()
        }
        //데이터 저장
        do{
            try self.context.save()
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
    }
    func delete(_ objectID : NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do{
            try context.save()
            return true
        }catch let e as NSError{
            print("\(e.localizedDescription)")
            return false
        }
    }
}
