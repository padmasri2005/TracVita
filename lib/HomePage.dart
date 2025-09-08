import 'package:flutter/material.dart';
import 'package:healthapp/main.dart';
import 'package:healthapp/water_remainder.dart'; // <-- Import WaterReminder
import 'package:provider/provider.dart';

class AndriodPrototype extends StatelessWidget {
  const AndriodPrototype({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<UsernameProvider>(context).username;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'TracVita',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(76, 15, 119, 1),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/homepage1.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello $userName ',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: 'Welcome to ',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: 'TracVita',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(76, 15, 119, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAdviceContainer(
                      context,
                      'Stay Hydrated,\nStay Strong',
                      'Fuel your body with water—every sip keeps you energized and focused.',
                      Icons.local_drink,
                      Color.fromARGB(255, 202, 224, 239),
                      Colors.blue,
                    ),
                    const SizedBox(width: 20),
                    buildAdviceContainer(
                      context,
                      'Medicine is a Step Toward Healing',
                      'Taking your medicine on time is a promise to your well-being. Keep going!',
                      Icons.medical_services,
                      Color.fromARGB(255, 246, 189, 227),
                      Color.fromARGB(255, 247, 58, 184),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildOptionButton(
                  context,
                  'Medication',
                  Icons.medication,
                  '/medication',
                ),
                const SizedBox(height: 20),
                buildWaterReminderButton(
                    context), // <--- Water Reminder below Medication
                const SizedBox(height: 20),
                buildOptionButton(
                  context,
                  'Exercise', // Changed label to Sport
                  Icons.sports_soccer, // Changed icon to a sports icon
                  '/fitness', // Redirects to fitness page
                ),
                const SizedBox(height: 20),
                buildOptionButton(
                  context,
                  'Appointment',
                  
                  Icons.calendar_today,
                  '/appointment',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5e4e8f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildWaterReminderButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaterReminder()),
        );
      },
      icon: Icon(Icons.water_drop, color: Colors.white),
      label: Text(
        'Water Reminder',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5e4e8f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildAdviceContainer(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
