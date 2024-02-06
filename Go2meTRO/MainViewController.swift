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
    @IBOutlet weak var upDownBtn: UIButton!
    @IBOutlet weak var upToHongshulinTableView: UITableView!
    
    
    var directionNow = DirectionNow.up
    lazy var upToHongshulinTableViewDataDelegate = UpToHongshulinTableViewDataDelegate(directionNow: self.directionNow)
    lazy var upToHongshulinTableViewDataSource = UpToHongshulinTableViewDataSource(directionNow: self.directionNow)

    override func viewDidLoad() {
        super.viewDidLoad()
        //       let upToHongshulinTableViewDelegate = UpToHongshulinTableViewDelegate()
        //        upToHongshulinTableView.dataSource = upToHongshulinTableViewDelegate
        //        upToHongshulinTableView.delegate   = upToHongshulinTableViewDelegate
        
        upToHongshulinTableView.delegate = upToHongshulinTableViewDataDelegate
        upToHongshulinTableView.dataSource = upToHongshulinTableViewDataSource
        upToHongshulinTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomSectionHeaderView")
        
        DanhaiLRTRequestManager.shared.upToHongshulinSubject.asDriver(onErrorJustReturn: emptyEachStatinInfo).filter{
                return !$0.stations.isEmpty
        }.drive(onNext: {eachStationInfo in
//                print("xxxxx\(eachStationInfo)")
                self.upToHongshulinTableView.reloadData()
            }).disposed(by: self.disposeBag)
        
        
        
        upDownBtn.rx.tap
            .subscribe(onNext: {[unowned self]  in
                self.directionNow = self.directionNow == .up ? .down : .up
                print("cccc::\(self.directionNow)")
                
            }).disposed(by: self.disposeBag)
        
        
        
        
        
    }
}
class UpToHongshulinTableViewDataSource:NSObject, UITableViewDataSource{
    var directionNow:DirectionNow
    
    init(directionNow: DirectionNow) {
        self.directionNow = directionNow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpToHongshulinTableViewCell", for: indexPath) as! UpToHongshulinTableViewCell
        cell.contentView.backgroundColor = .red
        
        switch self.directionNow {
        case .up:
            
            let info =  DanhaiLRTRequestManager.shared.upToHongshulinSubject.forceGetValue()
            
            if info.GpsDatas.count == 1 {
                cell.tt.text = info.GpsDatas[0].carNum

            }else{
                cell.tt.text = info.GpsDatas[indexPath.row].carNum

            }
            break
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
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.directionNow {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {DanhaiLRTRouteManager.witchLRTLine.allCases.count/2}
    
}
class UpToHongshulinTableViewDataDelegate:NSObject, UITableViewDelegate{
    var directionNow:DirectionNow
    
    init(directionNow: DirectionNow) {
        self.directionNow = directionNow
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
        //        view.backgroundColor = .blue
        //        return view
        switch self.directionNow {
        case .up:
            switch section {
            case 0:
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomSectionHeaderView") as! CustomSectionHeaderView
                headerView.titleLabel.text = "ggggg"
                return headerView
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
        headerView.titleLabel.text = "ggggg"
        return headerView
    }
    
}
class CustomSectionHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
