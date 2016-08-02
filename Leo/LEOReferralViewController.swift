//
//  LEOReferralViewController.swift
//  Leo
//
//  Created by Adam Fanslau on 8/2/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import UIKit
import MessageUI

final class LEOReferralViewController :
    UIViewController,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate {

    let headerText = "Refer a friend"
    let bodyText = "Tell your friends about Leo and invite them to schedule a consult with us. When they sign up they will receive 3 months of membership for free"

    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = headerText
            headerLabel.font = UIFont.leo_ultraLight27()
            headerLabel.textColor = UIColor.leo_gray124()
        }
    }

    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.text = bodyText
            bodyLabel.font = UIFont.leo_regular15()
            bodyLabel.textColor = UIColor.leo_gray124()
            bodyLabel.numberOfLines = 0
        }
    }

    @IBOutlet weak var inviteButtonEmail: UIButton! {
        didSet {
            styleButton(inviteButtonEmail)
            inviteButtonEmail.setTitle("INVITE BY EMAIL", forState: .Normal)
        }
    }

    @IBOutlet weak var inviteButtonText: UIButton! {
        didSet {
            styleButton(inviteButtonText)
            inviteButtonText.setTitle("INVITE BY TEXT MESSAGE", forState: .Normal)
        }
    }

    override func viewWillAppear(animated: Bool) {
        setupNavigationBar()
    }


    // MARK: Button Actions

    @IBAction func inviteButtonEmailAction() {

        guard MFMailComposeViewController.canSendMail() else {
            LEOAlertHelper.alertWithTitle("Oops! We couldn't compose a new email",
                                          message: "Make sure your device is set up to send emails",
                                          handler: nil)
            return
        }

        self.presentViewController(configuredMailComposeViewController(),
                                   animated: true,
                                   completion: nil)
    }

    @IBAction func inviteButtonTextAction() {

        guard MFMessageComposeViewController.canSendText() else {
            LEOAlertHelper.alertWithTitle("Oops! We couldn't compose a new message",
                                          message: "Make sure your device is set up to send text messages",
                                          handler: nil)
            return
        }

        self.presentViewController(configuredMessageComposeViewController(),
                                   animated: true,
                                   completion: nil)
    }


    // MARK: MFMessageComposeViewController

    func configuredMessageComposeViewController() -> MFMessageComposeViewController {

        UINavigationBar.appearance().setBackgroundImage(nil, forBarMetrics: .Default)

        let messageComposerVC = MFMessageComposeViewController()
        messageComposerVC.messageComposeDelegate = self
        messageComposerVC.body = "Insert biz-team approved copy here"

        return messageComposerVC
    }

    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: MFMailComposeViewController

    func configuredMailComposeViewController() -> MFMailComposeViewController {

        UINavigationBar.appearance().setBackgroundImage(nil, forBarMetrics: .Default)

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject("Insert biz-team approved copy here")
        mailComposerVC.setMessageBody("Insert biz-team approved copy here",
                                      isHTML: false)

        return mailComposerVC
    }

    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult,
                                                   error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: Styling

    func styleButton(button: UIButton) {
        LEOStyleHelper.styleButton(button, forFeature: .Settings)
    }

    func setupNavigationBar() {

        navigationController?.navigationBar.setBackgroundImage(UIImage.leo_imageWithColor(UIColor.leo_orangeRed()), forBarMetrics: .Default)
        LEOStyleHelper.styleBackButtonForViewController(self, forFeature: .Settings)
        LEOStyleHelper.styleViewController(self, navigationTitleText: headerText, forFeature: .Settings)
    }
}

