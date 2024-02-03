//
//  MainViewController.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/18.
//

import UIKit
import RxSwift
import RxDataSources
class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DanhaiLRTRequestManager.shared.upToHongshulinSubject.subscribe(onNext: {eachStationInfo in
            print("xxxxx\(eachStationInfo)")
        }).disposed(by: self.disposeBag)
        
        
        let sub = DanhaiLRTRequestManager.shared.upToHongshulinSubject.map { eachStationInfo -> SectionModel in
            let section = SectionModel(model: "", items:[eachStationInfo])
            
            
//            return eachStationInfo.GpsDatas
            return section
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: configureCell)

           
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
