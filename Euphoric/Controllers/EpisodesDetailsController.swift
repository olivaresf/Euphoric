//
//  EpisodesDetailsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 16/08/20.
//

import UIKit
import SwiftSoup
import WebKit

class EpisodeDetailsController: UIViewController {
    let webView2 = WKWebView()
    
    var episode:Episode?{
        didSet{
            guard let episode = episode else {return}
            navigationItem.title = episode.title
            webView2.loadHTMLString("<span style=\"font-family: -apple-system; font-size: 42\">\(episode.htmlDescription ?? "")</span>", baseURL: nil)
        }
    }
    
    let htmlDescription:UITextView = {
        let tv = UITextView()
        tv.isUserInteractionEnabled = false
        tv.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        tv.textColor = .black
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView2)
        webView2.navigationDelegate = self
        webView2.fillSuperview(padding: .init(top: 18, left: 14, bottom: 18, right: 14))
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


