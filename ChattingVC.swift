//
//  ChattingVC.swift
//  ume
//
//  Created by shin seunghyun on 2020/07/28.
//  Copyright © 2020 haii. All rights reserved.
//

import UIKit

class ChattingVC: UIViewController {

    @IBOutlet private weak var chattingView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputTextBoxConatinerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet private weak var chattingViewHeightConstraint: NSLayoutConstraint!

    //특정 메시지가 도착했을 때는 버튼을 보여주기 위해 collectionViewHeightConstraint의 크기를 높여준다.
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    //keyboard올라올 때 constant 값을 바꿔줌.
    @IBOutlet weak var inputTextBoxBottomConstraint: NSLayoutConstraint!

    
    //초기 textFieldSize 값을 담은 global 변수, 자꾸 character가 들어나면 옆에 버튼을 밀어내서 문제가됨. 다시 값을 initial width로 잡아주기 위해서 만든 변수
    private var textFieldInitialWidth: CGFloat?
    
    //gif 가 showing하는지 아닌지 추적하는 변수
    private var isGifShowing: Bool = false
    
    private var messages: [Message] = [
        Message(text: "오늘 `마음산책`어떠셨나요?", identifier: Message.K_YOU, isGifShown: true)
//        Message(text: "Hello", identifier: Message.ME),
//        Message(text: "Hello", identifier: Message.ME)
    ]
    
    private var buttons: [String] = [String]()
    
    
    private lazy var dismissButton: UIButton = {
        var button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "chat_dismiss"), for: .normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissButtonPressed)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chattingViewHeightConstraint.constant = view.frame.height * 0.5
        collectionViewHeightConstraint.constant = 0
        inputTextField.delegate = self
        setDismissButton()
        setDismissKeyboardListener()

        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        
        tableView.register(UINib(nibName: Message.K_ME_CELL_NAME, bundle: nil), forCellReuseIdentifier: Message.K_ME_CELL_NAME)
        tableView.register(UINib(nibName: Message.K_YOU_CELL_NAME, bundle: nil), forCellReuseIdentifier: Message.K_YOU_CELL_NAME)
        collectionView.register(UINib(nibName: "ButtonCC", bundle: nil), forCellWithReuseIdentifier: "ButtonCC")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chattingView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        tableView.backgroundColor = .clear
        
        
        //set keyboard event handler event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIResponder.keyboardWillHideNotification, object: nil);
        //초기 textFieldSize 값을 담은 global 변수
        textFieldInitialWidth = inputTextField.frame.width
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chattingView.layer.cornerRadius = 24
        chattingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        inputTextField.borderStyle = .roundedRect
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.cornerRadius = 18
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.clipsToBounds = true //clipsToBounds를 해주어야지 cornerRadius가 적용된다.
        //padding 추가
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: inputTextField.frame.height))
        inputTextField.leftViewMode = .always
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chattingViewHeightConstraint.constant = view.frame.height * 0.85
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.3) {
                    self.dismissButton.alpha = 1
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

//MARK: - UIComponent, dismissButton
extension ChattingVC {
    
    private func setDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: chattingView.topAnchor, constant: -8).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        dismissButton.alpha = 0
    }
    
    @objc private func dismissButtonPressed(_ sender: UITapGestureRecognizer) {
        sender.preventRepeatedPressed(view: dismissButton)
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITextField Delegate Method
extension ChattingVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == inputTextField {
            guard let textFieldInitialWidth: CGFloat = textFieldInitialWidth else { return false }
            if let count: Int = inputTextField.text?.count {
                if count > 50 {
                    return false
                }
            }
            if textField.frame.width >= textFieldInitialWidth {
                //강제로 width 크기를 못 늘리게함
                textField.widthAnchor.constraint(equalToConstant: textFieldInitialWidth).isActive = true
            }
            return true
        }
        return false
    }
    
}

//MARK: - Keyboard 관련
extension ChattingVC {
    
