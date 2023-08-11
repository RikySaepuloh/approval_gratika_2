class UserModel {
  List<User> user;
  List<Periode> periode;
  List<KodeFS> kodeFs;

  UserModel({required this.user, required this.periode, required this.kodeFs});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user: List<User>.from(json['user'].map((x) => User.fromJson(x))),
      periode: List<Periode>.from(json['periode'].map((x) => Periode.fromJson(x))),
      kodeFs: List<KodeFS>.from(json['kode_fs'].map((x) => KodeFS.fromJson(x))),
    );
  }
}

class User {
  String kodeKlpMenu;
  String nik;
  String nama;
  String pass;
  String statusAdmin;
  String klpAkses;
  String kodeLokasi;
  String nmlok;
  String kodePp;
  String namaPp;
  String kodeLokkonsol;
  String foto;
  String pathView;
  String logo;
  String kodeKota;
  String background;
  dynamic flagMenu;
  String email;
  String noTelp;
  String jabatan;

  User({
    required this.kodeKlpMenu,
    required this.nik,
    required this.nama,
    required this.pass,
    required this.statusAdmin,
    required this.klpAkses,
    required this.kodeLokasi,
    required this.nmlok,
    required this.kodePp,
    required this.namaPp,
    required this.kodeLokkonsol,
    required this.foto,
    required this.pathView,
    required this.logo,
    required this.kodeKota,
    required this.background,
    this.flagMenu,
    required this.email,
    required this.noTelp,
    required this.jabatan,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      kodeKlpMenu: json['kode_klp_menu'],
      nik: json['nik'],
      nama: json['nama'],
      pass: json['pass'],
      statusAdmin: json['status_admin'],
      klpAkses: json['klp_akses'],
      kodeLokasi: json['kode_lokasi'],
      nmlok: json['nmlok'],
      kodePp: json['kode_pp'],
      namaPp: json['nama_pp'],
      kodeLokkonsol: json['kode_lokkonsol'],
      foto: json['foto'],
      pathView: json['path_view'],
      logo: json['logo'],
      kodeKota: json['kode_kota'],
      background: json['background'],
      flagMenu: json['flag_menu'],
      email: json['email'],
      noTelp: json['no_telp'],
      jabatan: json['jabatan'],
    );
  }
}

class Periode {
  String periode;

  Periode({required this.periode});

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      periode: json['periode'],
    );
  }
}

class KodeFS {
  String kodeFs;

  KodeFS({required this.kodeFs});

  factory KodeFS.fromJson(Map<String, dynamic> json) {
    return KodeFS(
      kodeFs: json['kode_fs'],
    );
  }
}
