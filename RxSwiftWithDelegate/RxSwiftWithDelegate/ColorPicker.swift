//
//  ColorPicker.swift
//  RxSwiftWithDelegate
//
//  Created by kim sunchul on 2018. 5. 13..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ColorPicker:class {
    func selected(color:UIColor)
}

class ColorPickerView:UIView {
    weak var delegate:ColorPicker? = nil
    func selected(color:UIColor) {
        self.delegate?.selected(color: color)
    }
}


extension ColorPickerView {
    public var rx_delegate:DelegateProxy<ColorPickerView, ColorPicker>{
        return RxColorPickerDelegateProxy.proxy(for: self)
    }
    
    public var rx_selectedColor:Observable<UIColor?> {
        return rx_delegate.sentMessage(#selector(RxColorPickerDelegateProxy.selected(color:))).map {
            a in a[0] as? UIColor
        }
    }
}

