//
//  FakeResponses.swift
//  ntvos
//
//  Created by Raymond Kennedy on 2/2/23.
//

import Foundation

class FakeResponses {
    
    let mainResponse: Response?
    
    init() {
        let filePath = Bundle.main.path(forResource: "mainResponse", ofType: "json")!
        let contents = try? String(contentsOfFile: filePath)
        let data = try? JSONDecoder().decode(Response.self, from: contents!.data(using: .utf8)!)
        self.mainResponse = data
    }
}
