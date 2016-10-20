//
//  CoinFlipViewController.swift
//  CoinFlip
//
//  Created by Tim Rayle on 9/30/16.
//  Copyright © 2016 Knoable. All rights reserved.
//

import UIKit

class CoinFlipViewController: UIViewController {

    static let storyboardIdentifier = "CoinFlipViewController"

    weak var delegate: CoinFlipViewControllerDelegate?

    var coin: Coin?

    @IBAction func pressedFlipButton(_ sender: AnyObject) {
        print("Flip a Coin")
        delegate?.buildCoinFlipViewController(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// This protocol is for communication between view controllers.
protocol CoinFlipViewControllerDelegate: class {
// Called when the user taps to flip the coin
    func buildCoinFlipViewController(_ controller: CoinFlipViewController)
}


