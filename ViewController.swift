//
//  ViewController.swift
//  ChatGPTSwift
//
//  Created by Jung Hyun Kim on 2023/03/01.
//



import UIKit

class ViewController: UIViewController, UITableViewDelegate, TextInputAccessoryViewDelegate {
        
    lazy var containerView: TextInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        let textInputAccessoryView = TextInputAccessoryView(frame: frame)
        textInputAccessoryView.delegate = self
        return textInputAccessoryView
    }()
    
    func didTapSubmit(for input: String) {
        print(#function)
        if let textField = containerView.viewWithTag(100) as? UITextView,
           let inputText = textField.text, inputText.count > 3 {
            fetchGPTChatResponse(prompt: inputText)
        } else {
            print("Failed to submit")
        }
        self.containerView.clearInputTextField()
    }
    

    
    lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    
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

        view.addSubview(table)
        
        view.addSubview(indicatorView)
        indicatorView.isHidden = true
        indicatorView.frame = view.bounds
        indicatorView.backgroundColor = .systemGray6
        indicatorView.alpha = 0.95
        
        indicatorView.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        view.backgroundColor = .white
        table.delegate = self
        table.dataSource = self

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
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
                    DispatchQueue.main.async {
                        self?.indicatorView.isHidden = true
                        self?.activityIndicator.startAnimating()
                        print("Failed")
                    }
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
        didTapSubmit(for: textField.text ?? "")
        return true
    }
}


