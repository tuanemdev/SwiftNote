import Foundation

// Refer: https://www.alphacodingskills.com/swift/swift-math-functions.php

// MARK: - Hàm lượng giác
// Đơn vị sử dụng là radians
// Đối với các hàm tính góc nếu số nhập vào không hợp lệ sẽ trả về: nan
sin(60.0.degreesToRadians)                  // (√3)/2
cos(60.0.degreesToRadians)                  // 0.5
tan(45.0.degreesToRadians)                  // 1.0
asin(powl(3, 0.5) / 2).radiansToDegrees     // 60.0
acos(0.5).radiansToDegrees                  // 60.0
atan(1.0).radiansToDegrees                  // 45.0
// Hệ toạ độ cực: https://vi.wikipedia.org/wiki/H%E1%BB%87_t%E1%BB%8Da_%C4%91%E1%BB%99_c%E1%BB%B1c
// Chuyển đổi giữa hệ toạ độ cực và hệ toạ độ mặt phẳng
atan2(2.0, 0.0).radiansToDegrees            // atan2(y,x) // 90

// MARK: - Hàm Hyperbolic
// Phần này không rõ
/*
 sinh, cosh, tanh, asinh, acosh, atanh
 */

// MARK: - Hàm Error và gamma
// Phần này không rõ
/*
 erf, erfc, tgamma, lgamma
 */

// MARK: - Hàm số mũ và logarith
// y = func(x)
exp(1.0)        // e mũ x = y
exp2(2.0)       // 2 mũ x = y
log(10.0)       // e mũ y = x
log10(10.0)     // 10 mũ y = x
log2(4.0)       // 2 mũ y = x

// MARK: - Hàm mũ và căn
// y = func(x)
pow(2.0, 3.0)   // 2 mũ 3 = 8, pow(x,y) - (nếu x âm thì y không được lẻ)
sqrt(25.0)      // căn bậc 2 của x (x >= 0)
cbrt(9.0)       // căn bậc 3 của x
hypot(3.0, 4.0) // tính cạnh huyền khi cho 2 cạnh góc vuông (định lý Pythagoras)

// MARK: - Hàm làm tròn và lấy phần dư
// Làm tròn lên số nguyên gần nhất
ceil(5.2)       // 6.0
// Làm tròn xuống số nguyên gần nhất
floor(-5.8)     // -6.0
// Làm tròn về số nguyên gần nhất, nếu ở khoảng giữa dạng n.5 thì làm tròn về số chẵn
rint(1.5)       // 2.0
lrint(1.5)      // 2 - giống với rint nhưng kết quả trả về được cast thành Int chứ không phải FloatingPoint
llrint(1.5)     // 2 - cũng giống với rint nhưng kết quả trả về được cast thành Int64
// Làm tròn về số nguyên gần nhất, nếu ở khoảng giữa dạng n.5 thì làm tròn ra xa phía 0
round(-10.5)    // -11.0
lround(-10.5)   // -11 loại Int
llround(-10.5)  // -11 loại Int64
// Làm tròn về số nguyên gần về phía 0
trunc(10.8)     // 10.0
// fmod(x,y) Lấy số dư của x chia y, trong đó x/y làm tròn gần về phía 0
fmod(-9, 5)     // -4.0
// remainder(x,y) Lấy phần dư của x chia y, trong đó x/y làm tròn về số nguyên gần nhất, nếu ở khoảng giữa dạng n.5 thì làm tròn về số chẵn
remainder(7.5, 5)   // -2.5.0
// Giống như hàm remainder, nhưng thay vì return phần dư thì return cả Tuple gồm phần dư và thương số
remquo(7.5, 5)      // (-2.5, 2.0)
// Làm tròn theo phương thức trả về từ hàm fegetround()
switch(fegetround()) {
case FE_DOWNWARD:
    print("Rounding using downward method:")
case FE_TONEAREST:
    print("Rounding using to-nearest method:")
case FE_TOWARDZERO:
    print("Rounding using toward-zero method:")
case FE_UPWARD:
    print("Rounding using upward method:")
default:
    print("Rounding using unknown method:")
}
nearbyint(1.5)

// MARK: - Các hàm khác
// Tính trị tuyệt đối
abs(-1.3)               // 1.3
// fma(x,y,z) -> (x*y) + z
fma(1.0, 2.0, 3.0)      // 5.0
// So sánh giá trị giữa 2 số
fmax(-2.5, -3.5)        // -2.5 - lấy số lớn hơn
fmin(-2.5, -3.5)        // -3.5 - lấy số nhỏ hơn
// Tách FloatingPoint thành 1 số nguyên và phần dư cùng dấu với số nhập vào
modf(-2.7)              // (-2, -0.7)
// fdim(x, y) = max(x-y, 0)
fdim(2.0, 3.0)          // 0.0
// x = significand * 2^exponent - frexp(x) -> (significand, exponent) (significand: [0.5,1.0), exponent: Int)
frexp(8)                // (0.5, 4)
