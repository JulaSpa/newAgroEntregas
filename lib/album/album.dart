class Album {
  final String nroCP;
  final String nombreSit;
  final String xtitular;
  final String nombrePrc;
  final String xintermediario;
  final String xcorredor;
  final String observacionesana;
  final String xdestinatario;
  final String xdestino;
  final String idFl;
  final String fechaSistema;
  final String imagen;
  final String nombreMe;
  final String chasisFl;
  final String acopreFl;
  final String idSit;
  final String rem2;
  final String remCom;
  final String rem1;
  final String rem3;
  final String xcorredor1;
  final String xcorredor2;

  const Album({
    required this.nroCP,
    required this.nombreSit,
    required this.xtitular,
    required this.nombrePrc,
    required this.xintermediario,
    required this.xcorredor,
    required this.observacionesana,
    required this.xdestinatario,
    required this.xdestino,
    required this.idFl,
    required this.fechaSistema,
    required this.imagen,
    required this.nombreMe,
    required this.chasisFl,
    required this.acopreFl,
    required this.idSit,
    required this.rem2,
    required this.remCom,
    required this.rem1,
    required this.rem3,
    required this.xcorredor1,
    required this.xcorredor2,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      nroCP: json['NroCP'] ?? '',
      nombreSit: json['nombreSit'] ?? '',
      xtitular: json['x_titular'] ?? '',
      nombrePrc: json['nombrePrc'] ?? '',
      xintermediario: json["x_intermediario"] ?? '',
      xcorredor: json["x_corredor"] ?? '',
      observacionesana: json["observaciones_ana"] ?? '',
      xdestinatario: json["x_destinatario"] ?? '',
      xdestino: json["x_destino"] ?? '',
      idFl: json["idFl"] ?? '',
      fechaSistema: json["fecha_sistema"] ?? '',
      imagen: json["Imagen"] ?? '',
      nombreMe: json["nombreMe"] ?? '',
      chasisFl: json["chasisFl"] ?? '',
      acopreFl: json["acopreFl"] ?? '',
      idSit: json["idSit"] ?? '',
      rem2: json["x_remitente2"] ?? '',
      remCom: json["x_remitente_comercial"] ?? '',
      rem1: json["x_remitente1"] ?? '',
      rem3: json["x_remitente3"] ?? '',
      xcorredor1: json["x_corredor1"] ?? '',
      xcorredor2: json["x_corredor2"] ?? '',
    );
  }
}
