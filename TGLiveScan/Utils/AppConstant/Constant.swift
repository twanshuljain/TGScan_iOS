//
//  Secens.swift
//  TicketGateway
//
//  Created by Apple  on 13/04/23.


import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
    case home = "Home"
    case sidemenu = "SideMenu"
    case costumes =  "Costume"
    case manageevent = "ManageEvents"
    case scanevent = "ScanEvents"
    case wallet = "Wallet"
    case order = "Order"
    case profile = "Profile"
    case settings = "Settings"
    case manageventorder = "ManageEventOrder"
    case favourites = "Favorites"
}

enum StoryboardIdentifier: String {
    case LoginVC
    case SignUpVC
    case WelComeVC
    case WelcomeLoginSignupVC
    case ForgotPasswordVC
    case OtpNumberVC
    case OtpEmailVC
    case CreateAccountVC
    case VerifyPopupVC
    case LoginNmberWithEmailVC
    
    //Home
    case HomeVC
    case EventSearchHomeVC
    case EventSearchLocationVC
    case ViewMoreEventsVC
    case EventBookingTicketVC
    case EventBookingTicketOnApplyCouponVC
    case EventPromoCodeVC
    case EventMapVC
    case EventBookingTicketAddOnsVC
    case EventBookingOrderSummaryVC
    case EventBookingPaymentMethodVC
    case PaymentSuccessFullVC
    case PhoneVerificationViewController
    case EmailSentVC
    case EventCheckoutVerifyVC
    case CardListVC
    
    //SideMenuBar
    case AddAmountWalletVC
    case AmountAddedSuccessfullyVC
    case Organizers_Artists_ListVC
    case MyFollowersVC
    case VenueVC
    case EventDetailVC
    case MyWalletVC
    case MyRefundVC
    case CostumeViewController
    case DeviceSettingVC
    case Reward_LoyaltyPointsVC
    case NotificationVC
    case FAQVC
    //order
    case MyOrderViewController
    case SegmentCostumeVC
    case MyTicketVC
    case SeeFullTicketVC
    case TransferTicketVC
    case ContinueToTransferVC
    case ExchangeTicketVC
    case OrderSummaryVC
    case ChangeNameVC
    case ContactOrganiserVC
    case RequestRefundVC
    case EventDetailStatusVC
    case FeedbackViewController
    
    //ManageEvent
    //DashBoard
    case ManageEventVC
    case ManageEventDashboardVC
    case ManageEventTicketSoldVC
    case PromoCodeVC
    case ManageSellTicketSuccessfully
    case ManageSellTicketComplimentary
    case AddCardVC
    //sell
    case ManageSellAddBuyerVC
    case ManageSellBuyersInfoListVC
    
    //Check In
      case ManageEventCheckInVC
      case AttendeeDetailsVC
      case ScanQRVC
    
    //Profile/Settings
    case ManageEventSettingVC
    case ManageEventProfileVC
    case SoldOutTicketVC
    case CancelThisEventVC
    case ZoomViewController
    case ManageEventEditProfileVC
    //order
    case ManageEventOrderDeatilVC
    case RefundOptionsVC
    case ReviewRefundVC
    //Favourites
    case FavouriteVC
    
    //ScanEvents
      case ScanEventVC
      case SelectTicketTypeVC
      case ScannerVC
      case SearchVC
      case ScanSummaryVC
      case FindRFIDVC
      case EndScanPoPUpVC
    case WebViewViewController
}

enum PaymentError {
    case noPaymentModelSelected
    case cardholderName
    case cardNumber
    case expiryDate
    case cvv
    case cardNumberLenghtShort
    case nameMinCharactorCount
    case cvvMin
    case cardNumberMaxLength
    

