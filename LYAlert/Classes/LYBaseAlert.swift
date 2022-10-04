//
//  LYBaseAlert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/26.
//


import RxSwift
import RxCocoa

public class LYBaseAlert: UIView {
    
    public final var ly_isQueueControl = true
        
    public final func ly_show(in container: UIView) {
        removeFromSuperview()
        container.addSubview(self)
        if ly_isQueueControl {
            container.ly_altertStateSubject.onNext(.alterting)
        }
        ly_customerShow()
    }
    
    public final func ly_dismiss() {
        ly_customerDismiss { [weak self] () in
            guard let sself = self else { return }
            if sself.ly_isQueueControl {
                sself.superview?.ly_altertStateSubject.onNext(.dismissed)
            }
            sself.removeFromSuperview()
        }
    }

    
    public func ly_customerShow() {
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundColor = .clear
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    /// 可以继承，ly_customerDismiss
    /// 不要在里面做 self.removeFromSuperview的操作
    /// 必须调用 completion
    public func ly_customerDismiss(completionBlock: @escaping () -> Void) {}
    
    
    
    //MARK:-
    private lazy var ly_tapToDismissGes: UITapGestureRecognizer = {
        let ges = UITapGestureRecognizer { [weak self] (_) in
            self?.ly_dismiss()
        }
        ges.delegate = self
        //因为subview上的touch事件需要被触发，
        //比如subview上是一个tableview，tableview上有didSelecteCell事件，那么就需要设置为 false
        //因为：tableview去实现 didSelecteCell 是通过touchbegin，touchmove这些事件去实现的，
        //假设设置为yes，一旦响应这个手势，那就会立马给tableview发送一个touchCancel的事件，那么tableview上的didSelectd也就不会响应了
        //因为 tableview会调用touchbegin，然后tableview的super也会调用touchbegin，
        //然后如果super上有手势，并且 cancelsTouchesInView 为true 的话，那么所有的view，都用调用 touchCancel，
        //那么所有依赖于 touchbegin，touchmove去实现的触摸事件，就都没法响应
        ges.cancelsTouchesInView = false
        addGestureRecognizer(ges)
        return ges
    }()
    
    var ly_isNeedTapBlankToDismiss = false {
        didSet {
            ly_tapToDismissGes.isEnabled = ly_isNeedTapBlankToDismiss
        }
    }
    
    
    private var ly_dismissControlDispo: Disposable?
    public weak var ly_dismissControl: UIControl? {
        didSet {
            ly_dismissControlDispo?.dispose()
            ly_dismissControlDispo = ly_dismissControl?.rx.tap.take(until: rx.deallocated)
                .subscribe(onNext: { [weak self] () in
                    self?.ly_dismiss()
                })
        }
    }

    
}


extension LYBaseAlert: UIGestureRecognizerDelegate {

    //这个方法在 gestureRecognizerShouldBegin 之前调用，如果返回false，那么 gestureRecognizerShouldBegin 就不会调用
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard self == touch.view else { return false }
        return true
    }

    //就用苹果默认的，默认不允许同时响应两个tap，这样子其实最合理。
    //两个tap都添加的情况下，都没有代理的情况下，苹果会响应最后一个添加的。。。
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


