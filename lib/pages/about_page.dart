import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de Mí'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildSkillsSection(),
            const SizedBox(height: 30),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img/profile.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              'Alan Tubert',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Desarrollador Flutter Full-Stack',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              'Más de 5 años desarrollando aplicaciones móviles y web '
              'con tecnologías modernas. Apasionado por crear soluciones '
              'eficientes y escalables.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      children: [
        const Text(
          'Habilidades Técnicas',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSkillChip('Flutter'),
            _buildSkillChip('Dart'),
            _buildSkillChip('Firebase'),
            _buildSkillChip('Node.js'),
            _buildSkillChip('AWS'),
            _buildSkillChip('CI/CD'),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.blue.shade50,
      avatar: const Icon(Icons.code, size: 18),
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Contacto para Oportunidades',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildContactButton(
              icon: Icons.email,
              label: 'alantubert09@gmail.com',
              onTap: () => _launchEmail(),
            ),
            _buildContactButton(
              icon: Icons.link,
              label: 'linkedin.com/in/alan-tubert',
              onTap:
                  () => _launchUrl(
                    'https://www.linkedin.com/in/alan-tubert-aa319a1b2/',
                  ),
            ),
            _buildContactButton(
              icon: Icons.code,
              label: 'github.com/MockAlan02',
              onTap: () => _launchUrl('https://github.com/MockAlan02'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(label),
      onTap: onTap,
      minLeadingWidth: 20,
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'alantubert09@gmail.com',
      queryParameters: {'subject': 'Oferta de Trabajo'},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
