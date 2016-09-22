import Foundation
import UIKit

public extension UIBarButtonItem {
    
    /**
     To set an icon, use i.e. `barName.FAIcon = FAType.FAGithub`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: iconSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        title = icon.text
    }
    
    
    /**
     To set an icon, use i.e. `barName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    var FAIcon: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: size)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        
        var text = prefixText
        if let iconText = icon?.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}

public extension UIButton {
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, forState: .Normal)`
     */
    func setFAIcon(_ icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: FAStruct.FontName, size: titleLabel.font.pointSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        titleLabel.font = font!
        setTitle(icon.text, for: state)
    }
    
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, iconSize: 35, forState: .Normal)`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat, forState state: UIControlState) {
        setFAIcon(icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: UIControlState()) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSFontAttributeName, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSFontAttributeName:textFont]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttribute = [NSFontAttributeName:iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        setAttributedTitle(prefixTextAttribured, for: state)
    }
    
    
    func setFATitleColor(_ color: UIColor, forState state: UIControlState = UIControlState()) {
        FontLoader.loadFontIfNeeded()
 
        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedString.length))
       
        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}


public extension UILabel {
    
    /**
     To set an icon, use i.e. `labelName.FAIcon = FAType.FAGithub`
     */
    var FAIcon: FAType? {
        set {
            guard let newValue = newValue else { return }
                FontLoader.loadFontIfNeeded()
                let fontAwesome = UIFont(name: FAStruct.FontName, size: self.font.pointSize)
                assert(font != nil, FAStruct.ErrorAnnounce)
                font = fontAwesome!
                text = newValue.text
        }
        get {
            guard let text = text, let index = FAIcons.index(of: text) else { return nil }
            return FAType(rawValue: index)
        }
    }
    
    /**
     To set an icon, use i.e. `labelName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    func setFAIcon(_ icon: FAType, iconSize: CGFloat) {
        FAIcon = icon
        font = UIFont(name: font.fontName, size: iconSize)
    }
    
    
    func setFAColor(_ color: UIColor) {
        FontLoader.loadFontIfNeeded()
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }
    
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        FontLoader.loadFontIfNeeded()
        
        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSFontAttributeName, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSFontAttributeName : textFont]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? font.pointSize)!
            let iconAttribute = [NSFontAttributeName : iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        attributedText = prefixTextAttribured
    }
    
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {
    
    /**
     Create UIImage from FAType
     */
    public func setFAIconWithName(_ icon: FAType, textColor: UIColor, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        self.image = UIImage(icon: icon, size: frame.size, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {
    
    public func setFAIcon(_ icon: FAType) {
        FontLoader.loadFontIfNeeded()
        image = UIImage(icon: icon, size: CGSize(width: 30, height: 30))
    }
}


public extension UISegmentedControl {
    
    public func setFAIcon(_ icon: FAType, forSegmentAtIndex segment: Int) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: 23)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSFontAttributeName: font!], for: UIControlState())
        setTitle(icon.text, forSegmentAt: segment)
    }
}


public extension UIImage {
    
    public convenience init(icon: FAType, size: CGSize, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: FAStruct.FontName, size: fontSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        let attributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }
}


public extension UISlider {
    
    func setFAMaximumValueImage(_ icon: FAType, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25))
    }
    
    
    func setFAMinimumValueImage(_ icon: FAType, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25))
    }
}


public extension UIViewController {
    var FATitle: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font!]
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }
}


private struct FAStruct {
    
    static let FontName = "FontAwesome"
    static let ErrorAnnounce = "****** FONT AWESOME SWIFT - FontAwesome font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"
}


private class FontLoader {
    
    private static var __once: () = {
        let bundle = Bundle(for: FontLoader.self)
        var fontURL:URL?
        let identifier = bundle.bundleIdentifier
        
        if identifier?.hasPrefix("org.cocoapods") == true {
            
            fontURL = bundle.url(forResource: FAStruct.FontName, withExtension: "ttf", subdirectory: "Font-Awesome-Swift.bundle")
        } else {
            
            fontURL = bundle.url(forResource: FAStruct.FontName, withExtension: "ttf")
        }
        let data = try! Data(contentsOf: fontURL!)
        
        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }()
    
