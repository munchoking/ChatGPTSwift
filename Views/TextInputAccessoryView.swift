//
//  TextInputAccessoryView.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/05.
//

import UIKit

// contract btw TextInputAccessoryView and ViewController classes
protocol TextInputAccessoryViewDelegate {
    func didTapSubmit(for comment: String)
}

class TextInputAccessoryView: UIView {
    
    var delegate: TextInputAccessoryViewDelegate?
    
    func clearInputTextField() {
        inputTextView.text = nil
        inputTextView.showPlaceHolderLabel()
        submitButton.tintColor = .lightGray
    }
    
    let inputTextView: InputTextView = {
        let textView = InputTextView()
//        textView.placeholder = "Ask something"
        textView.tag = 100
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.autocorrectionType = .no
        return textView
    }()
    
    let submitButton: UIButton = {
        let sb = UIButton(type: .custom)
        sb.setImage(UIImage(systemName: "arrow.up.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sb.tintColor = .lightGray
        sb.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputTextView.delegate = self
        
        backgroundColor = .white
        
        // step 1 (push above the safeLayoutGuide)
        autoresizingMask = .flexibleHeight
        
        // step 3
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    
    // step 2
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = .lightGray
        addSubview(lineSeparator)
        lineSeparator.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    
    @objc func didTapSubmit() {
        print(#function)
        delegate?.didTapSubmit(for: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty {
            submitButton.tintColor = .blue // set the button image color to blue
        } else {
            submitButton.tintColor = .lightGray // set the button image color to light gray
        }
    }
    
}
