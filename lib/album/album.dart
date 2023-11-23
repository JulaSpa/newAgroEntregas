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

  const Album(
      {required this.nroCP,
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
      required this.idSit});

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
    );
  }
}
