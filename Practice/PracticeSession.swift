//
//  PracticeSession.swift
//  Practice

//  Created by Piyush Sharma on 6/4/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.

import Foundation
import  UIKit


// MARK: SEARCH

class PracticeSession {
    
    func linearSearch<T: Equatable>(array: [T], target: T) -> Int? {
        for (index, item) in array.enumerated() where target == item {
            return index
        }
        return nil
    }

    func binarySearch<T: Comparable>(array: [T], target: T, range: Range<Int>) -> Int? {
        
        //if we reached at this point that means we couldnt find the target value
        if range.lowerBound >= range.upperBound {
            return nil
        } else {
            
            //find a mid point to split the array
            let midIndex = range.lowerBound + (range.upperBound-range.lowerBound)/2
            
            //is target value lies in left half?
            if target < array[midIndex] {
                return binarySearch(array: array, target: target, range: range.lowerBound..<midIndex)
            }
                
            //is target value lies in right half?
            else if target > array[midIndex] {
                return binarySearch(array: array, target: target, range: midIndex+1..<range.upperBound)
            }
                
            //if we reach here means we found the target
            else {
                return midIndex
            }
        }
    }
    
    
    
    
    
    
    func binarySearch<T: Comparable>(array: [T], target: T) -> Int? {
        
        var lowerBound = 0
        var upperBound = array.count
        
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound-lowerBound)/2
            
            //if we reach here means we found the target
            if target == array[midIndex] {
                return midIndex
            }
                
            //is target value lies in right half
            else if target > array[midIndex] {
                lowerBound = midIndex + 1
            }
                
            //is target value lies in left half
            else if target < array[midIndex] {
                upperBound = midIndex
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    func countOccurancesLinear(array: [Int], target: Int) -> Int {
        var count = 0
        for num in array where num == target {
            count += 1
        }
        return count
    }
    
    
    
    
    
    func countOccurancesBinary(array: [Int], target: Int) -> Int {
        
        func rightBoundary() -> Int {
            var lowerBound = 0, upperBound = array.count
            while lowerBound < upperBound {
                let mid = lowerBound + (upperBound - lowerBound)/2
                
                //is target value lies in left half
                if target < array[mid] {
                    lowerBound = mid
                }
                //is target value lies in right half
                else {
                    upperBound = mid + 1
                }
            }
            return lowerBound
        }
        
        func leftBoundary() -> Int {
            var lowerBound = 0, upperBound = array.count
            while lowerBound < upperBound {
                let mid = lowerBound + (upperBound - lowerBound)/2
                
                //is target value lies in right half
                if target > array[mid] {
                    upperBound = mid + 1
                }
                //is target value lies in left halg
                else {
                    lowerBound = mid
                }
            }
            return lowerBound
        }
        return rightBoundary() - leftBoundary()
        
    }
}







// MARK: SORTING

extension PracticeSession {
    
    //in-place insertion sort with swap
    func insertinSort(array: [Int]) -> [Int] {
        var list = array
        
        for x in 1..<list.count {
            var y = x
            
            while y > 0 && list[y] < list[y-1] {
                list.swapAt(y, y-1)
                y -= 1
            }
        }
        
        return list
    }
    
    //in-place insertion sort without swap
    func insertionSort(nums: [Int]) -> [Int] {
        var list = nums
        
        for x in 1..<list.count {
            var y = x
            let temp = list[y]
            
            while y > 0 && temp < list[y-1] {
                list[y] = list[y-1]
                y -= 1
            }
            
            list[y] = temp
        }
        
        return list
    }
}

extension PracticeSession {
    
    func mergeSort(array: [Int]) -> [Int] {
        
        guard array.count > 1 else {
            return array
        }
        let mid = array.count/2
        let leftPile = mergeSort(array: Array(array[0..<mid]))
        let rightPile = mergeSort(array: Array(array[mid..<array.count]))
        return merge(leftPile: leftPile, rightPile: rightPile)
        
    }
    
    func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
        var leftIndex = 0, righIndex = 0, merged = [Int]()
        
