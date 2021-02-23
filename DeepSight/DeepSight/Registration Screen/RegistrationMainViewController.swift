//
//  RegistrationMainViewController.swift
//  DeepSight
//
//  Created by Kleomenis Katevas on 9/12/20.
//

import UIKit

class RegistrationMainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[Slide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide1.imageView.image = UIImage(named: "Happy")
        slide1.labelTitle.text = "Welcome to DeepSight"
        slide1.labelDescription.text = "Help us ......"
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide2.imageView.image = UIImage(named: "Sad")
        slide2.labelTitle.text = "Title 2"
        slide2.labelDescription.text = "Subtitle 2"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        //slide3.imageView.image = UIImage(named: "Angry")
        slide3.labelTitle.text = "Title 3"
        slide3.labelDescription.text = "Subtitle 3"
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(slides.count), height: self.scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.scrollView.frame.width * CGFloat(i), y: 0,
                                     width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func NextAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Registration Show Consent Form", sender: self)
    }

}
