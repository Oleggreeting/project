

import UIKit
protocol RaceViewControllerDelegate: AnyObject {
    func playing(info: Bool)
}

class RaceViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var viewForCar: UIView!
    @IBOutlet weak var viewForLabel: UIView!
    @IBOutlet weak var viewMyCar: UIView!
    @IBOutlet weak var myView1: UIView!
    @IBOutlet weak var myView2: UIView!
    @IBOutlet var trees1: [UIImageView]!
    @IBOutlet var trees2: [UIImageView]!
    @IBOutlet weak var road1: UILabel!
    @IBOutlet weak var road2: UILabel!
    @IBOutlet weak var road3: UILabel!
    @IBOutlet weak var road4: UILabel!
    @IBOutlet weak var buttonJump: UIButton!

    
    //MARK: - Var
    weak var delegate: RaceViewControllerDelegate?
    var moving: Bool = false
    var duration: Double = 0.01 //sec.
    var timer1: Timer! = nil
    var timer2: Timer! = nil
    var timer3 = Timer()
    var arrayCarsPassing: [UIImageView] = []
    var arrayCarsOncoming: [UIImageView] = []
    var arrayTrees: [UIImageView] = []
    var myCar: UIImageView!
    var gamer: Gamer? = nil
    var distans: Double = 0
    var difficulty: Double = 1
    var jumping = false
    
    //MARK: - Let
    let shared = Manager.shared
    let label = UILabel()
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if gamer != nil {
            difficulty = gamer!.difficulty
        }
        radiusig()
        createMyCar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.myView2.frame.origin.y -= self.myView2.frame.height
    }
    
    //MARK: - Actions
    @IBAction func buttonLeft(_ sender: UIButton) {
        if moving {
            myCar.frame.origin.x -= 10
        }
    }
    
    @IBAction func buttonRight(_ sender: UIButton) {
        if moving {
            myCar.frame.origin.x += 10
        }
    }
    @IBAction func buttonJump(_ sender: UIButton) {
        timerDown()
        buttonJump.isEnabled = false
        buttonJump.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.myCar.frame.size = CGSize(width: 60, height: 90)
            self.jumping = true
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseIn, animations: {
                self.myCar.frame.size = CGSize(width: 50, height: 80)
            }) { (_) in
                self.jumping = false
            }
        }
    }
    
    
    //   MARK: - Flow functions
    private func timerDown(){
        var count = 10

        var timer = Timer()
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                if(count > 0) {
//                    self.buttonJump.titleLabel?.text = String(count)
                    count -= 1
                }else{
                    self.buttonJump.isHidden = false

                    self.buttonJump.isEnabled = true
                    timer.invalidate()
                }
            }
        
    }
    private func breaking(){
        if myCar.frame.origin.x < 0 || myCar.frame.origin.x + myCar.frame.width > view.frame.width {
            moving = false
            rotation()
            transitionToEndVC()
        }
        for element in trees1 {
            var newFrame: CGRect = element.frame
            newFrame.origin.y += myView1.frame.origin.y + 30
            newFrame.size.height -= 40
            if newFrame.intersects(myCar.frame) {
                moving = false
                rotation(element)
                transitionToEndVC()
            }
        }
        for element in trees2 {
            var newFrame: CGRect = element.frame
            newFrame.origin.y += myView2.frame.origin.y + 30
            newFrame.size.height -= 40
            if newFrame.intersects(myCar.frame) {
                moving = false
                rotation(element)
                transitionToEndVC()
            }
        }
        if jumping == false {
            for element in arrayCarsPassing {
                if element.frame.intersects(myCar.frame) {
                    moving = false
                    rotation(element)
                    transitionToEndVC()
                }
            }
            for element in arrayCarsOncoming {
                if element.frame.intersects(myCar.frame){
                    moving = false
                    rotation(element)
                    transitionToEndVC()
                }
            }
        }
    }
    
    private func rotation(_ element: UIImageView? = nil) {
        let rotation: CGFloat = 20
        UIView.animate(withDuration: 0.5) {
            self.myCar.frame.origin.y -= 20
            self.myCar.transform = CGAffineTransform.init(rotationAngle: -rotation)
            element?.transform = CGAffineTransform.init(rotationAngle: rotation)
        }
    }
    
    private func activateTimers() {
        timer1 = Timer.scheduledTimer(withTimeInterval: duration/difficulty, repeats: true, block: { (_) in // timer for moving view
            self.breaking()
            if self.moving {
                self.moveView()
                guard self.arrayCarsOncoming.count > 0 else {return}
                self.moveOncomingCar()
                guard self.arrayCarsPassing.count > 0 else {return}
                self.movePassingCar()
            } else {
                self.timer1.invalidate()
            }
        })
        timer2 = Timer.scheduledTimer(withTimeInterval: TimeInterval(5 / difficulty), repeats: true) { (timer) in // timer for create cars
            if self.moving {
                self.arrayCarsPassing.removeAll{$0.frame.origin.y > self.view.frame.height}
                self.arrayCarsOncoming.removeAll{$0.frame.origin.y > self.view.frame.height}
                self.createPasssingCar()
                self.createOncomingCar()
            } else {
                self.timer2.invalidate()
            }
        }
        timer3 = Timer.scheduledTimer(withTimeInterval: TimeInterval(1/(difficulty/1.3)), repeats: true) { (_) in
            if self.moving {
                self.distans += 10
                self.label.text = String(Int(
                    self.distans))+"m"
                
                switch self.distans {
                case 100:
                    self.difficulty += 0.5
                    self.endTimer()
                    self.activateTimers()
                case 500:
                    self.difficulty += 0.5
                    self.endTimer()
                    self.activateTimers()
                case 1000:
                    self.difficulty += 0.5
                    self.endTimer()
                    self.activateTimers()
                case 1500:
                    self.difficulty += 0.5
                    self.endTimer()
                    self.activateTimers()
                case 2000:
                    self.difficulty += 0.5
                    self.endTimer()
                    self.activateTimers()
                default:
                    break
                }
                
            } else {
                self.timer3.invalidate()
            }
        }
    }
    
    private func endTimer(){
        timer1.invalidate()
        timer2.invalidate()
        timer3.invalidate()
    }
    
    private func createMyCar(){
        myCar = UIImageView()
        myCar.frame = CGRect(x: view.frame.width / 2 + 15, y: view.frame.height + 100, width: 50, height: 80)
        let image = UIImage(named: self.gamer!.nameCar!)
        myCar.image = image
        myCar.cornerRadius(20)
        viewMyCar.addSubview(myCar)
        moveMyCar()
    }
    
    private func createPasssingCar() {
        let car = UIImageView()
        let x1 = road3.frame.origin.x + 10
        let x2 = road4.frame.origin.x + 10
        let arrayX: [CGFloat] = [x1, x2]
        let x = Int(arrayX[Int.random(in: 0...1)])
        let y = Int.random(in: 80...150) * -1
        car.frame = CGRect(x: x, y: y, width: 50, height: 80)
        let random = Int.random(in: 0..<self.shared.arrayType.count)
        let image = UIImage(named: self.shared.arrayType[random])
        car.image = image
        car.cornerRadius(15)
        arrayCarsPassing.append(car)
        viewForCar.addSubview(arrayCarsPassing.last!)
    }
    
    private func createOncomingCar() {
        let car = UIImageView()
        let x1 = road1.frame.origin.x + 10
        let x2 = road2.frame.origin.x + 10
        let arrayX: [CGFloat] = [x1, x2]
        let x = Int(arrayX[Int.random(in: 0...1)])
        let y = Int.random(in: 80...150) * -1
        car.frame = CGRect(x: x, y: y, width: 50, height: 80)
        let random = Int.random(in: 0..<self.shared.arrayCarOncoming.count)
        let image = UIImage(named: self.shared.arrayCarOncoming[random])
        car.image = image
        car.cornerRadius(15)
        arrayCarsOncoming.append(car)
        viewForCar.addSubview(arrayCarsOncoming.last!)
    }
    
    private func moveMyCar() {
        UIView.animate(withDuration: 4, animations: {
            self.myCar.frame.origin.y -= 300
        }) { (_) in
            self.timerDown()
            self.moving = true
            self.activateTimers()
            self.addingLabel()
        }
    }
    
    private func moveView() {
        UIView.animate(withDuration: 0.01, animations: {
            self.myView1.frame.origin.y += 2
            self.myView2.frame.origin.y += 2

        }) { (_) in
            
            
            if self.myView1.frame.origin.y > self.view.frame.height {
                self.myView1.frame.origin.y = self.myView2.frame.origin.y - self.myView1.frame.height
            }
            if self.myView2.frame.origin.y > self.view.frame.height {
                self.myView2.frame.origin.y = self.myView1.frame.origin.y - self.myView2.frame.height
            }

        }
    }
    
    private func movePassingCar() {
        UIView.animate(withDuration: 0.1, animations: {
            for element in self.arrayCarsPassing {
                element.frame.origin.y += 1
            }
        })
    }
    
    private func moveOncomingCar() {
        UIView.animate(withDuration: 0, animations: {
            for element in self.arrayCarsOncoming {
                element.frame.origin.y += 3
            }
        })
    }
    
    private func addingLabel() {
        label.frame = CGRect(x: viewForLabel.frame.width / 2 - 25, y: 0, width: 100, height: 20)
        viewForLabel.addSubview(label)
    }
    
    private func radiusig() {
        for i in trees1 {
            i.cornerRadius(30)
        }
        for i in trees2 {
            i.cornerRadius(30)
        }
    }
    
    private func transitionToEndVC() {
        self.delegate?.playing(info: false)
        if Int(self.distans * self.difficulty) > self.gamer!.result {
            self.gamer?.difficulty = self.difficulty
            self.gamer?.distans = self.distans
            self.shared.addGamerToList(gamer: self.gamer!)
            self.shared.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            guard let VC = self.storyboard?.instantiateViewController(identifier: "ResultViewController") as? ResultViewController else {return}
            VC.gamer = self.gamer
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
}

//MARK: - Extention
extension UIImageView {
    func cornerRadius(_ radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
