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
        self.observableDistinct3()
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
        
    }
}

