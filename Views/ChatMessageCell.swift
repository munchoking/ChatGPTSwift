//
//  ChatMessageCell.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/03.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    static let identifier = "ChatMessageCell"
    
    let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var leading, trailing: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(bubbleView)
        addSubview(chatLabel)

        NSLayoutConstraint.activate([
            chatLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            chatLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            chatLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            chatLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 275),
            
            bubbleView.topAnchor.constraint(equalTo: chatLabel.topAnchor, constant: -8),
            bubbleView.leadingAnchor.constraint(equalTo: chatLabel.leadingAnchor, constant: -8),
            bubbleView.trailingAnchor.constraint(equalTo: chatLabel.trailingAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: chatLabel.bottomAnchor, constant: 8)
        ])
        
        leading = chatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trailing = chatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailing.priority = UILayoutPriority(999)
    }
    
    func configure(text: String, isUser: Bool) {
        chatLabel.text = text
        if isUser {
            bubbleView.backgroundColor = .systemGreen
            leading.isActive = false
            trailing.isActive = true
        } else {
            bubbleView.backgroundColor = .lightGray
            leading.isActive = true
            trailing.isActive = false
        }
    }

}
