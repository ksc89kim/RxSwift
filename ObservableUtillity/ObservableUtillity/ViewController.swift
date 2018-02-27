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
        //self.observeOn()
        //observeSubscribeOn()
        self.observableTimeOut()
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
    
    // observable의 시퀀스가 수행될 스케쥴러를 지정한다.
    func observeSubscribeOn(){
        let test = Observable<String>.create { observer in
            for count in 1 ... 3 {
                print("observable \(Thread.isMainThread)")
                observer.on(.next("\(count)"))
            }
            observer.on(.completed)
            return Disposables.create {
                print("dispose")
            }
            
        }
        
        test.observeOn(MainScheduler.instance)
            .map { (intValue) -> String in
                print("map \(Thread.isMainThread)")
                return "\(intValue)"
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .do(onNext: { event in
                print("doOn Next \(Thread.isMainThread)")
                
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos:.background))
            .subscribe { event in
                print("subscribe next \(Thread.isMainThread)")
                
        }.disposed(by: disposeBag)
    }
    
    // 지정된 시간동안 이벤트가 발생하지 않으면 error를 발생한다.
    func observableTimeOut() {
        let observable = Observable<Int>.interval(0.5, scheduler:MainScheduler.instance).filter {  $0 < 3 }
        
        observable.timeout(1, scheduler: MainScheduler.instance)
            .do(onNext: { item in
                print(item)
            }, onError: { error in
                print("error")
            }, onCompleted: nil).subscribe(onNext: { event in
                print(event)
            }).disposed(by: disposeBag)
    }
}

