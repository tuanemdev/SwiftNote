import Foundation

/*
 Stack: Cấu trúc dữ liệu ngăn xếp: LIFO: Last in first out
 Hai thành phần chính của Stack là:
 + push: thêm phần tử vào vị trí cao nhất của ngăn xếp
 + pop: lấy bỏ phần tử từ vị trí cao nhất của ngăn xếp ra ngoài
 */

public struct Stack<Element> {
    private var storage: [Element] = []
    public init() { }
    public init(_ elements: [Element]) {
        storage = elements
    }
    
    public mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> Element? {
        storage.popLast()
    }
    
    public func peek() -> Element? {
        storage.last
    }
    
    public var isEmpty: Bool {
        peek() == nil
    }
}

// var stack: Stack = [1.0, 2.0, 3.0, 4.0]
extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

extension Stack: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        ----top----
        \(storage.map { "\($0)" }.reversed().joined(separator: "\n"))
        -----------
        """
    }
}

/*
 Ứng dụng:
 + NavigationStack: iOS sử dụng để push và pop View (Screen)
 + Phân bổ bộ nhớ ở mức kiến trúc, bộ nhớ dùng cho biến cục bộ cũng được quản lý bởi stack
 + Dùng để giải quyết các bài toán cần quay ngược lại, ví dụ:
        ~ Một ứng dụng chỉnh sửa ảnh support tính năng undo (hoàn tác)
        ~ Nếu đi vào một mê cung thì bạn sẽ cần 1 sợi chỉ, để có thể quay ra mà không bị lạc thì chỉ cần lần ngược lại sợi chỉ
 */
