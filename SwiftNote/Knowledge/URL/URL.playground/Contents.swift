import Foundation

let myURL = URL(string: "https://www.example.co.uk:443/blog/article/search?docid=720&hl=en#dayone")!

let scheme      = myURL.scheme      // "https"
let host        = myURL.host        // "www.example.co.uk"
let port        = myURL.port        // 443
let path        = myURL.path        // "/blog/article/search"
let query       = myURL.query       // "docid=720&hl=en"
let fragment    = myURL.fragment    // "dayone"
let baseURL     = myURL.baseURL     // nil

// Edit
let queryItems: [URLQueryItem] = [URLQueryItem(name: "param01", value: "value01"),
                                  URLQueryItem(name: "param02", value: "value02"),
                                  URLQueryItem(name: "param03", value: "value03"),
                                  URLQueryItem(name: "param04", value: "value04")]
var myURLComponents = URLComponents(string: myURL.absoluteString)!
myURLComponents.queryItems = queryItems
myURLComponents.scheme = "myAppScheme"
print(myURLComponents.url!)
