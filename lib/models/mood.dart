enum Emotion {
  feliz,
  emocionado,
  contento,
  neutro,
  reflexivo,
  triste,
  ansioso,
  estresado,
  frustrado,
  abrumado,
  enojado
}

const emotionIcons = {
  Emotion.feliz: 'assets/images/feliz.png',
  Emotion.emocionado: 'assets/images/emocionado.png',
  Emotion.contento: 'assets/images/contento.png',
  Emotion.neutro: 'assets/images/neutro.png',
  Emotion.reflexivo: 'assets/images/reflexivo.png',
  Emotion.triste: 'assets/images/triste.png',
  Emotion.ansioso: 'assets/images/ansioso.png',
  Emotion.estresado: 'assets/images/estresado.png',
  Emotion.frustrado: 'assets/images/frustrado.png',
  Emotion.abrumado: 'assets/images/abrumado.png',
  Emotion.enojado: 'assets/images/enojado.png',
};

class Mood {
  Mood({
    required this.name,
  });

  final Emotion name;
}
