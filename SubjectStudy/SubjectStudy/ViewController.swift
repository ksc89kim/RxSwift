//
//  ViewController.swift
//  SubjectStudy
//
//  Created by 벨소프트 on 2017. 11. 21..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.publishSubject()
        self.behaviorSubject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // subject는 subscribe된 시점 이후부터 해당 observer에게 이벤트들을 전달
    // subscribe된 시점 이전의 이벤트는 전달하지 않는다.
    func publishSubject() {
        let publishSubject = PublishSubject<String>()
        
        publishSubject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        publishSubject.on(.next("1"))
        publishSubject.on(.next("2"))
        publishSubject.on(.completed)
    }
    
    //publish와 동일하지만 초기 이벤트를 가진 subject 이다. subscribe가 발생하면 즉시 현재 저장된 이벤트를
    //전달하고, 이후는 publish와 동일하다. 이벤트를 저장해두고 싶을때 사용한다.
    func behaviorSubject() {
        let behaviorSubject = BehaviorSubject<String>(value:"TEST")
        behaviorSubject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        behaviorSubject.on(.next("test2"))
        behaviorSubject.on(.next("test3"))
        behaviorSubject.on(.next("test4"))
        behaviorSubject.on(.completed)
    }
    
    //n개의 이벤트를 저장하고 subscribe가 되면 저장된 이벤트들을 모두 전달하는 subject
    func replaySubject() {
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.subscribe { event in
            print("replay 1 = \(event)")
        }
        
        replaySubject.on(.next("1"))
        replaySubject.on(.next("2"))
        replaySubject.on(.next("3"))
        replaySubject.on(.next("4"))
        
        replaySubject.subscribe { event in
            print("replay 2 = \(event)")
        }.disposed(by: disposeBag)
    }
}

