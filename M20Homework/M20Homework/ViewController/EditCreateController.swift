//
//  EditCreateController.swift
//  M20Homework
//
//  Created by Ivan Konishchev on 06.08.2023.
//

import UIKit
import SnapKit
//import CoreData

class EditCreateController: UIViewController {
    
    
    var executor: Executors?
    var date: Date = Date()
    var indexPath: IndexPath!
    weak var updateTableDelegate: UpdateTableViewDelegate?
    private lazy var dateFormatter: DateFormatter =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    //MARK: - view
    private lazy var fName: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.text = "Name"
        return label
    }()
    
    private lazy var fNmaeTextField: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Input name"
        textField.borderStyle = .line
        textField.textColor = .black
        
        return textField
    }()
    
    private lazy var lName: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.text = "Last name"
        return label
    }()
    
    private lazy var lNmaeTextField: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Input last name"
        textField.borderStyle = .line
        textField.textColor = .black
        
        return textField
    }()
    
    private lazy var country: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.text = "Country"
        return label
    }()
    
    private lazy var countryTextField: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Input Country"
        textField.borderStyle = .line
        textField.textColor = .black

        return textField
    }()
    
    
    private lazy var year: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.text = "Date of birth"
        return label
    }()
    
    private lazy var yearTextField: UITextField =
    {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.textColor = .black
        return textField
    }()

    private lazy var datePicker: UIDatePicker =
    {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let components = DateComponents()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        return datePicker
    }()
    
    private lazy var toolBar: UIToolbar =
    {
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45))
        
        toolBar.setItems([
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (cancelAction)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (doneAction)),
            
        ], animated: false)
        
        return toolBar
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let executor = self.executor
        {
            fNmaeTextField.text = executor.firstName
            lNmaeTextField.text = executor.lastName
            countryTextField.text = executor.country
            if let dateYear = executor.date
            {
                yearTextField.text = dateFormatter.string(from: dateYear)
            }
        }

        fNmaeTextField.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        executor?.country = countryTextField.text
        executor?.firstName = fNmaeTextField.text
        executor?.lastName = lNmaeTextField.text
        executor?.date = date
        try? executor?.managedObjectContext?.save()
        updateTableDelegate?.updateTableData(indexPath: indexPath)
    }
    
    
    //MARK: - Private methods
    private func setupView()
    {
        self.view.backgroundColor = .white
        self.view.addSubview(fName)
        self.view.addSubview(fNmaeTextField)
        self.view.addSubview(lName)
        self.view.addSubview(lNmaeTextField)
        self.view.addSubview(year)
        self.view.addSubview(yearTextField)
        self.view.addSubview(country)
        self.view.addSubview(countryTextField)
        self.yearTextField.inputView = datePicker
        self.yearTextField.setInputAccessoryView(view: self.toolBar)
        
        
        fName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            
        }
        
        fNmaeTextField.snp.makeConstraints { make in
            make.top.equalTo(fName.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        
        lName.snp.makeConstraints { make in
            make.top.equalTo(fNmaeTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        lNmaeTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.top.equalTo(lName.snp.bottom).offset(5)
        }
        
        year.snp.makeConstraints { make in
            make.top.equalTo(lNmaeTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        yearTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.top.equalTo(year.snp.bottom).offset(5)
            
        }
        country.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        countryTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.top.equalTo(country.snp.bottom).offset(5)
            
        }

        self.view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: countryTextField.bottomAnchor).isActive = true
    }
    
    @objc private func cancelAction() {
        self.yearTextField.resignFirstResponder()
    }

    @objc private func doneAction() {
        if let datePickerView = yearTextField.inputView as? UIDatePicker {
            let dateString = self.dateFormatter.string(from: datePickerView.date)
            self.yearTextField.text = dateString
            date = datePickerView.date
            self.yearTextField.resignFirstResponder()
        }
    }
}
