//
//  ViewController.swift
//  ObservableSubscriptionShare
//
//  Created by 벨소프트 on 2018. 4. 9..
//  Copyright © 2018년 tron. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // nonShare()
        share()
        // publishMulticastAndConnect()
         //replayOrReplayAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 비공유 예제
    func nonShare() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.subscribe { item in
            print("first subscription \(item)")
        }.disposed(by: disposeBag)
        observable.delaySubscription(2, scheduler: MainScheduler.instance).subscribe { item in
            print("second subscription \(item)")
        }.disposed(by: disposeBag)
    }
    
    // Observable의 시퀀스를 하나의 subject를 통해 multicast로 이벤트를 전달하게 된다.
    func publishMulticastAndConnect() {
        let subject = PublishSubject<Int>()
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(subject)
        observable.subscribe { item in
            print("first subscription \(item)")
        }.disposed(by: disposeBag)
        // observable.connect()를 하기전에는 시퀀스가 시작되지 않는다.
        observable.connect()
        observable.delaySubscription(2, scheduler: MainScheduler.instance).subscribe { item in
            print("second subscrib \(item)")
        }.disposed(by: disposeBag)
    }
    
    // 지정한 버퍼 크기만큼 시퀀스를 저장하고 subscription을 공유한다.
    func replayOrReplayAll() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(2)
        observable.subscribe { item in
            print("first subscription \(item)")
        }.disposed(by: disposeBag)
        observable.connect()
        observable.delaySubscription(3, scheduler: MainScheduler.instance).subscribe { item in
            print("second subscription \(item)")
        }.disposed(by: disposeBag)
    }
    
    // 간단하게 공유를 만들 수 있다. observer가 더이상 없을떄까지 지속되고 계속 적으로 subscription 을 공유 할 수 있다.
    func share() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance).share()
        observable.subscribe { item in
            print("first subscription \(item)")
        }.disposed(by: disposeBag)
        observable.delaySubscription(2, scheduler: MainScheduler.instance).subscribe { item in
            print("\(item)")
        }.disposed(by: disposeBag)
    }
}

