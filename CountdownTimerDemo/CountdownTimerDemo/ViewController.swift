//
//  ViewController.swift
//  CountdownTimerDemo
//
//  Created by Libor Kučera on 10.06.2021.
//

import UIKit
import CountdownTimer

class ViewController: UIViewController {

    var countDownManager = CountDownManager()

    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let operations: [Operation] = [
            CountDownOperation(actionBlock: { [weak self] in
                DispatchQueue.main.async {
                    self?.label.text = "3"
                }
            }),
            CountDownOperation(actionBlock: { [weak self] in
                DispatchQueue.main.async {
                    self?.label.text = "2"
                }
            }),
            CountDownOperation(actionBlock: { [weak self] in
                DispatchQueue.main.async {
                    self?.label.text = "1"
                }
            })
        ]
        self.countDownManager.processAsync(operations) { [weak self] in
            DispatchQueue.main.async {
                self?.label.text = "Finish"
            }
        }
    }
}