    struct Static {
        static var onceToken : Int = 0
    }
    
    static func loadFontIfNeeded() {
        if (UIFont.fontNames(forFamilyName: FAStruct.FontName).count == 0) {
            
            _ = FontLoader.__once
        }
    }
}


/**
 List of all icons in Font Awesome
 */
public enum FAType: Int {
    
    static var count: Int {
        
        return FAIcons.count
    }
    
    
    var text: String? {
        
        return FAIcons[rawValue]
    }
    
	case faGlass, faMusic, faSearch, faEnvelopeO, faHeart, faStar, faStarO, faUser, faFilm, faThLarge, faTh, faThList, faCheck, faTimes, faRemove, faClose, faSearchPlus, faSearchMinus, faPowerOff, faSignal, faCog, faGear, faTrashO, faHome, faFileO, faClockO, faRoad, faDownload, faArrowCircleODown, faArrowCircleOUp, faInbox, faPlayCircleO, faRepeat, faRotateRight, faRefresh, faListAlt, faLock, faFlag, faHeadphones, faVolumeOff, faVolumeDown, faVolumeUp, faQrcode, faBarcode, faTag, faTags, faBook, faBookmark, faPrint, faCamera, faFont, faBold, faItalic, faTextHeight, faTextWidth, faAlignLeft, faAlignCenter, faAlignRight, faAlignJustify, faList, faOutdent, faDedent, faIndent, faVideoCamera, faPictureO, faPhoto, faImage, faPencil, faMapMarker, faAdjust, faTint, faPencilSquareO, faEdit, faShareSquareO, faCheckSquareO, faArrows, faStepBackward, faFastBackward, faBackward, faPlay, faPause, faStop, faForward, faFastForward, faStepForward, faEject, faChevronLeft, faChevronRight, faPlusCircle, faMinusCircle, faTimesCircle, faCheckCircle, faQuestionCircle, faInfoCircle, faCrosshairs, faTimesCircleO, faCheckCircleO, faBan, faArrowLeft, faArrowRight, faArrowUp, faArrowDown, faShare, faMailForward, faExpand, faCompress, faPlus, faMinus, faAsterisk, faExclamationCircle, faGift, faLeaf, faFire, faEye, faEyeSlash, faExclamationTriangle, faWarning, faPlane, faCalendar, faRandom, faComment, faMagnet, faChevronUp, faChevronDown, faRetweet, faShoppingCart, faFolder, faFolderOpen, faArrowsV, faArrowsH, faBarChart, faBarChartO, faTwitterSquare, faFacebookSquare, faCameraRetro, faKey, faCogs, faGears, faComments, faThumbsOUp, faThumbsODown, faStarHalf, faHeartO, faSignOut, faLinkedinSquare, faThumbTack, faExternalLink, faSignIn, faTrophy, faGithubSquare, faUpload, faLemonO, faPhone, faSquareO, faBookmarkO, faPhoneSquare, faTwitter, faFacebook, faFacebookF, faGithub, faUnlock, faCreditCard, faRss, faFeed, faHddO, faBullhorn, faBell, faCertificate, faHandORight, faHandOLeft, faHandOUp, faHandODown, faArrowCircleLeft, faArrowCircleRight, faArrowCircleUp, faArrowCircleDown, faGlobe, faWrench, faTasks, faFilter, faBriefcase, faArrowsAlt, faUsers, faGroup, faLink, faChain, faCloud, faFlask, faScissors, faCut, faFilesO, faCopy, faPaperclip, faFloppyO, faSave, faSquare, faBars, faNavicon, faReorder, faListUl, faListOl, faStrikethrough, faUnderline, faTable, faMagic, faTruck, faPinterest, faPinterestSquare, faGooglePlusSquare, faGooglePlus, faMoney, faCaretDown, faCaretUp, faCaretLeft, faCaretRight, faColumns, faSort, faUnsorted, faSortDesc, faSortDown, faSortAsc, faSortUp, faEnvelope, faLinkedin, faUndo, faRotateLeft, faGavel, faLegal, faTachometer, faDashboard, faCommentO, faCommentsO, faBolt, faFlash, faSitemap, faUmbrella, faClipboard, faPaste, faLightbulbO, faExchange, faCloudDownload, faCloudUpload, faUserMd, faStethoscope, faSuitcase, faBellO, faCoffee, faCutlery, faFileTextO, faBuildingO, faHospitalO, faAmbulance, faMedkit, faFighterJet, faBeer, fahSquare, faPlusSquare, faAngleDoubleLeft, faAngleDoubleRight, faAngleDoubleUp, faAngleDoubleDown, faAngleLeft, faAngleRight, faAngleUp, faAngleDown, faDesktop, faLaptop, faTablet, faMobile, faMobilePhone, faCircleO, faQuoteLeft, faQuoteRight, faSpinner, faCircle, faReply, faMailReply, faGithubAlt, faFolderO, faFolderOpenO, faSmileO, faFrownO, faMehO, faGamepad, faKeyboardO, faFlagO, faFlagCheckered, faTerminal, faCode, faReplyAll, faMailReplyAll, faStarHalfO, faStarHalfEmpty, faStarHalfFull, faLocationArrow, faCrop, faCodeFork, faChainBroken, faUnlink, faQuestion, faInfo, faExclamation, faSuperscript, faSubscript, faEraser, faPuzzlePiece, faMicrophone, faMicrophoneSlash, faShield, faCalendarO, faFireExtinguisher, faRocket, faMaxcdn, faChevronCircleLeft, faChevronCircleRight, faChevronCircleUp, faChevronCircleDown, faHtml5, faCss3, faAnchor, faUnlockAlt, faBullseye, faEllipsisH, faEllipsisV, faRssSquare, faPlayCircle, faTicket, faMinusSquare, faMinusSquareO, faLevelUp, faLevelDown, faCheckSquare, faPencilSquare, faExternalLinkSquare, faShareSquare, faCompass, faCaretSquareODown, faToggleDown, faCaretSquareOUp, faToggleUp, faCaretSquareORight, faToggleRight, faEur, faEuro, faGbp, faUsd, faDollar, faInr, faRupee, faJpy, faCny, faRmb, faYen, faRub, faRuble, faRouble, faKrw, faWon, faBtc, faBitcoin, faFile, faFileText, faSortAlphaAsc, faSortAlphaDesc, faSortAmountAsc, faSortAmountDesc, faSortNumericAsc, faSortNumericDesc, faThumbsUp, faThumbsDown, faYoutubeSquare, faYoutube, faXing, faXingSquare, faYoutubePlay, faDropbox, faStackOverflow, faInstagram, faFlickr, faAdn, faBitbucket, faBitbucketSquare, faTumblr, faTumblrSquare, faLongArrowDown, faLongArrowUp, faLongArrowLeft, faLongArrowRight, faApple, faWindows, faAndroid, faLinux, faDribbble, faSkype, faFoursquare, faTrello, faFemale, faMale, faGratipay, faGittip, faSunO, faMoonO, faArchive, faBug, faVk, faWeibo, faRenren, faPagelines, faStackExchange, faArrowCircleORight, faArrowCircleOLeft, faCaretSquareOLeft, faToggleLeft, faDotCircleO, faWheelchair, faVimeoSquare, faTry, faTurkishLira, faPlusSquareO, faSpaceShuttle, faSlack, faEnvelopeSquare, faWordpress, faOpenid, faUniversity, faInstitution, faBank, faGraduationCap, faMortarBoard, faYahoo, faGoogle, faReddit, faRedditSquare, faStumbleuponCircle, faStumbleupon, faDelicious, faDigg, faPiedPiperPp, faPiedPiperAlt, faDrupal, faJoomla, faLanguage, faFax, faBuilding, faChild, faPaw, faSpoon, faCube, faCubes, faBehance, faBehanceSquare, faSteam, faSteamSquare, faRecycle, faCar, faAutomobile, faTaxi, faCab, faTree, faSpotify, faDeviantart, faSoundcloud, faDatabase, faFilePdfO, faFileWordO, faFileExcelO, faFilePowerpointO, faFileImageO, faFilePhotoO, faFilePictureO, faFileArchiveO, faFileZipO, faFileAudioO, faFileSoundO, faFileVideoO, faFileMovieO, faFileCodeO, faVine, faCodepen, faJsfiddle, faLifeRing, faLifeBouy, faLifeBuoy, faLifeSaver, faSupport, faCircleONotch, faRebel, faRa, faResistance, faEmpire, faGe, faGitSquare, faGit, faHackerNews, fayCombinatorSquare, faYcSquare, faTencentWeibo, faQq, faWeixin, faWechat, faPaperPlane, faSend, faPaperPlaneO, faSendO, faHistory, faCircleThin, faHeader, faParagraph, faSliders, faShareAlt, faShareAltSquare, faBomb, faFutbolO, faSoccerBallO, faTty, faBinoculars, faPlug, faSlideshare, faTwitch, faYelp, faNewspaperO, faWifi, faCalculator, faPaypal, faGoogleWallet, faCcVisa, faCcMastercard, faCcDiscover, faCcAmex, faCcPaypal, faCcStripe, faBellSlash, faBellSlashO, faTrash, faCopyright, faAt, faEyedropper, faPaintBrush, faBirthdayCake, faAreaChart, faPieChart, faLineChart, faLastfm, faLastfmSquare, faToggleOff, faToggleOn, faBicycle, faBus, faIoxhost, faAngellist, faCc, faIls, faShekel, faSheqel, faMeanpath, faBuysellads, faConnectdevelop, faDashcube, faForumbee, faLeanpub, faSellsy, faShirtsinbulk, faSimplybuilt, faSkyatlas, faCartPlus, faCartArrowDown, faDiamond, faShip, faUserSecret, faMotorcycle, faStreetView, faHeartbeat, faVenus, faMars, faMercury, faTransgender, faIntersex, faTransgenderAlt, faVenusDouble, faMarsDouble, faVenusMars, faMarsStroke, faMarsStrokeV, faMarsStrokeH, faNeuter, faGenderless, faFacebookOfficial, faPinterestP, faWhatsapp, faServer, faUserPlus, faUserTimes, faBed, faHotel, faViacoin, faTrain, faSubway, faMedium, fayCombinator, faYc, faOptinMonster, faOpencart, faExpeditedssl, faBatteryFull, faBattery4, faBatteryThreeQuarters, faBattery3, faBatteryHalf, faBattery2, faBatteryQuarter, faBattery1, faBatteryEmpty, faBattery0, faMousePointer, faiCursor, faObjectGroup, faObjectUngroup, faStickyNote, faStickyNoteO, faCcJcb, faCcDinersClub, faClone, faBalanceScale, faHourglassO, faHourglassStart, faHourglass1, faHourglassHalf, faHourglass2, faHourglassEnd, faHourglass3, faHourglass, faHandRockO, faHandGrabO, faHandPaperO, faHandStopO, faHandScissorsO, faHandLizardO, faHandSpockO, faHandPointerO, faHandPeaceO, faTrademark, faRegistered, faCreativeCommons, faGg, faGgCircle, faTripadvisor, faOdnoklassniki, faOdnoklassnikiSquare, faGetPocket, faWikipediaW, faSafari, faChrome, faFirefox, faOpera, faInternetExplorer, faTelevision, faTv, faContao, fa500px, faAmazon, faCalendarPlusO, faCalendarMinusO, faCalendarTimesO, faCalendarCheckO, faIndustry, faMapPin, faMapSigns, faMapO, faMap, faCommenting, faCommentingO, faHouzz, faVimeo, faBlackTie, faFonticons, faRedditAlien, faEdge, faCreditCardAlt, faCodiepie, faModx, faFortAwesome, faUsb, faProductHunt, faMixcloud, faScribd, faPauseCircle, faPauseCircleO, faStopCircle, faStopCircleO, faShoppingBag, faShoppingBasket, faHashtag, faBluetooth, faBluetoothB, faPercent, faGitlab, faWpbeginner, faWpforms, faEnvira, faUniversalAccess, faWheelchairAlt, faQuestionCircleO, faBlind, faAudioDescription, faVolumeControlPhone, faBraille, faAssistiveListeningSystems, faAmericanSignLanguageInterpreting, faAslInterpreting, faDeaf, faDeafness, faHardOfHearing, faGlide, faGlideG, faSignLanguage, faSigning, faLowVision, faViadeo, faViadeoSquare, faSnapchat, faSnapchatGhost, faSnapchatSquare, faPiedPiper, faFirstOrder, faYoast, faThemeisle, faGooglePlusOfficial, faGooglePlusCircle, faFontAwesome, faFa
	
}

