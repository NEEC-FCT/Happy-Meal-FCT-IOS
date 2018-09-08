//
//  RestaurantViewController.swift
//  HappyMealSwift
//
//  Created by Tiago Santo on 17/02/2018.
//  Copyright © 2018 Tiago Santo. All rights reserved.
//

import UIKit


class RestaurantViewController: ExpandingViewController {
    
    fileprivate let RESTAURANTDETAILSEGUE = "toRestaurantDetail"
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate var items: [ItemInfo] = []
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var isItUpdated: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    typealias ItemInfo = (imageName: String, title: String, isItOpenLabel: String, isItOpenImageName: String, data: NSDictionary)
    var data: NSDictionary? = [:]
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSize = CGSize(width: 256, height: 460)
        UIApplication.shared.statusBarStyle = .lightContent
        
        registerCell()
        setup()
        addGesture(to: collectionView!)
    }
    
    
    // MARK: Helpers
    fileprivate func setup() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 8 && hour < 17 {
            self.navigationItem.title = "PARA IR ALMOÇAR?"
        }
        else {
            self.navigationItem.title = "PARA IR JANTAR?"
        }
        
        downloadFile()
    }
    
    fileprivate func showIndicatorView() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    fileprivate func hideIndicatorView() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    fileprivate func isItOpenCurrentTime(fromTime: Int, toTime: Int, data: NSDictionary) -> Bool {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let currentTimeString = "\(hour)\(minutes)"
        let currentTime = Int(currentTimeString)
        
        if currentTime! > fromTime && currentTime! < toTime {
            return true
        }
        
        return false
    }
    
    fileprivate func loadInfo(isItOpen: Bool, imageName: String, title: String, data: NSDictionary) {
        var isItOpenString = ""
        var isItOpenImage = ""
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        
        let dateOfMenu = data.object(forKey: "weekId") as! String
        let dateArray = dateOfMenu.components(separatedBy: "-")

        if isItOpen && day == Int(dateArray[0]) {
            isItOpenString = "ABERTO"
            isItOpenImage = "bolas_verde"
            self.isItUpdated.isHidden = true
        }
        else {
            isItOpenString = "FECHADO"
            isItOpenImage = "bolas_vermelha"
            self.isItUpdated.isHidden = false
        }
        
        self.items.append(ItemInfo(imageName: imageName, title: title, isItOpenLabel: isItOpenString, isItOpenImageName: isItOpenImage, data: data))
    }
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: RestaurantCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: RestaurantCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: items.count)
    }
    
    
    /// MARK: Gesture
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(RestaurantViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(RestaurantViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? RestaurantCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            self.performSegue(withIdentifier: self.RESTAURANTDETAILSEGUE, sender: indexPath.row)
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_: UIScrollView) {
        pageLabel.text = "\(currentIndex + 1)/\(items.count)"
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? RestaurantCollectionViewCell else { return }
        
        let index = indexPath.row % items.count
        let info = items[index]
        cell.backgroundImageView?.image = UIImage(named: info.imageName)
        cell.customTitle.text = info.title
        cell.isItOpenImage.image = UIImage(named: info.isItOpenImageName)
        cell.isItOpenLabel.text = info.isItOpenLabel
        
        switch info.title {
        case "Cantina":
            cell.openTimeLabel.text = "2ª a 6ª-feira"
            cell.locationLabel.text = "Edíficio VII - Tenda ao pé dos microondas"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 11:30 - 14:30"
            cell.dinnerLabel.text = "Jantar: 18:30 - 20:30"
        case "Casa do Pessoal":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 8:30 às 18:00"
            cell.locationLabel.text = "Edíficio I - Junto do Mini Nova"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 12:00 - 15:00"
            cell.dinnerLabel.text = ""
        case "Bar Campus":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 9:30 às 18:00"
            cell.locationLabel.text = "Edifício da Biblioteca - Piso de baixo"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 12:00 - 18:00"
            cell.dinnerLabel.text = ""
        case "Bar D. Lídia":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 8:00 às 19:00"
            cell.locationLabel.text = "Edíficio II"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 12:00 - 14:30"
            cell.dinnerLabel.text = ""
        case "Sector + Departamental":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 9:00 às 18:00"
            cell.locationLabel.text = "Departamental"
            cell.avgPriceLabel.text = "Preço médio 6€"
            cell.lunchLabel.text = "Almoço: 11:30 - 14:30"
            cell.dinnerLabel.text = ""
        case "Teresa":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 8:30 às 21:00"
            cell.locationLabel.text = "Hangar I"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 11:30 - 14:30"
            cell.dinnerLabel.text = "Jantar: 18:30 - 20:30"
        case "C@mpus Come":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 9:00 às 18:00"
            cell.locationLabel.text = "Edíficio da Cantina - Ao lado do Duplix"
            cell.avgPriceLabel.text = "Preço médio 8€"
            cell.lunchLabel.text = "Almoço: 12:00 - 15:30"
            cell.dinnerLabel.text = ""
        case "My Spot":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 8:45 às 19:00"
            cell.locationLabel.text = "Edíficio da Cantina - Ao lado do Duplix"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 11:30 - 14:30"
            cell.dinnerLabel.text = ""
        case "Sector + Ed.7":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 9:00 às 18:00"
            cell.locationLabel.text = "Edíficio VII"
            cell.avgPriceLabel.text = "Preço médio 4.05€"
            cell.lunchLabel.text = "Almoço: 12:00 - 15:00"
            cell.dinnerLabel.text = ""
        case "Girassol":
            cell.openTimeLabel.text = "2ª a 6ª-feira das 8:30 às 18:00"
            cell.locationLabel.text = "Edíficio VIII"
            cell.avgPriceLabel.text = ""
            cell.lunchLabel.text = "Almoço: 11:30 - 14:30"
            cell.dinnerLabel.text = ""
        default:
            print("Error")
        }
        
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RestaurantCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            self.performSegue(withIdentifier: self.RESTAURANTDETAILSEGUE, sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.RESTAURANTDETAILSEGUE {
            if let vc = segue.destination as? RestaurantDetailViewController {
                let index: Int = (sender as? Int)!
                vc.item = self.items[index]
                vc.title = self.items[index].title.capitalized
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if self.items.count > 0 {
            return self.items.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RestaurantCollectionViewCell.self), for: indexPath)
    }
    
    

    fileprivate func downloadFile() {
        do {
            
            let urlString = "http://fcthub.neec-fct.com/JSON/maLucasNotification.json"
            
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with:url!) { (data, false , error) in
                if error != nil {
                    print(error)
                } else {
                    do {
                        
 
                        let dataArray = try JSONSerialization.jsonObject(with: data!, options:[])
                        self.data = dataArray as? NSDictionary
                        print("Data")

                        print( self.data )
                        
                        for (key,value) in self.data! {
                            switch key as! String {
                            case "Cantina":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1130, toTime: 1430, data: self.data?.object(forKey: key) as! NSDictionary) || self.isItOpenCurrentTime(fromTime: 1830, toTime: 2030, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "cantina1", title: "Cantina", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Casa do P.":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1200, toTime: 1500, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "casap4", title: "Casa do Pessoal", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Bar Campus":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1200, toTime: 1800, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "come1", title: "Bar Campus", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Bar D. Lídia":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1200, toTime: 1430, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "barlidia", title: "Bar D. Lídia", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Sector + Dep":
                                let isItOpenBool = self.self.isItOpenCurrentTime(fromTime: 1130, toTime: 1430, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "sectordep1", title: "Sector + Departamental", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Teresa":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1130, toTime: 1530, data: self.data?.object(forKey: key) as! NSDictionary) || self.isItOpenCurrentTime(fromTime: 1900, toTime: 2045, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "teresa4", title: "Teresa", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "C@m. Come":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1130, toTime: 1530, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "come1", title: "C@mpus Come", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "My Spot":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1145, toTime: 1500, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "myspot1", title: "My Spot", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Sector + Ed.7":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1200, toTime: 1500, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "sectored7", title: "Sector + Ed.7", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            case "Girassol":
                                let isItOpenBool = self.isItOpenCurrentTime(fromTime: 1130, toTime: 1430, data: self.data?.object(forKey: key) as! NSDictionary)
                                self.loadInfo(isItOpen: isItOpenBool, imageName: "girassol", title: "Girassol", data: value as! NSDictionary)
                                print("\(key) = \(value)")
                            default:
                                print("KEY value: \(key)")
                            }
                        }
                        
                        if self.items.count > 0 {
                            self.fillCellIsOpenArray()
                            self.pageLabel.text = "\(self.currentIndex + 1)/\(self.items.count)"
                            self.pageLabel.isHidden = false
                            self.infoButton.isHidden = false
                            self.collectionView?.reloadData()
                        }
                        else {
                            self.errorView.isHidden = false
                        }
                        self.hideIndicatorView()
                    } catch {
                        self.hideIndicatorView()
                        self.errorView.isHidden = false
                        print("Unable to load data: \(error)")
                    }
               
                        
                 
                    }
                }.resume()
            
            
        }
    }
    
    // MARK: Buttons Action
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        downloadFile()
    }
    @IBAction func infoButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "HappyMeal", message: "Swipe up. Try to do it again 😉", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
