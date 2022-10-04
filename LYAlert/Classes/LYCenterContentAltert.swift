//
//  LYCenterContentAltert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/26.
//

import UIKit
import RxSwift

class LYCenterContentAltert: LYBaseAltert {
    
    var ly_content: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let content = ly_content else {
                return
            }
            
            content.removeFromSuperview()
            addSubview(content)
            content.snp.makeConstraints({ make in
                make.center.equalToSuperview()
            })
        }
    }
    
    override func ly_customerShow() {
        super.ly_customerShow()
        ly_content?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.25) {
            self.ly_content?.transform = .identity
        }
    }
    
    override func ly_customerDismiss(completionBlock: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.ly_content?.transform = .identity
            self.backgroundColor = .clear
        } completion: { _ in
            completionBlock()
        }
    }
    

    
    
    
    private var ly_dismissDispo: Disposable?
    public weak var ly_dismissControl: UIControl? {
        didSet {
            ly_dismissDispo?.dispose()
            ly_dismissDispo = ly_dismissControl?.rx
                .controlEvent(.touchUpInside)
                .take(until: rx.deallocated)
                .subscribe(onNext: { [weak self] (_) in
                    self?.ly_dismiss()
                })
        }
    }
    
    deinit {
        ly_dismissDispo?.dispose()
    }
}



extension LYAlterContainer {
    
    public func ly_altertCenter(
        contentView: UIView,
        dismissControl: UIControl? = nil,
        isTapBlankToDismiss: Bool = true,
        isQueueControl: Bool = true) {
            let alter = LYCenterContentAltert()
            alter.ly_content = contentView
            alter.ly_dismissControl = dismissControl
            alter.ly_isNeedTapBlankToDismiss = isTapBlankToDismiss
            alter.ly_isQueueControl = isQueueControl
            ly_altert(altert: alter)
    }
}