private let FAIcons = ["\u{f000}", "\u{f001}", "\u{f002}", "\u{f003}", "\u{f004}", "\u{f005}", "\u{f006}", "\u{f007}", "\u{f008}", "\u{f009}", "\u{f00a}", "\u{f00b}", "\u{f00c}", "\u{f00d}", "\u{f00d}", "\u{f00d}", "\u{f00e}", "\u{f010}", "\u{f011}", "\u{f012}", "\u{f013}", "\u{f013}", "\u{f014}", "\u{f015}", "\u{f016}", "\u{f017}", "\u{f018}", "\u{f019}", "\u{f01a}", "\u{f01b}", "\u{f01c}", "\u{f01d}", "\u{f01e}", "\u{f01e}", "\u{f021}", "\u{f022}", "\u{f023}", "\u{f024}", "\u{f025}", "\u{f026}", "\u{f027}", "\u{f028}", "\u{f029}", "\u{f02a}", "\u{f02b}", "\u{f02c}", "\u{f02d}", "\u{f02e}", "\u{f02f}", "\u{f030}", "\u{f031}", "\u{f032}", "\u{f033}", "\u{f034}", "\u{f035}", "\u{f036}", "\u{f037}", "\u{f038}", "\u{f039}", "\u{f03a}", "\u{f03b}", "\u{f03b}", "\u{f03c}", "\u{f03d}", "\u{f03e}", "\u{f03e}", "\u{f03e}", "\u{f040}", "\u{f041}", "\u{f042}", "\u{f043}", "\u{f044}", "\u{f044}", "\u{f045}", "\u{f046}", "\u{f047}", "\u{f048}", "\u{f049}", "\u{f04a}", "\u{f04b}", "\u{f04c}", "\u{f04d}", "\u{f04e}", "\u{f050}", "\u{f051}", "\u{f052}", "\u{f053}", "\u{f054}", "\u{f055}", "\u{f056}", "\u{f057}", "\u{f058}", "\u{f059}", "\u{f05a}", "\u{f05b}", "\u{f05c}", "\u{f05d}", "\u{f05e}", "\u{f060}", "\u{f061}", "\u{f062}", "\u{f063}", "\u{f064}", "\u{f064}", "\u{f065}", "\u{f066}", "\u{f067}", "\u{f068}", "\u{f069}", "\u{f06a}", "\u{f06b}", "\u{f06c}", "\u{f06d}", "\u{f06e}", "\u{f070}", "\u{f071}", "\u{f071}", "\u{f072}", "\u{f073}", "\u{f074}", "\u{f075}", "\u{f076}", "\u{f077}", "\u{f078}", "\u{f079}", "\u{f07a}", "\u{f07b}", "\u{f07c}", "\u{f07d}", "\u{f07e}", "\u{f080}", "\u{f080}", "\u{f081}", "\u{f082}", "\u{f083}", "\u{f084}", "\u{f085}", "\u{f085}", "\u{f086}", "\u{f087}", "\u{f088}", "\u{f089}", "\u{f08a}", "\u{f08b}", "\u{f08c}", "\u{f08d}", "\u{f08e}", "\u{f090}", "\u{f091}", "\u{f092}", "\u{f093}", "\u{f094}", "\u{f095}", "\u{f096}", "\u{f097}", "\u{f098}", "\u{f099}", "\u{f09a}", "\u{f09a}", "\u{f09b}", "\u{f09c}", "\u{f09d}", "\u{f09e}", "\u{f09e}", "\u{f0a0}", "\u{f0a1}", "\u{f0f3}", "\u{f0a3}", "\u{f0a4}", "\u{f0a5}", "\u{f0a6}", "\u{f0a7}", "\u{f0a8}", "\u{f0a9}", "\u{f0aa}", "\u{f0ab}", "\u{f0ac}", "\u{f0ad}", "\u{f0ae}", "\u{f0b0}", "\u{f0b1}", "\u{f0b2}", "\u{f0c0}", "\u{f0c0}", "\u{f0c1}", "\u{f0c1}", "\u{f0c2}", "\u{f0c3}", "\u{f0c4}", "\u{f0c4}", "\u{f0c5}", "\u{f0c5}", "\u{f0c6}", "\u{f0c7}", "\u{f0c7}", "\u{f0c8}", "\u{f0c9}", "\u{f0c9}", "\u{f0c9}", "\u{f0ca}", "\u{f0cb}", "\u{f0cc}", "\u{f0cd}", "\u{f0ce}", "\u{f0d0}", "\u{f0d1}", "\u{f0d2}", "\u{f0d3}", "\u{f0d4}", "\u{f0d5}", "\u{f0d6}", "\u{f0d7}", "\u{f0d8}", "\u{f0d9}", "\u{f0da}", "\u{f0db}", "\u{f0dc}", "\u{f0dc}", "\u{f0dd}", "\u{f0dd}", "\u{f0de}", "\u{f0de}", "\u{f0e0}", "\u{f0e1}", "\u{f0e2}", "\u{f0e2}", "\u{f0e3}", "\u{f0e3}", "\u{f0e4}", "\u{f0e4}", "\u{f0e5}", "\u{f0e6}", "\u{f0e7}", "\u{f0e7}", "\u{f0e8}", "\u{f0e9}", "\u{f0ea}", "\u{f0ea}", "\u{f0eb}", "\u{f0ec}", "\u{f0ed}", "\u{f0ee}", "\u{f0f0}", "\u{f0f1}", "\u{f0f2}", "\u{f0a2}", "\u{f0f4}", "\u{f0f5}", "\u{f0f6}", "\u{f0f7}", "\u{f0f8}", "\u{f0f9}", "\u{f0fa}", "\u{f0fb}", "\u{f0fc}", "\u{f0fd}", "\u{f0fe}", "\u{f100}", "\u{f101}", "\u{f102}", "\u{f103}", "\u{f104}", "\u{f105}", "\u{f106}", "\u{f107}", "\u{f108}", "\u{f109}", "\u{f10a}", "\u{f10b}", "\u{f10b}", "\u{f10c}", "\u{f10d}", "\u{f10e}", "\u{f110}", "\u{f111}", "\u{f112}", "\u{f112}", "\u{f113}", "\u{f114}", "\u{f115}", "\u{f118}", "\u{f119}", "\u{f11a}", "\u{f11b}", "\u{f11c}", "\u{f11d}", "\u{f11e}", "\u{f120}", "\u{f121}", "\u{f122}", "\u{f122}", "\u{f123}", "\u{f123}", "\u{f123}", "\u{f124}", "\u{f125}", "\u{f126}", "\u{f127}", "\u{f127}", "\u{f128}", "\u{f129}", "\u{f12a}", "\u{f12b}", "\u{f12c}", "\u{f12d}", "\u{f12e}", "\u{f130}", "\u{f131}", "\u{f132}", "\u{f133}", "\u{f134}", "\u{f135}", "\u{f136}", "\u{f137}", "\u{f138}", "\u{f139}", "\u{f13a}", "\u{f13b}", "\u{f13c}", "\u{f13d}", "\u{f13e}", "\u{f140}", "\u{f141}", "\u{f142}", "\u{f143}", "\u{f144}", "\u{f145}", "\u{f146}", "\u{f147}", "\u{f148}", "\u{f149}", "\u{f14a}", "\u{f14b}", "\u{f14c}", "\u{f14d}", "\u{f14e}", "\u{f150}", "\u{f150}", "\u{f151}", "\u{f151}", "\u{f152}", "\u{f152}", "\u{f153}", "\u{f153}", "\u{f154}", "\u{f155}", "\u{f155}", "\u{f156}", "\u{f156}", "\u{f157}", "\u{f157}", "\u{f157}", "\u{f157}", "\u{f158}", "\u{f158}", "\u{f158}", "\u{f159}", "\u{f159}", "\u{f15a}", "\u{f15a}", "\u{f15b}", "\u{f15c}", "\u{f15d}", "\u{f15e}", "\u{f160}", "\u{f161}", "\u{f162}", "\u{f163}", "\u{f164}", "\u{f165}", "\u{f166}", "\u{f167}", "\u{f168}", "\u{f169}", "\u{f16a}", "\u{f16b}", "\u{f16c}", "\u{f16d}", "\u{f16e}", "\u{f170}", "\u{f171}", "\u{f172}", "\u{f173}", "\u{f174}", "\u{f175}", "\u{f176}", "\u{f177}", "\u{f178}", "\u{f179}", "\u{f17a}", "\u{f17b}", "\u{f17c}", "\u{f17d}", "\u{f17e}", "\u{f180}", "\u{f181}", "\u{f182}", "\u{f183}", "\u{f184}", "\u{f184}", "\u{f185}", "\u{f186}", "\u{f187}", "\u{f188}", "\u{f189}", "\u{f18a}", "\u{f18b}", "\u{f18c}", "\u{f18d}", "\u{f18e}", "\u{f190}", "\u{f191}", "\u{f191}", "\u{f192}", "\u{f193}", "\u{f194}", "\u{f195}", "\u{f195}", "\u{f196}", "\u{f197}", "\u{f198}", "\u{f199}", "\u{f19a}", "\u{f19b}", "\u{f19c}", "\u{f19c}", "\u{f19c}", "\u{f19d}", "\u{f19d}", "\u{f19e}", "\u{f1a0}", "\u{f1a1}", "\u{f1a2}", "\u{f1a3}", "\u{f1a4}", "\u{f1a5}", "\u{f1a6}", "\u{f1a7}", "\u{f1a8}", "\u{f1a9}", "\u{f1aa}", "\u{f1ab}", "\u{f1ac}", "\u{f1ad}", "\u{f1ae}", "\u{f1b0}", "\u{f1b1}", "\u{f1b2}", "\u{f1b3}", "\u{f1b4}", "\u{f1b5}", "\u{f1b6}", "\u{f1b7}", "\u{f1b8}", "\u{f1b9}", "\u{f1b9}", "\u{f1ba}", "\u{f1ba}", "\u{f1bb}", "\u{f1bc}", "\u{f1bd}", "\u{f1be}", "\u{f1c0}", "\u{f1c1}", "\u{f1c2}", "\u{f1c3}", "\u{f1c4}", "\u{f1c5}", "\u{f1c5}", "\u{f1c5}", "\u{f1c6}", "\u{f1c6}", "\u{f1c7}", "\u{f1c7}", "\u{f1c8}", "\u{f1c8}", "\u{f1c9}", "\u{f1ca}", "\u{f1cb}", "\u{f1cc}", "\u{f1cd}", "\u{f1cd}", "\u{f1cd}", "\u{f1cd}", "\u{f1cd}", "\u{f1ce}", "\u{f1d0}", "\u{f1d0}", "\u{f1d0}", "\u{f1d1}", "\u{f1d1}", "\u{f1d2}", "\u{f1d3}", "\u{f1d4}", "\u{f1d4}", "\u{f1d4}", "\u{f1d5}", "\u{f1d6}", "\u{f1d7}", "\u{f1d7}", "\u{f1d8}", "\u{f1d8}", "\u{f1d9}", "\u{f1d9}", "\u{f1da}", "\u{f1db}", "\u{f1dc}", "\u{f1dd}", "\u{f1de}", "\u{f1e0}", "\u{f1e1}", "\u{f1e2}", "\u{f1e3}", "\u{f1e3}", "\u{f1e4}", "\u{f1e5}", "\u{f1e6}", "\u{f1e7}", "\u{f1e8}", "\u{f1e9}", "\u{f1ea}", "\u{f1eb}", "\u{f1ec}", "\u{f1ed}", "\u{f1ee}", "\u{f1f0}", "\u{f1f1}", "\u{f1f2}", "\u{f1f3}", "\u{f1f4}", "\u{f1f5}", "\u{f1f6}", "\u{f1f7}", "\u{f1f8}", "\u{f1f9}", "\u{f1fa}", "\u{f1fb}", "\u{f1fc}", "\u{f1fd}", "\u{f1fe}", "\u{f200}", "\u{f201}", "\u{f202}", "\u{f203}", "\u{f204}", "\u{f205}", "\u{f206}", "\u{f207}", "\u{f208}", "\u{f209}", "\u{f20a}", "\u{f20b}", "\u{f20b}", "\u{f20b}", "\u{f20c}", "\u{f20d}", "\u{f20e}", "\u{f210}", "\u{f211}", "\u{f212}", "\u{f213}", "\u{f214}", "\u{f215}", "\u{f216}", "\u{f217}", "\u{f218}", "\u{f219}", "\u{f21a}", "\u{f21b}", "\u{f21c}", "\u{f21d}", "\u{f21e}", "\u{f221}", "\u{f222}", "\u{f223}", "\u{f224}", "\u{f224}", "\u{f225}", "\u{f226}", "\u{f227}", "\u{f228}", "\u{f229}", "\u{f22a}", "\u{f22b}", "\u{f22c}", "\u{f22d}", "\u{f230}", "\u{f231}", "\u{f232}", "\u{f233}", "\u{f234}", "\u{f235}", "\u{f236}", "\u{f236}", "\u{f237}", "\u{f238}", "\u{f239}", "\u{f23a}", "\u{f23b}", "\u{f23b}", "\u{f23c}", "\u{f23d}", "\u{f23e}", "\u{f240}", "\u{f240}", "\u{f241}", "\u{f241}", "\u{f242}", "\u{f242}", "\u{f243}", "\u{f243}", "\u{f244}", "\u{f244}", "\u{f245}", "\u{f246}", "\u{f247}", "\u{f248}", "\u{f249}", "\u{f24a}", "\u{f24b}", "\u{f24c}", "\u{f24d}", "\u{f24e}", "\u{f250}", "\u{f251}", "\u{f251}", "\u{f252}", "\u{f252}", "\u{f253}", "\u{f253}", "\u{f254}", "\u{f255}", "\u{f255}", "\u{f256}", "\u{f256}", "\u{f257}", "\u{f258}", "\u{f259}", "\u{f25a}", "\u{f25b}", "\u{f25c}", "\u{f25d}", "\u{f25e}", "\u{f260}", "\u{f261}", "\u{f262}", "\u{f263}", "\u{f264}", "\u{f265}", "\u{f266}", "\u{f267}", "\u{f268}", "\u{f269}", "\u{f26a}", "\u{f26b}", "\u{f26c}", "\u{f26c}", "\u{f26d}", "\u{f26e}", "\u{f270}", "\u{f271}", "\u{f272}", "\u{f273}", "\u{f274}", "\u{f275}", "\u{f276}", "\u{f277}", "\u{f278}", "\u{f279}", "\u{f27a}", "\u{f27b}", "\u{f27c}", "\u{f27d}", "\u{f27e}", "\u{f280}", "\u{f281}", "\u{f282}", "\u{f283}", "\u{f284}", "\u{f285}", "\u{f286}", "\u{f287}", "\u{f288}", "\u{f289}", "\u{f28a}", "\u{f28b}", "\u{f28c}", "\u{f28d}", "\u{f28e}", "\u{f290}", "\u{f291}", "\u{f292}", "\u{f293}", "\u{f294}", "\u{f295}", "\u{f296}", "\u{f297}", "\u{f298}", "\u{f299}", "\u{f29a}", "\u{f29b}", "\u{f29c}", "\u{f29d}", "\u{f29e}", "\u{f2a0}", "\u{f2a1}", "\u{f2a2}", "\u{f2a3}", "\u{f2a3}", "\u{f2a4}", "\u{f2a4}", "\u{f2a4}", "\u{f2a5}", "\u{f2a6}", "\u{f2a7}", "\u{f2a7}", "\u{f2a8}", "\u{f2a9}", "\u{f2aa}", "\u{f2ab}", "\u{f2ac}", "\u{f2ad}", "\u{f2ae}", "\u{f2b0}", "\u{f2b1}", "\u{f2b2}", "\u{f2b3}", "\u{f2b3}", "\u{f2b4}", "\u{f2b4}"]
