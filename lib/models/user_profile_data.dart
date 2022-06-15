class User_profile_data {
  int errorCode;
  String errorMessage;
  ProfileResponse response;

  User_profile_data({this.errorCode, this.errorMessage, this.response});

  User_profile_data.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    response = json['Response'] != null
        ? ProfileResponse.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    if (this.response != null) {
      data['ProfileResponse'] = this.response.toJson();
    }
    return data;
  }
}

class ProfileResponse {
  int id;
  int userType;
  String username;
  String businessName;
  String name;
  String email;
  int isVerified;
  String countrycode;
  String mobile;
  String alternateMobile;
  int mobileHidden;
  int kyc;
  int trustedBadge;
  String trustedBadgeApproval;
  int personalDetails;
  int businessDetails;
  int paymentStatus;
  String preferences;
  String address;
  String about;
  String bankName;
  String branchName;
  String ifsc;
  String accountNo;
  String accountType;
  String gstNo;
  String panNo;
  String adhaarNo;
  String gstDoc;
  String panDoc;
  String adhaarDoc;
  String avatarPath;
  String avatarBaseUrl;
  String facebookUrl;
  String twitterUrl;
  String googlePlusUrl;
  String instagramUrl;
  String linkedinUrl;
  String youtubeUrl;
  int otp;
  String otpVerify;
  String website;
  int emailOtp;
  String emailVerify;
  String mobileVerify;
  String authKey;
  String accessToken;
  String passwordHash;
  String keyHash;
  String oauthClient;
  String oauthClientUserId;
  String facebookClinetUserId;
  int status;
  String deviceType;
  String devicetoken;
  String deviceid;
  String quickbloxId;
  String quickbloxUsername;
  String quickbloxEmail;
  String quickbloxPassword;
  String registerFrom;
  String socialToken;
  String socialType;
  String packageId;
  int country;
  int state;
  String city;
  String pincode;
  String currency;
  String adCount;
  String featuredAdCount;
  String newsletter;
  String terms;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int loggedAt;

