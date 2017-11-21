//
//  ViewController.swift
//  ObservableSynthesis
//
//  Created by 벨소프트 on 2017. 11. 21..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.observableCombineLatest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //combineLatest는 두 Observable의 각각 이벤트가 발생할때 각 이벤트들을 묶어서 전달한다.
    func observableCombineLatest() {
        let disposeBag = DisposeBag()
        let boys = Observable.from(["KIM","JANG", "LEE"])
        let girs = Observable.from(["PARK","MIN","JUNG"])
        Observable.combineLatest(boys, girs) { (boy:String,girl:String) in
            return (boy,girl)
            }.subscribe { event in
                print(event)
        }.disposed(by: disposeBag)
    }
}

