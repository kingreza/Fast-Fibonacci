//: Please build the scheme 'BigIntPlayground' first
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import BigInt

//: Playground - noun: a place where people can play


func slowFibonacci(n: UInt64) -> BigUInt {
  var a = BigUInt(0)
  var b = BigUInt(1)
  for _ in 0..<n {
    let c = a + b
    a = b
    b = c
  }
  return a
}


func fastFibonacciMatrix(n: UInt64) -> BigUInt? {
  let matrix: [BigUInt] = [BigUInt(1), BigUInt(1), BigUInt(1), BigUInt(0)]
  return matrixPower(matrix, power: n)?[1]
}

func fastFibonacciDoubling(n: Int) -> BigUInt {
  var a = BigUInt(0)
  var b = BigUInt(1)
  var m: Int = 0
  
  for i in (0...numberOfLeadingZeros(in: UInt64(n))).reversed() {
    let d = a * ((b << 1) - a)
    let e = a * a + b * b
    a = d
    b = e
    m *= 2
    if (((n >> i) & 1) != 0) {
      let c = a + b
      a = b
      b = c
      m += 1
    }
  }
  return  a
}

func matrixPower(_ matrix: [BigUInt], power: UInt64) -> [BigUInt]? {
  guard power > 0 else {
    print("power has not be non-zero")
    return nil
  }
  var n = power
  var m = matrix
  var result: [BigUInt] = [BigUInt(1), BigUInt(0), BigUInt(0), BigUInt(1)]
  while n > 0 {
    if n % 2 != 0 {
      result = matrixMultiply(x: result, y: m)
    }
    n /= 2
    m = matrixMultiply(x: m, y: m)
  }
  return result
}

func numberOfLeadingZeros(in n: UInt64) -> Int {
  let str = String(n, radix:2)
  return 63 - str.characters.count
}

func matrixMultiply(x: [BigUInt], y: [BigUInt]) -> [BigUInt] {
  return [(x[0] * y[0] + x[1] * y[2]),
          (x[0] * y[1] + x[1] * y[3]),
          (x[2] * y[0] + x[3] * y[2]),
          (x[2] * y[1] + x[3] * y[3])]
}

//n test cases
let test = [1,2,3,4,5,6,8,10,13,16,20,25,32,40,50,63,79,100,126,158,200,251,316,398,501,631,794,1000,1259,1585,1995,2512,3162,3981,5012,6310,7943,10000,12589,15849,
  19953,25119,31623,39811,50119,63096,79433,100000,125893,158489,199526,251189,316228,398107,501187,630957,794328,1000000,1258925,1584893,1995262,2511886,3162278,3981072]

for n in test {
  var start = NSDate()
  print(slowFibonacci(n: UInt64(n)))
  var end = Date().timeIntervalSince(start as Date)
  print(" Time to calculate fibonacci \(n) using slow dynamic: \t \(end)")
  
  start = NSDate()
  fastFibonacciMatrix(n: UInt64(n))!
  end = Date().timeIntervalSince(start as Date)
  print(" Time to calculate fibonacci \(n) using fast matrix:  \t \(end)")
  
  start = NSDate()
  fastFibonacciDoubling(n: n)
  end = Date().timeIntervalSince(start as Date)
  print(" Time to calculate fibonacci \(n) using fast doubling: \t \(end)")
  
  print("***********************************")
}



