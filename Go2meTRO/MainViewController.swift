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
    @IBOutlet weak var upToHongshulinTableView: UITableView!
    
    let upToHongshulinTableViewDataDelegate = UpToHongshulinTableViewDataDelegate()
    let upToHongshulinTableViewDataSource = UpToHongshulinTableViewDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
//       let upToHongshulinTableViewDelegate = UpToHongshulinTableViewDelegate()
//        upToHongshulinTableView.dataSource = upToHongshulinTableViewDelegate
//        upToHongshulinTableView.delegate   = upToHongshulinTableViewDelegate
        
        upToHongshulinTableView.delegate = upToHongshulinTableViewDataDelegate
        upToHongshulinTableView.dataSource = upToHongshulinTableViewDataSource
        upToHongshulinTableView.register(CustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomSectionHeaderView")

        DanhaiLRTRequestManager.shared.upToHongshulinSubject.subscribe(onNext: {eachStationInfo in
            print("xxxxx\(eachStationInfo)")
            self.upToHongshulinTableView.reloadData()
        }).disposed(by: self.disposeBag)
        
        
        

           
    }
}
class UpToHongshulinTableViewDataSource:NSObject, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpToHongshulinTableViewCell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
}
class UpToHongshulinTableViewDataDelegate:NSObject, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
//        view.backgroundColor = .blue
//        return view
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
