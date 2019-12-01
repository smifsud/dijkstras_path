
//
//  ViewController.swift
//  dijkstra's algo
//
//  Created by Spiro Mifsud on 11/26/19.
//  Copyright © 2019 Spiro Mifsud. All rights reserved.
//


import UIKit

class ViewController: UIViewController, NodeDelegate {
    
    var visitedNotesInOrder:[Node] = [Node]();
    
    var button:UIButton =  UIButton(frame: CGRect(x: 20, y: 20, width: 50, height: 50));
    var button2:UIButton = UIButton(frame: CGRect(x: 150, y: 20, width: 50, height: 50));
    
    var grid:[[Node]]?
    var startNode:Node?;
    var finishNode:Node?;
    var closestNode:Node?
    var pathNodes:[Node] = [];
    
    var step:Int = 0;
    
    var gridContrainer:UIView?
    var START_NODE_ROW = 10;
    var START_NODE_COL = 25;
    var FINISH_NODE_ROW = 10;
    var FINISH_NODE_COL = 15;
  
    var columnAmount:Int = 36;
    var rowAmount:Int = 26;
    
    // grid squarespacing
    let ySpacing = 25;
    let xSpacing = 25;
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.pathNodes = [];
        self.setGrid();
        self.setButtons();
        self.startSequence()
    };
    
    private func setButtons() -> Void {
       
        button = UIButton(frame: CGRect(x: 20, y: 20, width: 50, height: 50));
        button.setTitle("Start", for: .normal);
        button.backgroundColor = .white;
        button.setTitleColor(UIColor.black, for: .normal);
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside);
        self.view.addSubview(button);

        button2 = UIButton(frame: CGRect(x: 150, y: 20, width: 50, height: 50));
        button2.setTitle("Reset", for: .normal);
        button2.backgroundColor = .white;
        button2.setTitleColor(UIColor.black, for: .normal);
        button2.addTarget(self, action: #selector(self.resetButtonTapped), for: .touchUpInside);
        self.view.addSubview(button2);
        
        self.button.alpha = 0.10
        self.button.isEnabled = false;
    };
    
    @objc func buttonTapped(sender : UIButton) {
        self.visualizeDijkstra(grid: self.grid!, startNode: self.grid![START_NODE_COL][START_NODE_ROW], finishNode: self.grid![FINISH_NODE_COL][FINISH_NODE_ROW])
        self.button.alpha = 0.10
        self.button.isEnabled = false;
    };
    
    @objc func resetButtonTapped(sender : UIButton) {
        self.step = 0;
        self.setUp();
        self.startSequence();
        self.button.alpha = 0.10
        self.button.isEnabled = false;
    };
    
    private func setUp() {
        self.grid = []
        self.gridContrainer?.removeFromSuperview();
        self.pathNodes = [];
        self.visitedNotesInOrder = [];
        self.setGrid();
               
        self.button.alpha = 1.00
        self.button.isEnabled = true;
    }
    
    private func setGrid() {
         var currentRow:[Node] = [Node]();
        self.grid = [];
        self.rowAmount = Int(((self.view.frame.width-50)/25).rounded(.down));
        self.columnAmount = Int(((self.view.frame.height-80)/25).rounded(.down));
        self.gridContrainer = UIView(frame: CGRect(x: 25, y: 80, width: self.view.frame.width, height:self.view.frame.height))
        self.view.addSubview (self.gridContrainer!);
                       
        for i in 0...columnAmount - 1  {
            currentRow = []
            for j in 0...rowAmount - 1  {
                let node:Node = Node(frame: CGRect (x:xSpacing * j, y: ySpacing * i , width: 25, height: 25 ))
                node.row = i;
                node.column = j;
                node.delegate = self;
                currentRow.append(node);
                self.gridContrainer!.addSubview(node);
                //  print("Row: " + String (describing: i) + ", Column: " + String (describing: j) )
            };
            self.grid?.append(currentRow)
            
        };
              
          //  self.grid![START_NODE_COL][START_NODE_ROW].setStartNode();
         //   self.grid![FINISH_NODE_COL][FINISH_NODE_ROW].setEndNode();
    };
    
    private func visualizeDijkstra (grid:[[Node]], startNode:Node, finishNode:Node) -> Void {
        startNode.setStartNode();
        startNode.distance = 0;
        finishNode.setEndNode();
        
        let startNode:Node = grid[START_NODE_COL][START_NODE_ROW];
        let finishNode:Node = grid[FINISH_NODE_COL][FINISH_NODE_ROW];
        let visitedNodesInOrder = dijkstra(grid: grid, startNode: startNode, finishNode: finishNode);
        let nodesInShortestPathOrder = getNodesInShortestPathOrder(finishNode: finishNode);
        
        self.animateDijstra(visitedNodesInOrder: visitedNodesInOrder, nodesInShortestPathOrder: nodesInShortestPathOrder)
     };
    
    private func animateDijstra(visitedNodesInOrder:[Node], nodesInShortestPathOrder:[Node]) {
        var i:Int = 0;
        self.pathNodes =  nodesInShortestPathOrder;
        for items in visitedNodesInOrder {
           
            grid![items.row][items.column].highlightBlue(delay:i/2);
             
            i = i + 1;
            if (i == visitedNodesInOrder.count-1){
                      grid![items.row][items.column].isEnd = true;
                }
        };
    };
    
    func onLastAnimated(_ onLastAnimated: Node) {
        self.animatePath(nodesInShortestPathOrder: self.pathNodes)
    };
   
    
    private func animatePath(nodesInShortestPathOrder:[Node]){
        var i:Int = 0;
        for items in nodesInShortestPathOrder {
            grid![items.row][items.column].highlight(delay:i/2)
           i = i + 1;
        };
    };
};

