import UIKit

class claimMainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var viewControllerList: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create your view controllers and add them to the list
        let viewController1 = ClaimDetailsFormViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController1")
        let viewController2 = ClaimBeneficiaryDetailsViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController2")
        let viewController3 = ClaimFileUploadViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController3")

        viewControllerList = [viewController1, viewController2, viewController3]

        // Set the data source and delegate
        self.dataSource = self
        self.delegate = self

        // Set the first view controller
        setViewControllers([viewController1], direction: .forward, animated: true, completion: nil)
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            return viewControllerList[previousIndex]
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = currentIndex + 1
        if nextIndex < viewControllerList.count {
            return viewControllerList[nextIndex]
        }

        return nil
    }
}
