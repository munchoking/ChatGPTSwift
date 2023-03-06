//
//  TextInputView.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/05.
//

import UIKit

//protocol TextInputViewDelegate {
//    func didTapSubmit(for comment: String)
//}
//
//class TextInputView: UIView {
//    
//    var delegate: TextInputViewDelegate?
//    
//    func clearInputTextField() {
//        inputTextField.text = nil
//    }
//    
//    fileprivate let inputTextField: UITextField = {
//        let field = UITextField()
//        field.placeholder = "Ask something"
//        return field
//    }()
//    
//    fileprivate let submitButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
//        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
//        return button
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(submitButton)
//        submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
//        
//        addSubview(inputTextField)
//        inputTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
//    }
//    
//    
//    @objc func handleSubmit() {
//        guard let inputText = inputTextField.text else { return }
//        delegate?.didTapSubmit(for: inputText)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
