//
//  Clippy.swift
//  SmartAssSoftware
//
//  Created by admin on 08/04/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var spinningLoader: UIActivityIndicatorView!

    @IBAction func clickedShowHelp(_ sender: AnyObject) {
        self.spinningLoader.startAnimating();
        performGetRequest(url: configAPIBase + "generate", completion: /*handleResponse*/{a,b in}, error: {err in
            popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            self.spinningLoader.stopAnimating();
        })
    }
    func continueOperation(qId: String, rId: String) -> Void {
        performGetRequest(url: configAPIBase + "submitResponse?qid=" + qId + "&rid=" + rId, completion: /*handleResponse*/{a,n in }, error: {err in
            popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            self.spinningLoader.stopAnimating();
        })
    }

/*    func handleResponse (response: URLResponse, data: Data) -> Void {
        let parsedResponse = try? JSONSerialization.jsonObject(with: data, options: []);
        if let parsedResponse = parsedResponse as? [String: Any] {
            if (String(describing: parsedResponse["state"]) != "ok"){
                popupAlert(parent: self, title: "An error has occurred", message: "API returned an error: " + String(describing: parsedResponse["errorCode"]!) + String(describing: parsedResponse["errorHuman"]!));
            } else {
                if let responseDict = parsedResponse["response"] as? [String: String] {
                    var actions: [UIAlertAction] = [];
                    let question: String = responseDict["question"]!;
                    if (!Bool.init(responseDict["endOfDialog"]!)!) {
                        if let actions = responseDict["actions"] as? [Dictionary] {
                            for action in actions {
                                actions.append(contentsOf: UIAlertAction.init(title: action["buttonTitle"], style: UIAlertActionStyle.default, handler: continueOperation(qId: responseDict["qid"], rId: action["rid"])));
                            }
                        }
                    }
                    displayDialogActionSheet(parent: self, title: "Clippy says", text: question, actions: actions, completion: { () in self.spinningLoader.stopAnimating() });
                }
            }
        }
    }*/
}
class HAboutViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func discordBtn(_ sender: AnyObject) {
        UIApplication.shared.open(URL.init(string: "https://discord.gg/cuaEvdg")!);
    }
    @IBAction func githubBtn(_ sender: AnyObject) {
        UIApplication.shared.open(URL.init(string: "https://github.com/FreeApp2014/SmartAssClippy")!);

    }
    @IBAction func twitterBtn(_ sender: AnyObject) {
        UIApplication.shared.open(URL.init(string: "https://twitter.com/FreeAppSW")!);

    }
}
