//
//  InputTextView.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/07.
//

import UIKit

class InputTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Ask Anything"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceHolderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super .init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
