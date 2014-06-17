//
//  Evaluator.swift
//  Sweme
//
//  Created by YOSHIHASHI Kenji on 6/15/14.
//  Copyright (c) 2014 YOSHIHASJI Kenji. All rights reserved.
//

import Foundation

class Number : Expression {
    let value : Int
    init(value: Int){
        self.value = value
        super.init(type: ExpressionType.Number)
    }
    override func toString() -> String {
        return "Number(" + String(self.value) + ")"
    }
    override func toInt() -> Int? {
        return self.value
    }
    override func eval() -> Expression {
        return self
    }
}


class List : Expression {
    var items : Array<Expression>
    
    init(){
        items = []
        super.init(type: ExpressionType.List)
    }
    
    override func toString() -> String {
        var str = "List("
        for item in items {
            str += item.toString()
            str += " "
        }
        return str + ")"
    }
    override func eval() -> Expression {
        return self.arithmetic()
    }
    func arithmetic() -> Number {
        var acc = (items[1].eval() as Number).value
        for var i = 2; i < items.count; i++ {
            let x = (items[i].eval() as Number).value
            switch (items[0] as Symbol).name {
            case "+": acc += x
            case "-": acc -= x
            case "*": acc *= x
            case "/": acc /= x
            case "%": acc %= x
            default:
                return Number(value: 9984)
            }
        }
        return Number(value: acc)
    }
}
/*
class Pair : Expression {
    var first : Expression
    var second : Expression
    
    init(first : Expression, second : Expression){
        self.first = first
        self.second = second
    }
}
*/
enum ExpressionType {
    case Symbol
    case Pair
    case Number
    case List
    case Expression
}


class Expression {
    var type = ExpressionType.Expression
    init (type : ExpressionType){
        self.type = type
    }
    func toString() -> String { return "expression" }
    func eval() -> Expression {
        println("eval:" + self.toString())
        return self
    }
    func toInt() -> Int? {
        return nil
    }
}

class Symbol : Expression {
    let name :String
    init(name : String){
        self.name = name
        super.init(type: ExpressionType.Symbol)
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

        let nextChar = input.substringFromIndex(nextIndex).substringToIndex(1)
        println("nextChar => '" + nextChar + "'")
        switch nextChar {
        case "(", ")", "+", "*", "-", "/", "%":
            return (nextChar, nextIndex)
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
        case "+", "*":
            return (Symbol(name: tokens[startIndex]), startIndex)
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
    
    func eval(expression : Expression) -> Expression {
        return expression.eval()
    }
}

class Environment {
    
}

class SwemePair {
    
}