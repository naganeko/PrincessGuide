//
//  CharaView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CharaView: UIView {

    let icon = IconImageView()
    
    let rarityView = RarityView()
    
    let bondRankView = CharaItemView()
    
    let rankView = CharaItemView()
    
    let levelView = CharaItemView()
    
    let skillLevelView = CharaItemView()
    
    let uniqueEquipmentLevelView = CharaItemView()
    
    var icons = [SelectableIconImageView]()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addSubview(rarityView)
        rarityView.stackView.alignment = .center
        rarityView.snp.makeConstraints { (make) in
            make.centerX.equalTo(icon)
            make.width.lessThanOrEqualTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
        
        addSubview(levelView)
        levelView.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalToSuperview()
        }
        
        addSubview(bondRankView)
        bondRankView.snp.makeConstraints { (make) in
            make.left.equalTo(levelView.snp.right)
            make.right.equalToSuperview()
            make.width.top.equalTo(levelView)
        }
        
        addSubview(rankView)
        rankView.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(levelView.snp.bottom).offset(10)
        }
        
        addSubview(skillLevelView)
        skillLevelView.snp.makeConstraints { (make) in
            make.left.equalTo(rankView.snp.right)
            make.right.equalToSuperview()
            make.width.top.equalTo(rankView)
        }
        
        addSubview(uniqueEquipmentLevelView)
        uniqueEquipmentLevelView.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(rankView.snp.bottom).offset(10)
        }
        
//        addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.lessThanOrEqualToSuperview()
//            make.top.greaterThanOrEqualTo(skillLevelView.snp.bottom).offset(5)
//            make.top.greaterThanOrEqualTo(rarityView.snp.bottom).offset(5)
//            make.height.equalTo(self.snp.width).dividedBy(6).offset(-50 / 6)
//            make.bottom.equalToSuperview()
//        }
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
        
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .vertical)
        icon.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for chara: Chara) {
        let card = Card.findByID(Int(chara.id))
        
        if chara.rarity >= 3 {
            icon.cardID = chara.card?.iconID(style: .r3)
        } else {
            icon.cardID = chara.card?.iconID(style: .r1)
        }
        
        rarityView.setup(stars: Int(chara.rarity))
        
        levelView.configure(for: NSLocalizedString("Level", comment: ""), content: String(chara.level))
        
        bondRankView.configure(for: NSLocalizedString("Bond Rank", comment: ""), content: String(chara.bondRank))
        
        var rankString = "\(chara.rank)"
        if let currentRankSlotCount = card?.promotions[Int(chara.rank - 1)].equipSlots.filter({ $0 != 999999 }).count {
            let equipedSlotCount = chara.slots.filter { $0 }.count
            rankString += "(\(equipedSlotCount)/\(currentRankSlotCount))"
        }
        rankView.configure(for: NSLocalizedString("Rank", comment: ""), content: rankString )
        
        skillLevelView.configure(for: NSLocalizedString("SLv.", comment: ""), content: String(chara.skillLevel))
        
        uniqueEquipmentLevelView.isHidden = !chara.enablesUniqueEquipment
        uniqueEquipmentLevelView.configure(for: NSLocalizedString("Unique Equipment Lv.", comment: ""), content: String(chara.uniqueEquipmentLevel))
//        icons.forEach {
//            $0.removeFromSuperview()
//        }
//        icons.removeAll()
//        
//        if let promotions = card?.promotions, promotions.indices ~= Int(chara.rank - 1) {
//            zip(chara.slots, promotions[Int(chara.rank - 1)].equipSlots).forEach {
//                let icon = SelectableIconImageView()
//                icon.equipmentID = $1
//                icon.isSelected = $0
//                stackView.addArrangedSubview(icon)
//                icons.append(icon)
//            }
//        }
        
    }
    
}
