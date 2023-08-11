class HistoryListItem {
  final String noBukti;
  final String keterangan;
  final String noUrut;
  final String nilai;
  final String dueDate;
  final String modul;
  final String id;
  final String deskripsi;
  final String namaPp;
  final String kodePp;
  final String noDokumen;
  final String tanggal;
  final String status;

  HistoryListItem({
    required this.noBukti,
    required this.keterangan,
    required this.noUrut,
    required this.nilai,
    required this.dueDate,
    required this.modul,
    required this.id,
    required this.deskripsi,
    required this.namaPp,
    required this.kodePp,
    required this.noDokumen,
    required this.tanggal,
    required this.status,
  });

  factory HistoryListItem.fromJson(Map<String, dynamic> json) {
    return HistoryListItem(
      noBukti: json['no_bukti'],
      keterangan: json['keterangan'],
      noUrut: json['no_urut'],
      nilai: json['nilai'],
      dueDate: json['due_date'],
      modul: json['modul'],
      id: json['id'],
      deskripsi: json['deskripsi'],
      namaPp: json['nama_pp'],
      kodePp: json['kode_pp'],
      noDokumen: json['no_dokumen'],
      tanggal: json['tanggal'],
      status: json['status'],
    );
  }
}
