//
//  ViewController.swift
//  Practice
//
//  Created by Piyush Sharma on 4/12/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit

//MARK: Linklist
class Node<T: Equatable> {
    var data: T? = nil
    var next: Node? = nil
    
    init(data: T) {
        self.data = data
        self.next = nil
    }
    
    init() {}
    
    func setLink(node: Node) {
        next = node
    }
}

class LinkList<T: Equatable> {
    
    var head = Node<T>()
    func insertAtBegining(data: T) {
        if head.data == nil {
            head.data = data
        } else {
            let newNode = Node<T>()
            newNode.data = data
            
            newNode.next = head
            head = newNode
        }
    }
    
    func insertAtEnd(node: Node<T>) {
        if head.data == nil {
            head.data = node.data
        }  else {
            var temp = head
            
            while temp.next != nil {
                temp = temp.next!
            }
            
            temp.next = node
        }
    }
    
    func insertAtLast(data: T) {
        if head.data == nil {
            head.data = data
        } else {
            let newNode = Node<T>()
            newNode.data = data
            
            var temp = head
            
            while temp.next != nil {
                temp = temp.next!
            }
            
            temp.next = newNode
        }
    }
    
    func insert(at n : Int, data: T) {
        if head.data == nil {
            head.data = data
        } else {
            
            var temp = head
            let newNode = Node<T>()
            newNode.data = data
            
            
            if n == 0 {
                newNode.next = head
                head = newNode
            } else {
                for _ in 0..<n {
                    temp = temp.next!
                }
                newNode.next = temp.next
                temp.next = newNode
            }
        }
    }
    
    func delete(at n: Int) {
        if n == 0 {
            if head.next == nil {
                head = Node<T>()
            } else {
                head = head.next!
            }
        } else {
            var temp = head
            
            for _ in 0..<n {
                temp = temp.next!
            }
            
            let deleteNode = temp.next
            temp.next = deleteNode?.next!
        }
    }
    
    func delete(data: T) {
        if head.data == data {
            if head.next == nil {
                head = Node<T>()
            } else {
                head = head.next!
            }
        } else {
            var temp = head
            var prevNode = Node<T>()
            
            while temp.data != data {
                prevNode = temp
                temp = temp.next!
            }
            prevNode.next = temp.next!
        }
    }
    
    func reverse() {
        //https://www.youtube.com/watch?v=sYcOK51hl-A&t=235s
        var currentNode = head
        var prevNode = Node<T>()
        var nextNode = Node<T>()
        
        while currentNode.next != nil {
            
            //save next node address, as link will be broken
            nextNode = currentNode.next!
            
            //set pointer to nil to break its next node link
            currentNode.next = prevNode
            
            //set previous node as currentNode
            prevNode = currentNode
            
            //set currentNode as nextNode
            currentNode = nextNode
        }
        
        currentNode.next = prevNode
        head = currentNode
        
    }
    
    func reverseRecursive(p: Node<T>) {
        if p.next == nil {
            head = p
            return
        }
        
        if p.next != nil {
            reverseRecursive(p: p.next!)
        }
        
        let q = p.next!
        q.next = p
        p.next = nil
    }
    
    var isCircular: Bool {
        var slowPtr = head
        var fastPtr = head
        
        while fastPtr.next != nil {
            fastPtr = fastPtr.next!.next!
            slowPtr = slowPtr.next!
            
            if fastPtr === slowPtr {
                return true
            }
        }
        return false
    }
    
    
    func addTwoNumbers(l1: Node<Int>?, l2: Node<Int>?) -> Node<Int> {
        
        //This dummy node will hold reference for resultinh linklist l3
        let dummyNode = Node<Int>()
        
        //This node will hold addition of two nodes of l1 & l2
        var currentNode = dummyNode
        
        var carry = 0 , l1 = l1, l2 = l2
        
        while l1 != nil && l2 != nil {
            let digit = (l1!.data! + l2!.data! + carry) % 10
            carry = (l1!.data! + l2!.data! + carry) / 10
            let newNode = Node<Int>(data: digit)
            currentNode.next = newNode
            currentNode = newNode // make a reference to new node
            l1 = l1?.next
            l2 = l2?.next
        }
        
        while l1 != nil {
            let digit = (l1!.data! + carry) % 10
            carry = (l1!.data! + carry) / 10
            let newNode = Node<Int>(data: digit)
            currentNode.next = newNode
            currentNode = newNode // make a reference to new node
            l1 = l1?.next
        }
        
        
        while l2 != nil {
            let digit = (l2!.data! + carry) % 10
            carry = (l2!.data! + carry) / 10
            let newNode = Node<Int>(data: digit)
            currentNode.next = newNode
            currentNode = newNode // make a reference to new node
            l1 = l2?.next
        }
        
        return dummyNode.next!
    }
    

    
    func showList() {
        var curentNode: Node! = head
        
        while curentNode != nil && curentNode?.data != nil {
            print(curentNode?.data as! Int)
            curentNode = curentNode?.next
        }
    }
    
}

