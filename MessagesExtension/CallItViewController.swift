//
//  CallItViewController.swift
//  CoinFlip
//
//  Created by Tim Rayle on 10/5/16.
//  Copyright © 2016 Knoable. All rights reserved.
//

import UIKit

class CallItViewController: UIViewController {

    static let storyboardIdentifier = "CallItViewController"

    weak var delegate: CallItViewControllerDelegate?

    var coin: Coin?
    
    @IBAction func calledHeads(_ sender: AnyObject) {
        coin?.call = true
        delegate?.buildCallItViewController(self)
        printOutcome()
    }
    @IBAction func calledTails(_ sender: AnyObject) {
        coin?.call = false
        delegate?.buildCallItViewController(self)
        printOutcome()
    }
    private func printOutcome() {
        if (coin?.calledIt)! {
            print("You win")
        }
        else {
            print("You lose")
        }
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

// This protocol allows communication between view controllers
protocol CallItViewControllerDelegate: class {
    // Called when the user calls the toss as either heads or tails
    func buildCallItViewController(_ controller: CallItViewController)
}

