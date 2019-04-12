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
    
    @IBAction func pressInfo(_ sender: AnyObject) {
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutVC");
        self.present(newVC, animated: true);
    }

    @IBAction func clickedShowHelp(_ sender: AnyObject) {
        self.spinningLoader.startAnimating();
        performGetRequest(url: configAPIBase + "generate", completion: {a,n in
            ipcResourceId = String(data: n, encoding: .utf8)!;
            //DispatchQueue.main.sync(execute: {popupAlert(parent: self, title: "Copied", message: "ID copied");});
            DispatchQueue.main.sync(execute: {
                self.spinningLoader.stopAnimating();
                let newVC = UIStoryboard(name: "Conversation", bundle: nil).instantiateInitialViewController();
                self.present(newVC!, animated: true);

            });
        }, error: {err in
            popupAlert(parent: self, title: "An error has occurred", message: "Unable to reach API. " + err.localizedDescription);
            DispatchQueue.main.sync(execute: {self.spinningLoader.stopAnimating();});
        })
    }
}
class HAboutViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true);
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
