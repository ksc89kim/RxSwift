//
//  ViewController.swift
//  ObservableFiltering
//
//  Created by 벨소프트 on 2017. 11. 27..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let disposeBag:DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.observableDebounce()
        //self.observableDistinct1()
        //self.observableDistinct2()
        //self.observableDistinct3()
        //self.observableElementAt()
        //self.observableSingle()
        //self.observableFilter()
        //self.observableSample()
        //self.observableSkip()
        //self.observableSkipWhile()
        //self.observableSkipUntil()
        //self.observableTake()
        //self.observableTakeLast()
        //self.observableTakeUntil()
        self.observableTakeWhile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 지정한 시간간격 내에 하나의 이벤트만 발생한다. (throttle)
    func observableDebounce() {
        let emailObservable = emailTextField.rx.text
        let passwdObservable = passwordTextField.rx.text
        Observable.of(emailObservable,passwdObservable).merge().throttle(5,scheduler:MainScheduler.instance)
            .subscribe { event in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    //이전 이벤트와 비교해서 값이 다를 경우에만 이벤트를 발생한다.
    func observableDistinct1() {
        let test = ["a","a","b","c","c","c"]
        let distinceTest = Observable.from(test).distinctUntilChanged()
        distinceTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    func observableDistinct2() {
        struct Man {
            var name = ""
            var skinColor = ""
        }
        
        let masteryi = Man(name:"mysterYi", skinColor:"green")
        let teemo = Man(name:"teemo", skinColor:"brwon")
        let nidalee = Man(name:"nidalee", skinColor:"brwon")
        
        let array = [masteryi,masteryi,teemo,teemo,nidalee,masteryi]
        let distinceTest = Observable.from(array).distinctUntilChanged { $0.skinColor }
        distinceTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    func observableDistinct3() {
        struct Man {
            var name = ""
            var skinColor = ""
        }
        let masteryi = Man(name:"mysterYi", skinColor:"green")
        let teemo = Man(name:"teemo", skinColor:"brwon")
        let nidalee = Man(name:"nidalee", skinColor:"brwon")
        let array = [masteryi,masteryi,teemo,teemo,nidalee,masteryi]
        let distinceTest = Observable.from(array).distinctUntilChanged { (lhs,rhs) -> Bool in
            return lhs.name == rhs.name
        }
        distinceTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //지정한 index의 이벤트만 emit하도록 하는 메서드
    func observableElementAt() {
        let test = ["a","a","b","c","c","c"]
        let elementAtTest = Observable.from(test).elementAt(3)
        elementAtTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //첫번쨰 이벤트만 emit한다.
    func observableSingle() {
        let test = ["a","a","b","c","c","c"]
        let elementAtTest = Observable.from(test).single()
        elementAtTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //조건식에 부합하는 이벤트만 emit 한다.
    func observableFilter() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let filterTest = Observable.from(test).filter { $0.hasPrefix("f") }
        filterTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //sampler observable의 이벤트 시퀀스에 따라 본래 observable의 이벤트가 전달된다.
    func observableSample() {
        let observable = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        observable.sample(Observable<Int>.interval(0.8, scheduler: MainScheduler.instance))
            .subscribe { event in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    //n개의 이벤트를 스킵한다.
    func observableSkip() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let skipTest = Observable.from(test).skip(3)
        skipTest.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
    
    //특정 이벤트까지 skip 한다.
    func observableSkipWhile() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let skipTest = Observable.from(test).skipWhile { $0 != "fish" }
        skipTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //다른 Observable 시퀀스 이벤트가 발생하기 전까지를 스킵한다.
    func observableSkipUntil() {
        let observable = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        observable.skipUntil(Observable<Int>.interval(0.5, scheduler: MainScheduler.instance))
            .subscribe { event in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    //n개의 아이템만 emit한다.
    func observableTake() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let skipTest = Observable.from(test).take(2)
        skipTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    //마지막 이벤트를 기준으로 count만큼 이벤트를 발생한다.
    func observableTakeLast() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let skipTest = Observable.from(test).takeLast(1)
        skipTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
    
    // 다른 Observable 시퀀스 이벤트가 발생할때까지만 본래 Observable의 이벤트를 발생한다.
    func observableTakeUntil() {
        let observable = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        observable.takeUntil(Observable<Int>.interval(0.5, scheduler: MainScheduler.instance))
            .subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
    }
    
    //조건식에 부합될때까지만 이벤트를 발생한다.
    func observableTakeWhile() {
        let test = ["rabbit","fox","fish","dog","cat"]
        let skipTest = Observable.from(test).takeWhile { $0 != "fish" }
        skipTest.subscribe { event in
            print(event)
            }.disposed(by: disposeBag)
    }
}

