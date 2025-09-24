// // ceo_dashboard_full.dart
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../../charts/revenue_bar_chart.dart';
//
// /// Full CEO Dashboard content — responsive + professional charts
// /// Drop this file into your project and import where needed.
// /// Make sure to add `fl_chart` dependency in pubspec.yaml
//
// class CeoDashboardContent extends StatefulWidget {
//   const CeoDashboardContent({Key? key}) : super(key: key);
//
//   @override
//   State<CeoDashboardContent> createState() => _CeoDashboardContentState();
// }
//
// class _CeoDashboardContentState extends State<CeoDashboardContent> {
//   // ---------------------------
//   // Filters & Dummy Data (kept from your original)
//   // ---------------------------
//   String selectedBlock = "Atpadi";
//   String selectedDepartment = "ICDS";
//
//   final List<String> blocks = [
//     "Atpadi",
//     "Jath",
//     "Kadegaon",
//     "Kavathe Mahankal",
//     "Khanapur",
//     "Miraj",
//     "Palus",
//     "Shirala",
//     "Tasgaon",
//     "Walwa",
//   ];
//
//   final List<String> departments = [
//     "ICDS",
//     "Women & Child Welfare",
//     "Rural Water Supply",
//     "PWD",
//     "Education Primary",
//     "Finance",
//     "Agriculture",
//     "Gram Panchayat",
//     "Education Secondary",
//     "Animal Husbandry",
//     "General Administration",
//     "Minor Irrigation",
//     "Social Welfare"
//   ];
//
//   // departmentData same as user provided (kept inline so file is self-contained)
//   late final Map<String, List<Map<String, dynamic>>> departmentData;
//
//   @override
//   void initState() {
//     super.initState();
//     departmentData = _createDepartmentData();
//   }
//
//   Map<String, List<Map<String, dynamic>>> _createDepartmentData() {
//     return {
//       "ICDS": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Anganwadi Centers / अंगणवाडी केंद्रे": 10 + block.length,
//             "Children Enrolled / नोंदणीकृत बालक": 1000 + block.length * 20,
//             "Malnutrition Cases / कुपोषण प्रकरणे": 30 + block.length,
//             "Immunization Coverage (%) / लसीकरण कव्हरेज (%)": 85 + (block.length % 5),
//             "Growth Monitoring Done (%) / वाढीचे परीक्षण (%)": 80 + (block.length % 7),
//             "Pregnant Women Registered / गर्भवती महिलांची नोंदणी": 150 + block.length * 2,
//             "Lactating Women Registered / स्तनपान करणाऱ्या महिलांची नोंदणी": 120 + block.length * 3,
//             "Supplementary Nutrition (kg) / पूरक आहार (किलो)": 3000 + block.length * 50,
//             "Home Visits Conducted / गृह भेटी": 200 + block.length * 5,
//             "Worker Training (%) / कामगार प्रशिक्षण (%)": 70 + (block.length % 20),
//           }
//       ],
//       "Women & Child Welfare": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Women Beneficiaries / महिलांचे लाभार्थी": 500 + block.length * 15,
//             "Children Beneficiaries / बालकांचे लाभार्थी": 700 + block.length * 20,
//             "Self-Help Groups / स्वयं सहाय्य गट": 20 + block.length % 10,
//             "Skill Training Completed / कौशल्य प्रशिक्षण पूर्ण": 100 + block.length * 5,
//             "Maternal Health Checkups / मातृ आरोग्य तपासणी": 150 + block.length * 2,
//             "Child Protection Cases / बाल संरक्षण प्रकरणे": 5 + block.length % 5,
//             "Vaccination Coverage (%) / लसीकरण कव्हरेज (%)": 80 + block.length % 10,
//             "Nutrition Kits Distributed / पोषण किट वितरित": 200 + block.length * 10,
//             "Awareness Programs / जनजागृती कार्यक्रम": 10 + block.length % 5,
//             "Loan Assistance / कर्ज सहाय्य": 30 + block.length % 10,
//           }
//       ],
//       "Rural Water Supply": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Functional Schemes / कार्यरत योजना": 40 + block.length,
//             "Non-Functional Schemes / बिघडलेल्या योजना": 3 + block.length % 3,
//             "Household Tap Connections / घरगुती नळ जोडणी": 5000 + block.length * 100,
//             "Schools with Water Supply / पाणीपुरवठा असलेली शाळा": 50 + block.length,
//             "Quality Tests Done / गुणवत्तेची तपासणी": 200 + block.length * 3,
//             "Fluoride Affected Villages / फ्लोराईड प्रभावित गावे": block.length % 2,
//             "Rainwater Harvesting Units / पावसाचे पाणी साठवण": 10 + block.length % 4,
//             "Water Tankers Deployed / पाणी टँकर पाठवले": 5 + block.length % 3,
//             "Coverage (%) / कव्हरेज (%)": 80 + block.length % 10,
//             "Grievances Registered / तक्रारी नोंदविल्या": 20 + block.length % 5,
//           }
//       ],
//       "PWD": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Roads Constructed (km) / बांधलेले रस्ते (कि.मी.)": 100 + block.length * 5,
//             "Roads Repaired (km) / दुरुस्त केलेले रस्ते (कि.मी.)": 50 + block.length * 3,
//             "Bridges Constructed / पूल बांधले": 2 + block.length % 3,
//             "Buildings Constructed / इमारती बांधल्या": 10 + block.length % 5,
//             "Ongoing Projects / सुरू असलेली प्रकल्पे": 5 + block.length % 4,
//             "Completed Projects / पूर्ण प्रकल्पे": 20 + block.length % 7,
//             "Budget Utilized (₹ Lakh) / वापरलेला निधी (₹ लाख)": 500 + block.length * 20,
//             "Maintenance Works / देखभाल कामे": 15 + block.length % 6,
//             "Contractors Engaged / ठेकेदार कामावर": 10 + block.length % 5,
//             "Pending Works / प्रलंबित कामे": 5 + block.length % 3,
//           }
//       ],
//       "Education Primary": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Schools / शाळा": 80 + block.length,
//             "Students Enrolled / विद्यार्थी नोंदणी": 4000 + block.length * 50,
//             "Teachers Available / उपलब्ध शिक्षक": 200 + block.length * 3,
//             "PTR (Student-Teacher Ratio) / विद्यार्थी-शिक्षक गुणोत्तर": 20 + block.length % 5,
//             "Toilets Available / स्वच्छतागृहे": 60 + block.length,
//             "Midday Meals Served / मध्यान्ह भोजन सेवा": 3000 + block.length * 40,
//             "Dropout Students / शाळा सोडलेले विद्यार्थी": 20 + block.length % 10,
//             "Smart Classrooms / स्मार्ट वर्ग": 10 + block.length % 4,
//             "Scholarships Given / शिष्यवृत्ती दिल्या": 200 + block.length * 5,
//             "Attendance Rate (%) / उपस्थिती दर (%)": 85 + block.length % 10,
//           }
//       ],
//       "Finance": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Budget Allocated (₹ Cr) / वितरित अंदाजपत्रक (₹ कोटी)": 100 + block.length * 10,
//             "Expenditure (₹ Cr) / खर्च (₹ कोटी)": 90 + block.length * 8,
//             "Revenue Collected (₹ Cr) / महसूल वसुली (₹ कोटी)": 80 + block.length * 7,
//             "Pending Payments (₹ Cr) / प्रलंबित देयके (₹ कोटी)": 10 + block.length % 5,
//             "Audit Completed (%) / लेखापरीक्षण पूर्ण (%)": 85 + block.length % 10,
//             "Funds Released (₹ Cr) / वितरित निधी (₹ कोटी)": 70 + block.length * 6,
//             "Subsidies Distributed / वितरित अनुदाने": 200 + block.length * 5,
//             "Taxes Collected (₹ Cr) / वसूल कर (₹ कोटी)": 60 + block.length * 4,
//             "Grants Utilized (%) / अनुदाने वापरले (%)": 75 + block.length % 15,
//             "Financial Irregularities / आर्थिक अनियमितता": 1 + block.length % 3,
//           }
//       ],
//       "Agriculture": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Farmers Registered / नोंदणीकृत शेतकरी": 2000 + block.length * 30,
//             "Crop Insurance Beneficiaries / पिक विमा लाभार्थी": 800 + block.length * 15,
//             "Irrigated Land (Ha) / सिंचित जमीन (हे)": 1500 + block.length * 20,
//             "Fertilizer Supplied (MT) / खते पुरवठा (टन)": 300 + block.length * 10,
//             "Seeds Supplied (MT) / बियाणे पुरवठा (टन)": 200 + block.length * 5,
//             "Training Programs / प्रशिक्षण कार्यक्रम": 10 + block.length % 5,
//             "Soil Testing Done / मृदा परीक्षण": 500 + block.length * 10,
//             "Subsidy Given (₹ Lakh) / अनुदान (₹ लाख)": 100 + block.length * 5,
//             "Farm Ponds Constructed / शेततळी बांधली": 5 + block.length % 4,
//             "Organic Farming Area (Ha) / सेंद्रिय शेती क्षेत्र (हे)": 100 + block.length * 2,
//           }
//       ],
//       "Gram Panchayat": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Villages Covered / गावे": 60 + block.length,
//             "Panchayats Active / कार्यरत ग्रामपंचायती": 20 + block.length % 5,
//             "Sanitation Coverage (%) / स्वच्छता कव्हरेज (%)": 80 + block.length % 10,
//             "Streetlights Installed / बसवलेले दिवे": 200 + block.length * 5,
//             "Wells Repaired / दुरुस्त केलेली विहिरी": 10 + block.length % 4,
//             "Beneficiaries of Schemes / योजना लाभार्थी": 300 + block.length * 10,
//             "Village Roads Constructed / बांधलेले गाव रस्ते": 15 + block.length % 6,
//             "E-Governance Centers / ई-गव्हर्नन्स केंद्रे": 5 + block.length % 3,
//             "Panchayat Meetings Held / झालेल्या बैठक": 12 + block.length % 5,
//             "Complaints Resolved / तक्रारी निकाली": 50 + block.length * 2,
//           }
//       ],
//       "Education Secondary": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "High Schools / माध्यमिक शाळा": 40 + block.length,
//             "Students Enrolled / विद्यार्थी नोंदणी": 3000 + block.length * 40,
//             "Teachers Available / शिक्षक": 150 + block.length * 3,
//             "Labs Available / प्रयोगशाळा": 20 + block.length % 5,
//             "Libraries Available / वाचनालये": 15 + block.length % 4,
//             "Scholarships Given / शिष्यवृत्ती": 250 + block.length * 5,
//             "Dropout Students / शाळा सोडलेले विद्यार्थी": 15 + block.length % 8,
//             "Sports Facilities / क्रीडा सुविधा": 10 + block.length % 3,
//             "Smart Classrooms / स्मार्ट वर्ग": 5 + block.length % 2,
//             "Attendance Rate (%) / उपस्थिती दर (%)": 80 + block.length % 10,
//           }
//       ],
//       "Animal Husbandry": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Cattle Vaccinated / लसीकरण केलेले जनावरे": 2000 + block.length * 30,
//             "Artificial Inseminations / कृत्रिम रेतन": 500 + block.length * 10,
//             "Milk Production (Litre) / दूध उत्पादन (लिटर)": 50000 + block.length * 500,
//             "Goat Units / शेळी पालन युनिट": 50 + block.length % 10,
//             "Poultry Units / कुक्कुटपालन युनिट": 100 + block.length % 15,
//             "Fodder Supplied (MT) / चारा पुरवठा (टन)": 400 + block.length * 5,
//             "Veterinary Camps / पशुवैद्यकीय शिबिरे": 10 + block.length % 4,
//             "Farmers Benefited / शेतकरी लाभार्थी": 300 + block.length * 5,
//             "Animal Insurance / जनावर विमा": 100 + block.length * 3,
//             "Diseases Reported / नोंदवलेले आजार": 5 + block.length % 3,
//           }
//       ],
//       "General Administration": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Offices Functional / कार्यरत कार्यालये": 15 + block.length % 5,
//             "Staff Available / कर्मचारी": 200 + block.length * 5,
//             "Citizen Services Delivered / नागरिक सेवा दिल्या": 5000 + block.length * 50,
//             "Grievances Registered / तक्रारी नोंदवल्या": 100 + block.length * 2,
//             "Grievances Resolved / तक्रारी निकाली": 80 + block.length * 2,
//             "RTI Applications / माहिती अधिकार अर्ज": 20 + block.length % 5,
//             "E-Services Usage (%) / ई-सेवा वापर (%)": 70 + block.length % 20,
//             "Office Inspections / कार्यालय तपासणी": 10 + block.length % 3,
//             "Citizen Satisfaction (%) / समाधान (%)": 80 + block.length % 15,
//             "Pending Files / प्रलंबित कागदपत्रे": 30 + block.length % 10,
//           }
//       ],
//       "Minor Irrigation": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Irrigation Schemes / सिंचन योजना": 30 + block.length,
//             "Ponds Constructed / बांधलेली तळी": 10 + block.length % 5,
//             "Check Dams Built / बंधारे बांधले": 15 + block.length % 7,
//             "Canals Repaired (km) / दुरुस्त कालवे (कि.मी.)": 20 + block.length * 2,
//             "Area Irrigated (Ha) / सिंचित क्षेत्र (हे)": 2000 + block.length * 40,
//             "Farmers Benefited / शेतकरी लाभार्थी": 800 + block.length * 10,
//             "Budget Utilized (₹ Lakh) / वापरलेला निधी (₹ लाख)": 500 + block.length * 15,
//             "Water Storage Capacity (ML) / पाणी साठवण (मे.ली.)": 300 + block.length * 10,
//             "Ongoing Projects / सुरू प्रकल्प": 5 + block.length % 3,
//             "Completed Projects / पूर्ण प्रकल्प": 20 + block.length % 6,
//           }
//       ],
//       "Social Welfare": [
//         for (var block in BlockConstants.blocks)
//           {
//             "block": block,
//             "Beneficiaries / लाभार्थी": 1000 + block.length * 20,
//             "Scholarships Given / शिष्यवृत्ती दिल्या": 400 + block.length * 10,
//             "Hostels Functional / कार्यरत वसतिगृह": 10 + block.length % 5,
//             "Old Age Homes / वृद्धाश्रम": 5 + block.length % 3,
//             "Disabled Beneficiaries / अपंग लाभार्थी": 200 + block.length * 5,
//             "Welfare Programs Conducted / कल्याण कार्यक्रम": 20 + block.length % 6,
//             "Training Provided / दिलेले प्रशिक्षण": 100 + block.length * 4,
//             "Awareness Camps / जनजागृती शिबिरे": 15 + block.length % 5,
//             "Loans Distributed / दिलेली कर्जे": 50 + block.length % 10,
//             "Women Benefited / लाभार्थी महिला": 600 + block.length * 12,
//           }
//       ],
//     };
//   }
//
//   // ---------------------------
//   // Helpers to compute filtered dataset & KPI aggregates
//   // ---------------------------
//   List<Map<String, dynamic>> get _filteredList {
//     final list = departmentData[selectedDepartment] ?? [];
//     return list.where((m) => m['block'] == selectedBlock).toList();
//   }
//
//   Map<String, dynamic> get _singleEntry {
//     final list = _filteredList;
//     if (list.isNotEmpty) return list.first;
//     return {"block": selectedBlock};
//   }
//
//   int _getKpiValue(String key) {
//     final val = _singleEntry[key];
//     if (val is int) return val;
//     if (val is double) return val.toInt();
//     return 0;
//   }
//
//   /// Mocked revenue/time-series for charts derived from some numeric fields
//   List<double> _revenueSeries() {
//     // Use some numeric fields to craft a series (stable across changes)
//     final base = (_getKpiValue("Children Enrolled / नोंदणीकृत बालक") / 50).toDouble();
//     return List.generate(6, (i) => (base * (0.8 + i * 0.4)).clamp(100.0, 20000.0));
//   }
//
//   List<double> _visitorSeries() {
//     final a = _getKpiValue("Home Visits Conducted / गृह भेटी").toDouble();
//     final b = _getKpiValue("Beneficiaries / लाभार्थी") != 0
//         ? _getKpiValue("Beneficiaries / लाभार्थी").toDouble()
//         : 200.0;
//     return [
//       (a * 0.5).clamp(10.0, 1000.0),
//       (a * 0.7).clamp(10.0, 1000.0),
//       (a * 0.9).clamp(10.0, 1000.0),
//       (a * 1.1).clamp(10.0, 1000.0),
//       (a * 1.05).clamp(10.0, 1000.0),
//       (b * 0.1).clamp(10.0, 1000.0),
//       (b * 0.15).clamp(10.0, 1000.0),
//     ];
//   }
//
//   List<double> _satisfactionSeries() {
//     final p = _getKpiValue("Worker Training (%) / कामगार प्रशिक्षण (%)");
//     final q = _getKpiValue("Growth Monitoring Done (%) / वाढीचे परीक्षण (%)");
//     return [
//       (p * 0.6).clamp(0.0, 100.0),
//       (p * 0.8).clamp(0.0, 100.0),
//       (q * 0.9).clamp(0.0, 100.0),
//       (q * 1.0).clamp(0.0, 100.0),
//     ];
//   }
//
//   Map<String, double> _topProductsMock() {
//     // provide 4 product labels with percents derived from some counts
//     final v1 = (_getKpiValue("Home Visits Conducted / गृह भेटी") % 100).toDouble();
//     final v2 = (_getKpiValue("Children Enrolled / नोंदणीकृत बालक") % 100).toDouble();
//     final v3 = (_getKpiValue("Supplementary Nutrition (kg) / पूरक आहार (किलो)") % 100).toDouble();
//     final v4 = (_getKpiValue("Pregnant Women Registered / गर्भवती महिलांची नोंदणी") % 100).toDouble();
//
//     final total = (v1 + v2 + v3 + v4).clamp(1.0, 400.0);
//     return {
//       "Home Decor Range": (v1 / total * 100).clamp(1.0, 99.0),
//       "Disney Princess Pink Bag 1B": (v2 / total * 100).clamp(1.0, 99.0),
//       "Bathroom Essentials": (v3 / total * 100).clamp(1.0, 99.0),
//       "Apple Smartwatches": (v4 / total * 100).clamp(1.0, 99.0),
//     };
//   }
//
//   // ---------------------------
//   // Build
//   // ---------------------------
//   @override
//   Widget build(BuildContext context) {
//     final entry = _singleEntry;
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeaderFilters(),
//           const SizedBox(height: 18),
//
//           // KPI Cards Row similar to screenshot
//           Wrap(
//             spacing: 14,
//             runSpacing: 14,
//             children: [
//               _SummaryCard(
//                 value: _getCardValueForIndex(0),
//                 label: _getCardLabelForIndex(0),
//                 hint: "+8% from yesterday",
//                 color: const Color(0xFFFFF3DB),
//                 width: 320,
//               ),
//               _SummaryCard(
//                 value: _getCardValueForIndex(1),
//                 label: _getCardLabelForIndex(1),
//                 hint: "+5% from yesterday",
//                 color: const Color(0xFFFFE7E7),
//                 width: 320,
//               ),
//               _SummaryCard(
//                 value: _getCardValueForIndex(2),
//                 label: _getCardLabelForIndex(2),
//                 hint: "+1.2% from yesterday",
//                 color: const Color(0xFFEAFDF0),
//                 width: 320,
//               ),
//               _SummaryCard(
//                 value: _getCardValueForIndex(3),
//                 label: _getCardLabelForIndex(3),
//                 hint: "0.5% from yesterday",
//                 color: const Color(0xFFF1EBFF),
//                 width: 320,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 18),
//
//
//
//           // Grid: Left big charts, right small visitor
//           LayoutBuilder(builder: (context, constraints) {
//             final wide = constraints.maxWidth > 1100;
//             return Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 SizedBox(
//                   width: wide ? (constraints.maxWidth * 0.62) - 16 : constraints.maxWidth,
//                   child: Column(
//                     children: [
//                       // Row: Total Revenue, Customer Satisfaction, Target vs Reality (three in a row)
//                       Wrap(
//                         spacing: 16,
//                         runSpacing: 16,
//                         children: [
//                           SizedBox(
//                             width: wide ? (constraints.maxWidth * 0.62 - 16) * 0.62 : constraints.maxWidth,
//                             child: _ChartCard(
//                               title: "Total Revenue",
//                               child: CeoPageRevenueBarChart(
//                                 departmentData: departmentData,
//                                 department: "Finance",
//                                 metric: "Revenue Collected (₹ Cr) / महसूल वसुली (₹ कोटी)",
//                                 barColor: Colors.green,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: wide ? (constraints.maxWidth * 0.62 - 16) * 0.36 : constraints.maxWidth,
//                             child: _ChartCard(
//                               title: "Customer Satisfaction",
//                               child: CustomerSatisfactionChart(series: _satisfactionSeries()),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // another row: Top Products + Map placeholder + Volume vs Service
//                       // Wrap(
//                       //   spacing: 16,
//                       //   runSpacing: 16,
//                       //   children: [
//                       //     SizedBox(
//                       //       width: wide ? (constraints.maxWidth * 0.62 - 16) * 0.47 : constraints.maxWidth,
//                       //       child: _ChartCard(
//                       //         title: "Top Products",
//                       //         child: TopProductsWidget(data: _topProductsMock()),
//                       //       ),
//                       //     ),
//                       //     // SizedBox(
//                       //     //   width: wide ? (constraints.maxWidth * 0.62 - 16) * 0.47 : constraints.maxWidth,
//                       //     //   child: _ChartCard(
//                       //     //     title: "Sales Mapping by Country",
//                       //     //     child: const MapPlaceholder(),
//                       //     //   ),
//                       //     // ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//
//                 // Right column: Visitor insights + Target vs Reality + Volume vs Service Level small boxes
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 16,
//                   children: [
//                     SizedBox(
//                       width: wide ? (constraints.maxWidth * 0.62 - 16) * 1.7 : constraints.maxWidth,
//                       child: _ChartCard(
//                         title: "Top Products",
//                         child: TopProductsWidget(data: _topProductsMock()),
//                       ),
//                     ),
//                     // SizedBox(
//                     //   width: wide ? (constraints.maxWidth * 0.62 - 16) * 0.47 : constraints.maxWidth,
//                     //   child: _ChartCard(
//                     //     title: "Sales Mapping by Country",
//                     //     child: const MapPlaceholder(),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             );
//           }),
//
//           const SizedBox(height: 28),
//         ],
//       ),
//     );
//   }
//
//   // KPI card helpers for "Today's Sales" like in screenshot
//   String _getCardLabelForIndex(int idx) {
//     switch (idx) {
//       case 0:
//         return "Total Sales";
//       case 1:
//         return "Total Order";
//       case 2:
//         return "Product Sold";
//       default:
//         return "New Customers";
//     }
//   }
//
//   String _getCardValueForIndex(int idx) {
//     // pick representative values from available metrics
//     final map = _singleEntry;
//     switch (idx) {
//       case 0:
//         return "\$1k"; // keep same visual text as screenshot
//       case 1:
//         return "300";
//       case 2:
//         return "5";
//       default:
//         return "8";
//     }
//   }
//
//   // small mocks for grouped charts
//   List<double> _mockTargetValues() => [8, 12, 10, 14, 9, 11];
//   List<double> _mockRealityValues() => [6, 9, 12, 10, 8, 13];
//
//   Widget _buildHeaderFilters() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Block Dropdown Card
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: DropdownButtonFormField<String>(
//               value: selectedBlock,
//               decoration: const InputDecoration(
//                 labelText: "Select Block",
//                 labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
//                 border: InputBorder.none,
//                 prefixIcon: Icon(Icons.location_on, color: Colors.blueAccent),
//               ),
//               items: blocks
//                   .map((b) => DropdownMenuItem(
//                 value: b,
//                 child: Text(
//                   b,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ))
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) setState(() => selectedBlock = val);
//               },
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//
//         // Department Dropdown Card
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: DropdownButtonFormField<String>(
//               value: selectedDepartment,
//               decoration: const InputDecoration(
//                 labelText: "Select Department",
//                 labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
//                 border: InputBorder.none,
//                 prefixIcon: Icon(Icons.business_center, color: Colors.blueAccent),
//               ),
//               items: departments
//                   .map((d) => DropdownMenuItem(
//                 value: d,
//                 child: Text(
//                   d,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ))
//                   .toList(),
//               onChanged: (val) {
//                 if (val != null) setState(() => selectedDepartment = val);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
// }
//
// // ---------------------------
// // Reusable small widgets & charts
// // ---------------------------
//
// class _SummaryCard extends StatelessWidget {
//   final String value;
//   final String label;
//   final String hint;
//   final Color color;
//   final double width;
//   const _SummaryCard({
//     Key? key,
//     required this.value,
//     required this.label,
//     required this.hint,
//     required this.color,
//     this.width = 300,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width ,
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
//         const SizedBox(height: 12),
//         Text(hint, style: const TextStyle(fontSize: 12, color: Colors.green)),
//       ]),
//     );
//   }
// }
//
// class _ChartCard extends StatelessWidget {
//   final String title;
//   final Widget child;
//   const _ChartCard({Key? key, required this.title, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // fixed decoration similar to screenshot
//       margin: EdgeInsets.zero,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFBF6FB),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 12),
//           SizedBox(height: 180, child: child),
//         ],
//       ),
//     );
//   }
// }
//
// class VisitorInsightsChart extends StatelessWidget {
//   final List<double> series;
//   const VisitorInsightsChart({Key? key, required this.series}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // make two lines: primary = series, secondary = series * 0.6
//     final primary = series;
//     final secondary = series.map((v) => v * 0.6).toList();
//
//     return LineChart(
//       LineChartData(
//         minY: 0,
//         maxY: (primary.reduce((a, b) => a > b ? a : b) * 1.3),
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//             spots: primary.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
//             isCurved: true,
//             color: Colors.purple,
//             barWidth: 3,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: true, color: Colors.purple.withOpacity(0.15)),
//           ),
//           LineChartBarData(
//             spots: secondary.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
//             isCurved: true,
//             color: Colors.orange,
//             barWidth: 3,
//             dotData: FlDotData(show: false),
//             belowBarData: BarAreaData(show: true, color: Colors.orange.withOpacity(0.12)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ---------------------------
// // CustomerSatisfactionChart (curved line + area gradient)
// // ---------------------------
// class CustomerSatisfactionChart extends StatelessWidget {
//   final List<double> series;
//   const CustomerSatisfactionChart({Key? key, required this.series}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final maxY = (series.reduce((a, b) => a > b ? a : b) * 1.2).clamp(10.0, 100.0);
//     return LineChart(
//       LineChartData(
//         minY: 0,
//         maxY: maxY,
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//             spots: series.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
//             isCurved: true,
//             color: Colors.green,
//             barWidth: 3.5,
//             dotData: FlDotData(show: true),
//             belowBarData: BarAreaData(
//               show: true,
//               gradient: LinearGradient(colors: [Colors.green.withOpacity(0.25), Colors.white.withOpacity(0.02)]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ---------------------------
// // Target vs Reality Chart (grouped bars)
// // ---------------------------
// class TargetVsRealityChart extends StatelessWidget {
//   final List<double> targetValues;
//   final List<double> realityValues;
//   const TargetVsRealityChart({Key? key, required this.targetValues, required this.realityValues}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final len = (targetValues.length <= realityValues.length) ? targetValues.length : realityValues.length;
//     final maxY = [
//       ...targetValues.take(len),
//       ...realityValues.take(len)
//     ].reduce((a, b) => a > b ? a : b) * 1.2;
//
//     return BarChart(
//       BarChartData(
//         maxY: maxY,
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         groupsSpace: 18,
//         barGroups: List.generate(len, (i) {
//           final t = targetValues[i];
//           final r = realityValues[i];
//           return BarChartGroupData(
//             x: i,
//             barRods: [
//               BarChartRodData(toY: t, width: 8, color: Colors.orange),
//               BarChartRodData(toY: r, width: 8, color: Colors.teal),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
// // ---------------------------
// // TopProductsWidget (horizontal progress bars)
// // ---------------------------
// class TopProductsWidget extends StatelessWidget {
//   final Map<String, double> data;
//   const TopProductsWidget({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final entries = data.entries.toList();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(entries.length, (i) {
//         final item = entries[i];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15),
//           child: Row(
//             children: [
//               SizedBox(width: 36, child: Text("0${i + 1}", style: const TextStyle(color: Colors.black54))),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(item.key, style: const TextStyle(fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 6),
//                   Stack(children: [
//                     Container(height: 8, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
//                     Container(width: (item.value / 100) * (MediaQuery.of(context).size.width * 0.3).clamp(60.0, 200.0), height: 8, decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(6))),
//                   ]),
//                 ]),
//               ),
//               const SizedBox(width: 12),
//               Text("${item.value.toStringAsFixed(0)}%", style: const TextStyle(color: Colors.black54)),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ---------------------------
// // Volume vs Service Level (grouped bars with categories)
// // ---------------------------
// class VolumeVsServiceChart extends StatelessWidget {
//   const VolumeVsServiceChart({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final categories = ["Completed", "Pending", "In Progress"];
//     final volume = [42.0, 10.0, 8.0];
//     final service = [95.0, 70.0, 80.0];
//
//     final maxY = [
//       ...volume,
//       ...service
//     ].reduce((a, b) => a > b ? a : b) * 1.2;
//
//     return BarChart(
//       BarChartData(
//         maxY: maxY,
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         groupsSpace: 18,
//         barGroups: List.generate(categories.length, (i) {
//           return BarChartGroupData(
//             x: i,
//             barRods: [
//               BarChartRodData(toY: volume[i], width: 10, color: Colors.purple),
//               BarChartRodData(toY: service[i], width: 10, color: Colors.green),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
// // ---------------------------
// // Map Placeholder
// // ---------------------------
// class MapPlaceholder extends StatelessWidget {
//   const MapPlaceholder({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Center(child: Text("World map (color regions)", style: Theme.of(context).textTheme.bodyMedium)),
//     );
//   }
// }
//
// // ---------------------------
// // Block Constants used in dummy data generation
// // ---------------------------
// class BlockConstants {
//   static const List<String> blocks = [
//     "Atpadi",
//     "Jath",
//     "Kadegaon",
//     "Kavathe Mahankal",
//     "Khanapur",
//     "Miraj",
//     "Palus",
//     "Shirala",
//     "Tasgaon",
//     "Walwa",
//   ];
// }
