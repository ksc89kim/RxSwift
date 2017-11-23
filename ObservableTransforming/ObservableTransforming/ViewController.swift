//
//  ViewController.swift
//  ObservableTransforming
//
//  Created by 벨소프트 on 2017. 11. 23..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.observableBuffer()
        //self.observableFlatMap()
        //self.observableFlatMapFirst()
        //self.observableFlatMapLatest()
        //self.observableMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 이벤트를 버퍼에 저장한뒤 묶어서 방출한다.
    func observableBuffer() {
        let bufferTest = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        bufferTest.buffer(timeSpan: 3, count: 3, scheduler: MainScheduler.instance).subscribe(
            onNext:{ event in
                print(event)}
        ).disposed(by: disposeBag)
    }
    
    //이벤트 시퀀스를 다른 이벤트 시퀀스로 변형(평탄화)한다.
    func observableFlatMap() {
        let timer = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        let flatMap = timer.flatMap { (num) -> Observable<String> in
            return Observable<String>.create { observer in
                observer.on(.next("P\(num)"))
                observer.on(.next("U\(num)"))
                return Disposables.create {
                    print("dispose")
                }
            }
        }
        
        flatMap.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //첫번째 발생한 이벤트를 다른 이벤트로 변환하는 Observable로 생성하지만 이 Observable의 동작이 끝나기 전에 다른 이벤트들은 무시하게 된다.
    func observableFlatMapFirst(){
        let timer = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        let flatMap = timer.flatMapFirst { (num) -> Observable<String> in
            return Observable<String>.create { observer in
                observer.on(.next("P\(num)"))
                observer.on(.next("U\(num)"))
                observer.onCompleted()
                return Disposables.create {
                    print("dispose")
                }
            }.delaySubscription(3, scheduler: MainScheduler.instance)
        }
        
        flatMap.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //이벤트를 변형한 Observable은, 다음 원본 이벤트가 발생하면 dispose되고 다시 변형된 Observable을 생성한다.
    func observableFlatMapLatest() {
        let timer = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        let flatMap = timer.flatMapLatest { (num) -> Observable<Int> in
            print("----------------------------------------------------")
            return Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
        }
        
        flatMap.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //이벤트를 다른 이벤트로 변환한다.
    func observableMap() {
        let timer = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        let mapTest = timer.map {"map test \($0)"}
        mapTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //scan은 값을 축적해서가지고 있을수 있으며, 이 값을 통해 이벤트를 변형할수 있는 메서드이다.
    func observableScan() {
        
    }
}

