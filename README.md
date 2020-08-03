# Chatbot_Swift

- Chatting Model Customizing 해야함
- 서버에서 데이터 받아오는 코드 작성해야함

# 불러오는 방법

```swift

if let chattingVC: ChattingVC = UIStoryboard(name: "Chatting", bundle: nil).instantiateViewController(withIdentifier: "ChattingVC") as? ChattingVC {
    chattingVC.modalPresentationStyle = .overCurrentContext
    present(chattingVC, animated: false, completion: nil)
}

```
