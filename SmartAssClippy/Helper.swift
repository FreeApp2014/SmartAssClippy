//
// Created by admin on 2019-04-08.
// Copyright (c) 2019 admin. All rights reserved.
//

import Foundation
import UIKit

func displayDialogActionSheet(parent: UIViewController, title: String, text: String, actions: [UIAlertAction], completion: @escaping ()->Void){
    let asToPresent: UIAlertController = UIAlertController.init(title: title, message: text, preferredStyle: UIAlertControllerStyle.actionSheet);
    for action in actions {
        asToPresent.addAction(action);
    }
    asToPresent.addAction(UIAlertAction.init(title: "Close Dialog", style: UIAlertActionStyle.cancel, handler: nil));
    parent.present(asToPresent, animated: true, completion: completion);
}
func performGetRequest(url: String, completion: @escaping (URLResponse, Data) -> Void, error: @escaping (Error) -> Void){
    let url: URL = URL(string: url)!;
    let task = URLSession.shared.dataTask(with: url){ data, response, err in
        if (err != nil) {
            error(err!);
        } else {
            completion(response!, data!);
        }
    }
    task.resume();
}

func popupAlert(parent: UIViewController, title: String, message: String){
    let asToPresent: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
    asToPresent.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil));
    parent.present(asToPresent, animated: true, completion: nil);
}

