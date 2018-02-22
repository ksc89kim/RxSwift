//
//  ViewController.swift
//  ObservableUtillity
//
//  Created by 벨소프트 on 2018. 2. 22..
//  Copyright © 2018년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //observableDoOn()
        self.observeOn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Observable의 이벤트(next 등)가 발생할때 이벤트 핸들러를 등록할 수 있는 메서드이다.
    func observableDoOn() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.do(onNext:{ event in
            print("doOnNext : \(event)")
        }).subscribe({ event in
            print("subscribe:\(event)")
        }).disposed(by: disposeBag)
    }
    
    //observable의 메서드가 수행될 스케쥴러를 지정할 수 있다.
    func observeOn(){
        let observeOnTest = ["rabbit", "fox", "fish", "fox", "cat"]
        Observable.from(observeOnTest).observeOn(MainScheduler.instance).do(onNext: { event in
            print("doOnNext \(Thread.isMainThread)")
        }).observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .subscribe({ _ in
                print("subscribeNext \(Thread.isMainThread)")
        }).disposed(by: disposeBag)
    }
}

