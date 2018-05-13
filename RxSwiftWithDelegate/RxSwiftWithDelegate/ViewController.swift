//
//  ViewController.swift
//  RxSwiftWithDelegate
//
//  Created by kim sunchul on 2018. 5. 13..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController,ColorPicker{
    var pickerView:ColorPickerView?
    var disposeBag:DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView = ColorPickerView()
        pickerView?.delegate =  self
//        pickerView?.selected(color: UIColor.red)
        
        /*
            음.. 이용 불가 나중에 방법을 찾아야할듯..
        pickerView?.rx_selectedColor.subscribe(onNext:{ color in
            print("onNext")
        }).disposed(by: disposeBag)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selected(color: UIColor) {
        print("selected color")
    }


}

