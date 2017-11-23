//
//  ViewController.swift
//  ErrorStudy
//
//  Created by 벨소프트 on 2017. 11. 22..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.catchError()
        self.catchErrorJustReturn()
        self.reTry()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 에러를 감지했을때, onError를 부르지 않도록 하고, 이벤트를 발생해서 시퀀스를 진행하고
    // onComplte 될수 있도록 한다.
    func catchError() {
        let zoo = Observable<String>.create { observer in
            for count in 1...3 {
                observer.on(.next("Rabbit\(count)"))
            }
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            observer.on(.error(error))
            observer.on(.next("Rabbit 4"))
            return Disposables.create {
                print("dispose")
            }
        }
        
        zoo.catchError { (error : Error) -> Observable<String> in
            //return Observable.of("qqqq","qq2q2")
            return Observable.just("Zoo Closed")
            }.subscribe (onNext: { test in
                print(test)
            }).disposed(by: disposeBag)
    }
    
    // error가 발생했을때, 설정해둔 단일 이벤트를 전달하도록 하는 연산자이다.
    func catchErrorJustReturn(){
        let zoo = Observable<String>.create { observer in
            for count in 1...3 {
                observer.on(.next("Rabbit\(count)"))
            }
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            observer.on(.error(error))
            observer.on(.next("Rabbit4"))
            return Disposables.create {
                print("dispose")
            }
        }
        
        zoo.catchErrorJustReturn("End").subscribe (onNext: { test in
                print(test)
            }).disposed(by: disposeBag)
    }
    
    //시퀀스가 정상동작하기를 기대하며 재시도 하는 연산자이다.
    func reTry(){
        var errorCount = 0
        let zoo = Observable<String>.create { observer in
            for count in 1...3 {
                if errorCount == 2 {
                    print("error")
                    errorCount+=1
                    let error = NSError(domain:"dummyError", code:0, userInfo:nil)
                    observer.on(.error(error))
                } else {
                    errorCount+=1
                    observer.on(.next("Rabbit\(count)"))
                }
                
            }
            observer.on(.completed)
            return Disposables.create {
                print("dispose")
            }
        }
        zoo.retry().subscribe(onNext:{ message in
            print(message)
        }).disposed(by: disposeBag)
 
        //retry하는 시점을 지정할 수 있다.
        /*
        zoo.retryWhen { (_) -> Observable<Int> in
            return Observable.timer(3,scheduler:MainScheduler.instance)
        }.subscribe(onNext:{ message in
                print(message)
        }).disposed(by: disposeBag) */
    }
    
}

