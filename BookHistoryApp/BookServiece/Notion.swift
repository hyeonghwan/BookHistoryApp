//
//  Notion.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation
import RxSwift
import RxCocoa
import NotionSwift

class Notion {
    init(){
        
        let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: "secret_fvhLY7okcQ3B7yusKImb7ez9mzEOhIC6u5DO0LWMPbW"))
        
        let pageId = Page.Identifier("380c09a77725420fa3164f371bd01cb6")
    
        notion.page(pageId: pageId) { [notion] in
            print("---- Properties ----- ")
            
            switch $0 {
            case .success(let page):
                notion.blockChildren(blockId: page.id.toBlockIdentifier) { data in
                    print("---- Children ----- ")
                    switch data{
                    case .success(let response):
                        print("response.results : \(response.results)")
                    case .failure(let error):
                        print("error : \(error)")
                    }
                }
            default:
                break
            }
        }
        let parentPageId = Page.Identifier("{PAGE UUIDv4}")

        let request = PageCreateRequest(
            parent: .page(parentPageId),
            properties: [
                "title": .init(
                    type: .title([
                        .init(string: "Lorem ipsum \(Date())")
                    ])
                )
            ]
        )

        notion.pageCreate(request: request) {
            print($0)
        }
        
        
    }
}

