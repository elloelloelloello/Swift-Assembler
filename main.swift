import Foundation
import Glibc

let x = Reader()
let c = Chunker()
let b = Tokenizer()
let a = MakeFiles()
/*
let path1 = "/home/learnswift/Programs/virtualMachine/binaryCommands.txt"
x.readBinaryFile(path1)
x.setUp()
*/
//let path2 = "/home/learnswift/Programs/virtualMachine/doublesCode.txt"
//c.readCodeFile(path2)

func chunk() {
  for line in c.codeLines {
    c.searchLine(line)
  }
  for line in c.allChunks {
    b.getPossibleLabels(line)
  }
}

func tokenize() {
  for line in c.allChunks {
    b.makeLineOfTokens(line)
  }

  a.countTokens(b.allTokens)
}


func makeErrorOrBinary() {
  if a.numberBadTokens == 0 {
    a.binaryMakerPass1(b.allTokens)
    a.binaryMakerPass2(b.allTokens)
  } else {
    var x = 0
    for line in b.allTokens {
      x += 1
      for token in line {
        if token.type == .BadToken {
          a.addToErrorList("Line \(x): " + token.description)
        }
      }
    }
  }
}

func makeAllFiles(location: [String], file: String) {
  a.makeListingFile(location, file, a.errorList, b.allTokens, c.codeLines)
  if a.errorList.count == 0 {
    a.makeBinaryFile(location, file)
    a.makeSymbolTable(location, file, b.allTokens)
    print("Assembly was successful.")
  } else {
    print("Assembly was NOT successful. There were \(a.errorList.count) errors.")
  }
}

// --------- User Interface ---------------------------------------------------------

var path = ""
var locationArray = [String]()
var fileName = ""

func help() {
  print("Welcome to the Assembler!\n\n" +
      "Here is the list of commands:\n" +
      "  asm <program name> - assemble the specified program\n" +
      "  run <program name> - run the specified program\n" +
      "  path <path specification> - set the path for the assembler program directory\n" +
      "    include final / but not name of file. File must have an extension of .txt\n" +
      "  printlst <program name> - print listing file for the specified program\n" +
      "  printbin <program name> - print binary file for the specified program\n" +
      "  printsym <program name> - print symbol table for the specified program\n" +
      "  printtokens - print working tokens\n" +
      "  quit - terminate assembler program\n" +
      "  help - print help table\n")
}

func asm(_ programName: String) {
  fileName = programName
  let location = "\(path)\(fileName).txt"
  print("Assembling file \(location)")
  c.clearCodeLines()            //retains earlier files in case
  if c.readCodeFile(location).count > 0 {
    c.clearChunks()
    b.clearTokenizerVariables()
    a.clearMakeFilesVariables()
    a.clearFiles(locationArray, fileName)
    chunk()
    tokenize()
    makeErrorOrBinary()
    makeAllFiles(location: locationArray, file: fileName)
  } else {
    print("Failed to locate file.")
    print("Make sure that the path is correct and that the extension is .txt.")
    print("Also, make sure to end the path with /")
  }

}

func path(_ pathSpec: String) {
  path = pathSpec
  locationArray = path.characters.split{$0 == "/"}.map{ String($0) }
}

help()
var lineResponse = ""
var responseParts = [String]()
while lineResponse != "quit" {
  print("Enter option...", terminator: "")
  lineResponse = String(describing: readLine()!)
  responseParts = x.splitStringIntoParts(lineResponse)
  switch responseParts[0] {
    case "asm":
      if responseParts.count == 2 {
        asm(responseParts[1])
      } else {
        print("Assembly command expects one parameter.")
      }
    case "path":
      if responseParts.count == 2 {
        path(responseParts[1])
      } else {
        print("Path command expects one parameter.")
      }
    case "run":
      if responseParts.count == 2 {
        print("Run command currently does not work.")
      } else {
        print("Run command expects one parameter.")
      }
    case "printlst":
      if responseParts.count == 2 {
        for line in x.readFile(".lst", path, responseParts[1]) {
          print(line)
        }
      } else {
        print("Printlst command expects one parameter.")
      }
    case "printbin":
      if responseParts.count == 2 {
        for line in x.readFile(".bin", path, responseParts[1]) {
          print(line)
        }
      } else {
        print("Printbin command expects one parameter.")
      }
    case "printsym":
      if responseParts.count == 2 {
        for line in x.readFile(".sym", path, responseParts[1]) {
          print(line)
        }
      } else {
        print("Printsym command expects one parameter.")
      }
    case "printtokens":
      if responseParts.count == 1 {
        for line in b.allTokens {
          for token in line {
            print("TokenType: \(token.type), IntValue: \(token.intValue), StringValue: \(token.stringValue), TupleValue: \(token.tupleValue), Description: \(token.description)")
          }
        }
        if b.allTokens.count == 0 {
          print("Currently no tokens. Assemble first.")
        }
      } else {
        print("Printtokens command expects no parameters.")
      }
    case "help":
      if responseParts.count == 1 {
        help()
      } else {
        print("Help command expects no parameters.")
      }
    case "quit":
      if responseParts.count == 1 {
        print("Quitting assembler.")
      } else {
        print("Quit command expects no parameters.")
      }
    default:
      print("Invalid command. Type help for the command list.")
  }
  //path("/home/learnswift/Programs/virtualMachine/")
  //asm("doubles")
  print("")

}
