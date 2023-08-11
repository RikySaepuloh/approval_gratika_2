class ApprovalListItem {
  final String modul;
  final String nilai;
  final String dueDate;
  final String keterangan;
  final String noBukti;
  final String namaPp;
  final String noDokumen;
  final String kodePp;
  final String tanggal;
  final String? id;

  ApprovalListItem({
    required this.modul,
    required this.nilai,
    required this.dueDate,
    required this.keterangan,
    required this.noBukti,
    required this.namaPp,
    required this.noDokumen,
    required this.kodePp,
    required this.tanggal,
    this.id,
  });

  factory ApprovalListItem.fromJson(Map<String, dynamic> json) {
    return ApprovalListItem(
      modul: json['modul'],
      nilai: json['nilai'],
      dueDate: json['due_date'],
      keterangan: json['keterangan'],
      noBukti: json['no_bukti'],
      namaPp: json['nama_pp'],
      noDokumen: json['no_dokumen'],
      kodePp: json['kode_pp'],
      tanggal: json['tanggal'],
      id: json['id'],
    );
  }
}