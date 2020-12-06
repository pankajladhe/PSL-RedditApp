//
//  NewsCellTableViewCell.swift
//  PSL-RedditApp
//
//  Created by PSL on 12/05/20.
//  Copyright © 2020 PSL All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import AVFoundation

class NewsCellTableViewCell: UITableViewCell {
    
    var vStackView = UIStackView()
    var title = UILabel()
    var cellImage = UIImageView()
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var hStackView = UIStackView()
    
    let score = UILabel()
    let comments = UILabel()
    let share = UILabel()
    
    var childData: Child? {
        didSet {
            if let cd = childData {
                self.title.text = cd.data.title
                self.title.font = UIFont.boldSystemFont(ofSize: 17)
                showImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellImage.image = nil
    }
    
    func showImage() {
        if let cd = childData, let iData = cd.data.preview?.images[0].source.url {
            let decodedimageUrlString = String(htmlEncodedString: iData)
            if let urlString = decodedimageUrlString, let imageURL = URL(string: urlString) {
                //Caching the downloaded image
                self.cellImage.kf.setImage(with: imageURL)
                
                var currentHeight = 0
                var CurrentWidth = 0
                if let ht = cd.data.thumbnailHeight, let wd = cd.data.thumbnailWidth {
                    currentHeight = ht
                    CurrentWidth = wd
                    
                } else {
                    if let ht = cd.data.preview?.images[0].resolutions[0].height,  let wd = cd.data.preview?.images[0].resolutions[0].width {
                        currentHeight = ht
                        CurrentWidth = wd
                    }
                }
                self.cellImage.heightAnchor.constraint(equalToConstant: CGFloat(currentHeight*2)).isActive = true
                self.cellImage.widthAnchor.constraint(equalToConstant: CGFloat(CurrentWidth)).isActive = true
            }
        } else {
            self.cellImage.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        }
        if let cd = childData {
            if cd.data.preview?.redditVideoPreview != nil || cd.data.media?.redditVideo != nil {
                self.showVideo()
            }
        }
        
        self.showAnalayticsData()
        setNeedsLayout()
    }
    
    func showVideo() {
        if let cd = childData {
            let previewUrlStr = cd.data.preview?.redditVideoPreview?.scrubberMediaURL
            let mediaUrlStr = cd.data.media?.redditVideo?.scrubberMediaURL
            var decodedimageUrlString = ""
            
            if let pUrlStr = previewUrlStr  {
                decodedimageUrlString = String(htmlEncodedString: pUrlStr)!
                
            } else if let mUrlStr = mediaUrlStr {
                decodedimageUrlString = String(htmlEncodedString: mUrlStr)!
            }
            
            if let imageURL = URL(string: decodedimageUrlString) {
                
                let asset = AVAsset(url: imageURL)
                let playerItem = AVPlayerItem(asset: asset)
                self.player = AVPlayer(playerItem: playerItem)
                
                //Create AVPlayerLayer object
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.cellImage.bounds
                playerLayer.videoGravity = .resizeAspect
                
                //Add playerLayer to view layer
                self.cellImage.image = nil
                self.cellImage.layer.addSublayer(playerLayer)
                
                //Play Video
                player.play()
                
                //CellImage height
                var currentHeight = 0
                var CurrentWidth = 0
                
                if let ht = cd.data.preview?.redditVideoPreview?.height , let wd = cd.data.preview?.redditVideoPreview?.width {
                    currentHeight = ht
                    CurrentWidth = wd
                } else if let ht = cd.data.media?.redditVideo?.height, let wd = cd.data.media?.redditVideo?.width {
                    currentHeight = ht
                    CurrentWidth = wd
                    
                }
                self.cellImage.heightAnchor.constraint(equalToConstant: CGFloat(currentHeight*2)).isActive = true
                self.cellImage.widthAnchor.constraint(equalToConstant: CGFloat(CurrentWidth)).isActive = true
            }
            setNeedsLayout()
        }
    }
    
    func showAnalayticsData() {
        hStackView.backgroundColor = .green
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .equalSpacing
        hStackView.spacing = 32
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.hStackView.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        self.hStackView.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        if let cd = childData {
            
            //Have no image to append, so simply adding text
            //Up vote(Score)
            let formatedUps = formatNumber(cd.data.score)
            score.text = "Ups: \(formatedUps)"
            self.score.font = UIFont.systemFont(ofSize: 15)
            hStackView.addArrangedSubview(score)
            
            //Comments
            let formatedCom = formatNumber(cd.data.numComments)
            comments.text = "Com: \(formatedCom)"
            self.comments.font = UIFont.systemFont(ofSize: 15)
            hStackView.addArrangedSubview(comments)
            
            //Share
            share.text = "Share"
            self.share.font = UIFont.systemFont(ofSize: 15)
            hStackView.addArrangedSubview(share)
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set any attributes of your UI components.
        vStackView.axis = .vertical
        vStackView.alignment = .fill
        vStackView.distribution = .fill
        vStackView.spacing = 32
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.sizeToFit()
        
        vStackView.addArrangedSubview(title)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addArrangedSubview(cellImage)
        vStackView.addArrangedSubview(hStackView)
        
        //Title Constraints
        title.anchor(top: vStackView.topAnchor,
                     topConstant: 0,
                     bottom: cellImage.topAnchor,
                     bottomConstant: 20,
                     leading: vStackView.leadingAnchor,
                     leadingConstant: 0,
                     trailing: vStackView.trailingAnchor,
                     trailingConstant: 0)
        
        //Horizontal Constraints
        hStackView.anchor(top: cellImage.bottomAnchor,
                          topConstant: 10,
                          bottom: vStackView.bottomAnchor,
                          bottomConstant: 10,
                          leading: vStackView.leadingAnchor,
                          leadingConstant: 20,
                          trailing: vStackView.trailingAnchor,
                          trailingConstant: 20)
        
        contentView.addSubview(vStackView)
        
        // Main StackView Constraints
        vStackView.anchor(top: contentView.topAnchor,
                          topConstant: 10,
                          bottom: contentView.bottomAnchor,
                          bottomConstant: 10,
                          leading: contentView.leadingAnchor,
                          leadingConstant: 10,
                          trailing: contentView.trailingAnchor,
                          trailingConstant: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
        player.replaceCurrentItem(with: nil)
        share.text = ""
        comments.text = ""
        share.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
