//
//  MemoVO.swift
//  MemberManagement
//
//  Created by Shin on 28/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemoVO{
    var memoIndex : Int?
    var title : String?
    var contents : String?
    var image : UIImage?
    var regdate : Date?
    
    //MemoMO 인스턴스를 구별하기 위한 변수
    var objectID : NSManagedObjectID?
}
/*
struct MemoVO{
    var memoIndex : Int?
    var title : String?
    var contents : String?
    var image : UIImage?
    var regdate : Date
}
*/