        while leftIndex < leftPile.count && righIndex < rightPile.count {
            if leftPile[leftIndex] < rightPile[righIndex] {
                merged.append(leftPile[leftIndex])
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[righIndex] {
                merged.append(rightPile[righIndex])
                righIndex += 1
            } else {
                merged.append(leftPile[leftIndex])
                leftIndex += 1
                merged.append(rightPile[righIndex])
                righIndex += 1
            }
        }
        
        while leftIndex < leftPile.count {
            merged.append(leftPile[leftIndex])
            leftIndex += 1
        }
        
        while righIndex < rightPile.count {
            merged.append(rightPile[righIndex])
            righIndex += 1
        }
        
        return merged
    }
}

extension PracticeSession {
    
    //Approach #1: recursive quick sort
    
    func quickSort<T: Comparable>(array: [T]) -> [T] {
        guard array.count > 1 else {
            return array
        }
        
        let pivot = array[array.count/2]
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        return quickSort(array: less) + equal + quickSort(array: greater)
    }
    
    
    
    
    //Approach #2: lomuto partition quick sort
    
    func lomutoPatition<T: Comparable>(array: inout [T], low: Int, high: Int) -> Int {
        let pivot = array[high]
        
        var i = low
        
        for j in low..<high {
            if array[j] <= pivot {
                array.swapAt(i, j)
                i += 1
            }
        }
        
        array.swapAt(high, i)
        return i
    }
    
    func quickSort<T: Comparable>(array: inout [T], low: Int, high: Int) {
        if low < high {
            let p = lomutoPatition(array: &array, low: low, high: high)
            quickSort(array: &array, low: low, high: p-1)
            quickSort(array: &array, low: p+1, high: high)
        }
    }
    
    
    
    //Approach #1: Find kth largest element
    
    func findKthLargestElement(k: Int, array: [Int]) -> Int? {
        let length = array.count
        
        if k > 0 && k <= length {
            let sorted = array.sorted()
            let kth = sorted[length-k]
            return kth
        } else {
            return nil
        }
    }
    
    
    //Approach #2: Find kth largest element
    
    //step1: generate a random pivot and swap with the last item
    func randomPivot(low: Int, high: Int, array: inout [Int]) -> Int {
        let randomIndex = Int(arc4random_uniform(UInt32(high-low+1)))
        array.swapAt(randomIndex, high)
        return array[high]
    }
    
    
    //step2: partition the array using lomuto algorithm
    func randomPartition(low: Int, high: Int, array: inout [Int]) -> Int {
        let pivot = randomPivot(low: low, high: high, array: &array)
        var i = low
        
        for j in low..<high {
            if array[j] <= pivot {
                array.swapAt(i, j)
                i += 1
            }
        }
        
        array.swapAt(i, high)
        return i
    }
    
    //step3: search kth element in the array using binary search
    func searchElement(array: inout [Int], low: Int, high: Int, k: Int) -> Int {
        let partitionIndex = randomPartition(low: low, high: high, array: &array)
        if low < high {
            
            //if kth element exist in left pile
            if k < partitionIndex {
                return searchElement(array: &array, low: low, high: partitionIndex-1, k: k)
            }
                
                //if kth element exist in right pile
            else if k > partitionIndex {
                return searchElement(array: &array, low: partitionIndex+1, high: high, k: k)
            }
                
                //if kth element is equal to parition index
            else {
                return array[partitionIndex]
            }
        } else {
            return array[low]
        }
    }
    
    
    func findkthElement(array: inout [Int], k: Int) -> Int {
        return searchElement(array: &array, low: 0, high: array.count-1, k: 4)
    }
}

// MARK: QUEUE

extension PracticeSession {
    
    struct Queue<T> {
        var array: [T?] = []
        var head = 0
        
        var isEmpty: Bool {
            return array.count == 0
        }
        
        var count: Int {
            return array.count - head
        }
        
        mutating func enqueue(element: T) {
            array.append(element)
        }
        
