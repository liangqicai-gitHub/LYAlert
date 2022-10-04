//
//  uiview+lyAltert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/23.
//

import UIKit
import RxSwift
import SnapKit


typealias LYAlterContainer = UIView

enum LYToastState {
    case dismissed
    case alterting
}

extension LYAlterContainer {
    
    private struct LYAltertContainerKey {
        static var appendNewToastSubject  = "com.lyAppKit.toast.appendNewToastSubject"
        static var stateSubject = "com.lyAppKit.toast.stateSubject"
    }
    
    var ly_altertAddedSubject: PublishSubject<LYBaseAltert> {
        guard
            let associatedObject = objc_getAssociatedObject(self, &LYAltertContainerKey.appendNewToastSubject),
            let rs = associatedObject as? PublishSubject<LYBaseAltert>
        else {
            
            let ob = PublishSubject<LYBaseAltert>()
            let dismissed = ly_altertStateSubject.filter({$0 == .dismissed})
            _ = Observable.zip(dismissed, ob)
                .map({$1})
                .take(until: rx.deallocated)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] (altert) in
                    self?.ly_alterRealShow(altert: altert)
                })
            
            objc_setAssociatedObject(self, &LYAltertContainerKey.appendNewToastSubject, ob, .OBJC_ASSOCIATION_RETAIN)
            return ob
        }
        return rs
    }
    
    
    var ly_altertStateSubject: BehaviorSubject<LYToastState> {
        guard
            let rs = objc_getAssociatedObject(self, &LYAltertContainerKey.stateSubject) as? BehaviorSubject<LYToastState>
        else {
            let ob = BehaviorSubject<LYToastState>(value: .dismissed)
            objc_setAssociatedObject(self, &LYAltertContainerKey.stateSubject, ob, .OBJC_ASSOCIATION_RETAIN)
            return ob
        }
        return rs
    }
    
    
    public func ly_altert(altert: LYBaseAltert) {
        if altert.ly_isQueueControl {
            ly_altertAddedSubject.onNext(altert)
        } else {
            ly_alterRealShow(altert: altert)
        }
        
    }
    
    private func ly_alterRealShow(altert: LYBaseAltert) {
        altert.ly_show(in: self)
    }
    
}









