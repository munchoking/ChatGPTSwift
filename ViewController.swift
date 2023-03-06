//
//  ViewController.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/01.
//



import UIKit

class ViewController: UIViewController, UITableViewDelegate {
        
    var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//        containerView.layer.borderWidth = 1.5
//        containerView.layer.cornerRadius = 5
//        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
    
        let submitButton = UIButton(type: .system)
        submitButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        containerView.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)

        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 12, width: 50, height: 0)
//        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        let textField = UITextField()
        textField.placeholder = "Ask anything"
        textField.setLeftPaddingPoints(10)
        containerView.addSubview(textField)
        textField.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        textField.borderStyle = .none
//        textField.layer.cornerRadius = textField.frame.height / 1.6
//        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.tag = 100
        textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 15, paddingRight: 12, width: 0, height: 0)
        
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = .lightGray
        containerView.addSubview(lineSeparator)
        lineSeparator.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    
        return containerView
        
    }()
    


    
    @objc func didTapSubmit() {
        print(#function)
        if let textField = containerView.viewWithTag(100) as? UITextField,
            let inputText = textField.text, inputText.count > 3 {
            fetchGPTChatResponse(prompt: inputText)
        } else {
            print("Please check textfield")
        }
//        if let promptText = textField.text, promptText.count > 3 {
//            fetchGPTChatResponse(prompt: promptText)
//        } else {
//            print("Please check textfield")
//        }
    }
    
    
//    let field: UITextField = {
//        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 40))
//        textField.placeholder = "Ask Anything"
//        textField.setLeftPaddingPoints(10)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.borderStyle = .none
//        textField.layer.cornerRadius = textField.frame.height / 1.6
//        textField.layer.borderWidth = 1.5
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.returnKeyType = .done
//        return textField
//    }()
        
    
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
//    lazy var submitButton: UIButton = {
//        let button = UIButton()
//        var buttonConfig = UIButton.Configuration.plain()
//        buttonConfig.imagePadding = 10
//        let configuration = UIImage.SymbolConfiguration(scale: .large)
//        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: configuration)
//        buttonConfig.image = image
//        button.configuration = buttonConfig
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .clear
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
//        field.rightView = button
//        field.rightViewMode = .always
//        return button
//    }()
    
    var models = [String]()
    
    let indicatorView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
//        setupTabBar()
        configureUI()
    }
    
    // Every page inside iOS app has inputAccessoryView that allows you to type in information
    // bottom portion of the input
    override var inputAccessoryView: UIView? {
        get {
            containerView
        }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    func setupNaviBar() {
        title = "B𝟘T🤖"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
//    func setupTabBar() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithOpaqueBackground()
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//    }
    
    func configureUI() {
//        view.addSubview(field)
        view.addSubview(table)
//        view.addSubview(submitButton)
        
        view.addSubview(indicatorView)
        indicatorView.isHidden = true
        indicatorView.frame = view.bounds
        indicatorView.backgroundColor = .systemGray6
        indicatorView.alpha = 0.95
        
        indicatorView.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        view.backgroundColor = .white
//        field.delegate = self
        table.delegate = self
        table.dataSource = self

        NSLayoutConstraint.activate([
            
            
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            
            
//            field.heightAnchor.constraint(equalToConstant: 50),
//            field.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
//            field.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
//            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
            
        ])
    }
    
    func fetchGPTChatResponse(prompt: String) {
        indicatorView.isHidden = false
        activityIndicator.startAnimating()
        if !prompt.isEmpty {
            models.append(prompt)
            APICaller.shared.getResponse(input: prompt) { [weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output.replacingOccurrences(of: "\n\n", with: ""))
                    DispatchQueue.main.async {
                        self?.indicatorView.isHidden = true
                        self?.activityIndicator.startAnimating()
                        self?.table.reloadData()
                        self?.table.scrollToRow(at: IndexPath(row: (self?.models.count)! - 1, section: 0), at: .bottom, animated: true)
                    }
                case .failure:
                    self?.indicatorView.isHidden = true
                    self?.activityIndicator.startAnimating()
                    print("Failed")
                }
            }
        }
    }
    
//    @objc func didTapSubmit() {
////        field.resignFirstResponder()
//        if let promptText = textField.text, promptText.count > 3 {
//            fetchGPTChatResponse(prompt: promptText)
//        } else {
//            print("Please check textfield")
//        }
//
//    }
}


//MARK: - Extensions
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.identifier, for: indexPath) as! ChatMessageCell
        cell.selectionStyle = .none
        let text = models[indexPath.row]
//        cell.textLabel?.text = models[indexPath.row]
//        cell.textLabel?.numberOfLines = 0
        if indexPath.row % 2 == 0 {
            cell.configure(text: text, isUser: true)
        } else {
            cell.configure(text: text, isUser: false)
        }
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didTapSubmit()
        return true
    }
}


