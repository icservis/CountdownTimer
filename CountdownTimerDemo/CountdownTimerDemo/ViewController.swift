//
//  ViewController.swift
//  CountdownTimerDemo
//
//  Created by Libor Kučera on 10.06.2021.
//

import UIKit
import CountdownTimer

class ViewController: UIViewController {

    @IBOutlet private weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startButtontapped(_ sender: Any?) {
        startCountDown(completion: nil)
    }

    func startCountDown(completion: (() -> Void)?) {
        let controller = CountDownController()
        controller.initialCount = 5
        controller.tick = { count in
            debugPrint("Tick: \(count)")
        }
        controller.completion = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false, completion: completion)
        }
        present(controller, animated: false, completion: nil)
    }
}

