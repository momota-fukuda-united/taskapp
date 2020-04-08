//
//  Category.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/07.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import RealmSwift

class CategoryModel: Object{
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    @objc dynamic var name = ""
}
