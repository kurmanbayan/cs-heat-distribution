//
//  ViewController.swift
//  Heat
//
//  Created by Kurnmanbay Ayan on 4/9/18.
//  Copyright © 2018 Kurmanbay Ayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var a = Array(repeating: Array(repeating: 0.0, count: 10), count: 10)
    var g = Array(repeating: Array(repeating: 0.0, count: 10), count: 10);
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let n = 10;
    let th = 0.00000001;
    var timer = Timer()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for i in 0...n - 1 {
            a[i][0] = 20.0;
            a[i][n - 1] = 20.0;
            a[0][i] = 20.0;
            a[n - 1][i] = 20.0;
        }
        for i in 3...6 {
            a[0][i] = 100.0;
        }
        
        for _ in 0...400 {
            group.enter()
            for i in 1...self.n - 2 {
                DispatchQueue.main.async {
                    self.calc(i)
                }
            }
            group.leave()

            group.notify(queue: .main) {
                self.checkAndUpdate()
            }
        }
    }
    
    func checkAndUpdate() {
        var sum: Double = 0.0
        
        for i in 1...self.n - 2 {
            for j in 1...self.n - 2 {
                sum += (self.g[i][j] - self.a[i][j]);
            }
        }
        
        print(sum)
        
        let m = Double(self.n - 2)
        if (sum / (m * m) < self.th) {
            self.printAns()
            collectionView.reloadData()
        }
        
        for i in 1...self.n - 2 {
            for j in 1...self.n - 2 {
                self.a[i][j] = self.g[i][j];
            }
        }
    }
    
    func printAns() {
        for i in 0...n - 1 {
            print(a[i])
            print("")
        }
    }
    
    func calc(_ i: Int) {
        for j in 1...n - 2 {
            g[i][j] = (a[i - 1][j] + a[i + 1][j] + a[i][j - 1] + a[i][j + 1]) * 0.25
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        cell.backgroundColorView.backgroundColor = UIColor(red: CGFloat(a[indexPath.section][indexPath.row] / 100), green: 0, blue: 0, alpha: 1)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
}