  ProfileResponse(
      {
        this.id,
        this.userType,
        this.username,
        this.businessName,
        this.name,
        this.email,
        this.isVerified,
        this.countrycode,
        this.mobile,
        this.alternateMobile,
        this.mobileHidden,
        this.kyc,
        this.trustedBadge,
        this.trustedBadgeApproval,
        this.personalDetails,
        this.businessDetails,
        this.paymentStatus,
        this.preferences,
        this.address,
        this.about,
        this.bankName,
        this.branchName,
        this.ifsc,
        this.accountNo,
        this.accountType,
        this.gstNo,
        this.panNo,
        this.adhaarNo,
        this.gstDoc,
        this.panDoc,
        this.adhaarDoc,
        this.avatarPath,
        this.avatarBaseUrl,
        this.facebookUrl,
        this.twitterUrl,
        this.googlePlusUrl,
        this.instagramUrl,
        this.linkedinUrl,
        this.youtubeUrl,
        this.otp,
        this.otpVerify,
        this.website,
        this.emailOtp,
        this.emailVerify,
        this.mobileVerify,
        this.authKey,
        this.accessToken,
        this.passwordHash,
        this.keyHash,
        this.oauthClient,
        this.oauthClientUserId,
        this.facebookClinetUserId,
        this.status,
        this.deviceType,
        this.devicetoken,
        this.deviceid,
        this.quickbloxId,
        this.quickbloxUsername,
        this.quickbloxEmail,
        this.quickbloxPassword,
        this.registerFrom,
        this.socialToken,
        this.socialType,
        this.packageId,
        this.country,
        this.state,
        this.city,
        this.pincode,
        this.currency,
        this.adCount,
        this.featuredAdCount,
        this.newsletter,
        this.terms,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.loggedAt});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    username = json['username'];
    businessName = json['business_name'];
    name = json['name'];
    email = json['email'];
    isVerified = json['is_verified'];
    countrycode = json['countrycode'];
    mobile = json['mobile'];
    alternateMobile = json['alternate_mobile'];
    mobileHidden = json['mobile_hidden'];
    kyc = json['kyc'];
    trustedBadge = json['trusted_badge'];
    trustedBadgeApproval = json['trusted_badge_approval'];
    personalDetails = json['personal_details'];
    businessDetails = json['business_details'];
    paymentStatus = json['payment_status'];
    preferences = json['preferences'];
    address = json['address'];
    about = json['about'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    ifsc = json['ifsc'];
    accountNo = json['account_no'];
    accountType = json['account_type'];
    gstNo = json['gst_no'];
    panNo = json['pan_no'];
    adhaarNo = json['adhaar_no'];
    gstDoc = json['gst_doc'];
    panDoc = json['pan_doc'];
    adhaarDoc = json['adhaar_doc'];
    avatarPath = json['avatar_path'];
    avatarBaseUrl = json['avatar_base_url'];
    facebookUrl = json['facebook_url'];
    twitterUrl = json['twitter_url'];
    googlePlusUrl = json['google_plus_url'];
    instagramUrl = json['instagram_url'];
    linkedinUrl = json['linkedin_url'];
    youtubeUrl = json['youtube_url'];
    otp = json['otp'];
    otpVerify = json['otp_verify'];
    website = json['website'];
    emailOtp = json['email_otp'];
    emailVerify = json['email_verify'];
    mobileVerify = json['mobile_verify'];
    authKey = json['auth_key'];
    accessToken = json['access_token'];
    passwordHash = json['password_hash'];
    keyHash = json['key_hash'];
    oauthClient = json['oauth_client'];
    oauthClientUserId = json['oauth_client_user_id'];
    facebookClinetUserId = json['facebook_clinet_user_id'];
    status = json['status'];
    deviceType = json['device_type'];
    devicetoken = json['devicetoken'];
    deviceid = json['deviceid'];
    quickbloxId = json['quickblox_id'];
    quickbloxUsername = json['quickblox_username'];
    quickbloxEmail = json['quickblox_email'];
    quickbloxPassword = json['quickblox_password'];
    registerFrom = json['register_from'];
    socialToken = json['social_token'];
    socialType = json['social_type'];
    packageId = json['package_id'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    currency = json['currency'];
    adCount = json['ad_count'];
    featuredAdCount = json['featured_ad_count'];
    newsletter = json['newsletter'];
    terms = json['terms'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    loggedAt = json['logged_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    data['business_name'] = this.businessName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['is_verified'] = this.isVerified;
    data['countrycode'] = this.countrycode;
    data['mobile'] = this.mobile;
    data['alternate_mobile'] = this.alternateMobile;
    data['mobile_hidden'] = this.mobileHidden;
    data['kyc'] = this.kyc;
    data['trusted_badge'] = this.trustedBadge;
    data['trusted_badge_approval'] = this.trustedBadgeApproval;
    data['personal_details'] = this.personalDetails;
    data['business_details'] = this.businessDetails;
    data['payment_status'] = this.paymentStatus;
    data['preferences'] = this.preferences;
    data['address'] = this.address;
    data['about'] = this.about;
    data['bank_name'] = this.bankName;
    data['branch_name'] = this.branchName;
    data['ifsc'] = this.ifsc;
    data['account_no'] = this.accountNo;
    data['account_type'] = this.accountType;
    data['gst_no'] = this.gstNo;
    data['pan_no'] = this.panNo;
    data['adhaar_no'] = this.adhaarNo;
    data['gst_doc'] = this.gstDoc;
    data['pan_doc'] = this.panDoc;
    data['adhaar_doc'] = this.adhaarDoc;
    data['avatar_path'] = this.avatarPath;
    data['avatar_base_url'] = this.avatarBaseUrl;
    data['facebook_url'] = this.facebookUrl;
    data['twitter_url'] = this.twitterUrl;
    data['google_plus_url'] = this.googlePlusUrl;
    data['instagram_url'] = this.instagramUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['youtube_url'] = this.youtubeUrl;
    data['otp'] = this.otp;
    data['otp_verify'] = this.otpVerify;
    data['website'] = this.website;
    data['email_otp'] = this.emailOtp;
    data['email_verify'] = this.emailVerify;
    data['mobile_verify'] = this.mobileVerify;
    data['auth_key'] = this.authKey;
    data['access_token'] = this.accessToken;
    data['password_hash'] = this.passwordHash;
    data['key_hash'] = this.keyHash;
    data['oauth_client'] = this.oauthClient;
    data['oauth_client_user_id'] = this.oauthClientUserId;
    data['facebook_clinet_user_id'] = this.facebookClinetUserId;
    data['status'] = this.status;
    data['device_type'] = this.deviceType;
    data['devicetoken'] = this.devicetoken;
    data['deviceid'] = this.deviceid;
    data['quickblox_id'] = this.quickbloxId;
    data['quickblox_username'] = this.quickbloxUsername;
    data['quickblox_email'] = this.quickbloxEmail;
    data['quickblox_password'] = this.quickbloxPassword;
    data['register_from'] = this.registerFrom;
    data['social_token'] = this.socialToken;
    data['social_type'] = this.socialType;
    data['package_id'] = this.packageId;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['currency'] = this.currency;
    data['ad_count'] = this.adCount;
    data['featured_ad_count'] = this.featuredAdCount;
    data['newsletter'] = this.newsletter;
    data['terms'] = this.terms;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['logged_at'] = this.loggedAt;
    return data;
  }
}