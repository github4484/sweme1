//
//  Evaluator.swift
//  Sweme
//
//  Created by YOSHIHASHI Kenji on 6/15/14.
//  Copyright (c) 2014 YOSHIHASJI Kenji. All rights reserved.
//

import Foundation

class Interpreter {
    
}

class List : Expression {
    var items : Array<Expression> = []
    init(){}
    
    override func toString() -> String {
        var str = "List("
        for item in items {
            str += item.toString()
            str += " "
        }
        return str + ")"
        
    }
}

class Number : Expression {
    let value : Int
    init(value: Int){
        self.value = value
    }
    override func toString() -> String {
        return "Number(" + String(self.value) + ")"
    }
}
class Pair : Expression {
    var first : Expression
    var second : Expression
    
    init(first : Expression, second : Expression){
        self.first = first
        self.second = second
    }
}

enum ExpressionType {
    case Symbol
    case Pair
    case Number
}


class Expression {
    func toString() -> String { return "expression" }
}

class Value {
    
}

class Symbol : Expression {
    let name :String
    init(name : String){
        self.name = name
    }
    
    override func toString() -> String {
        return "symbol(" + self.name + ")"
    }
}

class Procedure {
    var name :String
    
    init(name:String){
        self.name = name
    }
}
/*
class Primitive : Procedure {
    init(){
        
    }
}
*/
class Evaluator {
    func parse(input: String) -> Expression? {
        println("tokenize")
        let tokens = tokenize(input)
        println("parseTokens")
        for t in tokens {
            println(t)
        }
        //println(tokens.join(":"))
        let parsed = parseTokens(tokens, startIndex: 0, endIndex: tokens.count - 1)
        return parsed.expression
    }
    
    func tokenize(input :String) -> Array<String> {
        var tokens = Array<String>()
        var nextIndex = 0
        while nextIndex < countElements(input) {
            println("readNextToken")
            let read = readNextToken(input, startIndex: nextIndex)
            tokens += read.token!
            nextIndex = read.lastIndex + 1
        }
        return tokens
    }

    func readNextToken(input :String, startIndex : Int) -> (token : String?, lastIndex : Int) {
        var nextIndex = startIndex
        while nextIndex < countElements(input) {
            if input.substringFromIndex(nextIndex).hasPrefix(" ") {
                nextIndex++
            } else {
                break
            }
        }
        if nextIndex == countElements(input) {
            return (nil, nextIndex - 1)
        }

        let restInput = input.substringFromIndex(nextIndex)
        println("restInput => '" + restInput + "'")
        switch restInput {
        case let x where x.hasPrefix("("):
            return ("(", nextIndex)
        case let x where x.hasPrefix(")"):
            return (")", nextIndex)
        case let x where x.hasPrefix("+"):
            return ("+", nextIndex)
        default:
            println("readNumber")
            return readNumber(input, startIndex: nextIndex)
        }
    }
    
    func readNumber(input : String, startIndex : Int) -> (token :String?, lastIndex :Int) {
        var value = ""
        var nextIndex : Int = startIndex
        while nextIndex < countElements(input) {
            println("substringToIndex")
            let nextChar = input.substringFromIndex(nextIndex).substringToIndex(1)
            println("nextChar:" + nextChar)
            switch nextChar {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                value += nextChar
            default:
                return (value, nextIndex - 1)
            }
            nextIndex++
        }
        return (value, nextIndex - 1)
    }

    func parseTokens(tokens : Array<String>, startIndex : Int, endIndex :Int) -> (expression : Expression, lastIndex: Int) {
        switch tokens[startIndex] {
        case "(":
            println("readTilListEnd")
            return readTillListEnd(tokens, startIndex: startIndex + 1, endIndex: endIndex)
        case "+":
            return (Symbol(name: "+"), startIndex)
        default:
            println("'" + tokens[startIndex] + "'.toInt")
            let value = tokens[startIndex].toInt()
            return (Number(value: value!), startIndex)
        }
}

    func readTillListEnd(tokens : Array<String>, startIndex : Int, endIndex : Int) -> (expression : Expression, lastIndex: Int) {
        var list = List()
        var nextIndex = startIndex
        while nextIndex < endIndex && tokens[nextIndex] != ")" {
            println(tokens[nextIndex])
            println("parseTokens")
            let parsed = parseTokens(tokens, startIndex: nextIndex, endIndex: endIndex)
            list.items += parsed.expression
            nextIndex = parsed.lastIndex + 1
        }
        return (list, nextIndex)
    }
    
}

class Environment {
    
}

class SwemePair {
    
}