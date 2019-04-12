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
var spawnedBtns: [UIButton] = [];
var taskInfo: [String: String] = [:];

class CViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }

    @IBOutlet weak var btnProt: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var spinningLoader: UIActivityIndicatorView!
    
    @IBAction func pressInfo(_ sender: AnyObject) {
        let newVC = UIStoryboard(name: "Conversation", bundle: nil).instantiateViewController(withIdentifier: "aboutTaskVC");
        self.present(newVC, animated: true);
    }
    @IBAction func pressCancel(_ sender: AnyObject) {
        self.dismiss(animated: true);
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        lastCGFloat = self.btnProt.frame.minY;
        loadTask();
    }

    private func spawnActionButton(title: String, y: CGFloat, id: String) -> CGFloat {
        let btnY: CGFloat = y + btnProt.frame.height;
        let newButton: UIButton = UIButton();
        newButton.frame = CGRect(x: btnProt.frame.minX, y: btnY, width: btnProt.frame.width, height: btnProt.frame.height);
        newButton.setTitle(title, for: .normal);
        newButton.setTitleColor(btnProt.currentTitleColor, for: .normal);
        newButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside);
        newButton.restorationIdentifier = id;
        newButton.clearsContextBeforeDrawing = true;
        spawnedBtns.append(newButton);
        self.view.addSubview(newButton);
        return btnY;
    }

    private func removeAllButtons() {
        for button in spawnedBtns {
            DispatchQueue.main.sync(execute: {
                button.removeFromSuperview();
            });
        }
        spawnedBtns.removeAll();
        lastCGFloat = self.btnProt.frame.minY;
    }

    @objc private func actionButton(sender: UIButton) {
//        DispatchQueue.main.sync(execute: {
//            self.spinningLoader.startAnimating();
//        })
        loadNextTask(rId: (sender.restorationIdentifier)!, qId: quid)
    }

    private func loadTask() {
        performGetRequest(url: configAPIBase + "task?id=" + ipcResourceId, completion: { response, data in
            do {
                apiValue = try JSONSerialization.jsonObject(with: data);
            } catch {
                DispatchQueue.main.sync(execute: {
                    popupAlert(parent: self, title: "Error", message: "Unable to parse API response.");
                })
                return;
            };
            if let apiValue2 = apiValue as? [String: Any] {
                let info = apiValue2["info"] as! [String: String];
                DispatchQueue.main.sync(execute: {
                    self.navBar.title = info["name"];
                })
                quid = apiValue2["qId"] as! String;
                DispatchQueue.main.sync(execute: {
                    self.textView.text = apiValue2["text"] as? String;
                })
                let options = (apiValue2["options"])! as! NSArray;
                for option in options {
                    DispatchQueue.main.sync(execute: {
                        lastCGFloat = self.spawnActionButton(title: ((option as! [String: String])["text"])!, y: lastCGFloat, id: ((option as! [String: String])["rId"])!);
                    });
                }
                DispatchQueue.main.sync(execute: {
                    self.spinningLoader.stopAnimating();
                })
            }
        }, error: { err in
            DispatchQueue.main.sync(execute: {
                popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            })
        })
    }

    private func loadNextTask(rId: String, qId: String) {
        performGetRequest(url: configAPIBase + "taskResponse?taskId=" + ipcResourceId + "&question=" + qId + "&response=" + rId, completion: { response, data in
            do {
                apiValue = try JSONSerialization.jsonObject(with: data);
            } catch {
                DispatchQueue.main.sync(execute: {
                    popupAlert(parent: self, title: "Error", message: "Unable to parse API response.");
                })
                return;
            };
            self.removeAllButtons();
            if let apiValue2 = apiValue as? [String: Any] {
                DispatchQueue.main.sync(execute: {
                    self.textView.text = apiValue2["text"] as? String;
                })
                let options = (apiValue2["options"])! as! NSArray;
                for option in options {
                    DispatchQueue.main.sync(execute: {
                        lastCGFloat = self.spawnActionButton(title: ((option as! [String: String])["text"])!, y: lastCGFloat, id: ((option as! [String: String])["rId"])!);
                    });
                }
                DispatchQueue.main.sync(execute: {
                    self.spinningLoader.stopAnimating();
                })
            }

        }, error: { err in
            DispatchQueue.main.sync(execute: {
                popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            })
        })
    }
}

class ATViewController: UIViewController{
    @IBAction func pressDone(){
        self.dismiss(animated: true);
    }
}
