class ApprovalDetail {
  bool status;
  List<ApprovalDetailDataItem> data;
  List<ApprovalDetailDataDetailItem> data_detail;
  List<ApprovalDetailDataTotalItem> data_total;
  List<ApprovalDetailDataDokumenItem> data_dokumen;
  List<ApprovalDetailDataHistoriItem> data_histori; // Adjust the data type accordingly
  List<dynamic> data_detail_spb; // Adjust the data type accordingly
  String message;

  ApprovalDetail({
    required this.status,
    required this.data,
    required this.data_detail,
    required this.data_total,
    required this.data_dokumen,
    required this.data_histori,
    required this.data_detail_spb,
    required this.message,
  });

  factory ApprovalDetail.fromJson(Map<String, dynamic> json) {
    return ApprovalDetail(
      status: json['status'],
      data: List<ApprovalDetailDataItem>.from(json['data'].map((data) => ApprovalDetailDataItem.fromJson(data))),
      data_detail: List<ApprovalDetailDataDetailItem>.from(json['data_detail'].map((data) => ApprovalDetailDataDetailItem.fromJson(data))),
      data_total: List<ApprovalDetailDataTotalItem>.from(json['data_total'].map((data) => ApprovalDetailDataTotalItem.fromJson(data))),
      data_dokumen: List<ApprovalDetailDataDokumenItem>.from(json['data_dokumen'].map((data) => ApprovalDetailDataDokumenItem.fromJson(data))),
      data_histori: List<ApprovalDetailDataHistoriItem>.from(json['data_histori'].map((data) => ApprovalDetailDataHistoriItem.fromJson(data))),
      data_detail_spb: json['data_detail_spb'],
      message: json['message'],
    );
  }
}

class ApprovalDetailDataHistoriItem {
  String id;
  String noPb;
  String status;
  String keterangan;
  String nik;
  String nama;
  String noUrut;
  String id2;
  String tgl;
  String tanggal;

  ApprovalDetailDataHistoriItem({
    required this.id,
    required this.noPb,
    required this.status,
    required this.keterangan,
    required this.nik,
    required this.nama,
    required this.noUrut,
    required this.id2,
    required this.tgl,
    required this.tanggal,
  });

  factory ApprovalDetailDataHistoriItem.fromJson(Map<String, dynamic> json) {
    return ApprovalDetailDataHistoriItem(
      id: json['id'] as String,
      noPb: json['no_pb'] as String,
      status: json['status'] as String,
      keterangan: json['keterangan'] as String,
      nik: json['nik'] as String,
      nama: json['nama'] as String,
      noUrut: json['no_urut'] as String,
      id2: json['id2'] as String,
      tgl: json['tgl'] as String,
      tanggal: json['tanggal'] as String,
    );
  }
}

class ApprovalDetailDataItem {
  String no_bukti;
  String no_dokumen;
  String kode_pp;
  String tanggal;
  String keterangan;
  String no_urut;
  String nama_pp;
  String nilai;
  String due_date;
  String modul;

  ApprovalDetailDataItem({
    required this.no_bukti,
    required this.no_dokumen,
    required this.kode_pp,
    required this.tanggal,
    required this.keterangan,
    required this.no_urut,
    required this.nama_pp,
    required this.nilai,
    required this.due_date,
    required this.modul,
  });

  factory ApprovalDetailDataItem.fromJson(Map<String, dynamic> json) {
    return ApprovalDetailDataItem(
      no_bukti: json['no_bukti'],
      no_dokumen: json['no_dokumen'],
      kode_pp: json['kode_pp'],
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      no_urut: json['no_urut'],
      nama_pp: json['nama_pp'],
      nilai: json['nilai'],
      due_date: json['due_date'],
      modul: json['modul'],
    );
  }
}

class ApprovalDetailDataDetailItem {
  String no_pb;
  String nama_brg;
  String satuan;
  String jumlah;
  String harga;
  String nu;

  ApprovalDetailDataDetailItem({
    required this.no_pb,
    required this.nama_brg,
    required this.satuan,
    required this.jumlah,
    required this.harga,
    required this.nu,
  });

  factory ApprovalDetailDataDetailItem.fromJson(Map<String, dynamic> json) {
    return ApprovalDetailDataDetailItem(
      no_pb: json['no_pb'],
      nama_brg: json['nama_brg'],
      satuan: json['satuan'],
      jumlah: json['jumlah'],
      harga: json['harga'],
      nu: json['nu'],
    );
  }
}

class ApprovalDetailDataTotalItem {
  String no_pb;
  String jum_brg;

  ApprovalDetailDataTotalItem({
    required this.no_pb,
    required this.jum_brg,
  });

  factory ApprovalDetailDataTotalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalDetailDataTotalItem(
      no_pb: json['no_pb'],
      jum_brg: json['jum_brg'],
    );
  }
}

class ApprovalDetailDataDokumenItem {
  String no_pb;
  String no_gambar;
  String nu;
  String kode_jenis;
  String no_ref;
  String file_dok;

  ApprovalDetailDataDokumenItem({
    required this.no_pb,
    required this.no_gambar,
    required this.nu,
    required this.kode_jenis,
    required this.no_ref,
    required this.file_dok,
  });

  factory ApprovalDetailDataDokumenItem.fromJson(Map<String, dynamic> json) {
    return ApprovalDetailDataDokumenItem(
      no_pb: json['no_pb'],
      no_gambar: json['no_gambar'],
      nu: json['nu'],
      kode_jenis: json['kode_jenis'],
      no_ref: json['no_ref'],
      file_dok: json['file_dok'],
    );
  }
}
