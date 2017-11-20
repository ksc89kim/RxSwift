//
//  ViewController.swift
//  ObservableStudy
//
//  Created by 벨소프트 on 2017. 11. 20..
//  Copyright © 2017년 tronplay. All rights reserved.
//

import UIKit
import RxSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let disposeBag = DisposeBag()
        
        // Observable은 observer의 메소드를 호출하면서 item이나 정보등을 호출(emit)하는 역할을 한다. Observer는 onNext, onError, onCompleted의 메소드가 구현되어 있다.
        // Disposable observer 메모리 해지랑 연관이 있다.
        let observableTest = Observable<String>.create { observer -> Disposable in
            observer.on(.next("next")) // EVENT를 호출하는 과정
            observer.on(.next("next2")) // EVENT를 호출하는 과정
            observer.on(.completed) // 완료
            return Disposables.create{
                print("dispose") //메모리 해지 될때 필요한 영역
            }
        }
        
        // onNext:((String) -> Void)?
        // onError:((Error) -> Void)?,
        // onCompleted:(() -> Void)?,
        observableTest.subscribe( onNext: { event in
            print(event)
        },  onError: { error in
                                    
        }, onCompleted : {
            print("completed")
        }).disposed(by:disposeBag);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

