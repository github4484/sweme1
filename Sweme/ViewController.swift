//
//  ViewController.swift
//  Sweme
//
//  Created by YOSHIHASHI Kenji on 6/15/14.
//  Copyright (c) 2014 YOSHIHASJI Kenji. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let evaluator = Evaluator()
        println("evaluator init")
        let expression = evaluator.parse("(+ 0 (+ 1 22) 333)")
        println("parsed")
        println(expression?.toString())
        let evaluated = evaluator.eval(expression!)
        println("== result ==")
        println(evaluated.toString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