    var value:String {
        switch self {
        case .noPaymentModelSelected:
            return "Please select payment method"
        case .cardholderName:
            return "Please enter cardholder name."
        case .cardNumber:
            return "Please enter card number."
        case .expiryDate:
            return "Please enter expiry date."
        case .cvv:
            return "Please enter cvv."
        case .cardNumberLenghtShort:
            return "Card number should not be less than 16 digits"
        case .nameMinCharactorCount:
            return "Full name contain atleast 3 characters"
        case .cvvMin:
            return "Please enter valid cvv"
        case .cardNumberMaxLength:
            return "Card number should not be more than 16 digits"
        }
    }
    
}


public extension Notification.Name {
     static let didUpdateWorkoutData = Notification.Name(rawValue: "didUpdateWorkoutData")
     static let didStopWorkoutTimer = Notification.Name(rawValue: "didStopWorkoutTimer")
}

//MARK: - String Constant
let GOOGLE_CLIENT_ID = "1090307909671-o90bdqh5777lnkgqk9mugturu85d524g.apps.googleusercontent.com"
let TITLE_LOGIN = "Login"
let TITLE_CONTINUE = "Continue"

let STRIPE_PUBLISH_KEY = "pk_test_WUFLfpw1GDQk1k14iO90JbAx00ujBjHe6m"
let STRIPE_SECRET_KEY = "sk_test_51FlbBdAzj89HkZFlgU9eCHTk9rWlyfu0Y9Q4Nxz8QPE5kirWckckTTK7ZRuBDp4CWMlypBwenC7lMzHZrZKa8aSw00OWLIFgLZ"

