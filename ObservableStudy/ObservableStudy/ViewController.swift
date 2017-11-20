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
        self.baseObservable()
        self.observableGenerate()
        self.observableJust()
        self.observableEmptyOrNeverOrError()
        self.observableOfOrFrom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //기본 발생
    func baseObservable() {
        let disposeBag = DisposeBag()
        
        // Observable은 observer의 메소드를 호출하면서 item이나 정보등을 호출(emit)하는 역할을 한다. Observer는 onNext, onError, onCompleted의 메소드가 구현되어 있다.
        // Disposable observer 메모리 해지랑 연관이 있다.
        let baseObservable = Observable<String>.create { observer -> Disposable in
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
        baseObservable.subscribe( onNext: { event in
            print(event)
        },  onError: { error in
            
        }, onCompleted : {
            print("completed")
        }).disposed(by:disposeBag);
    }
    
    //조건식 발생
    func observableGenerate(){
        let disposeBag = DisposeBag()
        // 조건식 initialState 초기화 condition 조건 iterate: 결과
        let generate = Observable.generate(initialState: 1, condition: { $0 < 30 }, iterate: { $0 + 10})
        generate.subscribe( onNext: {event in
            print(event);
        }).disposed(by: disposeBag);
    }
    
    //단일 이벤트 발생
    func observableJust() {
        let disposeBag = DisposeBag()
        let just = Observable<String>.just("JUST TEST");
        just.subscribe { event in
            print(event);
        }.disposed(by: disposeBag)
    }
    
    // 예외처리
    func observableEmptyOrNeverOrError() {
       // let empty = Observable<String>.empty()
       // let never = Observable<String>.never()
       // let error = Observable<String>.error()
       /*
             Observable을 nil 등으로 리턴하여 에러처리하는 것보다 Observable 생성이 되고 빈 이벤트 전달 후에 complte되거나,
             종료되지 않거나, 에러를 리턴하고 싶을떄 사용
         */
    }
    
    //순차적으로 이벤트를 발생
    func observableOfOrFrom() {
        let disposeBag = DisposeBag()
        let of = Observable<String>.of("KIM","LEE","ZANG")
        of.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        let arr = ["TEST1","TEST2","TEST3"]
        let from = Observable<String>.from(arr)
        from.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }
}

