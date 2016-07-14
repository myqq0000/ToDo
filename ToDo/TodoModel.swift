//
//  TodoModel.swift
//  ToDo
//
//  Created by 杨逸飞 on 16/7/12.
//  Copyright © 2016年 杨逸飞. All rights reserved.
//

import UIKit

class TodoModel: NSObject {
    var id: String
    var image: String
    var title: String
    var date: NSDate
    
    init(id: String, image: String, title: String, date: NSDate) {
        self.id = id
        self.image = image
        self.title = title
        self.date = date
    }
}

//class or struct?

/*
struct TodoModel2 {
    var id: String
    var image: String
    var title: String
    var date: NSDate
}
*/

//if use struct,it will save in stack, the result will not return to list
//class传递指针，struct传递对象的拷贝