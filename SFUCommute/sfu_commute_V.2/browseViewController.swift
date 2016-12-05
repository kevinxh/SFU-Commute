//
//  browseViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let browseCell = "browseCell"

struct cellInfo{
    var startLocation : String = ""
    var destination : String = ""
    var date : String = ""
    var scheduler : String = ""
}

class browseViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cells = [cellInfo]()
    var content:role = .request

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(browseCollectionViewCell.self, forCellWithReuseIdentifier: browseCell)
    }

    override func viewDidAppear(_ animated: Bool) {
        cells.removeAll()
        switchContent()
        loadList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func switchContent(){
        if((self.tabBarController?.selectedIndex) == 0){
            content = .offer
        } else {
            content = .request
        }
    }
    
    func loadList(){
        var type = "Both"
        if(content == .offer){
            type = "Driver"
        } else if (content == .request){
            type = "Rider"
        }
        let parameters : Parameters = ["scheduleType": type]
        Alamofire.request("http://54.69.64.180/ride", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if(json["ride"].count > 0) {
                    var cell = cellInfo()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E, d MMM yyyy HH:mm"
                    for (index,subJson):(String, JSON) in json["ride"] {
                        cell.startLocation = subJson["startLocation"]["name"].stringValue
                        cell.destination = subJson["destination"]["name"].stringValue
                        let d = subJson["date"].stringValue.isoDateToNSDate()
                        cell.date = formatter.string(from: d)
                        cell.scheduler = subJson["scheduler"]["user"]["firstname"].stringValue
                        self.cells.append(cell)
                    }
                    self.collectionView?.reloadData()
                }
            case .failure(let error):
                print(error)
                //to do: error handling
            }
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: browseCell, for: indexPath) as! browseCollectionViewCell
        if(cells.count > 0){
            cell.startLocation = cells[indexPath.row].startLocation
            cell.destination = cells[indexPath.row].destination
            cell.date = cells[indexPath.row].date
            cell.name = cells[indexPath.row].scheduler
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(content == .offer){
            self.performSegue(withIdentifier: "offerToTripInfo", sender: self)
        } else if (content == .request){
            self.performSegue(withIdentifier: "requestToTripInfo", sender: self)
        }
    }
}

class browseCollectionViewCell : UICollectionViewCell {
    var startLocation : String = ""{
        didSet{
            startText.text = startLocation
        }
    }
    var destination : String = ""{
        didSet{
            destinationText.text = destination
        }
    }
    var date : String = ""{
        didSet{
            timeText.text = date
        }
    }
    var name : String = ""{
        didSet{
            nameText.text = name
        }
    }
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "START LOCATION"
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        label.textColor = Colors.SFURed
        return label
    }()
    
    let startText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        return label
    }()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.text = "DESTINATION"
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        label.textColor = Colors.SFUBlue
        return label
    }()
    
    let destinationText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        return label
    }()
    
    let timeText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-Bold", size: 12)!
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let nameText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)!
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        return label
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "user-placeholder"))
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        setupShadow()
        backgroundColor = UIColor.white
        addSubview(startLabel)
        addSubview(startText)
        addSubview(destinationLabel)
        addSubview(destinationText)
        addSubview(timeText)
        addSubview(nameText)
        addSubview(userImage)
        startLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(20)
            make.width.equalTo(150)
        }
        startText.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(self.frame.width - 200)
            make.top.equalTo(startLabel.snp.bottom)
        }
        destinationLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(150)
            make.top.equalTo(startText.snp.bottom)
        }
        destinationText.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(self.frame.width - 200)
            make.top.equalTo(destinationLabel.snp.bottom)
        }
        timeText.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(120)
            make.top.equalTo(startLabel)
            make.height.equalTo(36)
        }
        nameText.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(timeText)
            make.top.equalTo(timeText.snp.bottom)
        }
        userImage.snp.makeConstraints{(make) -> Void in
            make.centerX.equalTo(nameText)
            make.width.height.equalTo(40)
            make.top.equalTo(nameText.snp.bottom)
        }
    }
    
    func setupShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = shadowPath.cgPath
    }
}
