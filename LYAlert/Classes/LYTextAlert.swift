//
//  LYTextAlert.swift
//  LYAppKit
//
//  Created by 孙宁宁 on 2022/9/26.
//


public class LYTextAlert: LYBaseAlert {
    
    public let ly_content: UILabel = {
        let rs = UILabel()
        rs.textColor = .white
        rs.font = UIFont.systemFont(ofSize: 14)
        rs.numberOfLines = 0
        return rs
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        ly_isQueueControl = false
        layer.cornerRadius = 5
        backgroundColor = .black
        addSubview(ly_content)
        ly_content.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.width.lessThanOrEqualTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func ly_customerShow() {
        snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
    }
    
    public override func ly_customerDismiss(completionBlock: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.0
        } completion: { _ in
            completionBlock()
        }
    }
}


extension LYAlertContainer {
    public func ly_alertText(
        text: String?,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        color: UIColor = .white,
        isQueueControl: Bool = false,
        duration: Int = 5) {
            guard let text = text, text.count > 0 else { return }
            
            let alter = LYTextAlert()
            alter.ly_content.text = text
            alter.ly_content.font = font
            alter.ly_content.textColor = color
            alter.ly_isQueueControl = isQueueControl
            ly_alert(alert: alter)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
                alter.ly_dismiss()
            }
    }
}
