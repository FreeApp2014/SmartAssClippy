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
    
    @IBOutlet weak var spinningLoader: UIActivityIndicatorView!

    @IBAction func clickedShowHelp(_ sender: AnyObject) {
        self.spinningLoader.startAnimating();
        performGetRequest(url: configAPIBase + "generate", completion: handleResponse, error: {err in
            popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            self.spinningLoader.stopAnimating();
        })
    }
    private func continueOperation(qId: String, rId: String){
        performGetRequest(url: configAPIBase + "submitResponse?qid=" + qId + "&rid=" + rId, completion: <#T##@escaping (URLResponse, Data) -> Void##@escaping (Foundation.URLResponse, Foundation.Data) -> Swift.Void#>, error: <#T##@escaping (Error) -> Void##@escaping (Swift.Error) -> Swift.Void#>)
    }

    private func handleResponse (data: Data, response: URLResponse) {
        let parsedResponse = try? JSONSerialization.jsonObject(with: data, options: []);
        if let parsedResponse = parsedResponse as? [String: String] {
            if (parsedResponse["state"] != "ok"){
                popupAlert(parent: self, title: "An error has occurred", message: "API returned an error: " + parsedResponse["errorCode"]! + parsedResponse["errorHuman"]!);
                return;
            }
            if let responseDict = parsedResponse["response"] as? [String: String]{
                var actions: [UIAlertAction] = [];
                let question: String = responseDict["question"]!;
                if let actions = responseDict["actions"] as? [Dictionary]{
                    for action in actions {
                        actions.append(contentsOf: UIAlertAction.init(title: action["buttonTitle"], style: UIAlertActionStyle.default, handler: continueOperation(qId: responseDict["qid"], rId: action["rid"])));
                    }
                }
                displayDialogActionSheet(parent: self, title: "Question", text: "", actions: actions, completion: {() in self.spinningLoader.stopAnimating()});

            }
        }
    }
}

