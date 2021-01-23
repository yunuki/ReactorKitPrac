//
//  CounterViewController.swift
//  ReactorKitPrac
//
//  Created by woogie on 2021/01/23.
//

import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class CounterViewController: UIViewController, View {
    
    
    var disposeBag: DisposeBag = DisposeBag()
    
    //MARK: Constant
    struct Metric {
        static let fontSize: CGFloat = 40
        static let padding: CGFloat = 40
    }
    
    //MARK: UI
    let increaseBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: Metric.fontSize)
        return btn
    }()
    
    let decreaseBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("-", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: Metric.fontSize)
        return btn
    }()
    
    let valueLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.font = UIFont.boldSystemFont(ofSize: Metric.fontSize)
        l.text = "0"
        return l
    }()
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    //MARK: Initializing
    init(reactor: CounterViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(increaseBtn)
        view.addSubview(decreaseBtn)
        view.addSubview(valueLabel)
        view.addSubview(activityIndicatorView)
        setConstraint()
    }

    //MARK: Constraints
    func setConstraint() {
        increaseBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(valueLabel.snp.left).offset(Metric.padding * -1)
        }
        decreaseBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(valueLabel.snp.right).offset(Metric.padding)
        }
        valueLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Metric.fontSize)
            make.bottom.equalTo(valueLabel.snp.top).offset(Metric.padding * -1)
        }
        increaseBtn.sizeToFit()
        decreaseBtn.sizeToFit()
        valueLabel.sizeToFit()
    }
    
    //MARK: Binding
    func bind(reactor: CounterViewReactor) {
        increaseBtn.rx.tap
            .map {Reactor.Action.increase}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseBtn.rx.tap
            .map {Reactor.Action.decrease}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.value}
            .distinctUntilChanged()
            .map {"\($0)"}
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.isLoading}
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }

}

