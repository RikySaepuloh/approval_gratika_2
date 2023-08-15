import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/history_list_item.dart';
import 'package:approval_gratika/repository/repository.dart';
import 'package:approval_gratika/utils.dart';
import 'package:flutter/material.dart';

import '../detail/detail_history_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryListItem> listApproval = [];
  List<HistoryListItem> filteredList = [];
  bool isSearching = false; // Track whether the search icon is clicked
  Repository repository = Repository();

  getData() async {
    listApproval = await repository.getHistoryApprovalListData();
    filteredList = listApproval;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void filterList(String query) {
    setState(() {
      filteredList = listApproval.where((item) {
        return item.noBukti.toLowerCase().contains(query.toLowerCase()) ||
            item.modul.toLowerCase().contains(query.toLowerCase()) ||
            item.tanggal.toLowerCase().contains(query.toLowerCase()) ||
            item.namaPp.toLowerCase().contains(query.toLowerCase()) ||
            item.nilai.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History Approval",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            onChanged: (value) {
                              filterList(value);
                            },
                            style: TextStyle(fontSize: 12),
                            cursorColor: AppColors.primaryColor,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 1)),
                              prefixIcon: Icon(Icons.search,color: Colors.grey,),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              floatingLabelStyle:
                                  TextStyle(color: AppColors.primaryColor),
                              labelText: 'Search',
                            ),
                          )),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isSearching = false;
                                filteredList = listApproval;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                // Wrap ListView.builder with Expanded
                child: Container(
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: AppColors.primaryColor,
                    child: filteredList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailHistoryScreen(
                                        modul: item.modul,
                                        no_bukti: item.noBukti,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Container(
                                      margin: EdgeInsets.all(25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                item.modul,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              item.status.toLowerCase() ==
                                                      "approved"
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 14,
                                                    )
                                                  : Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 14,
                                                    ),
                                              Spacer(),
                                              Text(
                                                formatCurrency(
                                                    double.parse(item.nilai)),
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            item.keterangan,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.namaPp,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 12,
                                                color: AppColors.primaryColor,
                                              ),
                                              // Your icon here
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                item.tanggal,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text("Tidak ada riwayat pengajuan."),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
