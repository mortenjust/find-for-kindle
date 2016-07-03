//
//  ActionViewController.swift
//  here
//
//  Created by Morten Just Petersen on 6/18/16.
//  Copyright © 2016 Morten Just Petersen. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
//    @IBOutlet weak var topBar: UINavigationBar!
    
    

    @IBOutlet weak var doneButton: UIButton!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        print("We just pressed the button")
        extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let draggedTo = scrollView.contentOffset.y
        if draggedTo < -140 {
            self.done()
            print("DONE")
        }
        
//        print("did end dragging at "+String(scrollView.contentOffset.y))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.hidden = true // overscroll may be enough for now        
        webView.scrollView.delegate = self
        
        view.backgroundColor = UIColor(red:0.135, green:0.183, blue:0.246, alpha:1)
        navigationController?.navigationBar.barStyle = .Black
        
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    // this is text
                    itemProvider.loadItemForTypeIdentifier(kUTTypeText as String, options: nil, completionHandler: { (text, error) in
                        
                        if let searchString = text {
                            print("let's do something about \(searchString)")
                            self.loadPage(self.webView, query: searchString as! String)
                            
                            // load the web view
                        } else {
                            print("we don't know what to do ")
                        }
                    })
                }
            }

            // let's only do something about the last item (would there ever be several?)
            
        }
    }
    
    func loadPage(webView:UIWebView, query:String){
        let escapedQuery = query
            .stringByAddingPercentEncodingWithAllowedCharacters(
                NSCharacterSet.URLHostAllowedCharacterSet())!
        let urlString = "https://www.amazon.com/gp/aw/s/ref=is_s?n=154606011&n=154606011&k=\(escapedQuery)"
        let req = NSURLRequest(URL: NSURL(string: urlString)!)
        webView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}