        mutating func dequeue()  -> T? {
            guard head < array.count, let element = array[head] else {
                return nil
            }
            
            array[head] = nil
            head += 1
            
            let emptyArrayPercent = Double(head/array.count)
            
            if emptyArrayPercent > 0.25 && array.count > 50 {
                array.removeFirst(head)
                head = 0
            }
            return element
        }
    }
}

// MARK: ARRAY


extension PracticeSession {
    
    struct OrderedArray<T: Comparable> {
        var array: [T] = []
        
        init(_ array: [T]) {
            self.array = array.sorted()
        }
        
        var isEmpty: Bool {
            return array.count == 0
        }
        
        var count: Int {
            return array.count
        }
        
        subscript(index: Int) -> T {
            return array[index]
        }
        
        mutating func removeAt(index: Int) {
            array.remove(at: index)
        }
        
        
        func findInsertIndex(element: T) -> Int {
            for i in 0..<array.count {
                if element <= array[i] {
                    return i
                }
            }
            
            return array.count
        }
        
        func findInsertPoint(target: T) -> Int {
            var low = 0
            var high = array.count
            
            while low < high {
                let mid = low + (high - low)/2
                
                //equal
                if target == array[mid] {
                    return mid
                }
                    
                //greter
                else if target > array[mid] {
                    low = mid+1
                }
                
                //less
                else {
                    high = mid
                }
            }
            return low
        }
    }
}

extension PracticeSession {
    
    struct Array2D<T> {
        
        var array: [T] = []
        var rows: Int
        var columns: Int
        
        init(columns: Int, rows: Int, initialValue: T) {
            self.rows = rows
            self.columns = columns
            self.array = Array(repeating: initialValue, count: rows * columns)
        }
        
        subscript(column: Int, row: Int) -> T {
            get {
               return array[row * columns + column]
            }
            
            set {
                //The index of an object in the array is given by (row x numberOfColumns) + column,
                array[row * columns + column] = newValue
            }
        }
    }
}





// MARK: HASHTABLE

extension PracticeSession {
    
    struct HasTable<Key: Hashable, Value> {
        typealias Element = (key: Key, value: Value)
        typealias Bucket = [Element]
        
        //keep track of how many items have been added to the hash table using the count.
        var count = 0
        var buckets = [Bucket]()
        
        init(capacity: Int) {
            self.buckets = Array(repeating: [], count: capacity)
        }
        
        func bucketIndex(for key: Key) -> Int {
            return abs(key.hashValue).quotientAndRemainder(dividingBy: buckets.count).remainder
        }
        
        
        subscript(key: Key) -> Value? {
            get {
                return value(for: key)
            }
            set {
                if let value = newValue {
                    update(key: key, value: value)
                }
            }
        }
        
        func value(for key: Key) -> Value? {
            let index = bucketIndex(for: key)
            let value = buckets[index].first { $0.key == key}?.value
            return value
        }
        
        mutating func update(key: Key, value: Value) {
            let index = bucketIndex(for: key)
            if let (i, element) = buckets[index].enumerated().first(where: { $0.1.key == key }) {
                buckets[index][i].value = element.value
                return
            }
            
            count += 1
            buckets[index].append((key: key, value: value))
        }
        
        mutating func removeValue(for key: Key) {
            let index = bucketIndex(for: key)
            
            for (i, element) in buckets[index].enumerated() where element.key == key {
                count -= 1
                buckets[index].remove(at: i)
            }
        }
    }
}



//MARK: STACK

class StackNode<T> {
    var value: T?
    var next: StackNode<T>?
    
    init(value: T? = nil) {
        self.value = value
    }
}

struct Stack<T> {
    
    var top: StackNode? = StackNode<T>()
    
    mutating func push(_ item: T) {
        //keep track of top node which has been pushed onto stack
        let pushedNode = top
        top = StackNode<T>(value: item)
        top?.next = pushedNode
    }
    
    mutating func pop() -> T? {
        //keep track of current popping node and move the pointer to the next node
        let topNode = top
        top = top?.next
        return topNode?.value
    }
}








