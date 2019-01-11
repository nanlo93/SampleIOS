//
//  DisplayMapViewController.swift
//  MemberManagement
//
//  Created by Shin on 28/11/2018.
//  Copyright © 2018 Shin. All rights reserved.
//

import UIKit
import MapKit

class DisplayMapViewController: UIViewController {

    var theater : NSDictionary!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //극장 이름 출력
        self.navigationItem.title = theater["상영관명"] as! String
        
        //위도와 경도 찾기 - 위도와 경도라는 키에 저장되어 있는데
        //정수로 변환해야함
        let lat = (theater["위도"] as! NSString).doubleValue
        let lng = (theater["경도"] as! NSString).doubleValue
        
        //지도에 출력할 영역을 만들기
        //지도의 중심점 좌표를 생성
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //지도에 출력
        mapView.setRegion(coordinateRegion, animated: true)
        //영화관에 마커(어노테이션) 출력
        let point = MKPointAnnotation()
        point.coordinate = location
        point.title = theater["상영관명"] as! String
        mapView.addAnnotation(point)
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
