//
//  ExecutorCellTableViewCell.swift
//  HW_20
//
//  Created by Ivan Konishchev on 03.08.2023.
//

import UIKit
import SnapKit

class ExecuterCell: UITableViewCell {

    
   private lazy var lableFName: UILabel =
    {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return lable
    }()
    
    private lazy var lableLName: UILabel =
    {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return lable
    }()
    
    private lazy var lableDate: UILabel =
    {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return lable
    }()
    
    private lazy var lableCountry: UILabel =
    {
        let lable = UILabel()
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        lableFName.text = "Иван"
        lableLName.text = "Konishchev"
        lableDate.text = "12.12.1111"
        lableCountry.text = "Russia"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView()
    {
        self.addSubview(lableFName)
        self.addSubview(lableLName)
        self.addSubview(lableDate)
        self.addSubview(lableCountry)
        lableFName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            
        }
        
        lableLName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            make.top.equalTo(lableFName.snp.bottom).offset(5)
        }
        
        lableDate.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            make.top.greaterThanOrEqualTo(10)
        }
        lableCountry.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            make.top.equalTo(lableDate.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setupData(executor: Executors, date: String)
    {
        lableFName.text = executor.firstName
        lableLName.text = executor.lastName
        lableDate.text = date
        lableCountry.text = executor.country
    }
}
