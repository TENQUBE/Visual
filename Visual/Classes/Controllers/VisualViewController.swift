//
//  ViewController.swift
//  Visual
//
//  Created by tenqube on 15/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import UIKit
import JavaScriptCore

class VisualViewController : UIViewController, UIContractor, WebViewProtocol {
   
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    var visualViewDelegate: VisualViewDelegate?
    
    var paramPath: String = ""
    var paramUid: String?
    var paramApiKey: String?
    var paramLayer: String?
    
    var mUrl: String?
    
    var userRepository: UserRepo?
    var visualRepository: VisualRepo?
    var syncTranRepository: SyncTranRepo?
    var resourceRepository: ResourceRepo?
    var analysisRepository: AnalysisRepo?
    var parser: ParserProtocol?
    var logger: Log?
    var appExecutor: AppExecutors?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let visualRepo = self.visualRepository,
            let _ = self.userRepository,
            let _ = self.syncTranRepository,
            let _ = self.resourceRepository,
            let _ = self.analysisRepository,
            let _ = self.parser,
            let _ = self.logger,
            let _ = self.appExecutor
        
            else {
                self.loadFailPage()
                return
        }
        
        setSpinnserAnim(isActive: true)
        
        logger?.sendView(viewName: LogEvent.startVisual.rawValue)

        if let apiKey = paramApiKey {
            visualRepo.saveApiKey(apiKey: apiKey)
        }
        
        if let layer = paramLayer {
            visualRepo.saveLayer(layer: layer)
        }
 
        userRepository!.isSigned() {(isSigned) in
            
            if isSigned {
                self.start(url: self.getUrl(path: self.paramPath))
            } else {
                self.signUp()
            }
        }
    }
    
    func signUp() {
        
        guard let uid = paramUid else {
            finish()
            return
        }
 
        logger?.sendView(viewName: LogEvent.signUp.rawValue)
        
        self.userRepository!.signUp(uid: uid) {(signUpResult) in
            
            switch(signUpResult) {
            case .fail:
                self.loadFailPage()
                break
            case .success:
                self.start(url: self.getUrl(path: self.paramPath))
                break
            }
        }
    }
    
    func loadFailPage() {
        
        do {
            guard let url = Bundle(for: VisualViewController.self).url(forResource: "Visual", withExtension: "bundle"),
            let bundle = Bundle(url: url) else {
                    return
            }
            
            guard let filePath = bundle.path(forResource: "Resource.bundle/index", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            self.webView.loadHTMLString(contents as String, baseURL: baseUrl)
        } catch {
            finish()
        }
    }
    
    func start(url: String) {
        
        self.mUrl = url
        
        // set webBridge
        self.setBridges()

        // settings
        self.setSettings()

        // load
        self.loadUrl(url: url)
    }
    
    func setBridges() {
        let uiContractor = self as UIContractor
        let webViwProtocol = self as WebViewProtocol
        
        let uiBridge = UIBridge(webView: webViwProtocol, view: uiContractor)
        
        let repoBridge = RepositoryBridge(webView: webViwProtocol,
                                          visualRepository: visualRepository!,
                                          syncTranRepository: syncTranRepository!,
                                          analysisRepository: analysisRepository!,
                                          resourceRepository: resourceRepository!)
        
        let systemBridge = SystemBridge(webView: webViwProtocol)
        
        let actionBridge = ActionBridge(webView: webViwProtocol,
                                        view: uiContractor,
                                        visualRepository: visualRepository!,
                                        parser: parser!,
                                        syncTranRepository: syncTranRepository!,
                                        analysisRepository: analysisRepository!)
        
        let logBridge = LogBridge(webView: webViwProtocol, log: logger!)
        
        let errorBirdge = ErrorBridge(webView: webViwProtocol)
        
        self.webView.addJavascriptInterface(uiBridge, forKey: "visualUI")
        self.webView.addJavascriptInterface(repoBridge, forKey: "visualRepo")
        self.webView.addJavascriptInterface(systemBridge, forKey: "visualSystem")
        self.webView.addJavascriptInterface(logBridge, forKey: "visualLog")
        self.webView.addJavascriptInterface(errorBirdge, forKey: "visualError")
        self.webView.addJavascriptInterface(actionBridge, forKey: "visualAction")
        
    }
    
    func setSettings() {
        self.webView.scalesPageToFit = true
        self.webView.scrollView.bounces = false
    }
    
    func loadUrl(url: String) {
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
    }
    
    func getUrl(path: String) -> String {
        let baseUrl = self.visualRepository!.getWebUrl()
        let version = "/#v=" + Constants.Web.Version
        return baseUrl + version + path
    }
    
    func executeJs(js: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Change `2.0` to the desired number of seconds.
            self.webView.stringByEvaluatingJavaScript(from: js)
        }
        
    }
    
    func show(alert: UIAlertController, animated: Bool, completion: @escaping () -> Void) {
        self.appExecutor?.mainThread.async {
            self.present(alert, animated: false, completion: completion)
        }
    }
       
    
    func onPageLoaded() {
        self.appExecutor?.mainThread.async {
             self.setSpinnserAnim(isActive: false)
        }
       
    }
    
    func setRefreshEnabled(enabled: Bool) {
        
    }
    
    func finish() {
        self.appExecutor?.mainThread.async {
            self.visualViewDelegate?.onFinish()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func retry() {
        self.appExecutor?.mainThread.async {
            guard let failUrl = self.mUrl, let url = URL(string: failUrl) else {
                return
            }
            self.webView.loadRequest(URLRequest(url: url))
        }
        
    }
    
    func reload() {
        self.appExecutor?.mainThread.async {
            self.webView.reload()
        }
    }
    
    func addView(view: UIView) {
        self.appExecutor?.mainThread.async {
            self.view.addSubview(view)

        }
    }
    
    func getView() -> UIView {
        return self.view
    }

    func openNewView(path: String) {
        self.appExecutor?.mainThread.async {
            guard let vvc = self.storyboard?.instantiateViewController(withIdentifier: "Visual") as? VisualViewController else {
                return
            }
            
            vvc.paramPath = path
            
            self.present(vvc, animated: true)
            
        }
        
    }
    
    func goSafari(url: URL) {
        self.appExecutor?.mainThread.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    func export(path: URL) {
        self.appExecutor?.mainThread.async {
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            ////        vc.excludedActivityTypes = [
            ////            UIActivity.ActivityType.assignToContact,
            ////            UIActivity.ActivityType.saveToCameraRoll,
            ////            UIActivity.ActivityType.postToFlickr,
            ////            UIActivity.ActivityType.postToVimeo,
            ////            UIActivity.ActivityType.postToTencentWeibo,
            ////            UIActivity.ActivityType.postToTwitter,
            ////            UIActivity.ActivityType.postToFacebook,
            ////            UIActivity.ActivityType.openInIBooks
            ////        ]
            self.present(vc, animated: true, completion: nil)
        }
      
        
    }
    
    func goMsgApp() {
        
        self.appExecutor?.mainThread.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
}

extension VisualViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        setSpinnserAnim(isActive: false)
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

        print("webViewDidFinishLoad")
        self.setSpinnserAnim(isActive: false)
        
    
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       
        print("error",error)

        self.appExecutor?.mainThread.async {
            self.setSpinnserAnim(isActive: false)
            self.loadFailPage()
        }
    }
    
    func setSpinnserAnim(isActive: Bool) {
//        self.appExecutor?.mainThread.async {
//         
//            if isActive {
//                self.spinner.startAnimating()
//            } else {
//                self.spinner.stopAnimating()
//            }
//        }
    }
}