let FINISH = "Finish"
let NEXT = "Next"
let OTP_VERIFICATION = "OTP Verification"
let PLEASE_ENTER_OTP = "Please enter otp"
let NETWORK = "Network"
let EMAIL_SENT_SUCCESSFULLY = "Your email has been verified successfully!"
let FORGOT_PASSWORD = "Forgot password"
let EMAIL_LINK_SENT = "Email link has been sent"
let CREATE_ACCOUNT = "Create Account"
let VIEW_MORE_EVENT = "View more events"
let SEE_ALL = "See all"
let ADD_TO_CALENDAR = "Add to Calender"
let SHOW_MAP = "Show Map"
let READ_MORE = "Read More"
let EVENT = "Event"
let FOLLOWING = "Following"
let TICKETS = "Tickets"
let HEADER_TITLE_SUNBURN = "Sunburn reload NYE - toronto"
let HEADER_DESCRIPTION_DATE_TIME = "Saturday, March 18 • 6:00 AM"
let APPLIED = "Applied"
let ADD_ONS = "Add-Ons"
let SKIP = "Skip"
let T_SHIRT =  "T-shirt"
let DOLLAR_PRICE = "$ 0.00"
let PEPSI = "Pepsi"
let POP_DESCRIPTION = "Pepsi cans and bottles available, In the sizes of Large & Medium, Pepsi black and Diet coke,"
let OKAY = "Okay"
let ORDER_SUMMARY = "Order Summary"
let SELECT_PAYMENT_METHOD =  "Select a Payment Method"
let CARD_LIST =  "Card list"
let PAYMENT_SUCCESSFULL = "Payment Successful"
let BROWSE_MORE_EVENT = "Browse more events"
let BROWSE_EVENTS = "Browse events"
let VIEW_MY_TICKETS = "View my Ticket"
let DOWNLOAD_MY_TICKETS = "Download my Ticket"
let GO_TO_MY_ACCOUNT = "Go to my account"
let NEED_HELP_CONTACT_US = "Need Help? Contact Us"
let NEED_HELP_CHECK_FAQs = "Need Help? Check FAQs"
let FIND_EVENT_IN = "Find events in..."
let SHOW_RESULT = "Show Results"
let RESET = "Reset"
let MY_ORDERS = "My Orders"
let MY_TICKETS = "My Tickets"
let TRANSFER_TICKETS = "Transfer Tickets"
let TRANSFER_TICKET_ALERT = "Are you sure to transfer ticket to "
let TRANSFER_TICKET_ALERT1 = "Your transferred ticket won't be visible"
let NUMBERS = "#3246431341"
let TICKET_TRANSFERRED = "Ticket Transferred"
let ENTER_DETAIL_TITLE = "Enter Details"
let EMAIL_ADDRESS = "Email"
let ORGANIZERS_EMAIL_ADDRESS = "Organizer’s Email "
let ORGANIZERS_NAME = "Organizer’s Email "
let CONFIRM_EMAIL_ADDRESS = "Confirm Email Address "
let EXCHANGE_FOR = "Exchange For"
let EXCHANGE_TICKETS = "Exchange ticket"
let BUTTON_CONTINUE = "Continue CAD$9.90"
let CHANGE_NAME = "Change name"
let FIRST_NAME =  "First Name "
let LAST_NAME =  "Last Name "
let TICKET_NAME_CHANGED = "Ticket Name Changed"
let TICKET_NAME_SUCCESSFULLY_CHANGED = "Your ticket name has been successfully changed."
let CONTACT_ORGANISER = "Contact Organiser"
let NAME = "Name "
let REASON = "Reason "
let DONE = "Done"
let CHANGE_ORGANISER = "Change Orangniser"
let MESSAGE_SUCCESSFULLY_SENT_TO_ORGANISER = "Your message has been succssfully sent to the organiser of this event"
let REQUEST_REFUND = "Request Refund"
let SALE_NUMBER = "Sale #32926471 Mangesh Yahoo"
let REFUND_SUCCESSFULL = "Refund Successfull"
let FAVOURITE = "Favourites"
let BAND_LEADER_PROFILE = "Band leader’s profile"
let DESCRIPTION = "Description"
let SECTION_LEADER = "Section Leader"
let CONTACT_DETAILS =  "Contact Details"
let COSTUME_DETAILS = "Costume Details"
let THE_BAND_TRINI_REVELLARS = "The Band - Rini Revellars"
let COSTUME = "Costume"
let MY_WALLET =  "My Wallet"
let ADD_AMOUNT = "Add Amount"
let IN_TG_WALLET =  "in TG Wallet"
let SUCCESSFUL_ADDED = "Successful Added"
let AMOUNT_ADDED_SUCCESSFULLY = "Amount added Successfully"
let MY_REFUNDS = "My Refunds"
let NOTIFICATIONS =  "Notifications"
let MY_FOLLOWERS = "My Followers"
let ORGANISER = "Organizers"
let TRENDING_ORGANISER = "Trending Organizers"
let SUGGESTED_FOR_YOU = "Suggested for you"
let ARTISTS = "Artists"
let TRENDING_ARTISTS = "Trending Artists"
let REWARDS_LOYALTY_POINTS = "Rewards & Loyalty Points"
let DEVICE_SETTINGS = "Device settings"
let FEEDBACK = "Feedback"
let FAQS = "FAQs"
let VENUE =  "Venue"
let SCANNING_DOES_NOT_SUPPORT = "Your device doesn't support for scanning a QR code. Please use a device with a camera."
let ATTENDEE_DETAILS = "Attendee Details"
let CHECKED_IN = "Checked In"
let CHECK_IN = "Check In"
let APPLY = "Apply"
let PROMO_CODE = "Promo Code"
let PLACE_ORDER = "Place Order"
let BUYESR_INFO = "Buyers Info"
let ADD_MORE_BUYER = "Add more buyers"
let COMPLIMENTRY_APPLIED_SUCCESSFULLY =  "Complimentary applied successfully"
let SHARE = "Share"
let DOWNLOAD = "Download"
let SEND_ANOTHER_COMP = "Send another comp"
let CANCEL = "Cancel"
let SAVE = "Save"
let PREVIOUS = "Previeous"
let BUY_NOW = "Buy Now"
let CARD = "Card"
let CASH = "Cash"
let VIEW_CART = "View Cart"
let ADD_CUSTOMER_INFO = "Add customer info"
let COMPLIMENTRY = "Complimentary"
let PROFILE = "My Profile"
let EDIT_PROFILE = "Edit profile"
let CANCEL_EVENT = "Cancel event?"
let ARE_YOU_SURE_CANCEL_EVENT = "Are you sure you want to cancel this event."
let SAVE_CHANGES = "Save Changes"
let REVIEW_REFUND = "Review Refund"
let REFUND_OPTIONS = "Refund Options"
let SELECT_TICKETS = "Select Tickets "
let ORDER_DETAILS = "Order Details"
let TICKET_SOLD = "Ticket Sold"
let CREATE_EVENT = "Create Event"
let MANAGE = "Manage"
let PHONE_VERIFICATION = "Phone verification"
let ORDER_NO = "Order no."
let SALE = "Sale"
let DATE = "Date"
let TIME = "Time"
let DELIVERY_METHOD = "Delivery Method"
let GENRAL_ADMISSION = "1 x General Admission"
let TOTAL = "Total"
let NOTES = "Notes"
let ATTEENDE = "ATTENDEE - SWIPE TO CHECK IN"
let PAYMENT_METHOD = "Payment Method - Master Card1133"
let REFUND_TO_ORIGINAL = "Refund To Original Payment Method"
let TG_WALLET = "TG Wallet"
let GET_FULL_REFUND = "Get A Full Refund (inclusive Service Fee)"
let REASON_FOR_REFUND = "Reason For Refund"
let FULL_REFUND = "Full Refund"
let BARCODE_WILL_NO_LONGER_VALID = "Barcode will no longer be valid"
let PARTIAL_REFUND = "Partial Refund"
let BARCODE_WILL_REMAIN_VALID = "Barcode will remain valid"
let Total_to_Refund = "Total to Refund"
let Total_Tickets = "Total Tickets"
let REFUND_AMOUNT = "REFUND AMOUNT"
let PROCEED_REFUND = "Proceed Refund"
let TICKET_TYPE = "Ticket Type"
let BARCODE = "Barcode"
let SCAN_TG_QR = "Scan TG QR"
let PLEASE_ALIGN_QR = "Please align the QR within scanner"
let END_SCAN = "End scan?"
let WANT_TO_SCAN_EVENT = "Are you sure you want to end scan for this event."
let SCAN_SUMMARY =  "Scan Summary"
let SCAN = "SCAN"
let FIND_RFID = "FIND RFID"
let SEARCH = "SEARCH"
let SELECT_TICKET_TYPE = "Select ticket Type"
let SOMETHING_WENT_WRONG = "something went wrong please try again"
let WELCOME_DESCRIPTION = "Join the millions who’ve saved on event tickets."
let WELCOME_TITLE = "TicketGateway.com"
let SIGN_IN = "Sign in"
let NEW_HERE = "I'm new here"
let LBL_SIGN_IN = "Sign In"
let LBL_OR_SIGNIN_WITH = "or sign in with"
let EMAIL = "Email"
let MOBILE_NUMBER = "Mobile Number"
let PLEASE_ENTER_YOUR_MOBILE_NUMBER_DDESCRIPTION = "Please enter your mobile number, We will send you a One Time Password on this number"
let DONT_HAVE_AN_ACCOUNT = "Don’t have an account?"
let SIGN_UP = "Sign Up"
let OR_SIGN_UP_WITH = "or sign up with"
let VERIFY_YOUR_EMAIL = "Verify your email before exploring the TG app"
let ALREADY_HAVE_AN_ACCOUNT = "Already have an account?"
let SENT_VERIFICATION_CODE_TO = "We have sent a verification code to"
let AUTO_APPLY = "will apply auto to the field"
let DONT_WORRY = "Don’t worry! it happens, Please enter the Email associated with your account."
let CONFIRM_EMAIL_ALERT = "Please enter valid confirm email"
let Full_Name = "Full Name"
let First_Name = "First Name"
let Last_Name = "Last Name"
let CONFIRM_EMAIL = "Confirm Email"
let PASSWORD = "Password"
let CONFIRM_PASSWORD = "Confirm Password"
let SELECT_THE_EMAIL_ACCOUNT = "Select the email account you want to login"
let TRENDING_BAND_LEADERS = "Trending band leaders"
let Parade_Location = "Parade Location"
let Junior_Carnival = "Junior Carnival"
let Mas_Camp_Location = "Mas Camp Location"
let LBL_MON = "Mon - Fri"
let LBL_SAT = "Sat - Sun"
let Band_Leader = "Band Leader"
let Section_Leader = "Section Leader"
let VIDEOS = "Videos"
let PHOTOS = "Photos"
let SIMILAR_PRODUCT = "Similar Product"
let APPLY_PROMO = "Apply promo code to avail exclusive offer only for you."
let SELECT_SIZE = "Select Size"
let BRA_SIZE = "Bra Size"
let CUP_SIZE = "Cup Size"
let WAIST_SIZE = "Waist Size"
let BOTTOM_SIZE = "Bottom Size"
let HIP_SIZE = "Hip Size"
let PANTY_SIZE = "Panty Size"
let BELT_SIZE = "Belt Size"
let Choose_Payment_Mode = "Choose payment mode"
let TOTAL_BALANCE = "TOTAL BALANCE"
let ADD_AMOUNT_IN_TG_WALLET = "Add amount in TG wallet"
let TRANSACTION = "Transaction"
let This_Weekend =  "This Weekend"
let Online_Events = "Online Events"
let Popular_Events = "Popular Events"
let Free_Events = "Free Events"
let Upcoming_Events = "Upcoming Events"
let Events_Near_Toronto = "Events Near Toronto"
let Unable_To_Like = "Please log in into the app to like the event."
let Unable_To_Follow = "Please log in into the app to follow the organizer."
let Ticket_Resend_Success = "Ticket has been transferred to"
let RecurringDates = "Recurring Dates"
let VIRTUAL = "VIRTUAL"
let MULTIPLE = "MULTIPLE"
let MultipleLocation = "Multi Location"
let VirtualEvent = "Virtual Event"
let Retry_Payment = "Retry Payment"
let Transaction_Failed = "Transaction Failed"
let Thank_You = "Thank You!"
let Go_To_My_Tickets = "Go to my tickets"

