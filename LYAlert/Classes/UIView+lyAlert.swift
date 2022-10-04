//
//  uiview+lyAlert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/23.
//

import UIKit
import RxSwift
import SnapKit


typealias LYAlertContainer = UIView

enum LYAlertState {
    case dismissed
    case alerting
}

extension LYAlertContainer {
    
    private struct LYAlertContainerKey {
        static var appendNewToastSubject  = "com.lyAppKit.toast.appendNewToastSubject"
        static var stateSubject = "com.lyAppKit.toast.stateSubject"
    }
    
    var ly_alertAddedSubject: PublishSubject<LYBaseAlert> {
        guard
            let associatedObject = objc_getAssociatedObject(self, &LYAlertContainerKey.appendNewToastSubject),
            let rs = associatedObject as? PublishSubject<LYBaseAlert>
        else {
            
            let ob = PublishSubject<LYBaseAlert>()
            let dismissed = ly_altertStateSubject.filter({$0 == .dismissed})
            _ = Observable.zip(dismissed, ob)
                .map({$1})
                .take(until: rx.deallocated)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] (altert) in
                    self?.ly_alterRealShow(altert: altert)
                })
            
            objc_setAssociatedObject(self, &LYAlertContainerKey.appendNewToastSubject, ob, .OBJC_ASSOCIATION_RETAIN)
            return ob
        }
        return rs
    }
    
    
    var ly_alertStateSubject: BehaviorSubject<LYAlertState> {
        guard
            let rs = objc_getAssociatedObject(self, &LYAlertContainerKey.stateSubject) as? BehaviorSubject<LYAlertState>
        else {
            let ob = BehaviorSubject<LYAlertState>(value: .dismissed)
            objc_setAssociatedObject(self, &LYAlertContainerKey.stateSubject, ob, .OBJC_ASSOCIATION_RETAIN)
            return ob
        }
        return rs
    }
    
    
    public func ly_alert(alert: LYBaseAlert) {
        if altert.ly_isQueueControl {
            ly_altertAddedSubject.onNext(alert)
        } else {
            ly_alterRealShow(altert: alert)
        }
        
    }
    
    private func ly_alterRealShow(alert: LYBaseAlert) {
        alert.ly_show(in: self)
    }
    
}