extension ViewController {

    private func dijkstra (grid:[[Node]], startNode:Node, finishNode:Node) -> [Node] {
        self.startNode = startNode;
        self.finishNode = finishNode;
        
        startNode.distance = 0;
        
        var unvisitedNodes = getAllNodes(grid: grid);
        while (unvisitedNodes.count > 0) {
        
        unvisitedNodes = self.sortNodesByDistance(unvisitedNodes: unvisitedNodes);
        
        let closestNode:Node =  unvisitedNodes.removeFirst()
            
        if (!closestNode.isWall) {
            if (closestNode.distance == Double.infinity) {return visitedNotesInOrder }
            closestNode.isVisited = true;
            visitedNotesInOrder.append(closestNode);
        
            if (closestNode == finishNode) {
        
                return visitedNotesInOrder;
            }
            updateUnvisitedNeighbors(node: closestNode, grid: grid)
            }
        }
            return visitedNotesInOrder
    };
        
    
    private func sortNodesByDistance(unvisitedNodes: [Node]) -> [Node] {
        return (unvisitedNodes.sorted(by: {(nodeA:Node, nodeB:Node)-> Bool in return nodeA < nodeB}));
    };
    
    private func updateUnvisitedNeighbors(node:Node, grid:[[Node]]) {
        let unvisitedNeighbors = getUnvisitedNeighbors(node: node, grid: grid);
    
        for neighbor in unvisitedNeighbors {
            neighbor.distance = node.distance + 1;
            neighbor.previousNode = node;
        };
    };

    private func getUnvisitedNeighbors(node:Node,grid:[[Node]]) -> [Node] {
        var neighbors:[Node] = [];
        let col:Int = node.column;
        let row:Int = node.row;
        
        if (row > 0) {
            neighbors.append(grid[row-1][col])
        };
        
        if (row < grid.count - 1) {
            neighbors.append(grid[row + 1][col]);
        };
        
        if (col > 0) {
            neighbors.append(grid[row][col-1]);
        };
        
        if (col < grid [0].count - 1) {
            neighbors.append (grid[row][col+1])
        };
        
        var tempArray:[Node] = [];
        
        for items in neighbors // refactor
        {
            if (!items.isVisited) {
                tempArray.append (items)
            };
        };
        
        return tempArray;
    };
    
    private func getAllNodes (grid:[[Node]]) -> [Node] {
        var nodes:[Node] = [];
        nodes = grid.flatMap{ $0 }
        return nodes;
    };
    
    private func getNodesInShortestPathOrder (finishNode:Node) -> [Node] {
        var nodesInShortestPathOrder:[Node] = [];
        var currentNode = self.finishNode;
        
        while (currentNode?.previousNode !== nil) {
            nodesInShortestPathOrder.insert(currentNode!, at: 0)
            currentNode = currentNode?.previousNode!
        };
        
        return nodesInShortestPathOrder
    };
};

extension ViewController {
    
    func onNodeSelected(_ onNodeSelected: Node) {
        if (self.step == 0) {
            self.step = 1;
            self.grid![onNodeSelected.row][onNodeSelected.column].setStartNode();
            self.START_NODE_ROW = onNodeSelected.column;
            self.START_NODE_COL = onNodeSelected.row;
              
            self.startSequence();
        }
        else if (self.step == 1) {
            self.step = 2;
            self.grid![onNodeSelected.row][onNodeSelected.column].setEndNode();
            self.FINISH_NODE_ROW = onNodeSelected.column;
            self.FINISH_NODE_COL = onNodeSelected.row;
            self.startSequence();
            
        }
        else {
            self.step = 3;
            self.grid![onNodeSelected.row][onNodeSelected.column].setAsWall();
            }
    }
    
    private func startSequence() {
        if (step == 0) {
        let alert = UIAlertController(title: "Start Point", message: "Pick a square as a starting point", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,  handler: {(_: UIAlertAction!) in
           }))
        
        DispatchQueue.main.async(execute: {
          self.present(alert, animated: true, completion: nil)
            })
        }
            
        else if (step == 1) {
        let alert = UIAlertController(title: "End Point", message: "Pick a square as an end point", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
         }))
        DispatchQueue.main.async(execute: {self.present(alert, animated: true, completion: nil) })}
            
        else {
        let alert = UIAlertController(title: "Walls", message: "Add some walls to maneuver around then tap Start", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK",style: UIAlertAction.Style.default,  handler: {(_: UIAlertAction!) in self.button.alpha = 1.00
            self.button.isEnabled = true;
           }))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
      }
}
