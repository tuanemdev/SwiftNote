//
//  CoreData.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 21/05/2023.
//

import Foundation

/*
 Các thành phần CoreData
 
 NSPersistentContainer
        NSManagedObjectModel                Được định nghĩa trong file .xcdatamodeld
        NSManagedObjectContext              Là class quản lý các đối tượng, thực hiện tác vụ chính CRUD
        NSPersistentStoreCoordinator        Cầu nối tới phần data trong database
                Storage                     (thường là SQLite) (có thể là XML, Binary, SQLite) (In-Memory)
 
 
 Model: Xcode sẽ tự động gen và ẩn file Model, thay đổi bằng cách ấn vào Entity và thay đổi Codegen thành manual (xoá Derived Data để tránh lỗi duplicate)
    có 3 chế độ:
                class definition (tự động toàn bộ và tự động đồng bộ khi có thay đổi)
                extension (tự động tạo các properties còn thủ công thêm các method cần thiết để làm việc với model)
                manual (làm tất cả mọi thứ thủ công)
 Tuy nhiên best pratice là làm thủ công
    1. chọn Codegen thành manual/none
    2. Menu > Editor > Create NSManagedObject Subclass
 
 Tạo PersistenceController và thiết lập enviroment trong App
 */
