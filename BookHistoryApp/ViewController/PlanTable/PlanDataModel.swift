//
//  PlanDataModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import Foundation

typealias PlanDataModels = [PlanDataModel]

struct PlanDataModel{
    let title: String?
    let content: String?
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    init(){
        self.title = nil
        self.content = nil
    }
}
