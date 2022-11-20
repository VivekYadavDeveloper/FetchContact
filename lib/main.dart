import 'package:contacts_service/contacts_service.dart';
import 'package:fetch_contact/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('_isDark') ?? false;
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDark});
  final bool isDark;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
        create: (context) => ThemeModel(isDark),
        builder: (context, snapshot) {
          final setting = Provider.of<ThemeModel>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: setting.currentTheme,
            home: const ContactList(),
          );
        });
  }
}

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contacts = [];

  bool isLoading = true;
  @override
  void initState() {
    getContactPermission();
    super.initState();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContact() async {
    contacts = await ContactsService.getContacts();

    isLoading = false;
  }

  void _toggleTheme() {
    final setting = Provider.of<ThemeModel>(context, listen: false);
    setting.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Fetch",
        ),
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon: const Icon(Icons.lightbulb),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(-3, -3),
                        ),
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(-3, -3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.limeAccent,
                    ),
                    child: Text(contacts[index].givenName![0]),
                  ),
                  title: Text(contacts[index].givenName!),
                  subtitle: Text(contacts[index].phones![0].value!),
                );
              },
            ),
    );
  }
}
