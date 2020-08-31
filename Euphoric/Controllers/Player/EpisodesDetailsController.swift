//
//  EpisodesDetailsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 16/08/20.
//

import UIKit
import WebKit

class EpisodeDetailsController: UIViewController {
    
    let spiner = UIActivityIndicatorView(style: .medium)
    let webView = WKWebView()
    
    var episode:Episode?{
        didSet{
            spiner.startAnimating()
            guard let episode = episode else {return}
            navigationItem.title = episode.title
            webView.loadHTMLString("<span style=\"font-family: -apple-system; font-size: 42\">\(episode.htmlDescription ?? "")</span>", baseURL: nil)
            spiner.stopAnimating()
        }
    }
    
    let htmlDescription:UITextView = {
        let tv = UITextView()
        tv.isUserInteractionEnabled = false
        tv.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        tv.textColor = .normalDark
        tv.backgroundColor = .clear
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "blueBackground")
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.fillSuperview(padding: .init(top: 18, left: 14, bottom: 18, right: 14))
        webView.isOpaque = false
        webView.backgroundColor = UIColor(named: "blueBackground")
        webView.addSubview(spiner)
        spiner.fillSuperview()
    }
}

extension EpisodeDetailsController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}