func merge(array1: [Int], array2: [Int]) -> [Int] {
    let count1 = array1.count
    let count2 =  array2.count
    
    var i = 0
    var j = 0
    
    var resultArray = [Int]()
    
    while i < count1 && j < count2 {
        if array1[i] < array2[j] {
            resultArray.append(array1[i])
            i += 1
        } else if array2[j] < array1[i]  {
            resultArray.append(array2[j])
            j += 1
        } else {
            resultArray.append(array1[i])
            i += 1
            j += 1
        }
    }
    
    while i < count1 {
        resultArray.append(array1[i])
        i += 1
    }
    
    while j < count2 {
        resultArray.append(array2[j])
        j += 1
    }
    
    return resultArray
}

func getMissingNumber(array: [Int]) -> Int {
    let count = array.count
    var totalElements = ((array.count + 1) * (array.count + 2)) / 2
    for index in 0..<count {
        totalElements -= array[index]
    }
    
    return totalElements
}

func reverse(array: [Int]) -> [Int] {
    var array1 = array
    
    var start = 0
    var end = array1.count - 1
    
    while start < end {
        let temp = array1[start]
        array1[start] = array1[end]
        array1[end] = temp
        
        start += 1
        end -= 1
    }
    
    return array1
}

func shuffle(array: [Int]) -> [Int] {
    var array1 = array
    
    let randomIndex = Int(arc4random_uniform(UInt32(array1.count)) % UInt32(array1.count))
    
    for index in 0..<array1.count {
        let temp = array1[index]
        array1[index] = array1[randomIndex]
        array1[randomIndex] = temp
    }
    
    return array1
}


func getFibonacci(number: Int) {
    var first = 0
    var second = 1
    var next = 0
    
    var index = 0
    
    while index < number {
        if index <= 1 {
            next = index
        } else {
            next = first + second
            first = second
            second = next
        }
        print(next)
        index += 1
    }
}

func removeSpaces(string: String) -> String {
    var resultString = String()
    
    string.forEach { (char) in
        if char != Character(" ") {
            resultString.append(char)
        }
    }
    
    return resultString
}

func reverseEveryOtherWord(sentence: String) -> String {
   //first get all words fro ma string
    let allWords = sentence.components(separatedBy: " ")
    var newSentence = ""
    
    allWords.enumerated().forEach { (index, word) in
        if newSentence != "" {
            newSentence += " "
        }
        
        if index % 2 == 1 {
            newSentence += String(word.reversed())
        } else {
            newSentence += word
        }
        
    }
    return newSentence
    
}
//5x3  = 3x5
func convertRowsToColumns(array: [[Int]]) {
   var newArray = [[Int]]()
    
    for x in 0..<array.first!.count {
        var temp = [Int]()
        for y in 0..<array.count {   // (0,0), (1,0), (2,0)
                                     // (0,1), (1,1), (2,1)
                                     // (0,2), (1,2), (2,2)
            temp.append(array[y][x])
        }
        newArray.append(temp)
    }
    print(newArray)
}

//Mark: 2Sum Brute force appraoch - O(n2)
func twoSum(array: [Int], target: Int) -> [(Int, Int)] {
    var pairs = [(Int, Int)]()
    for i in 0..<array.count {
        for j in i+1..<array.count {
            if array[j] == target - array[i] {
                pairs.append((i, j))
            }
        }
    }
    return pairs
}

//Mark: 2Sum Optimized appraoch - O(n)
func twoSum(list: [Int], target: Int) -> [(Int, Int)] {
    var dict = [Int : Int] ()
    var pair = [(Int, Int)] ()

    //traverse through the list and check if target-number value exist in hash
    for (index, number) in list.enumerated() {
        if let targetIndex = dict[target-number] {
            pair.append((targetIndex, index))
        }
        dict[number] = index
    }
    return pair
}



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let node1  = Node<Int>()
        node1.data = 1
        
        let node2  = Node<Int>()
        node2.data = 2
        
        let node3  = Node<Int>()
        node3.data = 3
        
        let list1 = LinkList<Int>()
        list1.insertAtEnd(node: node1)
        list1.insertAtEnd(node: node2)
        list1.insertAtEnd(node: node3)
        list1.showList()
        
        let node4  = Node<Int>()
        node4.data = 4
        
        let node5  = Node<Int>()
        node5.data = 5
        
        let node6  = Node<Int>()
        node6.data = 6
        
        let list2 = LinkList<Int>()
        list2.insertAtEnd(node: node4)
        list2.insertAtEnd(node: node5)
        list2.insertAtEnd(node: node6)
        list2.showList()
        
        let node = list1.addTwoNumbers(l1: list1.head, l2: list2.head)
        let list3 = LinkList<Int>()
        list3.head = node
        list3.showList()
        
        //list.reverse()
        //list.reverseRecursive(p: list.head)
        //list.showList()
        
        //let arr1 = [1,4,6,8]
        //let arr2 = [9,3,5,7]
        
        //let str = reverseEveryOtherWord(sentence: "Apple Google Airbnb Uber")
        //print(str)
        
        //3 rows 5 columns
        //convertRowsToColumns(array: [ [13,4,8,14,1], [9,6,3,7,21], [5,12,17,9,3] ])
        //5 rows 3 columns
        //[ [13,9,5], [4,6,12], [8,3,17], [14,7,9], [1,21,3] ]
        
       //let arr = shuffle(array:  [1,2,3,4,5])
       //print(arr)
        
        //let pairs = [2, 5, 11, 7, 15, 4, 5]
        //let pair = twoSum(list: pairs, target: 9)
        //print(pair)
    }
}




