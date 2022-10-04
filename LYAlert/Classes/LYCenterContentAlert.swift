//
//  LYCenterContentAltert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/26.
//

import UIKit


class LYCenterContentAlert: LYBaseAlert {
    
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
    

    
    

}



extension LYAlterContainer {
    
    public func ly_alertCenter(
        contentView: UIView,
        dismissControl: UIControl? = nil,
        isTapBlankToDismiss: Bool = true,
        isQueueControl: Bool = true) {
            let alter = LYCenterContentAltert()
            alter.ly_content = contentView
            alter.ly_dismissControl = dismissControl
            alter.ly_isNeedTapBlankToDismiss = isTapBlankToDismiss
            alter.ly_isQueueControl = isQueueControl
            ly_alert(alter: alter)
    }
}
