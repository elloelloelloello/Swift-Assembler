import Foundation
import Glibc

class Reader {

  func splitStringIntoParts(_ expression: String) -> [String] {
    return expression.characters.split{$0 == " "}.map{ String($0) }
  }

  func splitStringIntoLines(_ expression: String) -> [String] {
    return expression.characters.split{$0 == "\n"}.map{ String($0) }
  }

  func readFile(_ ext: String, _ path: String, _ file: String) -> [String] {
    let text: String
    do {
      text = try String(contentsOfFile: path + file + ext, encoding: String.Encoding.utf8)
    } catch {
      return ["File of this name was not made."]
    }
    let splitString = splitStringIntoLines(text)
    return splitString
  }

  func remove() {
    binaryCommands.remove(at: 0)
  }

  func setUp() {
    numMemorySpots = binaryCommands[0]
    remove()
    exeStart = binaryCommands[0]
    commandPointer = exeStart
    remove()
    memoryArray = binaryCommands
    registerArray = Array(repeating: 0, count: 10)
  }

  func binaryCommand(_ command: Int) {
    switch command {
      case 0:
        halt()
      case 8:
        movmr()
      default:
        brk()
    }
  }

  func halt() {}

  func movmr() {}

  func brk() {}

  var binaryCommands = [Int]()
  var numMemorySpots = 0
  var exeStart = 0
  var commandPointer = 0
  var memoryArray = [Int]()
  var registerArray = [Int]()

}
