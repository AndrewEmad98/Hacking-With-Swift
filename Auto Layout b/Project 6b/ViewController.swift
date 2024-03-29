//
//  ViewController.swift
//  Project 6b
//
//  Created by Andrew Emad on 06/07/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "I"
        label1.backgroundColor = .darkGray
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "am"
        label2.backgroundColor = .red
        label2.sizeToFit()
        
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.text = "Andrew"
        label3.backgroundColor = .cyan
        label3.sizeToFit()
        
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.text = "Emad"
        label4.backgroundColor = .yellow
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.text = "Gergeus"
        label5.backgroundColor = .brown
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
      /* let viewDictionary = ["label1":label1 ,
                              "label2":label2 ,
                              "label3":label3 ,
                              "label4":label4 ,
                              "label5":label5
        ]

        for label in viewDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewDictionary))
       }

       let metrics = ["labelHeight":80]

       view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewDictionary)) */
        
        var previous : UILabel?
        
        
        
        for label in [label1,label2,label3,label4,label5] {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            }
            previous = label
        }
   
    }


}

