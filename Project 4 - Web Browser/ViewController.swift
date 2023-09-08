//
//  ViewController.swift
//  Project 4 - Web Browser
//
//  Created by Mina Thabet on 19/08/2023.
//

import UIKit
import WebKit
class ViewController: UITableViewController, WKNavigationDelegate  {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        websites+=["apple.com", "facebook.com"]
    }
/* override func loadView() {
     }
*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        webView = WKWebView()
        view = webView
        webView.navigationDelegate = self
        let url = URL(string: "https://" + websites[indexPath.row])!
        webView.load(URLRequest(url: url))
              webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open page...", style: .plain, target: self, action: #selector(openTapped))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", image: nil, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", image: nil, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title:"open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }
    func openPage(action: UIAlertAction){
        let url = URL(string:   "https://" + action.title!)!
        webView.load(URLRequest(url:url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        let ac = UIAlertController(title: "Site Blocked", message: "Accessing this website is not allowed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

