//
//  ViewController.swift
//  StartRxSwift
//
//  Created by 벨소프트 on 2017. 11. 16..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.observableSequenceExample()
        self.observableSequenceExample2()
        self.myJust(element: 20).subscribe(onNext:{ n in
            print(n)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func observableSequenceExample(){
        let disposeBag = DisposeBag()
        
        let stringSequence =  Observable.just("this is string")
        let oddSequence = Observable.from([1,3,5,7,9])
        let dictSequence = Observable.from([1:"Rx", 2:"Swift"])
        
        var subscription = stringSequence.subscribe { (event: Event<String>) in
            print(event)
        }
        subscription.disposed(by: disposeBag)
        
        subscription = oddSequence.subscribe { (event:Event<Int>) in
            print(event)
        }
        subscription.disposed(by: disposeBag)
        
        subscription = dictSequence.subscribe { (event:Event<(key:Int, value:String)>) in
            print(event)
        }
        subscription.disposed(by: disposeBag)
    }
    
    func observableSequenceExample2(){
        Observable<String>.create { observer -> Disposable in
            observer.onNext("100")
            observer.onNext("200")
            observer.onNext("300")
            observer.onCompleted()
            return Disposables.create()
            }.subscribe {
                print($0)
        }
    }
    
    func myJust<E>(element:E) -> Observable<E> {
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
}