    //Observe when keyboard appears
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputTextBoxBottomConstraint.constant = keyboardSize.height - inputTextBoxConatinerView.frame.height * 0.3
        }
    
        UIView.animate(withDuration: 0) {
          self.view.layoutIfNeeded() //레이아웃 그려주기
            if self.messages.count > 0 {
                let lastIndex: Int = self.messages.count - 1
                let lastIndexPath: IndexPath = IndexPath(item: lastIndex, section: 0)
                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
            }
        }
        
    }
    
    //Observe when keyboard hides
    @objc func keyboardWillHide(notification: Notification){
        inputTextBoxBottomConstraint.constant = 0
        view.layoutIfNeeded() //레이아웃 그려주기
    }
    
}

//MARK: - Chatting Logic
extension ChattingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: Message = messages[indexPath.row]
        if message.identifier == Message.K_ME {
            let cell: MeCell = tableView.dequeueReusableCell(withIdentifier: Message.K_ME_CELL_NAME) as! MeCell
            if let text: String = messages[indexPath.row].text {
                cell.chattingTextLabel.text = text
            }
            return cell
        } else {
            let cell: YouCell = tableView.dequeueReusableCell(withIdentifier: Message.K_YOU_CELL_NAME) as! YouCell
            if let text: String = self.messages[indexPath.row].text {
                cell.chattingTextLabel.text = text
            }
            
            //1. message data를 reference 삼아서 cell안에 있는 isGifShown 변수에 값을 준다.
            cell.isGIFShown = message.isGifShown
            
            //2. cell의 isGifShown 값을 기준 삼아서 gif를 보여줄지 아닐지 정해준다.
            if let isGifShown: Bool = cell.isGIFShown {
                if !isGifShown {
                    isGifShowing = true //gif를 보여주는 중
                    cell.gifImageView.isHidden = false
                    cell.gifImageView.loadGif(name: "text_typing")
                    cell.chattingBubble.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.tableView.beginUpdates()
                        cell.gifImageView.isHidden = true
                        cell.chattingBubble.isHidden = false
                        let index: Int = indexPath.row
                        let indexPath: IndexPath = IndexPath(item: index, section: 0)
                        self.tableView.endUpdates()
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        //3. message data에 값 업데이트
                        self.messages[indexPath.row].isGifShown = true
                        
                        self.isGifShowing = false //gif를 모두 보여줌
                    }
                }
            }
            
            return cell
        }
    }
    
    @IBAction private func sendButtonPressed(_ sender: UIButton) {
        sender.preventRepeatedPressed()
        
        if isGifShowing {
            print("gif is showing, sending message is impossible")
            return
        }
        
        if let textInput: String = inputTextField.text {
            
            //아래가 실제로 사용할 코드
//            messages.append(Message(text: textInput, identifier: Message.ME))
//            inputTextField.text = ""
            
            
            //text는 서버에 던져야함
            //서버에서 데이터가 날라왔다고 가정 - button type text
            if messages.count % 5 == 0 {
                inputTextField.isEnabled = false
                if textInput == "" {
                    return
                }
                messages.append(Message(text: textInput, identifier: Message.K_ME))
                inputTextField.text = ""
                let lastIndex: Int = messages.count - 1
                let lastIndexPath: IndexPath = IndexPath(item: lastIndex, section: 0)
                tableView.insertRows(at: [lastIndexPath], with: .none)
                tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
                messages.append(Message(text: "button, button, button, button, button", identifier: Message.K_YOU, type: Message.K_BUTTON_CHATTING))
                
                buttons.removeAll()
                buttons.append("그럭저럭🤔")
                buttons.append("응! 완전!!")
                buttons.append("마음처럼 잘 안되네")
                buttons.append("ㅋㅋㅋㅋㅋㅋㅋ")
                buttons.append("ㅎㅎㅎㅎㅎㅎㅎ")
                buttons.append("호호호호호호호호")
                UIView.animate(withDuration: 0) {
                    self.collectionViewHeightConstraint.constant = 80
                    self.collectionView.reloadData()
                    self.view.layoutIfNeeded()
                }
                let lastYouIndex: Int = self.messages.count - 1
                let lastYouIndexPath: IndexPath = IndexPath(item: lastYouIndex, section: 0)
                tableView.insertRows(at: [lastYouIndexPath], with: .none)
                tableView.scrollToRow(at: lastYouIndexPath, at: .bottom, animated: false)
            } else {
                inputTextField.isEnabled = true
                if textInput == "" {
                    return
                }
                messages.append(Message(text: textInput, identifier: Message.K_ME))
                inputTextField.text = ""
                let lastIndex: Int = messages.count - 1
                let lastIndexPath: IndexPath = IndexPath(item: lastIndex, section: 0)
                tableView.insertRows(at: [lastIndexPath], with: .none)
                tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
                
                messages.append(Message(text: "anything, anything, anything, anything, anything", identifier: Message.K_YOU))
                UIView.animate(withDuration: 0) {
                      self.collectionViewHeightConstraint.constant = 0
                      self.view.layoutIfNeeded()
                }
                let lastYouIndex: Int = self.messages.count - 1
                let lastYouIndexPath: IndexPath = IndexPath(item: lastYouIndex, section: 0)
                tableView.insertRows(at: [lastYouIndexPath], with: .none)
                tableView.scrollToRow(at: lastYouIndexPath, at: .bottom, animated: false)
            }

        }
    }
    
}

