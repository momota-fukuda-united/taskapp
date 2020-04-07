//
//  TaskModel.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/06.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import RealmSwift

class TaskModel: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
