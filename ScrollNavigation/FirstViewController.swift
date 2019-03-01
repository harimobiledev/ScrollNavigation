//
//  FirstViewController.swift
//  PushPageView
//
//  Created by Hari Keerthipati on 05/02/19.
//  Copyright © 2019 Avantari Technologies. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController, Storyboarded {

    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .clear// colors[index!%colors.count]
        numberLabel.text = "\(self.navController?.getIndex(of: self) ?? 1000)"
    }
    
    func updateLabel(with number: Int)
    {
        numberLabel.text = "\(number)"
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let viewController = FirstViewController.instantiate()
        self.navController?.pushTo(viewController: viewController, animation: true)
    }
    
    deinit {
        print("===deinit=====")
    }
}
