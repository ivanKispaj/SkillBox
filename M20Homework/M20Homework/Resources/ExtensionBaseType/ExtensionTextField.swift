//
//  ExtensionTextField.swift
//  M20Homework
//
//  Created by Ivan Konishchev on 06.08.2023.
//

import Foundation
import UIKit
import SnapKit


extension UITextField {
    
    
    func setInputAccessoryView(view: UIToolbar)
    {
        self.inputAccessoryView = view
    }
    //    func datePicker<T>(target: T,
//                       doneAction: Selector,
//                       cancelAction: Selector,
//                       toolBar : UIToolbar) {
//        
//        // let screenWidth = UIScreen.main.bounds.width
//        
//        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
//            let buttonTarget = style == .flexibleSpace ? nil : target
//            let action: Selector? = {
//                switch style {
//                case .cancel:
//                    return cancelAction
//                case .done:
//                    return doneAction
//                default:
//                    return nil
//                }
//            }()
//            
//            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
//                                                target: buttonTarget,
//                                                action: action)
//            
//            return barButtonItem
//        }
//        
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .wheels
//        
//        self.inputView = datePicker
//        
//        let toolBar = UIToolbar()
//        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
//                          buttonItem(withSystemItemStyle: .flexibleSpace),
//                          buttonItem(withSystemItemStyle: .done)],
//                         animated: true)
//        self.inputAccessoryView = toolBar
//        //        toolBar.snp.makeConstraints { make in
//        //            make.leading.equalTo(self.snp.leading)
//        //            make.trailing.equalTo(self.snp.trailing)
//        //            make.centerX.equalTo(self.snp.centerX)
//        //        }
//    }
}
