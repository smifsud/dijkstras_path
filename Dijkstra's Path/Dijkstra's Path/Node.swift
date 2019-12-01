//
//  Node.swift
//  Dijkstra's Path
//
//  Created by Spiro Mifsud on 11/30/19.
//  Copyright © 2019 Spiro Mifsud. All rights reserved.
//


import UIKit

protocol NodeDelegate {
    func onLastAnimated(_ onLastAnimated: Node)
    func onNodeSelected (_ onStartNodeMove: Node)
    }

class Node: UIView {
    
    var delegate:NodeDelegate?
    
    var column:Int = 0;
    var row:Int = 0;
    var isWall:Bool = false;
    var isStart:Bool = false;
    var isEnd:Bool = false;
    var isVisited:Bool = false;
    var distance:Double = Double.infinity;
    var status:Bool = false;
    
    var previousNode:Node?
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = .white;
        self.layer.borderColor = UIColor.gray.cgColor;
        self.layer.borderWidth = 0.25 //make border 1px thick
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
      
    };
   
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.onNodeSelected(self);
    };
    
    func setAsWall() {
        self.isWall = true;
        self.backgroundColor = .darkGray;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    };
    
    func setSelected() {
        self.backgroundColor = .blue;
    };
    
    func setStartNode(){
        self.isStart = true
        self.status = true;
        self.backgroundColor = .green
    };
    
    func setEndNode(){
        self.isEnd = true
         self.status = true;
        self.backgroundColor = .red
    };
    
    func highlight (delay:Int) {
        UIView.self.animate(withDuration: 0, delay: Double(delay)/25, animations: {
            self.backgroundColor = .yellow
        }, completion:nil)
    }
    
    func highlightBlue (delay:Int) {
        if (!self.status) {
            UIView.self.animate(withDuration: 0.5, delay: Double(delay)/30, animations: {
                   self.backgroundColor = UIColor(red: 175.0/255.0, green: 216.0/255.0, blue: 248.0/255.0, alpha: 1.0);
        }, completion:{ (finished: Bool) in
            self.animationCallback();
        })
        }
    }
    
    private func animationCallback() -> Void {
        if (self.isEnd) {
          
            delegate?.onLastAnimated(self)
              delegate = nil;
        };
          delegate = nil;
    };
};

extension Node: Comparable
{
    static func < (nodeA:Node, nodeB:Node) -> Bool {
        return (nodeA.distance < nodeB.distance)
    }
    
    static func > (nodeA:Node, nodeB:Node) -> Bool {
        return (nodeA.distance > nodeB.distance)
    }
};
