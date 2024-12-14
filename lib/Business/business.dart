
class Business {
  String userId;
  String company;
  String industry;
  String name;
  String designation;
  String contact;
  String email;
  String addBio;
  String addServices;
  String whatAppNum;
  String messenger;
  String address;
  String website;
  String driveLink;
  String document;
  String cloudLink;
  String skype;
  String twitter;
  String instagram;
  String linkedin;
  String facebook;
  String gpay;
  String paytm;
  String education;
  String experience;
  String hobbies;
  String info;

  Business(
      this.userId,
      this.company,
      this.industry,
      this.name,
      this.designation,
      this.contact,
      this.email,
      this.addBio,
      this.addServices,
      this.whatAppNum,
      this.messenger,
      this.address,
      this.website,
      this.driveLink,
      this.document,
      this.cloudLink,
      this.skype,
      this.twitter,
      this.instagram,
      this.linkedin,
      this.facebook,
      this.gpay,
      this.paytm,
      this.education,
      this.experience,
      this.hobbies,
      this.info);

  Map<String, dynamic> toJson() => {
        'userId': userId.toString(),
        'company': company.toString(),
        'industry': industry.toString(),
        'name': name.toString(),
        'designation': designation.toString(),
        'contact': contact.toString(),
        'email': email.toString(),
        'add_bio': addBio.toString(),
        'add_services': addServices.toString(),
        'whatApp_no': whatAppNum.toString(),
        'messenger': messenger.toString(),
        'address': address.toString(),
        'website': website.toString(),
        'drivelink': driveLink.toString(),
        'document': document.toString(),
        'cloud_link': cloudLink.toString(),
        'skype': skype.toString(),
        'twitter': twitter.toString(),
        'instagram': instagram.toString(),
        'linkedin': linkedin.toString(),
        'facebook': facebook.toString(),
        'gpay': gpay.toString(),
        'paytm': paytm.toString(),
        'education': education.toString(),
        'experience': experience.toString(),
        'hobbies': hobbies.toString(),
        'info': info.toString(),
      };
}
