//
//  MainViewController.swift
//  Go2meTRO
//
//  Created by 呂子揚 on 2024/1/18.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var debugModeBtn: UIButton!
    @IBOutlet weak var upDownBtn: UIButton!
    @IBOutlet weak var upToHongshulinTableView: UITableView!
   
    let viewModel = MainViewModel()
    let viewDebugModel = MainViewDebugModel()
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        upToHongshulinTableView.showsVerticalScrollIndicator = false
       

        DanhaiLRTRequestManager.shared.run()//MainTableViewCell
        upToHongshulinTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomSectionHeaderView")
//        upToHongshulinTableView.register(MainTableViewCell.self, forHeaderFooterViewReuseIdentifier: "MainTableViewCell")

        debugModeBtn.isHidden = !MainViewModel.isDebugMode

        
        DanhaiLRTRequestManager.shared.upToHongshulinSubject.asDriver(onErrorJustReturn: StationInfos.emptyEachStatinInfo).filter{
            return !$0.stations.isEmpty
        }.drive(onNext: {eachStationInfo in
            //                print("xxxxx\(eachStationInfo)")
            self.upToHongshulinTableView.reloadData()
        }).disposed(by: self.disposeBag)
        
        
        debugModeBtn.rx.tap
            .subscribe(onNext: {[unowned self]  in
                self.viewDebugModel.openDebugSetting = !viewDebugModel.openDebugSetting
                print("cccc::\( self.viewDebugModel.openDebugSetting)")

                self.upToHongshulinTableView.reloadData()
                
            }).disposed(by: self.disposeBag)
        upDownBtn.rx.tap
            .subscribe(onNext: {[unowned self]  in
                self.viewModel.directionNow = self.viewModel.directionNow == .up ? .down : .up
                
            }).disposed(by: self.disposeBag)
        
        
        
        
        
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch self.viewModel.directionNow {
        case .up:
            
            let info:StationInfos =  DanhaiLRTRequestManager.shared.upToHongshulinSubject.forceGetValue()
                
            if viewDebugModel.openDebugSetting{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DebugModeTableViewCell", for: indexPath) as! DebugModeTableViewCell
                cell.contentView.backgroundColor = indexPath.row%2 == 0 ? .cyan : .green
                cell.modifyLabelsSetting(info: info,row: indexPath.row)
                return cell
            }else if StationInfos.isVacant(infos: info) {
                //還沒取的資料
            }else{

                let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
                cell.timeLabel.text = String(arc4random_uniform(11))+"min"
                let staticInfos = DanhaiLRTRequestManager.shared.getStaticStationInfos()
                let theStationInfo = staticInfos[indexPath.row]
                cell.stationName.text = theStationInfo.localizationKey
                cell.arrivalTimeLabel.text = "12:44"
                
                return cell
            }
            
        case .down:
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            default:
                //use default value in View
                break
            }
        }
        
        
      
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.directionNow {
        case .up:
            
            switch section {
            case DanhaiLRTRouteManager.witchLRTLine.upToHongshulin.rawValue:
                return DanhaiLRTRouteManager.upToHongshulinStationKey.allCases.count
            case DanhaiLRTRouteManager.witchLRTLine.upToKanding.rawValue:
                return DanhaiLRTRouteManager.upToKandingStationKey.allCases.count
                
            default:
                return 0
                
            }
            
            
            let info =  DanhaiLRTRequestManager.shared.upToHongshulinSubject.forceGetValue()
            
            //            return info.GpsDatas.count == 1 ?
        case .down:
            return 8
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return DanhaiLRTRouteManager.witchLRTLine.allCases.count/2
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  viewDebugModel.openDebugSetting {
            return DebugModeTableViewCell.heigh
        }else{
            return MainTableViewCell.height
        }
        //        return 50
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CustomSectionHeaderView.height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
        //        view.backgroundColor = .blue
        //        return view
        switch self.viewModel.directionNow {
        case .up:
            switch section {
            case 0:
//                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomSectionHeaderView") as! CustomSectionHeaderView
//                headerView.defaultSeting(witchLRTLine: .upToHongshulin)
//                headerView.headLineLable.text = "GGGGGG"
//                headerView.subTitleLable.text = "hhhhhh"
//                return headerView
                break
            case 1:
                break
            case 2:
                break
            default:
                //use default value in View
                assertionFailure()
            }
        case .down:
            switch section {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            default:
                //use default value in View
                assertionFailure()
            }
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomSectionHeaderView") as! CustomSectionHeaderView
        headerView.defaultSeting(witchLRTLine: .upToHongshulin)
        headerView.headLineLable.text = "紅樹林"
        headerView.subTitleLable.text = "終點站"
        
        return headerView
    }
}
