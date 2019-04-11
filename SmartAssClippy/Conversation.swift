//
//  Conversation.swift
//  SmartAssClippy
//
//  Created by admin on 10/04/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

var apiValue: Any = "";
var lastCGFloat = CGFloat(0.0);
var quid = "";

class CViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }

    @IBOutlet weak var btnProt: UIButton!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad();
        lastCGFloat = self.btnProt.frame.minY;
        loadTask();
    }

    private func spawnActionButton (title: String, y: CGFloat, id: String) -> CGFloat {
        let btnY: CGFloat = y + btnProt.frame.height;
        let newButton: UIButton = UIButton();
        newButton.frame = CGRect(x: btnProt.frame.minX, y: btnY, width: btnProt.frame.width, height: btnProt.frame.height);
        newButton.setTitle(title, for: .normal);
        newButton.setTitleColor(btnProt.currentTitleColor, for: .normal);
        newButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside);
        newButton.restorationIdentifier = id;
        newButton.clearsContextBeforeDrawing = true;
        self.view.addSubview(newButton);
        return btnY;
    }
    @objc private func actionButton(sender: UIButton){
        loadNextTask(rId: (sender.restorationIdentifier)!, qId: quid)
    }
    private func loadTask(){
        performGetRequest(url: configAPIBase + "task?id=" + ipcResourceId, completion: { response, data in
            do {apiValue = try JSONSerialization.jsonObject(with: data);} catch {popupAlert(parent: self, title: "Error", message: "Unable to parse API response."); return;};
            if let apiValue2 = apiValue as? [String: Any] {
                quid = apiValue2["qId"] as! String;
                DispatchQueue.main.sync(execute: { self.textView.text = apiValue2["text"] as? String; })
                let options = (apiValue2["options"])! as! NSArray;
                for option in options {
                    DispatchQueue.main.sync(execute: {lastCGFloat = self.spawnActionButton(title: ((option as! [String: String])["text"])!, y: lastCGFloat, id: ((option as! [String: String])["rId"])!);});
                }
            }
        }, error:  {err in popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);})
    }
    private func loadNextTask(rId: String, qId: String){
        performGetRequest(url: configAPIBase + "taskResponse?taskId=" + ipcResourceId + "&question=" + qId + "&response=" + rId , completion: { response, data in
            //TODO: rewrite everything here
            do {apiValue = try JSONSerialization.jsonObject(with: data);} catch {popupAlert(parent: self, title: "Error", message: "Unable to parse API response."); return;};
            if let apiValue2 = apiValue as? [String: Any]{
                self.textView.text = apiValue2["text"] as? String;
                if let options = apiValue2["options"] as? [[String: String]] {
                    for option in options {
                        lastCGFloat = self.spawnActionButton(title: (option["text"])!, y: lastCGFloat, id: (option["rId"])!);
                    }
                }
            }

        }, error:  {err in popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);})
    }
}
