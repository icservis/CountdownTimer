//
//  CountDownController.swift
//  ping-pong
//
//  Created by Libor Kučera on 12.06.2021.
//  Copyright © 2021 IC Servis, s.r.o. All rights reserved.
//

import UIKit

public class CountDownController: UIViewController {
    public typealias CompletionBlock = () -> Void
    public typealias TickBlock = (Int) -> Void
    private lazy var countDownManager = CountDownManager()

    public var completion: CompletionBlock?
    public var tick: TickBlock?
    public var initialCount: Int = 3

    public lazy var countdownLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = .init(name: "digital-7", size: 120)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0.1, alpha: 0.7)

        addCountDownLabel()
        fireCountDown { [weak self] in
            self?.completion?()
        }
    }

    public func addCountDownLabel() {
        self.view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    public func fireCountDown(completion: CompletionBlock?) {
        self.countdown(initialCount: self.initialCount, completion: completion)
    }

    public func countdown(initialCount: Int, completion: CompletionBlock?) {
        self.countDownManager.processAsync(
            (1...initialCount).reversed().map { count in
                CountDownOperation {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.tick?(count)
                        self.countdownLabel.text = "\(count)"

                        let upScaleTransform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                        let downScaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        UIView.animate(
                            withDuration: 0.25,
                            delay: 0.0,
                            usingSpringWithDamping: 0.5,
                            initialSpringVelocity: 5,
                            options: UIView.AnimationOptions.curveEaseOut,
                            animations: {
                                self.countdownLabel.transform = upScaleTransform
                                self.view.layoutIfNeeded()
                            }, completion: { _ in
                                UIView.animate(
                                    withDuration: 0.25,
                                    delay: 0,
                                    usingSpringWithDamping: 0.5,
                                    initialSpringVelocity: 5,
                                    options: UIView.AnimationOptions.curveEaseOut,
                                    animations: {
                                        self.countdownLabel.transform = downScaleTransform
                                        self.view.layoutIfNeeded()
                                    }
                                )
                            }
                        )
                    }
                }
            }
        ) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.countdownLabel.text = nil
                self.tick?(0)
                completion?()
            }
        }
    }
}
