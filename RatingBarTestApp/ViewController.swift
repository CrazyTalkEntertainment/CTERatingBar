//
//  ViewController.swift
//  CTETestApp
//
//  Created by CrazyTalk Entertainment on 2014-06-14.
//  Copyright (c) 2014 CrazyTalk Entertainment. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit


class ViewController: UIViewController, CTERatingBarDelegate {
    
    required init(coder aDecoder: NSCoder) {
        
        ratingLabel = UILabel(frame: CGRect(x: 244, y: 250, width: 56, height: 50));
        ratingLabel.textAlignment = .Center
        
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var ratingView: CTERatingBar?
    @IBOutlet var IBRatingLabel: UILabel?
    var ratingBar: CTERatingBar?
    var ratingLabel: UILabel
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
//rating bar one
        if (ratingView != nil) {
            
            ratingView!.delegate = self
            ratingView!.ratingImageUnselected = UIImage(named: "DefaultStar");
            ratingView!.maxRating = 10
            ratingView!.currentRating = 7.5
            ratingView!.imageBufferDistance = 5.0
        }
        if (IBRatingLabel != nil) {
            
            IBRatingLabel!.text = "\(ratingView!.currentRating)"
        }
        
//rating bar two
        
        ratingBar = CTERatingBar(frame: CGRect(x: 20, y: 250, width: 216, height: 50), ratingImage: UIImage(named: "DefaultStar")!, maxRating: 5)
        
        ratingBar!.contentMode = .ScaleAspectFit
        ratingBar!.delegate = self
        view.addSubview(ratingBar!)
        
        ratingBar!.currentRating = 3.75
        ratingBar!.imageBufferDistance = 5.0
        ratingBar!.ratingTintColor = UIColor.blueColor()
        
        view.addSubview(ratingLabel)
        ratingLabel.text = "\(ratingBar!.currentRating)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
//CTERatingBar Delegate Methods
    func didSelectRating(rating: Double, ratingBar: CTERatingBar) {
        
        if ratingBar == self.ratingView {
            
            IBRatingLabel!.text = "\(rating)"
        }
        else if (ratingBar == self.ratingBar) {
            
            ratingLabel.text = "\(rating)"
        }
    }

}

