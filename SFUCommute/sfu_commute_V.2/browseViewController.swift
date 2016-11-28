//
//  browseViewController.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-08.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import UIKit

let browseCell = "browseCell"

class browseViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(browseCollectionViewCell.self, forCellWithReuseIdentifier: browseCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: browseCell, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

class browseCollectionViewCell : UICollectionViewCell {
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "START LOCATION"
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        label.textColor = Colors.SFURed
        return label
    }()
    
    let startText: UILabel = {
        let label = UILabel()
        label.text = "8888 University Drive. Burnaby BC"
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
        label.text = "8888 University Drive. Burnaby BC"
        label.font = UIFont(name: "Futura-Medium", size: 16)!
        return label
    }()
    
    let timeText: UILabel = {
        let label = UILabel()
        label.text = "Tue, Nov 29, 08:00 AM"
        label.font = UIFont(name: "Futura-Bold", size: 12)!
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let nameText: UILabel = {
        let label = UILabel()
        label.text = "Kevin Abcd"
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
            make.left.top.equalTo(self).offset(15)
            make.top.equalTo(self).offset(20)
            make.width.equalTo(150)
        }
        startText.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(self.frame.width - 100)
            make.top.equalTo(startLabel.snp.bottom)
        }
        destinationLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(150)
            make.top.equalTo(startText.snp.bottom)
        }
        destinationText.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(startLabel)
            make.width.equalTo(self.frame.width - 100)
            make.top.equalTo(destinationLabel.snp.bottom)
        }
        timeText.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(self).offset(-20)
            make.width.equalTo(100)
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
