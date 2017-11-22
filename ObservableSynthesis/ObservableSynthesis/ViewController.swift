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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.observableCombineLatest()
        self.observableWithLatestFrom()
        //self.observableMerge()
        self.observableSwitchLatest()
        self.observableZip()
        self.observableConcat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //combineLatest는 두 Observable의 각각 이벤트가 발생할때 각 이벤트들을 묶어서 전달한다.
    func observableCombineLatest() {
        let boys = Observable.from(["KIM","JANG", "LEE"])
        let girs = Observable.from(["PARK","MIN","JUNG"])
        Observable.combineLatest(boys, girs) { (boy:String,girl:String) in
            return (boy,girl)
            }.subscribe { event in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    // 두 개의 Observable을 합성하지만, 한쪽 Observable의 이벤트가 발생할때에 합성해주는 메서드
    // 합성할 다른 쪽 이벤트가 없다면 이벤트는 스킵된다.
    func observableWithLatestFrom() {
        let gamnamstyles = Observable.from(["OPPA", "GAMANAM", "STYLE"])
        let newfaces = Observable.from(["NEW","FACE","WASH","POP"]) //기준 배열
        newfaces.withLatestFrom(gamnamstyles, resultSelector: {(newface:String,gamnamstyle:String) in
            return (newface, gamnamstyle)
        }).subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //같은 타입의 이벤트를 발생하는 Observable을 합성하는 함수이며, 각각의 이벤트를 모두 수신할 수 있다.
    func observableMerge() {
        
        let merge1 = Observable.from(["red1", "red2", "red3"])
        let merge2 = Observable.from(["red4", "red5", "red6"])
        
        Observable.of(merge1,merge2).merge().subscribe { event in
            print("\(event)")
        }.disposed(by: disposeBag)
        
        /*
         DisposeBag will dispose of your subscription once it goes out of scope.
         In this instance, it'll be right after the call to subscribe,
         and it explains why you don't see anything printed to the console.
         Move the definition of dispose bag to the class creating the subscription and everything should work fine.
        */
        //disposeBag 지역 변수로 있을시, interval하면 지역변수가 범위를 넘어가기 때문에 메모리가 해지. 그럼으로써 멤버변수로
        //disposeBag을 두고 써야함.
        let readTeam = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map {
            "red:\($0)"
        }
        let blueTeam = Observable<Int>.interval(2, scheduler: MainScheduler.instance).map {
            "blue:\($0)"
        }
        let startTime = Date().timeIntervalSince1970
        Observable.of(readTeam,blueTeam).merge().subscribe { event in
            print("\(event):\(Int(Date().timeIntervalSince1970 - startTime))")
        }.disposed(by: disposeBag)

    }
    
    //observable을 switch 할 수 있는 observable이다
    //이벤트를 수신하고 싶은 observable로 바꾸면 해당 이벤트가 발생하는 것을 수신할 수 있다.
    func observableSwitchLatest () {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        let switchLatest = BehaviorSubject<Observable<String>>(value:subject1)
        switchLatest.switchLatest().subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        subject1.on(.next("1-1"))
        switchLatest.on(.next(subject2))
        subject1.on(.next("1-2"))
        subject2.on(.next("2-1"))
        subject2.on(.next("2-2"))
        subject1.on(.completed)
        subject2.on(.completed)
        switchLatest.on(.completed)
    }
    
    //zip은 두 Observable의 발생 순서가 같은 이벤트를 조합해서 이벤트를 발생한다.
    func observableZip() {
        let boys = Observable.from(["EPO", "EPA", "EPG"])
        let girls = Observable.from(["APO", "APA", "APG"])
        Observable.zip(boys,girls).subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //concat은 두개 혹은 그 이상의 Observable을 직렬로 연결
    func observableConcat() {
        let boys = Observable.from(["EPO", "EPA", "EPG"])
        let girls = Observable.from(["APO", "APA", "APG"])
        boys.concat(girls).subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
}