//MARK: - Button Type Chatting Handling
extension ChattingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonCCDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ButtonCC = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCC", for: indexPath) as! ButtonCC
        cell.chattingButtonLabel.text = buttons[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func notifyChattingButtonLabelClicked(text: String) {
        
        //서버에 던져야함
        messages.append(Message(text: text, identifier: Message.K_ME))
        let lastIndex: Int = messages.count - 1
        let lastIndexPath: IndexPath = IndexPath(item: lastIndex, section: 0)
        tableView.insertRows(at: [lastIndexPath], with: .none)
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        UIView.animate(withDuration: 0) {
              self.collectionViewHeightConstraint.constant = 0
              self.view.layoutIfNeeded()
        }
        
        //test code, server에서 message가 내려오는 것처럼 보여줌
        if messages.count % 5 == 0 {
            inputTextField.isEnabled = false
            messages.append(Message(text: "button, button, button, button, button", identifier: Message.K_YOU, type: Message.K_BUTTON_CHATTING))
            buttons.removeAll()
            buttons.append("그럭저럭🤔")
            buttons.append("응! 완전!!")
            buttons.append("마음처럼 잘 안되네")
            buttons.append("ㅋㅋㅋㅋㅋㅋㅋ")
            buttons.append("ㅎㅎㅎㅎㅎㅎㅎ")
            buttons.append("호호호호호호호호")
            UIView.animate(withDuration: 0) {
                self.collectionViewHeightConstraint.constant = 80
                self.collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
            let lastYouIndex: Int = self.messages.count - 1
            let lastYouIndexPath: IndexPath = IndexPath(item: lastYouIndex, section: 0)
            tableView.insertRows(at: [lastYouIndexPath], with: .none)
            tableView.scrollToRow(at: lastYouIndexPath, at: .bottom, animated: false)
        } else {
            inputTextField.isEnabled = true
            messages.append(Message(text: "anything, anything, anything, anything, anything", identifier: Message.K_YOU))
            UIView.animate(withDuration: 0) {
                   self.collectionViewHeightConstraint.constant = 0
                   self.view.layoutIfNeeded()
            }
            let lastYouIndex: Int = self.messages.count - 1
            let lastYouIndexPath: IndexPath = IndexPath(item: lastYouIndex, section: 0)
            tableView.insertRows(at: [lastYouIndexPath], with: .none)
            tableView.scrollToRow(at: lastYouIndexPath, at: .bottom, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let size: CGSize = collectionView.frame.size
        return UIEdgeInsets(top: 0, left: size.width * 0.1, bottom: 0, right: size.width * 0.1)
    }
    
}
