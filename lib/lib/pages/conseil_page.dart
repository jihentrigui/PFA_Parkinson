import 'package:flutter/material.dart';

class ConseilPage extends StatelessWidget {
  const ConseilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pour vivre avec Parkinson'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Symptômes de Parkinson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            symptomCardView(
              context,
              "1. Tremblements :",
              "Secousses ou tremblements involontaires, le plus souvent dans les mains.",
              "assets/images/symptom1.jpg",
            ),
            const SizedBox(height: 16),
            symptomCardView(
              context,
              "2. Raideur Musculaire :",
              "Les muscles deviennent raides et tendus, entraînant une perte de souplesse.",
              "assets/images/symptom2.jpg",
            ),
            symptomCardView(
              context,
              '3. Bradykinésie :',
              "Ralentissement des mouvements volontaires, ce qui rend les activités quotidiennes difficiles.",
              "assets/images/symptom3.jpg",
            ),
            symptomCardView(
              context,
              '4. Instabilité Posturale :',
              "Difficulté à maintenir l'équilibre et risque accru de chutes.",
              "assets/images/symptom4.jpg",
            ),
            const SizedBox(height: 32),
            const Text(
              'Conseils Pour vivre avec Parkinson',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Advice cards
            cardView(
              context,
              "1. Rester Actif :",
              "Pratiquez une activité physique régulière comme la marche, la natation...",
              "assets/images/c1.jpg",
            ),
            const SizedBox(height: 16),
            cardView(
              context,
              "2. Gestion des Médicaments :",
              "Prenez les médicaments selon les prescriptions de votre professionnel...",
              "assets/images/c2.jpg",
            ),
            cardView(
              context,
              '3. Alimentation Équilibrée :',
              "Maintenez une alimentation saine et équilibrée en mettant l'accent sur les...",
              "assets/images/c3.jpg",
            ),
            cardView(
              context,
              '4. Sommeil Adéquat :',
              "Assurez-vous de bénéficier d'un sommeil réparateur chaque nuit...",
              "assets/images/c4.jpg",
            ),
            cardView(
              context,
              '5. Bien-Être Émotionnel :',
              'Restez connecté socialement avec vos amis et votre famille. Envisagez de rejoindre...',
              "assets/images/c5.jpg",
            ),
          ],
        ),
      ),
    );
  }

  Widget symptomCardView(BuildContext context, String text, String descreption,
          String? image) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(descreption),
          ],
        ),
      );

  Widget cardView(BuildContext context, String text, String descreption,
          String? image) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(descreption),
          ],
        ),
      );
}