//MARK: - IMAGE Constant
let RIGHT_BUTTON_ICON = "rightOnButton"
let X_ICON = "x"
let PROFILE_ICON = "profile"
let PLUS_ICON = "plus"
let SHARE_ICON = "share"
let DOWNLOAD_ICON = "download"
let LEFT_ARROW_ICON = "arrow left"
let RIGHT_ARROW_ICON = "arrow right"
let CREDIT_CARD_ICON = "credit-card"
let DOLLAR_ICON = "dollar-sign"
let MENU_ICON = "Menu"
let SAVE_ICON = "Save"
let EDIT_2_ICON = "edit-2"
let CIRCLE_CHEVRON_UP_ICON = "circlechevronUp_ip"
let CIRCLE_CHEVRON_DOWN_ICON = "circleChevron-down_ip"
let REFUND_ICON = "Refund_ip"
let EVEN_FILTER_ICON = "EventFilter_ip"
let BACK_ARROW_ICON = "backArrow"
let RIGHT_BLUE_ICON = "ri8Blue"
let CHEVRON_UP_GD_ICON = "chevron-upGD_ip"
let CHEVRON_DOWN_DB_ICON = "chevron-downDB_ip"
let UNACTIVE_ICON = "unActive"
let ARROW_UP = "arrow-up"
let ACTIVE_ICON = "active"
let ARROW_DOWN_ICON = "arrow-down"
let CART_ICON = "Cart_ip"
let RADIO_SELECTION_ICON = "radio selection_ip"
let REMOVE_ICON = "Remov_ip"
let UNSELECTED_ICON = "Unselected_ip"
let ADD_ICON = "Add_ip"
let LEFT_ARROW = "LeftArrow_ip"
let CHEVRON_DOWN = "chevron-down_ip"
let FILTER_ICON = "ic-Filter"
let SORT_ICON = "sort_ip"
let IMAGE_ICON = "image"
let IMAGE_UNACTIVE_TERM_ICON = "unactiveTerm"
let IMAGE_ACTIVE_TERM_ICON = "activeTerm"
let UPLOAD_ICON = "upload_ip"
let FILTER_RADIO_INACTIVE = "filter_radio_inactive"
let FILTER_RADIO_ACTIVE = "filter_radio_active"
let BRAND_LEADER_ICON = "img_brand_leader"
let THUMBSUP_SELECTED_ICON = "img_thumbsup_selected"
let THUMBSUP_UNSELECTED_ICON = "img_thumbsup_unselected"
let THUMBSDOWN_SELECTED_ICON = "img_thumbsdown_selected"
let THUMBSDOWN_UNSELECTED_ICON = "img_thumbsdown_unselected"
let EYE_CLOSE = "eyeClose"
let EYE_OPEN = "eyeOpen"
let FAV_SELECT_ICON = "favSele_ip"
let TICKET_BLACK = "ticketBlack"
let POP_ICON = "pop_ip"
let FILTER = "filter"
let MENU_DOT_ICON = "menuDot_ip"
let DOWNLOAD_ICON_ORDER = "download_ip"
let APPLE_WALLET_ICON = "Apple_Wallet_ip"
let CHANGE_ICON = "Change_ip"
let CANCEL_ICON = "x_ip"
let ACTIVE_ICON_SQUARE = "active_ip"
let IMAGE_ICON_ = "image_ip"
let CHECK_CIRCLE_ICON = "check-circle"
let SCAN_ICON = "scan"
let BAR_CHART_ICON = "bar-chart"
let PHOTO_ICON = "photo_ip"
let USER_ICON = "user"
let ARROW_DOWN_WHITE_ICON = "arrow_down_white"
let ARROW_DOWN_BLACK_ICON = "arrow_down_black"
let LIKE_ICON = "Like_ip"
let FAV_UNSELECT_ICON = "favUnSele_ip"
let SCAN_SELECTED_ICON = "ScanSelected_ip"
let SCAN_UNSELECTED_ICON = "ScanUnselect_ip"
let FIND_UNSELECT_ICON = "FindUnselect_ip"
let FIND_SELECTED_ICON = "RFIDselected_ip"
let SEARCH_UNSELECT_ICON = "SearchUnselect_ip"
let SEARCH_SELECTED_ICON = "Searchselected_ip"
let DOWNLOAD_WHITE_ICON = "downloadwhite_ip"
let CHECK_RIGHT_ICON = "checkRi8"
let Name_Not_Nil = "Please Enter Your Name"
let Pin_Not_Nil = "Please Enter PIN"
let Allow_Camera_Permission = "Please allow the camera permission from the settings."
let Right = "Right"
let Wrong = "Wrong"
let SelectTicketMessage = "You need to select atleast one Ticket Type."
let OFFLINE_SCAN = "Offline Scan?"
let OFFLINE_SCAN_DESC = "When you click on offline scanning, we are giving you the ability to be able to scan your tickets at a location that you may not have wifi or 3G service. Please note that once you are finish scanning and to want to update your account, you need to click on update when you have internet access again. \n\n Once you are scanning offline, you will not be able to use multiple device, if you want to use multiple devices, you must first get internet access and then complete your scan."
let OFFLINE_ERROR = "Someone is already downloaded the data for offline scan."
