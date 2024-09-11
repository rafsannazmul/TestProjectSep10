//
//  ViewController.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/10/24.
//

import UIKit

class ViewController: UIViewController{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var messageWriteView: UIView!
    @IBOutlet weak var messageWriteViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageWriteViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageWriteTextView: UITextField!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    
    
    // MARK: Variables
    
    var conversation = [
        ChatMessage(message: "Hey, how are you?", type: .sender),
        ChatMessage(message: "I'm good! How about you?", type: .receiver),
        ChatMessage(message: "Doing great, thanks for asking!", type: .sender),
        ChatMessage(message: "Any plans for the weekend?", type: .receiver),
        ChatMessage(message: "Not sure yet, maybe a movie. You?", type: .sender),
        ChatMessage(message: "I might go hiking if the weather's good.", type: .receiver)
    ]
    
    // MARK: View Loading Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ChatCollectionView Setup - Register cell
        chatCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        //ChatCollectionView Setup - flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: chatCollectionView.frame.width - 10, height: 60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        chatCollectionView.collectionViewLayout = layout
        
        
        //Notification Center Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func sendButtonTapAction(_ sender: Any) {
        guard let text = messageWriteTextView.text else { return }
        messageWriteTextView.text = ""
        conversation.append(ChatMessage(message: text, type: .receiver))
        chatCollectionView.reloadData()
    }
    
    
    // MARK: Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageWriteViewBottomConstraint.constant == 0 {
                messageWriteViewBottomConstraint.constant = keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if messageWriteViewBottomConstraint.constant != 0 {
            messageWriteViewBottomConstraint.constant = 0
        }
    }
    
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        if conversation[indexPath.row].type == .sender{
            let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 40, height: 40))
            imageView.center.y = cell.frame.height/2
            imageView.image = UIImage(systemName: "person.circle.fill")
            cell.addSubview(imageView)
            
            let textView = UIView(frame: CGRect(x: imageView.frame.maxX + 5, y: 0, width: (cell.frame.width - 20) - (imageView.frame.maxX + 15), height: cell.frame.height - 10))
            textView.center.y = cell.frame.height/2
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: textView.frame.width - 16, height: textView.frame.height - 8))
            label.center.x = textView.bounds.width/2
            label.center.y = textView.bounds.height/2
            label.text = conversation[indexPath.row].message
            label.numberOfLines = 0
            label.lineBreakMode = .byClipping
            textView.addSubview(label)
            cell.addSubview(textView)
        }
        else{
            let imageView = UIImageView(frame: CGRect(x: cell.frame.width - 45, y: 0, width: 40, height: 40))
            imageView.center.y = cell.frame.height/2
            imageView.image = UIImage(systemName: "person.circle.fill")
            cell.addSubview(imageView)
            
            let textView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 50, height: cell.frame.height - 10))
            textView.center.y = cell.frame.height/2
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: textView.frame.width - 16, height: textView.frame.height - 8))
            label.center.x = textView.bounds.width/2
            label.center.y = textView.bounds.height/2
            label.text = conversation[indexPath.row].message
            label.textAlignment = .right
            label.numberOfLines = 0
            label.lineBreakMode = .byClipping
            textView.addSubview(label)
            cell.addSubview(textView)
        }
        
        
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = #colorLiteral(red: 0.03137254902, green: 0.4156862745, blue: 0.8509803922, alpha: 1)
        cell.layer.borderWidth = 0.5
        cell.layer.masksToBounds = true
        return cell
    }
    
    
}


extension ViewController{
    enum MessageType {
        case sender
        case receiver
    }
    
    struct ChatMessage {
        let message: String
        let type: MessageType
    }
    
}

extension ViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendButtonTapAction(self)
        return true
    }
}
