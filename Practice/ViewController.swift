//
//  ViewController.swift
//  Practice
//
//  Created by Piyush Sharma on 4/12/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit

func sqroot(n: Double) -> Int {
    var squareRoot = n/2
    var guess = 0.0
    
    while squareRoot != guess {
        guess = squareRoot
        squareRoot = (guess + (n/guess))/2
        
    }
    print(squareRoot)
    return Int(squareRoot)
}

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
    var front: Node? = Node<T>()
    var rear: Node? = Node<T>()
    
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
        } else {
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
        
        while fastPtr.next != nil && fastPtr.next!.next != nil {
            fastPtr = fastPtr.next!.next!
            slowPtr = slowPtr.next!
            if fastPtr === slowPtr {
                return true
            }
        }
        return false
    }
    
    func getLoopNode(startNode: Node<T>) {
        var fastPtr = startNode
        var slowPtr = startNode
        
        //If fastPtr encounters nil, it means there is no Loop in Linked list.
        while fastPtr.next != nil {
            fastPtr = fastPtr.next!.next!
            slowPtr = slowPtr.next!
            
            // if slowPtr and fastPtr meets, it means linked list contains loop.
            if slowPtr === fastPtr {
                //After meet, moving slowPtr to start node of list.
                slowPtr = head
                //Moving slowPtr and fastPtr one node at a time till the time they meet at common point.
                while !(slowPtr === fastPtr) {
                    fastPtr = fastPtr.next!
                    slowPtr = slowPtr.next!
                }
                print("Loop start at node: \(slowPtr.data!)")
                return
            }
        }
        
        print("No Loop")
    }
    
    func enqueue(node: Node<T>) {
        if front?.data == nil && rear?.data == nil {
            front = node
            rear = node
            head = front!
            return
        }
        
        rear?.next = node
        rear = node
    }
    
    func dequeue() {
        if front?.next == nil {
            front = Node<T>()
            head = front!
            return
        }
        
        if front === rear {
            front = Node<T>()
            rear = Node<T>()
        } else {
            front = front?.next
        }
        head = front!
    }
    
    func removeLoopFromLinkList(startNode: Node<T>) {
        var previousPtr: Node<T>?
        var fastPtr = startNode
        var slowPtr = startNode
        
        //If fastPtr encounters nil, it means there is no Loop in Linked list.
        while fastPtr.next != nil && fastPtr.next?.next != nil {
            previousPtr = fastPtr.next!
            fastPtr = fastPtr.next!.next!
            slowPtr = slowPtr.next!
            
            if slowPtr === fastPtr {
                slowPtr = head
                
                //If loop start node is starting at the root Node, then slowPtr, fastPtr and head all point to the same location.
                //we already capture previous node, just setting it to nill will work in this case.
                if slowPtr === fastPtr {
                    previousPtr?.setLink(node: Node())
                } else {
                    //We need to first identify the start of loop node and then by setting
                    //fast node to nil we can break the cycle
                    while slowPtr.next! !== fastPtr.next! {
                        slowPtr = slowPtr.next!
                        fastPtr = fastPtr.next!
                    }
                    fastPtr.setLink(node: Node())
                }
            }
        }
        print(startNode.data!)
    }
    
    func addTwoNumbers(l1: Node<Int>?, l2: Node<Int>?) -> Node<Int> {
        let dummyNode = Node<Int>(data: 0)
        var currentNode = dummyNode
        var carry = 0, sum = 0, l1 = l1, l2 = l2
        
        while l1 != nil || l2 != nil || carry != 0 {
            sum = carry
            
            if l1 != nil {
                sum += l1!.data!
                l1 = l1?.next
            }
            
            if l2 != nil {
                sum += l2!.data!
                l2 = l2?.next
            }
            
            let digit = sum % 10
            carry = sum / 10
            
            let node = Node<Int>(data: digit)
            currentNode.next = node
            currentNode = node
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

//merge two array without sorting
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

// Mark: 2Sum brute force appraoch - O(n2)

func twoSum(array: [Int], target: Int) -> [(Int, Int)] {
    var pairs = [(Int, Int)]()
    for i in 0..<array.count {
        for j in i+1..<array.count {
            if array[j] == (target - array[i]) {
                pairs.append((i, j))
            }
        }
    }
    return pairs
}

// Mark: 2Sum optimized approach, keep a track of target-number in the hashTable - O(n)

func twoSum(list: [Int], target: Int) -> [(Int, Int)] {
    var hashTable = [Int : Int] ()
    var pairs = [(Int, Int)] ()
    
    //traverse through the list and check if target-number key exist in the hashTable then its a sum.
    for (index, number) in list.enumerated() {
        if let targetIndex = hashTable[target-number] {
            pairs.append((targetIndex, index))
        }
        
        //if we cant find the key in hashTable then add the number (key) and index (value)
        hashTable[number] = index
    }
    return pairs
}


func findLongestSubstring(from s : String) -> (Int, String) {
    var j = 0, maxLength = 0, n = s.count, breakPoint = 0
    let array = Array(s)
    var dict = [Character : Int]()
    
    while j < n {
        let char = array[j]
        
        if let index = dict[char] {
            j = index + 1
            dict.removeAll()
        } else {
            dict[char] = j
            j += 1
            
            let currentLength = dict.keys.count
            if maxLength < currentLength {
                maxLength = currentLength
                breakPoint = j
            }
        }
    }
    
    let nonRepeatedString = array[(breakPoint-maxLength)..<breakPoint]
    return (maxLength, String(nonRepeatedString))
}

func longestPalinfromicSubstring(s: String) -> String {
    if s.isEmpty || s.count < 2 {
        return s
    }
    let stringArray = Array(s)
    let length = s.count
    
    var palindromeArray = Array(repeating: Array.init(repeating: false, count: length), count: length)
    var left = 0, right = 0
    
    for j in 1..<length {
        for i in 0..<j {
            let isInnerPalindrome = palindromeArray[i+1][j-1] || (j - i) <= 2
            //print(stringArray[i],stringArray[j])
            if stringArray[i] == stringArray[j] && isInnerPalindrome {
                palindromeArray[i][j] = true
                if (j - i) > (right - left) {
                    left = i
                    right = j
                }
            }
        }
    }
    let stringVal = String(Array(s)[left...right])
    return stringVal
}


func fizzBuzz(of number: Int) -> [String] {
    var result = [String]()
    
    if number < 0 {
        return result
    }
    
    for i in 0...number {
        if i%3 == 0 && i%5 == 0 {
            result.append("FizzBuzz")
        } else if i%3 == 0 {
            result.append("Fizz")
        } else if i%5 == 0 {
            result.append("Buzz")
        } else {
            result.append("\(i)")
        }
    }
    return result
}

class TreeNode {
    var value: Int?
    var left: TreeNode?
    var right: TreeNode?
    
    init(val: Int?) {
        self.value = val
        left = nil
        right = nil
    }
    
    var isLeaf: Bool {
        return left == nil ? right == nil : false
    }
}


class MaxDepthOfBimaryTree {
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        return max(maxDepth(root.left), maxDepth(root.right)) + 1
    }
}

func moveZeros(_ nums: inout [Int]) {
    var index = 0
    for num in nums {
        if num != 0 {
            nums[index] = num
            index += 1
            print(nums)
        }
    }
    
    while index < nums.count {
        nums[index] = 0
        index += 1
    }
}

/*  Given an array of stock prices, find the maximum profit that can be earned by doing a single transaction
 of buy and sell in the given period of time. buying day <= selling day */

func buySellStocksI(prices: [Int]) -> (Int, (Int, Int)) {
    var profit = 0, minPrice = prices.first ?? Int.max
    var days: (buyDay: Int, sellDay: Int) = (0, 0)
    
    for (_, price) in prices.enumerated() {
        if price < minPrice {
            minPrice = price
        } else {
            if (price - minPrice) > profit {
                days = (prices.index(of: minPrice)!, prices.index(of: price)!)
            }
            profit = max(price - minPrice, profit)
        }
    }
    return (profit, days)
}


/*  Given an array of stock prices, find the maximum profit that can be earned by performing multiple non-overlapping transactions (buy and sell).
    Note that you cannot buy on day 1, buy on day 2 and sell them later, as you are
    engaging multiple transactions at the same time. You must sell before buying again. */

func buySellStocksII(prices: [Int]) ->  (Int, [(Int, Int)]) {
    var profit = 0
    var days: [(buyDay: Int, sellDay: Int)] = [(0, 0)]
    
    guard prices.count > 1 else {
        return (profit, [])
    }
    
    days.removeFirst()
    for i in 1..<prices.count where prices[i] > prices[i-1] {
        days.append((i-1, i))
        profit += prices[i] - prices[i-1]
    }
    return (profit, days)
}


//MARK: Find majority element in an array which has occured more than n/2 times (basic)

func majorityElementI(in arr: [Int]) {
    let n = arr.count
    var maxCount = 0, index = 0
    
    //itereate throught array from 0...n, 1...n and so on.
    for i in 0..<n {
        var count = 0
        
        //loop through all the elements and track each element occurance count
        for j in 0..<n {
            if arr[i] == arr[j] {
                count += 1
            }
        }
        
        //update max count for each element
        if count > maxCount {
            maxCount = count
            index = i
        }
    }
    
    if maxCount > n/2 {
        print(arr[index])
    }
}

//MARK: Find majority element in an array which has occured more than n/2 times (moore voting algo)

/* This algorithm loops through each element and maintains a count of it. If the next element is same then
 increment the count, if the next element is not same then decrement the count, and if the count reaches 0 then changes
 the major to the current element and set the count again to 1.*/

func majorityElementII(in nums: [Int]) -> Int {
    var major = nums.first, count = 0
    
    for num in nums {
        if num == major {
            count += 1
        } else {
            count -= 1
        }
        
        if count == 0 {
            major = num
            count = 1
        }
    }
    return major!
}

func majorityElementIII(in nums: [Int]) {
    var dict = [Int: Int]()
    for num in nums {
        let isExist = dict.contains { (key, value) -> Bool in
            key == num
        }
        
        if isExist {
            dict[num] = dict[num]! + 1
        } else {
            dict[num] =  1
        }
        
        if dict[num]! > nums.count/3 {
            print(num)
        }
    }
}

func uniqueCharacter(in s: String) -> Int {
    var dict = [Character: Bool]()
    let charArray = Array(s)
    
    for char in charArray {
        if let _ = dict[char] {
            dict[char] = true
        } else {
            dict[char] = false
        }
    }
    
    for (index, char) in charArray.enumerated() {
        if let isDup = dict[char], !isDup {
            return index
        }
    }
    
    return -1
    
}

func flatten<T>(s: [T]) -> [T] {
    var r = [T]()
    for e in s {
        switch e {
        case let e as [T]:
            r += flatten(s: e)
        case let x:
            r.append(x)
        }
    }
    return r
}

//MARK: Tree

func convertArrayToBST(start: Int, end: Int, nums: [Int?]) -> TreeNode? {
    if nums.isEmpty {
        return nil
    }
    
    if start > end {
        return nil
    }
    
    let mid =  (start + end) / 2
    let root = TreeNode(val: nums[mid])
    root.left = convertArrayToBST(start: start, end: mid-1, nums: nums)
    root.right = convertArrayToBST(start: mid + 1, end: end, nums: nums)
    
    return root
}


//MARK: Preorder (root -> left -> right)

func preorderTraverse(root: TreeNode?) {
    var stack = [TreeNode]()
    stack.append(root!)
    
    while !stack.isEmpty {
        let node = stack.popLast()
        print(node?.value)
        
        if node?.right != nil {
            stack.append(node!.right!)
        }
        
        if node?.left != nil {
            stack.append(node!.left!)
        }
    }
}


//MARK: Inorder (left -> root -> right)

func inorderTraverse(root: TreeNode?) {
    var current = root, stack = [TreeNode]()
    
    while current != nil || !stack.isEmpty {
        if current != nil {
            stack.append(current!)
            current = current?.left
        } else {
            let node = stack.popLast()
            //print(node!.value)
            current = node?.right
        }
    }
}

//MARK: Postorder (left -> right -> root)
//https://www.programcreek.com/2012/12/leetcode-solution-of-iterative-binary-tree-postorder-traversal-in-java/
//https://www.youtube.com/watch?v=Ut90klNN264

func postorderTraverse(root: TreeNode?) {
    var stack = [TreeNode]()
    stack.append(root!)
    var peeked = [TreeNode?]()
    
    while !stack.isEmpty {
        let temp = stack.last//peek
        
        if (temp!.left == nil && temp?.right == nil) || peeked.contains(where : { $0 === temp}) {
            let node = stack.popLast()
            //print(node!.value)
        } else {
            if temp?.right != nil {
                stack.append(temp!.right!)
            }
            
            if temp?.left != nil {
                stack.append(temp!.left!)
            }
            
            peeked.append(temp)
        }
    }
}


func topKFrequentElements(_ a: [Int], _ k: Int) -> [Int]{
    var frequencyTable = [Int : Int]()
    var result = [Int]()
    
    for num in a {
        if frequencyTable[num] == nil {
            frequencyTable[num] = 1
        } else {
            frequencyTable[num]! += 1
        }
    }
    
    var buckets = [[Int]?](repeating: nil, count: a.count+1)
    
    for (num, times) in frequencyTable {
        if buckets[times] == nil {
            buckets[times] = [Int]()
        }
        buckets[times]?.append(num)
    }
    
    for i in stride(from: buckets.count-1, to: 0, by: -1) where result.count<k {
        if let bucket = buckets[i] {
            result += bucket
            if result.count > k {
                result = Array(result[0..<k])
            }
        }
    }
    return result
}

//MARK: Check if tree left branch is symmteric to right branch

func isMirror(root: TreeNode?) -> Bool {
    guard let root = root else {
        return true
    }
    return mirror(p: root.left, q: root.right)
}

func mirror(p: TreeNode?, q: TreeNode?) -> Bool {
    if p == nil && q == nil {
        return true
    }
    if p == nil || q == nil || p?.value != q?.value {
        return false
    }
    return mirror(p: p?.left, q: q?.right) && mirror(p: p?.right, q: q?.left)
}



//MARK: check if tree is subtree of another tree

func equals(p: TreeNode?, q: TreeNode?) -> Bool {
    if p == nil && q == nil {
        return true
    }
    
    if p == nil || q == nil || p?.value != q?.value {
        return false
    }
    return equals(p: p!.left, q: q!.left) && equals(p: p!.right, q: q!.right)
}

func isSubtree(tree1: TreeNode?, tree2: TreeNode?) -> Bool {
    if tree2 == nil { return true } // every leaf node has nil as sub tree
    if tree1 == nil { return false } //if main tree itself is nil then no match
    
    if tree1?.value != tree2?.value { return false } // if values of nodes dont matches
    return equals(p: tree1, q: tree2) || isSubtree(tree1: tree1?.left, tree2: tree2) || isSubtree(tree1: tree1, tree2: tree2?.right)
}


func removeDuplicates(array: inout [Int]) -> Int {
    if array.count <= 1 {
        return array.count
    }
    
    var lastIndex = 0
    
    for num in array {
        if num != array[lastIndex] {
            lastIndex += 1
            array[lastIndex] = num
        }
    }
    return lastIndex + 1
}

func shortestString(in words: [String]) -> (String, Int) {
    var length = Int.max
    var shortString = String()
    
    words.forEach { (word) in
        if words.count < length {
            length = word.count
            shortString = word
        }
    }
    return (shortString, length)
}

func longestCommonPrefix(strs: [String]) -> String {
    
    if strs.isEmpty {
        return ""
    }
    
    var longestCommonPrefix = strs.first!
    
    for i in 1..<strs.count {
        var j = 0, currentStringArray = Array(strs[i])
        
        while j < longestCommonPrefix.count && j < currentStringArray.count && currentStringArray[j] == Array(longestCommonPrefix)[j] {
            j += 1
        }
        
        if j == 0 {
            return ""
        }
        
        longestCommonPrefix = String(Array(longestCommonPrefix)[0..<j])
    }
    return longestCommonPrefix
}


func permutation(of string: inout String, start: Int, end: Int) {
    
    if start == end {
        print(string)
    } else {
        for i in start...end {
            var str = Array(string)
            str.swapAt(start, i)
            string = String(str)
            
            permutation(of: &string, start: start+1, end: end)
            str.swapAt(start, i)
            string = String(str)
        }
    }
}

func findDuplicate(array: inout [Int]) {
    var set = Set<Int>()
    
    for i in 0..<array.count {
        //get array number to be used as index
        let number = abs(array[i])
        
        //check this index value is negative or not if yes then add to set
        if array[number] < 0 {
            set.insert(abs(array[i]))
        } else {
            //or make it that index value negative
            array[i] = -array[number]
        }
    }
    
    for index in 0..<array.count {
        array[index] = abs(array[index])
    }
}

func sizeOf(tree: TreeNode?) -> Int {
    if tree == nil {
        return 0
    }
    
    if tree?.left == nil && tree?.right == nil {
        return 1
    }
    
    return sizeOf(tree:  tree?.left) + sizeOf(tree: tree?.right) + 1
    
}

//https://www.careercup.com/question?id=11298700
func kthLargestElementinBST(k: Int, root: TreeNode?) {
    var current = root, stack = [TreeNode]()
    var count = k
    
    while current != nil || !stack.isEmpty {
        if current != nil {
            stack.append(current!)
            current = current?.right
        } else {
            let node = stack.popLast()
            count -= 1
            if count == 0 {
                print(node?.value)
                break
            }
            current = node?.left
        }
    }
}

//https://www.programcreek.com/2014/07/leetcode-kth-smallest-element-in-a-bst-java/
func kthSmallestElementinBST(k: Int, root: TreeNode?) {
    var current = root, stack = [TreeNode]()
    var count = k
    
    if root == nil {
        print(" ")
    }
    
    while current != nil || !stack.isEmpty {
        if current != nil {
            stack.append(current!)
            current = current?.left
        } else {
            let node = stack.popLast()
            count -= 1
            
            if count == 0 {
                print(node?.value)
            }
            current = node?.right
        }
    }
}


struct DataStructure {
    var hash = [Int:Int]()
    var list = [Int]()
    
    mutating func add(element: Int) {
        
        if let _ = hash[element] {
            return
        }
        
        list.append(element)
        hash.updateValue(list.count-1, forKey: element)
    }
    
    
    mutating func remove(element: Int) {
        
        //Check if element is present by hash lookup
        guard let index = hash[element] else {
            return
        }
        
        //If present, then remove element from hash
        hash.removeValue(forKey: element)
        
        //Swap element with last element so that remove from arr[] can be done in O(1) time
        list.swapAt(list.count-1, index)
        
        //Remove last element (This is O(1))
        list.remove(at: list.count-1)
        
        //Update hash table for new index of last element
        let lastElement = list[list.count-1]
        hash.updateValue(list.count-1, forKey: lastElement)
    }
    
    var random: Int {
        let randomIndex = Int(arc4random_uniform(UInt32(list.count)))
        return list[randomIndex]
    }
    
    func search(element: Int) -> Int? {
        guard let index = hash[element] else {
            return nil
        }
        return index
    }
}

public class Interval {
    public var start: Int
    public var end: Int
    
    public init(_ start: Int, _ end: Int) {
        self.start = start
        self.end = end
    }
}



extension Interval: Equatable {
    public static func ==(lhs: Interval, rhs: Interval) -> Bool {
        return lhs.start == rhs.end
    }
}




func mergeOverlap(intervals: [Interval]) -> [Interval] {
    
    if intervals.isEmpty {
        return []
    }
    
    var result = [Interval](), accumulator = Interval(-1, -1)
    let sortedIntervals = intervals.sorted(by: {$0.start < $1.start })
    
    for interval in sortedIntervals {
        //let rangeInterval = Range<Int>(interval.start...interval.end)
        
        if accumulator == Interval(-1, -1) {
            accumulator = interval
        }
        
        if accumulator.end >= interval.end {
            //accumulator is in range
        }
            
        else if accumulator.end >= interval.start {
            accumulator.end = interval.end
        } else if accumulator.end <= interval.start {
            result.append(accumulator)
            accumulator = interval
        }
    }
    
    if accumulator !== Interval(-1, -1) {
        result.append(accumulator)
    }
    return result
}


func findPeakElement(array: [Int]) -> Int {
    if array.isEmpty {
        return -1
    }
    
    var lb = 0, ub = array.count-1
    
    while lb + 1 < ub {
        let mid = lb + (ub-lb)/2
        
        //if mid element is smaller than its next neighbour then peak element will be in right side
        if array[mid] < array[mid + 1] {
            lb = mid
        }
            
        //if mid element is smaller than its previuos neighbour then peak element will be in left side
        else if array[mid] < array[mid-1] {
            ub = mid
        } else {
            return array[mid]
        }
    }
    return array[lb] > array[ub] ? array[lb] : array[ub]
}


func searchInRotatedArray(nums: [Int], target: Int) -> Int {
    
    var left = 0, right = nums.count - 1
    
    while left <= right {
        let mid = (left + right) / 2
        
        //if mid element equals target we return it
        if nums[mid] == target {
            return mid
        }
            //check if first element is smaller than mid element
        else if nums[left] <= nums[mid] {
            
            //check if target number is between left <= target <= mid
            if target >= nums[left] && target <= nums[mid] {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else {
            //check if target number is between mid <= target <= right
            if target >= nums[mid] && target <= nums[right] {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    
    return  -1
}


func findMin(nums: [Int]) -> Int {
    
    if nums.isEmpty {
        return 0
    }
    
    if nums.count == 1 {
        return nums.first!
    }
    
    if nums.count == 2 {
        return min(nums[0], nums[1])
    }
    
    var start = 0, stop = nums.count - 1
    
    while start < stop {
        if nums[start] < nums [stop] {
            return nums[start]
        }
        
        let mid = (start + stop) / 2
        
        if mid == start {
            break
        }
        
        if nums[mid] > nums[start] {
            start = mid
        } else if nums [mid] < nums[start] {
            stop = mid
        }
    }
    return min(nums[start], nums[stop])
}

func findMin2(nums: [Int]) -> Int {
    
    if nums.count <= 0 {
        return 0
    }
    
    for i in 0..<nums.count {
        if nums[i] > nums [i + 1] {
            return nums[i+1]
        }
    }
    return nums.first!
}

func maxSumSubarray(from arr: [Int]) {
    var currentMax = arr[0], best = arr[0]
    
    for i in 1..<arr.count {
        currentMax = max(arr[i], currentMax + arr[i])
        best = max(currentMax, best)
    }
    
    print(best)
}

func maxProduct(nums: [Int]) -> Int {
    var min_soFar = nums[0]
    var max_soFar = nums[0]
    var max_global = nums[0]
    
    for i in 1..<nums.count {
        let a = max_soFar * nums[i]
        let b = min_soFar * nums[i]
        
        max_soFar = max(a, b, nums[i])
        min_soFar = min(a, b, nums[i])
        
        max_global = max(max_global, max_soFar)
    }
    
    return max_global
}

func productSelf(array: [Int]) {
    var products = Array(repeating: 1, count: array.count)
    
    //In this loop, products variable contains product of elements on left side excluding array[i] */
    for i in (1..<array.count) {
        products[i] = products[i-1] * array[i-1]
    }
    
    var right = 1
    
    /* In this loop, products variable contains product of elements on right side excluding array[i] */
    for i in (0..<array.count).reversed() {
        products[i] = right * products[i]
        right = right * array[i]
    }
    
    print(products)
}

//Brute force approach for coing change
func coinChangeBruteForce(money: Int, coins:[Int]) -> Int {
    
    if money == 0 {
        return 0
    }
    var result = Int.max
    
    for coin in coins {
        if money >= coin {
            result = min(result, coinChangeBruteForce(money: money - coin, coins: coins) + 1)
        }
    }
    return result
}

//Memoized approach for coin change
func coinChangeMemo(money: Int, coins:[Int]) -> Int {
    
    if let memo = memo[money] {
        return memo
    }
    
    if money == 0 {
        return 0
    }
    
    var result = Int.max
    
    for coin in coins {
        if money >= coin {
            result = min(result, coinChangeMemo(money: money - coin, coins: coins) + 1)
            memo[money] = result
        }
    }
    
    return result
}


//DP approach for coin change
func coinChangeDP(money: Int, coins:[Int]) -> Int {
    var result = Array(repeating: Int.max, count: money + 1)
    result[0] = 0
    
    for i in 1...money {
        for coin in coins {
            if i - coin >= 0 {
                result[i] = min(result[i], result[i-coin] + 1)
            }
        }
    }
    return result[money]
}


//DP approach for coin change ways
func coinChangeWaysDP(money: Int, coins:[Int]) -> Int {
    var result = Array(repeating: 0, count: money + 1)
    result[0] = 1
    
    for coin in coins {
        for i in 1..<result.count {
            if i >= coin {
                result[i] += result[i-coin]
            }
        }
    }
    return result[money]
}



//MARK: Brute force

func knapsack(weights: [Int], values: [Int], capacity: Int, i: Int) -> Int {
    if i == weights.count {
        return 0
    }
    
    //if weights of the (weights.count - 1) item is more thena knapsack capacity
    //then item can't be included in the optimum solution
    
    if capacity < weights[i]  {
        return knapsack(weights: weights, values: values, capacity: capacity, i: i+1)
    }
        
        //return max of two cases
        //(1). weights-1 item included
        //(2). weights-1 item not included
        
    else {
        let value1 = knapsack(weights: weights, values: values, capacity: capacity, i: i+1)
        let value2 = knapsack(weights: weights, values: values, capacity: capacity - weights[i], i: i+1) + values[i]
        return max(value1, value2)
    }
}

func knapsack(weights: [Int], values: [Int], capacity: Int) -> Int {
    return knapsack(weights: weights, values: values, capacity: capacity, i: 0)
}


//MARK: DP

func knapsack(weights: [Int], values: [Int], totalWeight: Int) {
    
    var cache = Array(repeating: Array(repeating: -1, count: totalWeight + 1), count: weights.count + 1)
    for i in 0...weights.count {
        for j in 0...totalWeight {
            
            if i == 0 || j == 0 {
                cache[i][j] = 0
            }
            
            //if current capacity of the bag  j: [0.1.2.3.4.5] is less than available weights
            else if j < weights[i-1] {
                cache[i][j] = cache[i-1][j]
            } else {
                cache[i][j] = max(cache[i-1][j], cache[i-1][j-weights[i-1]] + values[i-1])
            }
        }
    }
    print(cache[weights.count][totalWeight])
}

func LongestIncreasingSubsequence(nums: [Int]) -> Int {
    var length_global = 0
    var length_current = [Int](repeating: 1, count: nums.count)
    
    for i in 0..<nums.count {
        for j in 0..<i {
            if nums[i] > nums[j] {
                length_current[i] = max(length_current[i], length_current[j] + 1)
            }
        }
        length_global = max(length_global, length_current[i])
    }
    return length_global
}

func helperLCS(i: Int, j: Int, str1: String, str2: String) -> Int {
    let str1Arr = Array(str1)
    let str2Arr = Array(str2)
    
    if i > str1Arr.count-1 || j > str2Arr.count-1 {
        return 0
    } else if str1Arr[i] == str2Arr[j] {
        return 1 + helperLCS(i: i+1, j: j+1, str1: str1, str2: str2)
    } else {
        return max(helperLCS(i: i+1, j: j, str1: str1, str2: str2), helperLCS(i: i, j: j+1, str1: str1, str2: str2))
    }
}

func LCSRecursion(string1: String, string2: String) -> Int {
    return helperLCS(i: 0, j: 0, str1: string1, str2: string2)
}

func LCSDynamicProgramming(A: String, B: String) -> [[Int]] {
    let aArray = Array(A)
    let bArray = Array(B)
    var lcs = [[Int]](repeating: [Int](repeating: 0, count: bArray.count+1), count: aArray.count+1)
    
    for j in 1..<bArray.count+1 {
        for i in 1..<aArray.count+1 {
            if aArray[i-1] == bArray[j-1] {
                lcs[i][j] = 1 + lcs[i-1][j-1]
            } else {
                lcs[i][j] = max(lcs[i-1][j], lcs[i][j-1])
            }
            print("lcs[\(i)\(j)] = \(lcs[i][j])")
        }
    }
    return lcs
}

func backtrackLCS(A: String, B: String, lcs: [[Int]]) -> [Character] {
    let aArray = Array(A)
    let bArray = Array(B)
    
    var longest = lcs[aArray.count][bArray.count]
    var sequence: [Character] = [Character](repeating: " ", count: longest)
    var i = aArray.count, j = bArray.count
    
    while i > 0 && j > 0 {
        
        // If current character in A[] and B are same, then current character is part of LCS
        if aArray[i-1] == bArray[j-1] {
            
            // Put current character in result
            sequence[longest-1] = aArray[i-1] //or bArray[j-1] both are same
            i -= 1
            j -= 1
            longest -= 1
        }
        // If not same, then find the max of previous row, previous column
        else if lcs[i-1][j] > lcs[i][j-1] { // max condition as in above lcs dp solution
            i -= 1
        } else {
            j -= 1
        }
    }
    return sequence
}

var memo = [Int : Int]()

func jumps(nums: [Int]) -> Int{
    
    //if ladder has no stairs then we cant jump at all
    if nums.count <= 1 {
        return 0
    }
    
    var ladder = nums[0] //keep track of largest ladder you have
    var stairs = nums[0] //keep track of current ladder stairs count
    var jump = 1
    
    for level in 1..<nums.count {
        
        //base case
        if level == nums.count-1 {
            if ladder == nums.count-1 {
                print("can reach at the last of ladder")
            } else {
                print("can't reach at the last of ladder")
            }
            return jump
        }

        //build new ladder if find beter one than current one
        if level + nums[level] > ladder {
            ladder = level + nums[level]
        }
        
        //keep track of stairs, once used update remaining stairs
        stairs -= 1
        
        //once stairs are finished in current ladder, jump to another ladder
        if stairs == 0 {
            jump += 1
            //assign new stairs for current ladder
            stairs = ladder-level
        }
    }
    
    return jump
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = Queue()
        queue.enqueue(item: 10)
        queue.enqueue(item: 20)
        queue.enqueue(item: 30)
        queue.enqueue(item: 40)
        queue.enqueue(item: 50)
        
        
        let item1 = queue.dequeue()
        let item2 = queue.dequeue()

        let list4 = LinkList<Int>()
        list4.enqueue(node: Node<Int>(data: 6))
        list4.enqueue(node: Node<Int>(data: 5))
        list4.enqueue(node: Node<Int>(data: 4))
        //list4.showList()
        
        list4.dequeue()
        list4.showList()


        
//        let d = sqrt(2)
//        jumps(nums: [2,3,1,1,4])
//
//       // let val = buySellStocksI(prices: [3,3,5,0,0,3,1,4])
//
//        let ps = PracticeSession()
//
//        let data = ps.mergeSort(array: [2, 1, 5, 4, 9])
//        print(data)
//        //let lis = LongestIncreasingSubsequence(nums: [10,9,2,5,3,7,101,18])
//        //let lcs = LCSRecursion(string1: "bd", string2: "abcd")
//
//        let lcs = LCSDynamicProgramming(A: "longest", B: "stone")
//        let lcsString = backtrackLCS(A: "longest", B: "stone", lcs: lcs)
//        print(lcsString)
//
//        let knp = knapsack(weights: [1,2,3], values: [6,10,12], capacity: 5)
//        print(knp)
//
//        //knapsack(weights: [1,2,3], values: [6,10,12], totalWeight: 5)
//
//        //let and = coinChangeWaysDP(money: 12, coins: [1,2,5])
//
//        //let ans = minCoinsChangeRecursive(coins: [25, 5, 1], money: 25)
//        maxSumSubarray(from: [-2,3,-4])
//        //let intervalArray = [[1,3],[2,6],[8,10],[15,18]]
//        let intervalArray = [[1,4], [0,4]]
//        let intervalsMapped = intervalArray.map { Interval($0.first!, $0.last!)}
//        let overlapped = mergeOverlap(intervals: intervalsMapped)
//        print(overlapped)
//
//        let peakelement = findPeakElement(array: [1,2,3,1])
//        print("peak eleement:\(peakelement)")
//
//        var ds = DataStructure()
//        ds.add(element: 7)
//        ds.add(element: 9)
//        ds.add(element: 8)
//        ds.add(element: 6)
//        ds.add(element: 5)
//
//
//        print(ds.list)
//
//        //ds.remove(element: 9)
//        //ds.remove(element: 7)
//        print(ds.list)
//        print(ds.random)
//        print(ds.random)
//
//
//        let treeArray: [Int?] = [10, 20, 30, 40, 50]
//        let root = convertArrayToBST(start: 0, end: treeArray.count - 1, nums: treeArray)
//        //preorderTraverse(root: root!)
//        //inorderTraverse(root: root!)
//
//        postorderTraverse(root: root!)
//
//        let kthSmallest = kthSmallestElementinBST(k: 1, root: root)
//        let kthlargest = kthLargestElementinBST(k: 2, root: root)
//
//
//        var dups = [1,4,2,3,1]
//        findDuplicate(array: &dups)
//
//        var str = "ABC"
//        permutation(of: &str, start: 0, end: 2)
//
//
//        productSelf(array: [1, 2, 3, 4])
//
//        let arr = ["geeksforgeeks", "geeks",
//                   "geek", "geezer"]
//        let lcp = longestCommonPrefix(strs: arr)
//        print(lcp)
//
//
//        let n1 = Node(data: 1)
//        let n2 = Node(data: 20)
//        let n3 = Node(data: 5)
//        let n4 = Node(data: 18)
//        let n5 = Node(data: 22)
//        //let n6 = Node(data: 5)
////        let n7 = Node(data: 70)
////        let n8 = Node(data: 80)
//
//        let loopList = LinkList<Int>()
//        loopList.insertAtEnd(node: n1)
//        loopList.insertAtEnd(node: n2)
//        loopList.insertAtEnd(node: n3)
//        loopList.insertAtEnd(node: n4)
//        loopList.insertAtEnd(node: n5)
////        loopList.insertAtEnd(node: n6)
////        loopList.insertAtEnd(node: n7)
////        loopList.insertAtEnd(node:n8)
//
//        //to test loop in a linklist
//        n5.setLink(node: n3)
//
//        loopList.getLoopNode(startNode: loopList.head)
//        //loopList.showList()
//        print(loopList.isCircular) // true
//        loopList.removeLoopFromLinkList(startNode: loopList.head)
//        print(loopList.isCircular) //false
//
//        let node2  = Node<Int>()
//        node2.data = 2
//
//        let node4  = Node<Int>()
//        node4.data = 4
//
//        let node3  = Node<Int>()
//        node3.data = 3
//
//        let node6  = Node<Int>()
//        node6.data = 6
//
//        let list1 = LinkList<Int>()
//        list1.insertAtEnd(node: node2)
//        list1.insertAtEnd(node: node4)
//        list1.insertAtEnd(node: node3)
//        list1.insertAtEnd(node: node6)
//
//        //list1.showList()
//
//        //let node5  = Node<Int>()
//        //node5.data = 5
//        //let node6  = Node<Int>()
//        //node6.data = 6
//
//        let list2 = LinkList<Int>()
//        list2.insertAtEnd(node: node4)
//        //list2.insertAtEnd(node: node5)
//        //list2.insertAtEnd(node: node6)
//        //list2.showList()
//
//
//        let node = list1.addTwoNumbers(l1: list1.head, l2: list2.head)
//        let list3 = LinkList<Int>()
//        list3.head = node
//        //list3.showList()
//        
//        list1.reverse()
//        //list.reverseRecursive(p: list.head)
//        //list.showList()
//        //let arr1 = [1,4,6,8]
//        //let arr2 = [9,3,5,7]
//
//        //let str = reverseEveryOtherWord(sentence: "Apple Google Airbnb Uber")
//        //print(str)
//
//        //3 rows 5 columns
//        //convertRowsToColumns(array: [ [13,4,8,14,1], [9,6,3,7,21], [5,12,17,9,3] ])
//        //5 rows 3 columns
//        //[ [13,9,5], [4,6,12], [8,3,17], [14,7,9], [1,21,3] ]
//
//        //let arr = shuffle(array:  [1,2,3,4,5])
//        //print(arr)
//        //let pairs = [2, 5, 11, 7, 15, 4, 5]
//        //let pair = twoSum(list: pairs, target: 9)
//        //print(pair)
//        //        let arr = merge(array1: [9,4,5], array2: [3,2,8])
//        //        print(arr)
//        //        let result = findLongestSubstring(from: "aababca")
//        //        print(result.1, result.0)
//        //
//        //        let lps = longestPalinfromicSubstring(s: "cbbd")
//        //        print(lps)
//
//        //        let root = TreeNode(val: 1)
//        //        root.left = TreeNode(val: 2)
//        //        root.right = TreeNode(val: 3)
//        //        root.left?.left = TreeNode(val: 4)
//        //        root.right?.right = TreeNode(val: 5)
//        //print(MaxDepthOfBimaryTree().maxDepth(root))
//        //        var arr = [0, 1, 0, 3, 12]
//        //        moveZeros(&arr)
//        //        print(arr)/////////////////////////////////////'''''''''''''''''''''
//
//        let stockPrices = [7,1,5,3,6,4]
//        let stockDetails = buySellStocksII(prices: stockPrices)
//        print(stockDetails.0, stockDetails.1)
//        //let stockDetails = buySellStocksII(prices: stockPrices)
//        //print("Buying stocks at day: \(stockDetails.1.0) and selling at day: \(stockDetails.1.1), you will get profit of: \(stockDetails.0)")
//
//        let element = majorityElementII(in: [3, 3, 4, 2, 4, 4, 2, 4, 4])
//        print(element)
//
//        let index = uniqueCharacter(in: "geeksforgeeks")
//        print(index)
//
//        let r = flatten(s: [1,2, [3,4, [5,6, [7,8]]]])
//        let s = flatten(s: ["a","b", ["c","d", ["e","f", ["g","h"]]]])
//        print(r,s)
//
//        //let treeArray = [1,3,5,7,9]
//        //let root = convertArrayToBST(nums: treeArray)
//        //inorderTraverse(root: root!)
//
//        let resu = topKFrequentElements([1,2,1,2,3,4], 2)
//        print(resu)
//
//        //Mirror sub trees
//        let mirrorRoot = TreeNode(val: 1)
//        mirrorRoot.left = TreeNode(val: 2)
//        mirrorRoot.right = TreeNode(val: 2)
//        mirrorRoot.left?.left = TreeNode(val: 3)
//        mirrorRoot.left?.right = TreeNode(val: 4)
//        mirrorRoot.right?.left = TreeNode(val: 4)
//        mirrorRoot.right?.right = TreeNode(val: 3)
//        let istrue = isMirror(root: mirrorRoot)
//        print(istrue)
//
//        var duplicates = [0,0,1,1,1,2,2,3,3,4]
//        let length = removeDuplicates(array: &duplicates)
//        print(length)
        
    }
}





