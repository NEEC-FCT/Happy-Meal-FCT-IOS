//
//  RestaurantDetailViewController.swift
//  HappyMealSwift
//
//  Created by Tiago Santo on 21/02/2018.
//  Copyright © 2018 Tiago Santo. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    typealias ItemInfo = (imageName: String, title: String, isItOpenLabel: String, isItOpenImageName: String, data: NSDictionary)
    var item: ItemInfo!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    @IBOutlet weak var pageControlViewHeight: NSLayoutConstraint!
    var imageData: [String] = []
    var restaurantInfoData : NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        loadRestaurantInfo()
        loadData()
        setup()
    }
    
    // MARK: Helpers
    
    fileprivate func loadRestaurantInfo() {
        self.restaurantInfoData = self.item.data.mutableCopy() as! NSMutableDictionary
        self.restaurantInfoData.removeObjects(forKeys: ["weekId", "notifications"])
        
        if self.restaurantInfoData["informacao"] != nil {
            self.restaurantInfoData.removeObject(forKey: "informacao")
        }
        if self.restaurantInfoData["localizacao"] != nil {
            self.restaurantInfoData.removeObject(forKey: "localizacao")
        }
        
        if self.item.title == "Girassol" {
            self.restaurantInfoData.removeObject(forKey: "Bebidas")
        }
       
        for currObject in self.restaurantInfoData {
            if currObject.key as! String == "Cafetaria" {
//                let caffeeDict = self.restaurantInfoData.object(forKey: currObject.key) as! NSDictionary
//                self.restaurantInfoData.removeObject(forKey: currObject.key)
//
//                for caffeeObject in caffeeDict {
//                    let caffee = "Cafetaria -"
//                    self.restaurantInfoData.setObject(caffeeObject.value, forKey: "\(caffee) \(caffeeObject.key)" as NSCopying)
//                }
                self.restaurantInfoData.removeObject(forKey: currObject.key)
            }
            else {
                let array = self.restaurantInfoData.object(forKey: currObject.key) as! NSArray
                
                if array.count == 0 {
                    self.restaurantInfoData.removeObject(forKey: currObject.key)
                }
            }
        }
        
        
    }
    
    fileprivate func setup() {
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.allowsSelection = false
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.allowsSelection = false
        self.myTableView.estimatedRowHeight = 45
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myPageControl.numberOfPages = self.imageData.count
        
        if self.myPageControl.numberOfPages == 1 {
            self.myPageControl.isHidden = true
            self.pageControlViewHeight.constant = 1
        }
    }
    
    fileprivate func loadData() {
        switch self.item.title {
        case "Cantina":
            self.imageData.append(contentsOf: ["cantina1", "cantina2", "cantina3", "cantina4"])
            
        case "Casa do Pessoal":
            self.imageData.append(contentsOf: ["casap1", "casap2", "casap3", "casap4"])
        case "Bar Campus":
            self.imageData.append(contentsOf: ["barcampus1", "barcampus2", "barcampus3", "barcampus4"])
        case "Bar D. Lídia":
            self.imageData.append(contentsOf: ["barlidia", "barlidia1"])
        case "Sector + Departamental":
            self.imageData.append(contentsOf: ["sectordep1", "sectordep2", "sectordep3"])
        case "Teresa":
            self.imageData.append(contentsOf: ["teresa1", "teresa2", "teresa3", "teresa4"])
        case "C@mpus Come":
            self.imageData.append(contentsOf: ["come1", "come2", "come3", "come4"])
        case "My Spot":
            self.imageData.append(contentsOf: ["myspot1", "myspot2", "myspot3", "myspot4"])
        case "Sector + Ed.7":
            self.imageData.append("sectored7")
        case "Girassol":
            self.imageData.append("girassol")
        default:
            print("Error")
        }
    }
    
    // MARK: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.myCollectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.imageData.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantDetailCollectionViewCell.ReuseIdentifier, for: indexPath) as! RestaurantDetailCollectionViewCell
        
        cell.restaurantDetailImageView.image = UIImage(named: self.imageData[indexPath.row])!
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = self.myCollectionView.indexPathsForVisibleItems.first {
            self.myPageControl.currentPage = indexPath.row
        }
    }
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.restaurantInfoData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let keyArray = self.restaurantInfoData.allKeys
        let keyTitle = keyArray[section] as! String
        
        return keyTitle.capitalized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = self.restaurantInfoData.allKeys
        let key = keyArray[section] as! String
        let array = self.restaurantInfoData.object(forKey: key) as! NSArray
        
        return (array.count)/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCostTableViewCell", for: indexPath) as! TitleCostTableViewCell
        
//        switch self.item.title {
//        case "Cantina":
//        case "Casa do Pessoal":
//        case "Bar Campus":
//        case "Bar D. Lídia":
//        case "Sector + Departamental":
//        case "Teresa":
//        case "C@mpus Come":
//        case "My Spot":
//        case "Sector + Ed.7":
//        case "Girassol":
//        default:
//            NSLog("error", "")
//        }
        
        let keyArray = self.restaurantInfoData.allKeys
        let key = keyArray[indexPath.section] as! String
        let array = self.restaurantInfoData.object(forKey: key) as! NSArray
        
        let index = indexPath.row * 2
        
        let titleString = array.object(at: index) as? String
        let valueString = array.object(at: index + 1) as? String
        cell.titleLabel.text = titleString?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.valueLabel.text = valueString?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cell.valueLabel.text == "9999" {
            cell.valueLabel.isHidden = true
        }
        else {
            cell.valueLabel.isHidden = false
        }
        return cell
    }
}
