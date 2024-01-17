//
//  ViewController.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/16.
//

import UIKit
import RxAlamofire
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let aa = NetworManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cc  = aa.updateRailV()
        cc.subscribe({aa in
            
        }).disposed(by: disposeBag)
        
   
    }


}

