//
//  UserEnvironmetData.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import Alamofire
import ARCL

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height


class UserSettings:ObservableObject{
    //scene_instance : scene 관리
    @Published var scene_instance:SceneLocationView?;
    //isLogin : 로그인 여부
    @Published var isLogin = false;
    //tabselected : 탭 선택(1번 탭,2번탭,3번 탭,4번 탭)
    @Published var tabselected = 0;
    //currentRouteList : 현재 route의 Point의 coordinates 배열
    @Published var currentRouteList:[Pos] = [Pos](){
        didSet{
            
        }
    }
    //currentRouteProperties : 현재 route의 Point의 properties(turntype) 배열
    @Published var currentRouteProperties:[[String:Any]] = [[String:Any]](){
        didSet{
            print(currentRouteProperties)
        }
    }
    
    //AllRouteInfo : 서버에서 가져오는 모든 Route, Ex) 1번(윤경로 경로),2번(자연 경로),3번 기타 등등
    @Published var AllRouteInfo:[RouteInfo] = [RouteInfo]()
    //UserSelected : 현재 선택된 route 혹은 beacon
    @Published var UserSelected:String = "선택해주세요!"
    
    
    
    func requestRoute(start:CLLocationCoordinate2D,dest:CLLocationCoordinate2D){
        let appKey = "3b93e7ea-9bb4-4402-afdb-a96aaab9fa23"
        
        let header:HTTPHeaders = [
            "Accept" : "application/json",
            "appKey" : appKey
        ]
        
        let body:[String:String] = [
            "startX" : String(start.longitude),
            "startY" : String(start.latitude),
            "endX" : String(dest.longitude),
            "endY" : String(dest.latitude),
            "startName" : "출발지",
            "endName" : "도착지"
        ]
        
        AF.request(URLRoot.TMapRoute.rawValue,method: .post ,parameters: body,encoding: URLEncoding.default,headers: header)
            .responseData{ response in
                switch response.result{
                case .success(let value):
                    let info = Data_to_CLLocation(data: value)
                    self.currentRouteList = info.0
                    self.currentRouteProperties = info.1
                case .failure(let error):
                    print(error)
                }
        }
    }
}

