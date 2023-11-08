enum EmotionActivity { Ejercicio, Tarea, Pasear, Bailar, Jugar }

const emotionIconsActivity = {
  EmotionActivity.Ejercicio: 'assets/images/ejercicio.png',
  EmotionActivity.Tarea: 'assets/images/tarea.png',
  EmotionActivity.Pasear: 'assets/images/pasearperro.png',
  EmotionActivity.Bailar: 'assets/images/baile.png',
  EmotionActivity.Jugar: 'assets/images/videojuegos.png',
};

class Mood {
  Mood({
    required this.name,
  });

  final EmotionActivity name;
}