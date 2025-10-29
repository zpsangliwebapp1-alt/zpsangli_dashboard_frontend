// lib/features/complaint/data/models/complaint_request_model.dart

class ComplaintRequestModel {
  final String applicantName;
  final String mobileNumber;
  final String email;
  final String aadhaarNumber;
  final String address;
  final String villageName;
  final String taluka;
  final String district;
  final String complaintSubject;
  final String complaintDescription;
  final String concernedDepartment;
  final String attachmentUrl;
  final String incidentDate;
  final bool consentAccepted;

  ComplaintRequestModel({
    required this.applicantName,
    required this.mobileNumber,
    required this.email,
    required this.aadhaarNumber,
    required this.address,
    required this.villageName,
    required this.taluka,
    required this.district,
    required this.complaintSubject,
    required this.complaintDescription,
    required this.concernedDepartment,
    required this.attachmentUrl,
    required this.incidentDate,
    required this.consentAccepted,
  });

  Map<String, dynamic> toJson() {
    return {
      'applicantName': applicantName,
      'mobileNumber': mobileNumber,
      'email': email,
      'aadhaarNumber': aadhaarNumber,
      'address': address,
      'villageName': villageName,
      'taluka': taluka,
      'district': district,
      'complaintSubject': complaintSubject,
      'complaintDescription': complaintDescription,
      'concernedDepartment': concernedDepartment,
      'attachmentUrl': attachmentUrl,
      'incidentDate': incidentDate,
      'consentAccepted': consentAccepted,
    };
  }
}
