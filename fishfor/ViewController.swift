//
//  ViewController.swift
//  fishfor
//
//  Created by Morten Just Petersen on 6/18/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var blockerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("are you loaded NOW?")
        let js = "$('input#nav-search-keywords.nav-input').focus()"
        
        
        // let's hide the blue view
        UIView.animateWithDuration(0.9, delay: 0, options: .CurveEaseInOut, animations: {
            self.blockerView.alpha = 0
            }) { (done) in
                // done
        }
        
        
        webView.evaluateJavaScript(js) { (obj, error) in
            print("injected dat scriptz")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        blockerView = UIView(frame: view.frame)
        blockerView.backgroundColor = UIColor(red:0.135, green:0.183, blue:0.246, alpha:1)
        blockerView.userInteractionEnabled = false
        
        webView.addSubview(blockerView)
        
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        view.backgroundColor = UIColor(red:0.135, green:0.183, blue:0.246, alpha:1)
        // Do any additional setup after loading the view, typically from a nib.
        
        let initialUrl = "https://www.amazon.com/b/ref=aw_lnk_sm_kbk/182-6354739-5340946?_encoding=UTF8&aid=aw_palldept&apid=2468829862&arc=1201&arid=MJHM0K1GARYMXF5EJJJR&asn=center-4&node=154606011&rh=i"
        let req = NSURLRequest(URL: NSURL(string: initialUrl)!)
        webView.loadRequest(req)
        
        webView.bringSubviewToFront(blockerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

