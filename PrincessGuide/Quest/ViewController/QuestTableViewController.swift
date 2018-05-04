//
//  QuestTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class QuestTableViewController: UITableViewController {
    
    static func configureAsync(equipment: Equipment, callback: @escaping (QuestTableViewController) -> Void) {
        LoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async {
            Master.shared.getQuests(containsEquipment: equipment.equipmentId) { quests in
                DispatchQueue.main.async {
                    let vc = QuestTableViewController()
                    vc.navigationItem.title = equipment.equipmentName
                    vc.quests = quests.sorted { $0.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds > $1.allRewards.first { $0.rewardID == equipment.equipmentId }!.odds }
                    vc.hidesBottomBarWhenPushed = true
                    vc.focusedItemID = equipment.equipmentId
                    LoadingHUDManager.default.hide()
                    callback(vc)
                }
            }
        }
    }

    var quests = [Quest]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var focusedItemID: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(QuestTableViewCell.self, forCellReuseIdentifier: QuestTableViewCell.description())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.beginUpdates()
        tableView.endUpdates()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestTableViewCell.description(), for: indexPath) as! QuestTableViewCell
        cell.configure(for: quests[indexPath.row], focusedID: focusedItemID)
        return cell
    }
    
}