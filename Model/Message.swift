//
//  Message.swift
//  ume
//
//  Created by shin seunghyun on 2020/07/28.
//  Copyright © 2020 haii. All rights reserved.
//

struct Message {
    
    static let K_ME: String = "me"
    static let K_YOU: String = "you"
    static let K_ME_CELL_NAME: String = "MeCell"
    static let K_YOU_CELL_NAME: String = "YouCell"
    
    static let K_FREE_CHATTING: String = "freeChatting"
    static let K_BUTTON_CHATTING: String = "buttonChatting"
    
    var text: String?
    var identifier: String?
    var type: String = K_FREE_CHATTING
    
    
    
    //local, gif를 보여줘야하는지 안보여줘야하는지 정해준다
    var isGifShown: Bool = false
    
}
