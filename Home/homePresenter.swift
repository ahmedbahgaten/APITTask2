//
//  Presenter.swift
//  APIT Task2
//
//  Created by AHMED on 1/20/20.
//  Copyright © 2020 AHMED. All rights reserved.
//
import Foundation
protocol homePresenter {
    func getDataCounter() -> Int
    func fetchData()
    func getItem(atIndex: Int) -> ServerResponse
    func addNewItem(title:String,body:String)
    func removeItemOfData(atIndex:Int)
    func handleUserID() -> [Int]
    func updateData(atIndex:Int,Title:String,Body:String)
}
class homePresenterImplementation:homePresenter {
    
    weak var homeView: homeViewProtocol?
    var receivedData = [ServerResponse]()
    var router:homeRouter!
    
    init(view:homeViewProtocol,router:homeRouter) {
            self.homeView = view
        self.router = router
        }
    
    func handleUserID() -> [Int] {
        var userIDandID = [Int]()
        var userID = (receivedData.last?.userId ?? 0)
        let ID = (receivedData.last?.id ?? 0) + 1
        if ID % 10 == 1 {
            userID = (receivedData.last?.userId ?? 0)  + 1
        }
        userIDandID.append(userID)
        userIDandID.append(ID)
        return userIDandID
    }
    func addNewItem(title:String,body:String) {
        let userIDandID = handleUserID()
        let object = ServerResponse(userId: userIDandID[0] , id: userIDandID[1], title: title, body: body)
        receivedData.append(object)
        print(object.userId ?? 0,object.id ?? 0)
    }
    func getDataCounter() -> Int{
        return receivedData.count
    }
    
    func fetchData() {
        NetworkManager.DataFetching { [weak self] (serverResponse, err) in
            guard let data = serverResponse else {return}
            guard let self = self else {return}
            self.receivedData = data
            self.homeView?.reloadData()
        }
    }
    func getItem(atIndex: Int) -> ServerResponse {
        receivedData[atIndex]
    }
    func removeItemOfData(atIndex: Int) {
        receivedData.remove(at: atIndex)
        homeView?.reloadData()

    }
    func updateData(atIndex: Int, Title: String, Body: String) {
        receivedData[atIndex].title = Title
        receivedData[atIndex].body = Body
    }
}
