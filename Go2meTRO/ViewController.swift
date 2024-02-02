//
//  ViewController.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/16.
//

import UIKit
import RxAlamofire
import RxSwift
import WebKit
import RxCocoa
class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let aa = DanhaiLRTRequestManager()
    lazy var webView = WKWebView(frame: self.view.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.backgroundColor = .red
//        let webView = WKWebView(frame: self.view.bounds)
        self.view .addSubview(webView)
        self.view.addSubview(btn)
        
        
        _ = btn.rx.tap.subscribe({[unowned self] _ in
            
        }).disposed(by: disposeBag)
        webView.load(URLRequest(url: URL(string: LRT_URLs.ntmetroHome.rawValue)!))
        webView.rx.didFinishLoad.subscribe(
            onNext: {[unowned self] _ in
                webView.evaluateJavaScript("""
                 document.querySelectorAll('[aria-current="page"]')[1].click()

                
                                            
                                            
                                            
                                            
                """)
                
                
                
            },
            onError: {error in
                
            }).disposed(by: disposeBag)
        webView.rx.didCommit.subscribe({ _ in
                
            
            
        }).disposed(by: disposeBag)
        
//        webView.evaluateJavaScript("""
//                 document.querySelectorAll('[aria-current="page"]')[1].click()
//                            
//                """)
        
    }
    override func viewDidAppear(_ animated: Bool) {
      
    }
    
}

