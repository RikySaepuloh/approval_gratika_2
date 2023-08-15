import 'dart:io';

import 'package:al_downloader/al_downloader.dart';
import 'package:approval_gratika/check_permission.dart';
import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/approval_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../directory_path.dart';
import '../../../repository/repository.dart';
import '../../../utils.dart';
import 'pdf_viewer.dart';

class DetailHistoryScreen extends StatefulWidget {
  final String no_bukti;
  final String modul;

  const DetailHistoryScreen(
      {super.key, required this.no_bukti, required this.modul});

  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen>
    with SingleTickerProviderStateMixin {
  bool isPermission = false;
  var checkAllPermission = CheckPermission();
  bool downloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;

  var getPathFile = DirectoryPath();

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistsCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistsCheck;
    });
  }

  checkPermission() async {
    var permission = await checkAllPermission.isStoragePermission();
    if(permission){
      setState(() {
        isPermission = true;
      });
    }
  }
  late TabController _tabController;
  Repository repository = Repository();
  ApprovalDetail? _dataModel;
  double? _progress;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  var keterangan = "";

  @override
  void initState() {
    checkPermission();
    fetchData();
    initialize();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  /// Initialize
  void initialize() {
    /// ALDownloader initilize
    ALDownloader.initialize();

    /// Configure print
    ALDownloader.configurePrint(enabled: false, frequentEnabled: false);
  }

  void fetchData() async {
    try {
      final ApprovalDetail dataModel =
      await repository.getDetailApprovalData(widget.no_bukti);
      setState(() {
        _dataModel = dataModel;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
          Card(
            margin: EdgeInsets.zero,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
            ),
            child: Container(
              height: 250,
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text("History "+
                          widget.modul,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: 'Detail'),
                  Tab(text: 'Barang'),
                  Tab(text: 'Dokumen'),
                  Tab(text: 'History'),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 140),
                  child: TabBarView(controller: _tabController, children: [
                    buildDetailCard(widget.no_bukti),
                    buildBarangCard(),
                    buildDokumenCard(),
                    buildHistoryCard(),
                  ]),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Card buildDetailCard(String data) {
    return Card(
      margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                "No Dokumen",
                style: TextStyle(color: AppColors.fontSecondaryColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _dataModel?.data[0].no_dokumen ?? "-",
                style: TextStyle(),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                "Nilai Pengajuan",
                style: TextStyle(color: AppColors.fontSecondaryColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                formatCurrency(double.parse(_dataModel?.data.isNotEmpty == true
                    ? _dataModel!.data[0].nilai
                    : "0")),
                // formatCurrency(double.parse(_dataModel!.data[0].nilai)),
                style: TextStyle(),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                "Pembuat/PP",
                style: TextStyle(color: AppColors.fontSecondaryColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _dataModel?.data.isNotEmpty == true
                    ? _dataModel!.data[0].nama_pp
                    : "-",
                // _dataModel!.data[0].nama_pp,
                style: TextStyle(),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                "Deskripsi",
                style: TextStyle(color: AppColors.fontSecondaryColor),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _dataModel?.data.isNotEmpty == true
                    ? _dataModel!.data[0].keterangan
                    : "-",
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotal() {
    double total = 0.0;
    for (var item in _dataModel?.data_detail ?? []) {
      total += double.parse(item.harga) * double.parse(item.jumlah);
    }
    return total;
  }

  Card buildBarangCard() {
    return Card(
      margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                formatCurrency(calculateTotal()),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Card(
                color: AppColors.cardSecondaryColor,
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 9, 12, 9),
                  child: Row(
                    children: [
                      Text(
                        "Detail",
                        style: TextStyle(fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: GlowingOverscrollIndicator(
                  color: AppColors.primaryColor,
                  axisDirection: AxisDirection.down,
                  child: ListView.builder(
                      itemCount: _dataModel?.data_detail.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = _dataModel?.data_detail[index];
                        if (item != null) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.nama_brg,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Spacer(),
                                    Text(
                                      formatCurrency((double.parse(item.harga) *
                                          double.parse(item.jumlah)))
                                          .toString(),
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(
                                  double.parse(item.jumlah).toInt().toString() +
                                      " unit x " +
                                      formatCurrency(double.parse(item.harga))
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text("Tidak ada data"));
                        }
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDokumenCard() {
    return isPermission?Card(
      margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        child: Expanded(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.primaryColor,
            child: ListView.builder(
              itemCount: _dataModel?.data_dokumen.length ?? 0,
              itemBuilder: (context, index) {
                final item = _dataModel?.data_dokumen[index];
                if (item != null) {
                  return InkWell(
                    onTap: () {
                      item.file_dok.substring(item.file_dok.lastIndexOf('.') + 1) == "pdf"?
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PDFViewer(fileURL:item.file_dok)),
                      ):print("Download File");
                      // FileDownloader.downloadFile(
                      //     url: item.file_dok,
                      //     name: item.no_gambar,
                      //     onDownloadCompleted: (value) {
                      //       print('path $value');
                      //       setState(() {
                      //         _progress = null;
                      //       });
                      //     },
                      //     onDownloadError: (errorMessage) => print(errorMessage),
                      //     onProgress: (name, progress) {
                      //       setState(() {
                      //         _progress = progress;
                      //       });
                      //     });


                      // repository.downloadFile(item.file_dok, item.no_gambar);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildIconDocument(item.file_dok),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  child: Text(
                                    item.no_gambar,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              InkWell(
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                              color: AppColors.cardSecondaryColor,
                              child: SizedBox(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                              ))
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text("Tidak ada dokumen"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    ):TextButton(onPressed: checkPermission,child: Text("Permission Issue",style: TextStyle(color: AppColors.primaryColor),),);
  }

  StatelessWidget buildIconDocument(String ext) {
    switch (ext.substring(ext.lastIndexOf('.') + 1)) {
      case 'pdf':
        return Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
        );
      case 'xls':
        return FaIcon(
          FontAwesomeIcons.fileExcel,
          color: Colors.green,
        );
      case 'doc':
        return FaIcon(
          FontAwesomeIcons.fileWord,
          color: Colors.blue,
        );
      default:
        return Icon(
          Icons.file_copy,
          color: Colors.grey,
        );
    }
  }

  Card buildHistoryCard() {
    return Card(
      margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.primaryColor,
            child: Container(
              child: ListView.builder(
                  itemCount: _dataModel?.data_histori.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = _dataModel?.data_histori[index];
                    if (item != null) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TimelineTile(
                            isFirst: index == 0 ? true : false,
                            isLast: index == _dataModel!.data_histori.length - 1
                                ? true
                                : false,
                            alignment: TimelineAlign.manual,
                            lineXY: 0,
                            indicatorStyle: item.status == "Approved"
                                ? IndicatorStyle(color: Colors.green, width: 15)
                                : IndicatorStyle(color: Colors.red, width: 15),
                            endChild: Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.nama + " - " + item.tgl,
                                        style: TextStyle(
                                            color: AppColors.primaryColor),
                                      )
                                    ],
                                  ),
                                  Card(
                                    color: AppColors.cardSecondaryColor,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(12, 9, 12, 9),
                                      child: Row(
                                        children: [
                                          Text(
                                            item.keterangan,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    } else {
                      return Center(
                        child: Text("Tidak ada data"),
                      );
                    }
                  }),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
