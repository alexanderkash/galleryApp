//
//  DetailInfoViewController.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit
import WebKit

class DetailInfoViewController: UIViewController {
    
    private let url: String
    @IBOutlet private weak var webView: WKWebView!
    
    init?(url: String, coder: NSCoder) {
        self.url = url
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureWebView()
    }
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func configureWebView() {
        view = webView
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
        guard let url = URL(string: self.url) else { return }
        webView.load(URLRequest(url: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
