//
//  ShareCodeModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/12/02.
//

import Foundation

class ShareCodeModel {
    func createShareCode() -> Int {
        let numList = [1,2,3,4,5,6,7,8,9]
        var code = 0
        for i in 0..<6 {
            if let num = numList.randomElement() {
                code += setupCode(i: i, num: num)
            }
        }
        return code
    }
    
    private func setupCode(i: Int, num: Int) -> Int {
        switch i {
        case 0:
            return num * 1
        case 1:
            return num * 10
        case 2:
            return num * 100
        case 3:
            return num * 1000
        case 4:
            return num * 10000
        case 5:
            return num * 100000
        default:
            return 0
        }
    }
}
