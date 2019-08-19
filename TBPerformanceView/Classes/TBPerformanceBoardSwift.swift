//
//  TBPerformanceBoardSwift.swift
//  TBPerformanceView
//
//  Created by tongbin on 2019/8/19.
//

import UIKit

class TBPerformanceBoardSwift: NSObject {
    static let `default` = TBPerformanceBoardSwift()
    func startWorking(vc:UIViewController) {
        let t = TBPerformanceBoard()
        t.startWorking(on: vc)
    }
}
