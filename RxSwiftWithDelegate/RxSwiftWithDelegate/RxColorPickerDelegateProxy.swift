//
//  RxColorPickerDelegateProxy.swift
//  RxSwiftWithDelegate
//
//  Created by kim sunchul on 2018. 5. 13..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxCocoa

class RxColorPickerDelegateProxy:DelegateProxy<ColorPickerView, ColorPicker>,DelegateProxyType, ColorPicker {

    static func registerKnownImplementations() {
    }
    
    @objc internal func selected(color: UIColor) {
        
    }
    
    static func currentDelegate(for object: RxColorPickerDelegateProxy.ParentObject) -> RxColorPickerDelegateProxy.Delegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ColorPicker?, to object: ColorPickerView) {
        object.delegate = delegate
    }
    
}
